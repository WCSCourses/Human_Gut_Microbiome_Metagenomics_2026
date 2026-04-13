# Practical exercise - Quality control and decontamination of metagenomic reads.
---

# Exercise overview.

In this practical exercise, participants will use pre-generated QC report from the metaWRAP to understand how you evaluate evaluate sequencing quality for downstream metagenomic analysis.   
This exercise demonstrates the importance of preprocessing in ensuring accurate genome assembly, taxonomic and functional profiling.

---
# Dataset.
Participants will use pre-generated report on the cluster. 

---

## Exercise 1 — Evaluate raw sequencing quality
From the metaWRAP QC output, download the qc_report.html file to your local machine and open it in a web browser.

Below is the code that was used to generate the report. 
```bash
metawrap read_qc \
-1 /SRR30598619_1.fastq-001.gz \
-2 /SRR30598619_2.fastq-002.gz \
-t 24 \
-o /scratch/home/trainx/READ_QC/ \
-x hg38
```

Alternatively, if ran on nextflow, the metaWRAP pipeline generates a csv file with summarised QC statistics. 
---
### Questions.
1. Are there any overrepresented sequences?
2. What proportion of host reads were removed during trimming?
3. What percentage of reads aligned to the host genome?
4. How many reads remain after host removal?

---

### Final discussion questions.
1. Why is quality control essential before downstream metagenomic analysis?
2. What types of sequencing artefacts can lead to false microbial detection?
3. Why is host filtering particularly important in human microbiome studies?
4. How could host contamination affect functional annotation results?
5. Why is it useful to summarize QC results across samples using MultiQC?

#### Transition to the Next Module.
The cleaned reads generated in this exercise represent high-quality microbial sequencing data.

In Module 2, these reads will be used to reconstruct microbial genomes through metagenomic assembly and genome binning, enabling the recovery of metagenome-assembled genomes (MAGs), taxonomic profiling in module 4, community and functional profiling in module 5.
