# Module 4: Read-Based vs Assembly-Based Taxonomic Profiling 
---

## Module leads
Boniface Gichuki      
Luicer Anne Ingasia Olubayo

---

## Introduction

After preprocessing sequencing reads in **Module 1** and reconstructing genomes through assembly and binning in **Module 2**, the next major task in metagenomic analysis is **taxonomic annotation** — determining which microorganisms are present in a sample.

Taxonomic profiling in metagenomics is generally performed using two complementary strategies:

1. **Read-based taxonomic profiling**
2. **Assembly-based taxonomic annotation**

Read-based approaches classify sequencing reads directly against reference databases to estimate microbial community composition. Assembly-based approaches instead assign taxonomy to reconstructed genomic sequences such as contigs or **metagenome-assembled genomes (MAGs)**.

Both strategies are widely used in microbiome research and provide complementary insights into microbial communities.

---

## Goal of this module

The goal of this module is to demonstrate how **taxonomic profiling is performed in metagenomic workflows**, using both read-based and genome-based approaches.

In this module, participants will learn how taxonomic annotation can be performed using the **metaWRAP pipeline**, as well as alternative standalone tools commonly used in metagenomics.

---

## Learning outcomes

By the end of this module, participants will be able to:

1. Explain the difference between **read-based and assembly-based taxonomic profiling**
2. Perform read-based taxonomic classification using **metaWRAP kraken**
3. Assign taxonomy to reconstructed genomes using **metaWRAP classify_bins**
4. Interpret taxonomic classification outputs
5. Understand when each method is appropriate
6. Identify alternative standalone tools for taxonomic profiling

---
### Big picture: Where taxonomic annotation fits in the pipeline
The metagenomic workflow covered in this training course can be summarized as:
![read_vs_assembly_classfication](images/read_vs_assembly_classfication.png)

---

## Part I — Taxonomic profiling approaches

As introduced above, taxonomic annotation in metagenomics can be performed either directly on sequencing reads or on reconstructed genomes, such as metagenome-assembled genomes (MAGs).

In practice, different computational tools are designed for each type of input data. Below we introduce the main tools used for:

- **Read-based taxonomic profiling**
- **Genome-level taxonomic classification**

### Read-based taxonomic profiling

Read-based taxonomic profilers classify sequencing reads by comparing them to reference databases. These tools estimate the composition of microbial communities without requiring genome assembly.

Several computational strategies are commonly used.

---

#### 1. Marker gene–based profilers

Marker gene methods classify reads by mapping them to **taxonomically informative marker genes** that uniquely identify microbial lineages.

Examples include:

| Tool | Description |
|------|-------------|
| **MetaPhlAn** | Uses clade-specific marker genes to estimate microbial relative abundance |
| **mOTUs** | Uses universal single-copy marker genes to detect both known and unknown microbial species |

**Strengths**

- High taxonomic precision  
- Reduced false positives  
- Efficient for community composition profiling  

---

#### 2. k-mer–based classifiers

These tools classify reads by matching short subsequences (*k-mers*) to reference genome databases.

Examples include:

| Tool | Description |
|------|-------------|
| **Kraken2** | Uses exact k-mer matches and a Lowest Common Ancestor (LCA) algorithm for classification |
| **Bracken** | Improves species-level abundance estimation from Kraken results |
| **Phanta** | Fast k-mer-based profiler for sensitive taxonomic assignment |
| **Centrifuge** | Uses compressed indexing for efficient classification with lower memory requirements |

**Strengths**

- Extremely fast classification  
- Suitable for large metagenomic datasets  
- Sensitive detection of many taxa  

---

#### 3. Alignment-based approaches

Alignment-based methods compare reads against reference sequences using traditional sequence alignment.

Examples include:

| Tool | Description |
|------|-------------|
| **DIAMOND + MEGAN** | Aligns reads to protein databases and assigns taxonomy from best matches |
| **Kaiju** | Translates reads into amino acids and aligns them to protein databases |
| **HUMAnN** | Alignment-based approach used primarily for functional profiling |

**Strengths**

- Sensitive detection of distant homologs  
- Useful for detecting evolutionarily distant organisms  

---

### Genome-level taxonomic classification tools

Taxonomy can also be assigned to **assembled genomes or metagenome-assembled genomes (MAGs)** generated during assembly-based analysis.

Because these tools operate on longer genomic sequences rather than short reads, they often provide higher taxonomic resolution and enable classification of previously uncharacterized organisms.

Examples include:

| Tool | Description |
|------|-------------|
| **GTDB-Tk** | Uses conserved marker genes to place genomes within the Genome Taxonomy Database |
| **metaWRAP classify_bins** | Assigns taxonomy to MAGs reconstructed during binning workflows |

Genome-level classification is particularly useful for:

- identifying reconstructed microbial genomes  
- placing novel organisms within the microbial tree of life  
- linking taxonomy with genome-resolved metabolic potential  

---

## Summary of taxonomic annotation approaches

| Approach | Input data | Example tools | Typical purpose |
|----------|-----------|---------------|----------------|
| **Read-based profiling** | Sequencing reads | MetaPhlAn, Kraken2, Bracken, Centrifuge | Rapid community composition profiling |
| **Genome-based classification** | Assembled genomes / MAGs | GTDB-Tk, metaWRAP classify_bins | Genome-level taxonomy assignment |


> In practice, many metagenomic workflows combine multiple approaches. For example, a study might use **MetaPhlAn for precise taxonomic profiling**, **Kraken2 for rapid classification of large datasets**, and **GTDB-Tk for genome-level classification of MAGs reconstructed during assembly-based analysis**.

---

## Key tools used in this module

> **Tools used in this module**

**metaWRAP** – modular pipeline used for genome-resolved metagenomic analysis  
**Kraken** – k-mer–based read-level taxonomic classifier used within metaWRAP  
**Krona** – interactive visualization tool for taxonomic classification results  

metaWRAP provides wrappers for several tools that allow taxonomic annotation within the pipeline.

---

## Part II — Read-based classification using metaWRAP

metaWRAP includes a module called **kraken**, which performs read-level taxonomic classification using the Kraken classifier.

The module generates both classification outputs and interactive Krona visualizations.


#### Input data

This module uses the **quality-controlled, dehosted reads generated in Module 1**.

Example input files:
```text
DEHOSTED_READS/SRR30598619_dehosted.1.fastq.gz
DEHOSTED_READS/SRR30598619_dehosted.2.fastq.gz
```
### Step 1 — Run metaWRAP Kraken module
```bash
metawrap kraken \
    -o kraken_output \
    -t 16 \
    -1 DEHOSTED_READS/SRR30598619_dehosted.1.fastq.gz \
    -2 DEHOSTED_READS/SRR30598619_dehosted.2.fastq.gz
```

##### Parameter explanation
- `-o` output directory
- `-t` number of threads
- `-1` forward reads
- `-2` reverse reads

#### Output
The module produces a directory containing classification results and visualization files.

Example:
```text
kraken_output/
    kraken_output.txt
    krona.html
```

The **krona.html** file provides an interactive visualization of the taxonomic composition of the sample.

> ##### Interpreting Kraken results
The Kraken output reports the number of reads assigned to different taxonomic levels.

These classifications can be used to estimate the relative abundance of taxa present in the microbial community.

## Part III — Assembly-based taxonomic annotation
Assembly-based classification assigns taxonomy to **reconstructed genomes (MAGs)** generated in **Module 2**.

metaWRAP includes the module **classify_bins** for this purpose.

#### Input data
This module uses the refined bins generated in **Module 2**.

Example input directory:
```text
refined_bins/metawrap_bins/
```
Each bin represents a candidate metagenome-assembled genome (MAG).

### Step 2 — Run metaWRAP classify_bins
```bash
metawrap classify_bins \
    -b refined_bins/metawrap_bins \
    -o taxonomy_results \
    -t 16
```
#### Parameter explanation
- `-b` directory containing MAGs to classify
- `-o` output directory for taxonomy results
- `-t` number of CPU threads

#### Output
Example output directory:
```bash
taxonomy_results/
    bin_taxonomy_results.txt
```

Example result:
```text
bin.1   Bacteria;Firmicutes;Clostridia
bin.2   Bacteria;Bacteroidota;Bacteroidia
```
These classifications assign taxonomy to reconstructed genomes.

> #### Interpreting MAG classifications
Taxonomic annotation of MAGs provides insight into which microbial genomes were reconstructed during assembly and binning.

This information can be used to:
- identify dominant microbial genomes in a sample
- investigate microbial diversity
- link taxonomy with metabolic potential
- compare reconstructed genomes across samples

Because classification is performed on reconstructed genomes rather than short reads, assembly-based annotation often provides higher taxonomic resolution.

### Summary

In this module we introduced the two major strategies used for taxonomic profiling in metagenomics:

1.	Read-based classification of sequencing reads
2.	Assembly-based classification of reconstructed genomes

Using the metaWRAP pipeline, we demonstrated how to:
- perform read-level taxonomic classification using metaWRAP kraken
- assign taxonomy to MAGs using metaWRAP classify_bins

We also introduced several standalone tools frequently used in metagenomic research, including MetaPhlAn, Kraken2, Bracken, and GTDB-Tk.

Together, these methods enable researchers to characterize microbial communities and link taxonomic identity with genomic and functional information.