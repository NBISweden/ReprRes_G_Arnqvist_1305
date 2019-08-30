#! /bin/bash -l


## convert the mpileup file to a sync file
## Sync file: The sync-file provides a convenient summary of the allele counts of several populations
## col 1: reference chromosome
## col 2: position
## col 3: reference character
## col 4: allele counts for first population
## col 5: allele counts for second population
## col n: allele counts for n-3 population
## Allele counts are in the form ”A:T:C:G:N:del”
java -jar popoolation2_1201/mpileup2sync.jar --input Bra.Ca.Yem.idf.mpileup --output Bra.Ca.Yem.idf.sync --fastq-type sanger --min-qual 20 --threads 16

## subsample sync file
## --target-coverage: Reduce the coverage of the pileup-file to the here provided value; The target coverage also acts as minimum coverage
## --max-coverage: The maximum coverage; All populations are required to have coverages lower or equal than the maximum coverage; Mandatory
perl popoolation2_1201/subsample-synchronized.pl --input Bra.Ca.Yem.idf.sync --output Bra.Ca.Yem.idf.ss10.sync --target-coverage 10 --max-coverage 500  --method withoutreplace


## CALCULATING Fst
## OUTPUT OF THE FST SCRIPT
## col 1: reference chromosome
## col 2: position
## col 3: window size (1 for single SNPs)
## col 4: covered fraction (relevant for minimum covered fraction)
## col 5: average minimum coverage for the window across all populations (the higher the more reliable the estimate)
## col 6: pairwise FST comparing population 1 with population 2
## col 7: etc for ALL pairwise comparisons of the populations present in the sync file
perl popoolation2_1201/fst-sliding.pl --input Bra.Ca.Yem.idf.sync --output Bra.Ca.Yem.idf.fst --suppress-noninformative --min-count 6 --min-coverage 10 --max-coverage 500 --min-covered-fraction 1 --window-size 1 --step-size 1 --pool-size 100
## Convert the FST file into an '*.igv' file
perl popoolation2_1201/export/pwc2igv.pl --input Bra.Ca.Yem.idf.fst --output Bra.Ca.Yem.idf.fst.igv

## Fisher's Exact Test
perl popoolation2_1201/fisher-test.pl --input Bra.Ca.Yem.idf.sync --output Bra.Ca.Yem.idf.fet --min-count 6 --min-coverage 10 --max-coverage 500 --suppress-noninformative
## Load the Fisher's exact test results into the IGV
perl popoolation2_1201/export/pwc2igv.pl --input Bra.Ca.Yem.idf.fet --output Bra.Ca.Yem.idf.fet.igv

## RUNNING THE CMH-TEST
## The -log10 transformed p-value is just appended at the end of the sync file
perl popoolation2_1201/cmh-test.pl --min-count 6 --min-coverage 10 --max-coverage 500 --population 1-3,2-4,3-5,4-6,1-5,2-6 --input Bra.Ca.Yem.idf.sync --output Bra.Ca.Yem.idf.cmh
## Display the cmh-test results in the IGV
perl popoolation2_1201/export/cmh2gwas.pl --input Bra.Ca.Yem.idf.cmh --output Bra.Ca.Yem.idf.gwas --min-pvalue 1.0e-20

