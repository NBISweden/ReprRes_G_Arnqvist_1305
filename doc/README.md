# The genomic footprint of sexual conflict -- supplementary data and scripts

This is a collaborative project between the [Göran Arnqvist
group](http://arnqvist.org/), Animal Ecology, Dept. of Ecology and
Genetics, Uppsala University and the [NBIS](https://nbis.se/)
long-term support (a.k.a. WABI), performed during 2015-2018 (NBIS LT
project name: G_Arnqvist_1305).

As a part of the NBIS reproducible research policy, this repository
provides the data-files and scripts necessary to perform the
underlying analyses and create tables and plots used in Sayadi et
al. The genomic footprint of sexual conflict (manuscript in prep; link
not yet available)

Several scripts are provided to reproduce most parts of the
Pool-Seq analysis. Please refer to the readme file for more details.

*Note! The repository is provided for reproducibility reasons, only;
 no further development will be made.*

## Usage

#### Download

The content of this repository can be obtained in two ways:
*	Download the current release as a zip- or tar-archive (e.g., by clicking `Download Zip File` or `Download TAR Ball` on the *github.io* page)
*	Clone the repository from the *github* page (reached from the *github.io* page by clicking `View on GitHub`)

## Repository content and comments on running the scripts:

- **Data:**

  In this folder you will find several data files.

- **README.md**

  This file.

- *Scripts (in order of execution)*

1. **PopoolationPart1.sh, PopoolationPart2.sh:**
  In order to get the output result file from Popoolation you to run both scripts, several modules need to be installed (`Python, bowtie2, smatools, bcftools, bwa, java, picard`).
  The Raw files data need to be downloaded: (*Genome assembly file, raw sequencing data*).
  The annotated genome assembly, along with sequence data, is available from the European Nucleotide Archive (ENA) under accession PRJEB30475.
  All Pool-seq raw sequencing data have been deposited at the NCBI sequence read archive, under the accession number PRJNA503561.
  Please modify the script according to your folder organisation.
  Several folders need to be created before running the script (place your shell script in the same directory):
    + *Create necessary folders*
      ```
      mkdir ref # place genome assembly file in this folder
      mkdir re ads # place raw reads in this folder
      mkdir trimmed.reads
      mkdir mapping
      ```
    + *NB! modify the first 2 lines in the bash script PoPoolationPart1.sh to include the reference genome and the raw reads, before running the scripts*
      ```
      bash PoPoolationPart1.sh
      bash PoPoolationPart2.sh
      ```
  After running the script `PopoolationPart1.sh`, as an output you will get the `Bra.Ca.Yem.idf.mpileup` file.
  `PoPoolationPart2.sh` uses the mpileup file to produce the `sync` file, the `cmh` file and the `fst` file.
  Please refer to popoolation manual to get familiar with all the output files.

2. **gff.to.SNPs.pl:**

  This script is used to extract for each list of CDSs the corresponding  list of SNPs.

  `perl gff.to.SNPs.pl`

3. ** SNPs.to.cmh.allCDSs.pl:**

  To get the cmh value of each SNP in the CDS regions, you can run this script.

  `perl SNPs.to.cmh.allCDSs.pl`

4. ** SNPs.to.cmh.pl:**

  To get the cmh value of each SNP in the CDS regions, for each list of trancripts (SFP, Digestive enzymes, Abodmen, Head&Thorax). you can run this script.

  `perl SNPs.to.cmh.pl`

6. ** Polymorphic.CDSs.pl:**

  To get the list of SNPs present in the 3 pop in both samples at a proportion of at least 30/70.

  `perl Polymorphic.CDSs.pl > Polymorphic.SNPs.CDSs.txt`

7. ** SNPsLogFC.pl:**
  To get the LogFC value for each SNP in the list of transcripts Abodmen and Head&thorax, you need to run this script.
  You need to modify the first line of the script to select the input file.

  `perl SNPsLogFC.pl > output.txt`

8. ** Go.terms.enrichment.R:**

  Go term enrichment calculatin is made using this script.
  please modify the `read.table` line to specify the input file.

## Contact
* Göran Arnqvist group, UU:
     - [Ahmed Sayadi](mailto:ahmed.sayadi@ebc.uu.se)
     - [Göran Arnqvist](mailto:Goran.Arnqvist@ebc.uu.se)
* NBIS long-term support:
     - [Björn Nystedt](mailto:bjorn.nystedt@scilifelab.se)
