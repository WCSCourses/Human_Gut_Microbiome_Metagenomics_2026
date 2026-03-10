# Practical exercise - Quality control and decontamination of metagenomic reads
---

# Exercise overview

In this practical exercise, participants will perform quality control and decontamination of shotgun metagenomic sequencing reads. Using publicly available datasets, participants will download sequencing data, evaluate sequencing quality, trim technical artefacts, remove host contamination, and generate a set of cleaned microbial reads suitable for downstream metagenomic analysis.

This exercise demonstrates the importance of preprocessing in ensuring accurate taxonomic and functional profiling.

---
# Dataset
Participants will use publicly available human gut microbiome datasets from the European Nucleotide Archive (ENA).

Run accession numbers:
```text
SRR30598619
SRR30598621
SRR30598622
```
These represent paired-end Illumina shotgun metagenomic reads.

---
---

## Exercise 1 — Prepare the working directory
Create a structured directory layout to organize the analysis.
```bash
mkdir -p RAW_READS \
         QC/fastqc_raw QC/multiqc_raw \
         QC/fastqc_trimmed QC/multiqc_trimmed \
         QC/fastqc_dehosted QC/multiqc_dehosted \
         TRIMMED_READS DEHOSTED_READS HOST_REMOVAL
```
Check the directory structure:
```bash
tree .
```
Expected structure:
```text
   project/
      ├── RAW_READS/
      ├── QC/
      │   ├── fastqc_raw/
      │   ├── multiqc_raw/
      │   ├── fastqc_trimmed/
      │   └── multiqc_trimmed/
      ├── TRIMMED_READS/
      ├── DEHOSTED_READS/
      └── HOST_REMOVAL/
```
---
---
## Exercise 2 — Download sequencing data
Download one sample from ENA.
```bash
wget -c ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR305/019/SRR30598619/SRR30598619_1.fastq.gz
wget -c ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR305/019/SRR30598619/SRR30598619_2.fastq.gz
```
Move the files into the raw reads directory:
```bash
mv *.fastq.gz RAW_READS/
```
Verify the files:
```bash
ls RAW_READS
```
Expected output:
```text
SRR30598619_1.fastq.gz
SRR30598619_2.fastq.gz
```
---
---
## Exercise 3 — Evaluate raw sequencing quality
Run FastQC on the raw reads.
```bash
fastqc RAW_READS/*.fastq.gz -o QC/fastqc_raw
```
Generate a summary report using MultiQC.
```bash
multiqc QC/fastqc_raw -o QC/multiqc_raw
```
Open the report:
```bash
QC/multiqc_raw/multiqc_report.html
```

---
### Questions
1. What is the average per-base quality score across the reads?
2.	Do you observe any adapter contamination?
3.	Are there any overrepresented sequences?
4.	Is the GC content distribution consistent with microbial genomes?
5.	Are there any warnings or failures reported by FastQC?
---
## Exercise 4 — Perform read trimming
Trim adapters and low-quality bases using TrimGalore.
```bash
trim_galore --paired \
RAW_READS/SRR30598619_1.fastq.gz \
RAW_READS/SRR30598619_2.fastq.gz \
--output_dir TRIMMED_READS
```
Check the trimming reports:
```bash
ls TRIMMED_READS
```
Expected outputs:
```text
SRR30598619_1_val_1.fq.gz
SRR30598619_2_val_2.fq.gz
SRR30598619_1_trimming_report.txt
SRR30598619_2_trimming_report.txt
```

### Questions
1.	How many reads were trimmed due to low-quality bases?
2.	Were adapter sequences detected?
3.	What proportion of reads were removed during trimming?
---
---
## Exercise 5 — Validate trimmed reads
Run FastQC again on the trimmed reads.
```bash
fastqc TRIMMED_READS/SRR30598619_1_val_1.fq.gz \
TRIMMED_READS/SRR30598619_2_val_2.fq.gz \
-o QC/fastqc_trimmed
```
Generate a MultiQC summary.
``` bash
multiqc QC/fastqc_trimmed -o QC/multiqc_trimmed
```
Open the new report and compare with the raw data report.

---
### Questions
1.	Has the per-base quality improved after trimming?
2.	Has adapter contamination been removed?
3.	Are there still any warnings in the FastQC report?
---
---
## Exercise 6 — Remove host DNA contamination and evaluate the reads
Build the Bowtie2 index for the host genome.
```bash
bowtie2-build hg38.fa hg38_index
```
Align reads to the host genome and retain unmapped reads.

```bash
bowtie2 \
-x hg38_index \
-1 TRIMMED_READS/SRR30598619_1_val_1.fq.gz \
-2 TRIMMED_READS/SRR30598619_2_val_2.fq.gz \
--very-sensitive \
--threads 8 \
--un-conc-gz DEHOSTED_READS/SRR30598619_dehosted.fastq.gz \
-S HOST_REMOVAL/SRR30598619_host_alignment.sam
```
Expected Output
At the end of this exercise participants should obtain:
```text
DEHOSTED_READS/
   SRR30598619_dehosted.1.fastq.gz
   SRR30598619_dehosted.2.fastq.gz
   ```
   
Inspect the Bowtie2 alignment summary printed in the terminal.

### Questions
1.	What percentage of reads aligned to the host genome?
2.	How many reads remain after host removal?
3.	Why is host filtering particularly important in human microbiome studies?
---
---
### Final discussion questions
1.	Why is quality control essential before downstream metagenomic analysis?
2.	What types of sequencing artefacts can lead to false microbial detection?
3.	How could host contamination affect functional annotation results?
4.	Why is it useful to summarize QC results across samples using MultiQC?

#### Transition to the Next Module
The cleaned reads generated in this exercise represent high-quality microbial sequencing data.

In Module 2, these reads will be used to reconstruct microbial genomes through metagenomic assembly and genome binning, enabling the recovery of metagenome-assembled genomes (MAGs).