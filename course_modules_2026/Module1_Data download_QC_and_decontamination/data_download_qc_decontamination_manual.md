# Module 1: Data download, Quality Control and Decontamination
This module introduces participants to best practices for downloading, organising, and performing quality control (QC) and decontamination of raw gut microbiome metagenomic data. 
Participants will gain hands-on experience with real datasets, learning how to:
- Download raw metagenomic data from ENA
- Inspect sequencing quality for artefacts
- Trim low-quality reads and adapters
- Remove host contamination
- Interpret QC reports
- Understand how upstream laboratory steps influence downstream results

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

# Part I — Conceptual foundations (Lecture)
1. What is a FASTQ file?

A FASTQ file contains:
- Read identifier
- DNA sequence
- Separator (+)
- Quality scores

Example:
```text
@SEQ_ID
ACGTAGCTAGCT
+
FFFFFFFFFFFF
```
Quality scores represent the probability of sequencing error.

Low-quality bases increase false alignments and incorrect taxonomic assignments.

2. Sequencing platforms influence QC

Different platforms produce different error profiles:
- Illumina → short reads, low error rate
- Long-read platforms → higher error rates
- PCR amplification → potential bias
- Extraction kits → reagent contamination

> **Upstream decisions influence downstream QC patterns.**

---

3. Common Sources of Contamination
- Host DNA (human reads)
- Reagent contamination
- Environmental contamination
- Index hopping
- Cross-sample contamination

> **Important paper:**
Salter SJ. BMC Biology (2014) — Reagent contamination impacts microbiome studies.

# Part II — Downloading Data from ENA
There is a global alliance dedicated to open-access capture, preservation and dissemination of nucleotide sequence and comprises three main partners that exchange data daily to ensure a synchronized global archive: the National Center for Biotechnology Information (NCBI) in the US, the European Nucleotide Archive (ENA) in the UK, and the DNA Data Bank of Japan (DDBJ).

 For this training we will download data from ENA.
 We use ENADownloader.
 ## Step 1 — Load module
 ```bash
 module load enadownloader/v2.3.5-4ac05c8f
 ```

 ## Step 2 — Download study-level data
 Create a file:
 ```text
 study_accession_list.txt
 ```
 This file contains the study ID accession number.

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

Inspect:
- Per base quality
- Adapter content
- Overrepresented sequences
- GC content

## Step 2 — Combine reports using MultiQC
```bash
multiqc .
```
This produces:
- multiqc_report.html (allows cross-sample comparison)

