# Module 1: Data download, Quality Control and Decontamination
# Introduction
Quality control and decontamination are foundational steps in genomic analysis because every downstream result depends on the integrity of the raw sequencing data. Before interpreting microbial community structure, functional potential, or reconstructing genomes, researchers must ensure that the data accurately represent the biological sample rather than technical artefacts.

Shotgun metagenomic sequencing generates millions of short DNA reads originating not only from microbes, but also potentially from host tissue, environmental contaminants, reagent impurities, and sequencing artefacts. Low-quality bases, adapter contamination, PCR duplicates, uneven coverage, and human DNA contamination can all distort taxonomic profiling, functional inference, and genome assembly. Without careful quality control, these issues may lead to false detection of taxa, inflated diversity estimates, biased functional profiles, or erroneous metagenome-assembled genomes (MAGs).

Quality control therefore serves two essential purposes:
	1.	Technical validation — ensuring sequencing quality meets analytical standards.
	2.	Biological reliability — ensuring observed signals reflect true microbial composition rather than contamination or artefacts.

This module introduces participants to best practices for downloading, organising, and quality-checking shotgun metagenomic datasets. Participants will learn how to 
- Download raw metagenomic data from ENA
- identify common sequencing artefacts
- remove low-quality reads and adapter sequences
- filter host contamination 
- interpret quality reports in a biologically meaningful way. 

These skills establish the foundation required for reproducible taxonomic profiling, functional annotation, and genome-resolved analyses in subsequent modules.


## Why this module matters

Every downstream result — taxonomic profiling, functional annotation, MAG recovery — depends entirely on data quality.

Poor QC leads to:
- False taxa detection
- Inflated functional profiles
- Contaminant-driven MAGs
- Biologically misleading conclusions

Quality control is not optional, it is foundational.

## Learning Outcomes

By the end of this module, participants will be able to:
1.	Download shotgun metagenomic data from ENA.
2.	Interpret FASTQ format and sequencing quality metrics.
3.	Perform read trimming and filtering.
4.	Remove host contamination.
5.	Interpret MultiQC reports.
6.	Understand how contamination influences downstream assembly and profiling.
7.	Explain what a workflow manager is and why reproducibility matters.

# Part I — Understanding the data before cleaning it
Before we run any software, we must understand what type of data we are working with.

1. What is a FASTQ file?
A FASTQ file is the standard format used to store raw sequencing reads. Each read consists of four lines:

Example:
```text
@SEQ_ID
ACGTAGCTAGCT
+
FFFFFFFFFFFF
```

These four lines represent:
- Read identifier
- DNA sequence
- Separator (+)
- Quality scores

The quality scores represent the probability that each base was called incorrectly during sequencing.

Low-quality bases increase the likelihood of false alignments and incorrect taxonomic or functional assignments.

2. Sequencing platforms influence QC

Different sequencing platforms produce different error profiles:
- Illumina → short reads, low error rate
- Long-read platforms → higher error rates
- PCR amplification → potential amplification bias
- Extraction kits → potential reagent contamination

> **Upstream laboratory decisions influence downstream QC patterns.**

---

3. Common sources of contamination
- Host DNA (e.g. human reads)
- Reagent contamination
- Environmental contamination
- Index hopping
- Cross-sample contamination

> **Important paper:**
Salter SJ. BMC Biology (2014) — Reagent contamination impacts microbiome studies.

# Part II — Downloading data from ENA
The International Nucleotide Sequence Database Collaboration (INSDC) comprises three synchronized global archives:

- National Center for Biotechnology Information (NCBI) (USA)
- European Nucleotide Archive (ENA) (UK) 
- DNA Data Bank of Japan (DDBJ).

We can download the metagenomic data from the database one sample at a time using  ftp or wget or through SRA toolkit or ENADownloader for a list of samples.  For this training we will download data from ENA.
 
 ## Step 1a — Live demo on how to download metagenomic raw data 
 To download single fastq read files
 ```bash
 cd /path_to_your_folder
 wget -c ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR305/019/SRR30598619/SRR30598619_1.fastq.gz
 wget -c ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR305/019/SRR30598619/SRR30598619_2.fastq.gz
 ```
 -c allows resume if the download is interrupted.


Place the raw sequencing reads into a new folder
```bash
mkdir RAW_READS
mv *fastq.gz RAW_READS

ls RAW_READS
	SRR30598619_1.fastq.gz
	SRR30598619_2.fastq.gz
	SRR30598621_1.fastq.gz
	SRR30598621_2.fastq.gz
	SRR30598622_1.fastq.gz
	SRR30598622_2.fastq.gz
```

 

 ## Step 1b — Downloading metagenomic data using tools (ENA downloader/SRA toolkit)
 Alternatively you can use downloaders such as ENA or SRA toolkit if you have a long list of samples and you already have the project ID, then 
  Create a file with all the accession IDs [SRR30598619, SRR30598621, SRR30598622] and save as .txt:
 ```text
 study_accession_list.txt
 ```
 This file contains the study ID accession number (e.g., PRJNAxxxxx).
 Load the already downloaded module to enable downloading of all the samples in the list using ENA.
 ```bash
 module load enadownloader/v2.3.5-4ac05c8f
 ```
 Run:
 ```bash
 enadownloader -t study -i study_accession_list.txt -o ena_fastqs -d
```
 This generates:
 ```text
run_accession_list.txt
SRR30598619
SRR30598621
SRR30598622
```


# Part III — Initial quality control
In microbiome studies majority of the steps taken in preprocessing are as shown in the schematic below. 
![preprocessing](images/preprocessing.png)
There are several softwares that can be used for checking the quality and cleaning your reads off contamination and deduplicating for further downstream analysis 

We use:
- fastqc
- multiqc
- Trimmomatic

## Step 1 — Run FastQC
FastQC is a quality control tool for high throughput sequence data. It provides a detailed analysis of sequence quality and other metrics that can be used to identify potential problems in the data.
```bash
mkdir -p QC/fastqc_raw
fastqc RAW_READS/*.fastq.gz -o QC/fastqc_raw
```
FastQC evaluates:
- Per-base sequence quality
- Adapter content
- Overrepresented sequences
- GC content
- Sequence duplication levels

The output is a html file and an example is as shown below
![preqc_report](images/preqc_report.png)

## Step 2 — Combine reports using MultiQC
You can combine all the html reports into one large html report using mutliqc to be able to visualize all samples simultanoeusly.
```bash
mkdir -p QC/multiqc_raw
multiqc QC/fastqc_raw -o QC/multiqc_raw
```
This produces:
- multiqc_report.html (allows cross-sample comparison)

MultiQC allows cross-sample comparison and identification of:
-	Outlier samples
- Systematic contamination
- Batch effects
- Global quality trends

# Part IV - Correcting identified problems
Once quality issues are detected, the next step is to correct them.

Pre-processing typically involves two key operations:
	1.	Read trimming for adapter and quality filtering
	2.	Host DNA removal

These steps convert raw sequencing reads into high-quality microbial reads suitable for downstream analysis such as taxonomic profiling, functional annotation, and genome assembly.

In this section we perform these steps manually using standalone tools. Later in the module we will show how the same tasks can be executed using the metaWRAP read_qc pipeline, which automates these steps.
___


## 1. Adapter trimming and quality filtering
During library preparation, short synthetic sequences called adapters are attached to DNA fragments so they can bind to the sequencing flow cell.

Sometimes these adapters remain in the final sequencing reads. In addition, sequencing quality often declines toward the 3′ end of reads, producing low-confidence bases.

Typical issues include:
- Adapter contamination
- Low-quality bases
- Short fragments
- PCR artefacts

If not removed, these issues can:
- introduce false alignments
- inflate microbial diversity estimates
- reduce assembly quality
- bias downstream taxonomic and functional analyses

To correct these issues we perform read trimming and filtering.
___


### Step 1 — Run TrimGalore
TrimGalore is a wrapper around Cutadapt and FastQC that performs adapter removal and quality trimming.
```bash
trim_galore --paired SRR30598619_1.fastq.gz SRR30598619_2.fastq.gz
  ```
What TrimGalore does
- Detects and removes adapter sequences
- Trims low-quality bases
- Removes very short reads
- Produces trimmed paired-end reads


Output files
Typical outputs include:
```text
SRR30598619_1_val_1.fq.gz
SRR30598619_2_val_2.fq.gz
SRR30598619_1_trimming_report.txt
SRR30598619_2_trimming_report.txt
```

These trimmed reads will be used for host removal.
#### Why trimming matters
Trimming improves the reliability of downstream analyses because it:
- increases mapping accuracy
- reduces false taxonomic assignments
- improves metagenome assembly
- removes technical artefacts from sequencing

  
## 2. Post-trimming quality validation
Quality correction should always be verified.

Re-run FastQC on the trimmed reads:
```bash
fastqc SRR30598619_1_val_1.fq.gz SRR30598619_2_val_2.fq.gz
multiqc .
```
![postqc_report](images/postqc_report.png)
Compare the pre-QC and post-QC reports:
Expected improvements:
- improved per-base quality scores
- reduced adapter contamination
- fewer overrepresented sequences

This confirms that trimming successfully improved the data quality.

## 3. Host DNA Removal
In host-associated microbiome studies such as gut microbiome sequencing, a fraction of reads may originate from the host.

For example:
- human intestinal cells
- host mitochondrial DNA
- epithelial tissue contamination

If host reads are not removed:
- host genes may appear in functional profiles
- microbial assembly may become inefficient
- privacy risks may arise in human datasets

Therefore host reads must be filtered before downstream analysis.

metaWRAP performs host filtering using BMTagger.
Here we demonstrate the same principle using Bowtie2, which aligns sequencing reads to the host reference genome.

### Step 2 — Build the host genome index
If you do not already have an index for the host genome, build one using Bowtie2.
Example using the human genome:
``` bash
bowtie2-build hg38.fa hg38_index
  ```
This step generates several index files required for alignment.

### Step 3 — Align reads to the host genome
Next, align trimmed reads to the host genome and keep only unmapped reads.
```bash
bowtie2 \
  -x hg38_index \
  -1 SRR30598619_1_val_1.fq.gz \
  -2 SRR30598619_2_val_2.fq.gz \
  --very-sensitive \
  --threads 8 \
  --un-conc-gz SRR30598619_dehosted.fastq.gz \
  -S host_alignment.sam
  ```
What this command does
	•	aligns reads against the host genome
	•	writes host-aligned reads to the SAM file
	•	writes unaligned paired reads to:

```code
SRR30598619_dehosted.1.fastq.gz
SRR30598619_dehosted.2.fastq.gz
```
These files contain the clean microbial reads used in downstream analysis.

## 4. Validate host removal
After host filtering, inspect the Bowtie2 summary printed to the terminal.

Example output:
```code
95% reads aligned to host
5% reads retained
````
Key questions to ask:
	•	Was host contamination expected?
	•	Was the proportion unusually high?
	•	Do enough reads remain for microbial analysis?

If very high host contamination (>50–80%) is observed, this may indicate:
	•	low microbial biomass
	•	poor DNA extraction
	•	sample handling issues

Running FastQC again on the dehosted reads can confirm final data quality.

These cleaned reads can then be used for:
	•	taxonomic profiling
	•	functional annotation
	•	metagenome assembly
	•	metagenome-assembled genome (MAG) reconstruction


After host filtering:
	•	Inspect kneaddata summary reports
	•	Confirm proportion of reads removed
	•	Re-run FastQC if necessary

Questions to ask:
	•	Was host contamination expected?
	•	Was contamination unusually high?
	•	Does removal significantly reduce total reads?

If >50% reads are host-derived, sample quality or extraction protocol may need review.
___
In large metagenomic projects with hundreds of samples, performing these steps manually becomes inefficient.
# Using a workflow:
Workflow systems such as metaWRAP automate the preprocessing stage through the read_qc module, which performs trimming and host decontamination in a single pipeline.

The next section demonstrates how to perform the same preprocessing steps using metaWRAP.



MetaWRAP aims to be an easy-to-use metagenomic wrapper suite that accomplishes the core tasks of metagenomic analysis from start to finish: read quality control, assembly, visualization, taxonomic profiling, extracting draft genomes (binning), and functional annotation. Additionally, metaWRAP takes bin extraction and analysis to the next level (see module overview below). While there is no single best approach for processing metagenomic data, metaWRAP is meant to be a fast and simple approach before you delve deeper into parameterization of your analysis. MetaWRAP can be applied to a variety of environments, including gut, water, and soil microbiomes (see metaWRAP paper for benchmarks). Each individual module of metaWRAP is a standalone program, which means you can use only the modules you are interested in for your data.

![metaWRAP](images/metaWRAP.png)


 If you are interested in learning how to run the QC and decontamination in on one sample or multiple samples using a pipeline please go to [qc_and_decontam_with_metaWRAP.md](qc_and_decontam_with_metaWRAP.md).

Here is a schematic representation of the read_qc module specifically from metaWRAP
![readqc_module](images/readqc_module.png)

The resulting multiple sets of cleaned reads after host removal can then be used in further downstream analysis including he assembly to generate metagenomic assembled genomes (MAGS), taxonomic assignment and functional annotation.


