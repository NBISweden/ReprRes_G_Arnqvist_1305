#! /bin/bash -l


ref='genomeAssemblyFile.fasta' # genome assembly file
samples=(Pure-Bra-bra-1a_S2_L001 Pure-Bra-bra-2a_S4_L002 Pure-Ca-ca-1a_S3_L002 Pure-Ca-ca-2a_S29_L006 Pure-Yem-yem-1a_S28_L006 Pure-Yem-yem-2a_S1_L001)

## Prepare the reference genome
# echo With this command we are removing the description of the fasta entry. This step is strongly recommended as unnecessarily long fasta identifiers may lead to problems in downstream analysis.
awk '{print $1}' ref/$ref > ref/C.mac.genome.fasta
#echo indexing genome file
bwa index ref/C.mac.genome.fasta

## Samples used for calling the SNPs (All Pool-seq raw sequencing data have been deposited at the NCBI sequence read archive, under the accession number PRJNA503561.)


for sample in ${samples[@]} 
	do
    echo $sample
    
	## Unzip sample file
    gunzip -c reads/${sample}_R1_001.fastq.gz > reads/${sample}_R1_001.fastq
    gunzip -c reads/${sample}_R2_001.fastq.gz > reads/${sample}_R2_001.fastq

	## Trimming of reads
	## –input the input files
	## –output.. the output files; this will create three files with the extensions 1 2 SE;
	## –min-length discard reads that are after trimming smaller than this threshold; Note this step may create orphan reads, i.e.: reads who lost their mate :(
	## –no-5p-trim only trim reads at the 3’ end; this is necessary for the removal of duplicates
	## –quality-threshold reads should on average have a score higher than this threshold
	## –fastq-type is the encoding of the base quality in sanger or illumina (remember offset)
	## –disable-zipped-output in the newest versions of PoPoolation the output of the fastq files is per default zipped. Here we disable this feature
	
	#echo trim reads (Please download popoolation)
	perl popoolation-code-228-trunk/basic-pipeline/trim-fastq.pl --disable-zipped-output --input1 reads/${sample}_R1_001.fastq --input2 reads/${sample}_R2_001.fastq --min-length 50 --no-5p-trim --quality-threshold 20 --fastq-type sanger --output1 trimmed.reads/${sample}_R1_001.tr.fastq --output2 trimmed.reads/${sample}_R2_001.tr.fastq --outputse trimmed.reads/${sample}.se.tr.fastq

	## PAIRED END MAPPING
	## -I input is in Illumina encoding (offset 64); do not provide this when input is in sanger! Very important parameter!
	## -m not important; just telling bwa to process smaller amounts of reads at once
	## -l 200 seed size (needs to be longer than the read length to disable seeding)
	## -e 12 -d 12 gap length (for insertions and deletions)
	## -o 1 maximum number of gaps
	## -n 0.01 the number of allowed mismatches, in terms of probability of missing the read. In general the lower the value the more mismatches are allowed. The exact translation is shown at the beginning of the mapping
	## -t 2 number of threads, the more the faster
	
	#echo paired end mapping
	bwa aln -o 1 -n 0.01 -l 200 -e 12 -d 12 -t 16 ref/C.mac.genome.fasta trimmed.reads/${sample}_R1_001.tr.fastq > mapping/${sample}_R1_001.tr.sai
	bwa aln -o 1 -n 0.01 -l 200 -e 12 -d 12 -t 16 ref/C.mac.genome.fasta trimmed.reads/${sample}_R2_001.tr.fastq > mapping/${sample}_R2_001.tr.sai
	bwa sampe ref/C.mac.genome.fasta mapping/${sample}_R1_001.tr.sai mapping/${sample}_R2_001.tr.sai trimmed.reads/${sample}_R1_001.tr.fastq trimmed.reads/${sample}_R2_001.tr.fastq > mapping/${sample}.sam

	## CONVERTING SAM TO BAM
	## sam.. Sequence Alignment Map format) optimized for humans
	## bam.. binary sam) optimized for computers
	## It is easily possible to convert a sam to bam and vice versa a bam to sam. In the following we convert a sam into a bam and finally sort the bam file
	## samtools view -Sb pe/pe.sam > pe/pe.bam
	## -S input is sam
	## -b output is bam (-S may be merged with -b to -Sb)
	## ’sort - outpufile’ input for sorting is the pipe (rather than a file)
	## -q only include reads with mapping quality >= INT [0]
	
	#echo converting sam to bam
	samtools view -Sb mapping/${sample}.sam > mapping/${sample}.bam
	
	## SORTING WITH PICARD
	
	## Picard runs with Java
	## -Xmx2g give Java 2 Gb of memory
	## -jar SortSam use the Java software SortSam
	## I= input
	## O= output
	## SO= sort order; sort by coordinate
	# VALIDATION STRINGENCY= Picard is complaining about every deviation of the sam file from the most stringent requirements.
	
	#echo sorting with picard
	java -jar picard.jar SortSam I= mapping/${sample}.bam O= mapping/${sample}.sort.bam VALIDATION_STRINGENCY=SILENT SO=coordinate

	## REMOVING DUPLICATES
	## I= input file
	## O= output file for reads
	## M= output file of statistics (how many identified duplicates)
	## REMOVE DUPLICATES= remove duplicates from the output file rather than just marking them (remember flag in sam-file 0x400)
	
	#echo removing duplicates
	java -jar picard.jar MarkDuplicates I= mapping/${sample}.sort.bam O= mapping/${sample}.rmd.sort.bam M= mapping/${sample}.dupstat.txt VALIDATION_STRINGENCY=SILENT REMOVE_DUPLICATES=true

	## REMOVE LOW QUALITY ALIGNMENTS (AMBIGUOUS MAPPING)
	## -q 20 only keep reads with a mapping quality higher than 20 (remove ambiguously aligned reads)
	## -f 0x0002 only keep proper pairs (remember flags from sam file)
	## -F 0x0004 remove reads that are not mapped
	## -F 0x0008 remove reads with an un-mapped mate
	## Note ’-f’ means only keep reads having the given flag and ’-F’ discard all reads having the given flag.

	#echo remove low quality alignments
	samtools view -q 20 -f 0x0002 -F 0x0004 -F 0x0008 -b mapping/${sample}.rmd.sort.bam > mapping/${sample}.qf.rmd.sort.bam

	#echo indexing final bam files
	samtools index mapping/${sample}.qf.rmd.sort.bam

done

## CREATING A MPILEUP FILE
## -B disable BAQ computation (base alignment quality)
## -Q skip bases with base quality smaller than the given value
## -f path to reference sequence

echo CREATING A MPILEUP FILE
samtools mpileup -B -Q 0 -f ref/C.mac.genome.fasta mapping/Pure-Bra-bra-1a_S2_L001.qf.rmd.sort.bam mapping/Pure-Bra-bra-2a_S4_L002.qf.rmd.sort.bam mapping/Pure-Ca-ca-1a_S3_L002.qf.rmd.sort.bam mapping/Pure-Ca-ca-2a_S29_L006.qf.rmd.sort.bam mapping/Pure-Yem-yem-1a_S28_L006.qf.rmd.sort.bam mapping/Pure-Yem-yem-2a_S1_L001.qf.rmd.sort.bam > Bra.Ca.Yem.mpileup

#FILTERING INDELS
## –indel-window how many bases surrounding indels should be ignored
## –min-count minimum count for calling an indel. Note that indels may be sequencing errors as well
## Note: the filter-pileup script could also be used to remove entries overlapping with transposable elements (RepeatMasker produces a gtf as well).

echo filtering indels
perl popoolation-code-228-trunk/basic-pipeline/identify-genomic-indel-regions.pl --indel-window 5 --min-count 2 --input Bra.Ca.Yem.mpileup --output indels.gtf
perl popoolation-code-228-trunk/basic-pipeline/filter-pileup-by-gtf.pl --input Bra.Ca.Yem.mpileup --gtf indels.gtf --output Bra.Ca.Yem.idf.mpileup

## SUBSAMPLING TO UNIFORM COVERAGE
## –min-qual minimum base quality
## –method method for subsampling, we recommend without replacement
## –target-coverage which coverage should the resulting mpileup file have
## –max-coverage the maximum allowed coverage, regions having higher coverages will be ignored (they may be copy number variations and lead to wrong SNPs)
## –fastq-type (sanger means offset 33)

echo subsampling to uniform coverage
perl popoolation-code-228-trunk/basic-pipeline/subsample-pileup.pl --min-qual 20 --method withoutreplace --max-coverage 50 --fastq-type sanger --target-coverage 10 --input Bra.Ca.Yem.idf.mpileup --output Bra.Ca.Yem.idf.ss10.mpileup

##CALCULATING TAJIMA’S
## –min-coverage –max-coverage: for subsampled files not important; should contain target coverage, i.e.: 10
## –min-covered-fraction minimum percentage of sites having sufficient coverage in the given window
## –min-count minimum occurrence of allele for calling a SNP
## –measure which population genetics measure should be computed (pi/theta/D)
## –pool-size number of chromosomes (thus number of diploids times two)
## –region compute the measure only for a small region; default is the whole genome
## –output a file containing the measure () for the windows
## –snp-output a file containing for every window the SNPs that have been used for computing the measure (e.g.)
## –window-size –step-size control behaviour of sliding window; if step size is smaller than window size than the windows will be overlapping.

perl popoolation-code-228-trunk/Variance-sliding.pl --fastq-type sanger --measure pi --input Bra.Ca.Yem.idf.ss10.mpileup --min-count 2 --min-coverage 4 --max-coverage 10 --min-covered-fraction 0.5 --pool-size 200 --window-size 1000 --step-size 1000 --output Bra.Ca.Yem.idf.ss10.pi --snp -output Bra.Ca.Yem.idf.ss10.snps

## VISUALIZE IN IGV
perl popoolation-code-228-trunk/VarSliding2Wiggle.pl --input Bra.Ca.Yem.idf.ss10.pi --trackname "pi" --output Bra.Ca.Yem.idf.ss10.wig

