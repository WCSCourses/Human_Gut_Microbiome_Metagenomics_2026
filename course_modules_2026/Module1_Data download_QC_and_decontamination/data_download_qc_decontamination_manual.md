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

# Part II — Downloading Data from ENA
The International Nucleotide Sequence Database Collaboration (INSDC) comprises three synchronized global archives:

- National Center for Biotechnology Information (NCBI) (USA)
- European Nucleotide Archive (ENA) (UK) 
- DNA Data Bank of Japan (DDBJ).

 For this training we will download data from ENA.
 We use ENADownloader.
 ## Step 1 — Load module
 ```bash
 module load enadownloader/v2.3.5-4ac05c8f
 ```

 ## Step 2 — Download study-level data
 ENA allows pulling one sample ID or a list of sample IDs
 
 To download fastq files, you can use SRA toolkit, ftp or wget.

 For a single file use 
 ```bash
 cd /path_to_your_folder
 wget -c ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR305/019/SRR30598619/SRR30598619_1.fastq.gz
 wget -c ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR305/019/SRR30598619/SRR30598619_2.fastq.gz
 ```
 -c allows resume if the download is interrupted.

 Alternatively if you have a long list of samples and you already have the project ID, then 

  Create a file with all the accession IDs and save as .txt:
 ```text
 study_accession_list.txt
 ```
 This file contains the study ID accession number (e.g., PRJNAxxxxx).

 Example content:

 Run:
 ```bash
 enadownloader -t study -i study_accession_list.txt -o ena_fastqs -d
```
 This generates:
 ```text
 ena_fastqs/
  SRRxxxxx_1.fastq.gz
  SRRxxxxx_2.fastq.gz
```
# Part III — Initial quality control

We use:
- fastqc
- multiqc
- fastp

## Step 1 — Run FastQC
```bash
fastqc *_1.fastq.gz *_2.fastq.gz
fastqc data/demo -o data/
```
FastQC evaluates:
- Per-base sequence quality
- Adapter content
- Overrepresented sequences
- GC content
- Sequence duplication levels


## Step 2 — Combine reports using MultiQC
```bash
multiqc .
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

Quality correction typically involves two major processes:
	1.	Adapter trimming and quality filtering
	2.	Host DNA removal

These steps transform raw sequencing reads into biologically interpretable datasets suitable for downstream analysis.

## 1. Adapter Trimming and Quality Filtering
Sequencing reads often contain:
- Adapter remnants from library preparation
-	Low-quality bases (typically toward the 3′ end)
-	Very short reads that align unreliably

If not removed, these artefacts can:
-	Cause false alignments
-	Inflate diversity estimates
-	Reduce assembly quality

We use fastp for trimming and filtering.

### Step 1 — Run fastp
```bash
fastp \
  -i sample_1.fastq.gz \
  -I sample_2.fastq.gz \
  -o sample_clean_1.fastq.gz \
  -O sample_clean_2.fastq.gz \
  --detect_adapter_for_pe \
  --thread 8
  ```

  What this does:
- Detects and removes adapter sequences
- Trims low-quality bases
- Filters short reads
- Generates an HTML quality report

Output files:
	•	sample_clean_1.fastq.gz
	•	sample_clean_2.fastq.gz
	•	fastp.html
	•	fastp.jsonWhy trimming matters

Why trimming matters
Removing low-quality bases:
	•	Improves mapping accuracy
	•	Reduces false variant calls
	•	Enhances taxonomic classification
	•	Improves assembly continuity

  
## 2. Post-Trimming Quality Validation
Quality correction must always be validated.

Re-run FastQC on trimmed reads:
```bash
fastqc sample_clean_1.fastq.gz sample_clean_2.fastq.gz
multiqc .
```
Compare:
	•	Per-base quality distribution (should improve)
	•	Adapter content (should be removed)
	•	Overrepresented sequences (should decrease)

This confirms that trimming was successful.

## 3. Host DNA Removal
In host-associated microbiome studies (e.g., gut microbiome), host DNA contamination is common.

If not removed:
	•	Human genes may appear in functional profiles
	•	Host reads may dominate assemblies
	•	Sensitive genomic information may remain in datasets

We use kneaddata, which internally uses Bowtie2 to align and remove host reads.

### Step 2 — Run kneaddata
``` bash
kneaddata \
  --input sample_clean_1.fastq.gz \
  --input sample_clean_2.fastq.gz \
  --reference-db /path/to/human_genome \
  --output kneaddata_output \
  --threads 8
  ```
Output:
	•	Cleaned microbial reads
	•	Host reads (separated)
	•	Log and summary report

What kneaddata does internally
	1.	Aligns reads against the host reference genome
	2.	Removes aligned reads
	3.	Retains unaligned (microbial) reads

## 4. Validate Host Removal
After host filtering:
	•	Inspect kneaddata summary reports
	•	Confirm proportion of reads removed
	•	Re-run FastQC if necessary

Questions to ask:
	•	Was host contamination expected?
	•	Was contamination unusually high?
	•	Does removal significantly reduce total reads?

If >50% reads are host-derived, sample quality or extraction protocol may need review.

