# Module 5: Functional prediction and annotation from shotgun metagenomic data

## Introduction

Functional prediction and annotation from shotgun metagenomic data are essential because they shift microbiome research from describing which organisms are present to understanding what biological functions they are capable of performing. While taxonomic profiling identifies community composition, functional profiling reveals the metabolic pathways, gene families, and biochemical processes encoded within the microbiome. In many systems, function is more informative than taxonomy: different microbial species can perform similar metabolic roles, and it is these functions—such as short-chain fatty acid production, vitamin biosynthesis, nitrogen fixation, or antimicrobial resistance—that directly influence host health, disease progression, and ecosystem dynamics.

By reconstructing functional capacity from DNA sequence data, researchers can generate mechanistic hypotheses about how microbial communities impact their environment or host. Functional annotation enables the identification of metabolic pathways linked to clinical phenotypes, environmental processes, or pathogen virulence, and provides a foundation for integrating multi-omics data such as transcriptomics, proteomics, and metabolomics. When combined with genome-resolved approaches (e.g., annotation of metagenome-assembled genomes), functional prediction also allows us to determine which specific organisms encode particular traits, enabling deeper ecological and translational insights.

![Functional prediction and annotation mindmap](images/Functional_Annotation_Mind_Map.png)

## Goal of this module: 

This module aims to provide participants with the knowledge and practical skills to predict functional potential from shotgun metagenomic data. Participants will learn how to infer functional capacity and genome-resolved metabolic potential using complementary approaches based on quality controlled reads and metagenome-assembled genomes.

## Learning outcomes

By the end of this module, participants will be able to

* Explain the principles of functional prediction from shotgun metagenomic data, including the distinction between community-level functional capacity and genome-resolved metabolic potential.

* Apply computational tools (e.g., HUMAnN and Prokka) to quality-controlled metagenomic reads and metagenome-assembled genomes (MAGs) in order to generate functional annotation outputs.

* Interpret and compare community-level functional profiles and genome-resolved annotations to infer biologically meaningful insights about metabolic potential within microbial communities.

## HUMAnN
HUMAnN (The HMP Unified Metabolic Analysis Network) is a bioinformatics tool used to profile the functional potential of microbial communities from shotgun metagenomic sequencing data. It takes quality-controlled DNA reads as input and maps them to reference databases to identify gene families and reconstruct metabolic pathways. In simple terms, HUMAnN helps determine what biological functions are encoded within a microbiome.

The software quantifies the relative abundance of genes and pathways across samples, producing tables that can be used for statistical analysis and comparison. It can also generate stratified outputs that link specific functions to contributing microbial taxa. This allows researchers to move beyond identifying which organisms are present and instead understand what metabolic activities the community is capable of performing.

### References: 
Website: [https://huttenhower.sph.harvard.edu/humann/](https://huttenhower.sph.harvard.edu/humann/)

Publication:
Abubucker S., et al. (2012) Metabolic Reconstruction for Metagenomic Data and Its Application to the Human Microbiome. PLoS Computational Biology (this earlier work describes the original HUMAnN approach for functional profiling from metagenomes). [https://journals.plos.org/ploscompbiol/article?id=10.1371%2Fjournal.pcbi.1002358](https://journals.plos.org/ploscompbiol/article?id=10.1371%2Fjournal.pcbi.1002358)

## Prokka
Prokka is a rapid genome annotation tool designed for the functional annotation of prokaryotic genomes, including bacterial and archaeal isolates and metagenome-assembled genomes (MAGs). It takes assembled genome sequences (FASTA files) as input and predicts coding sequences (CDS), rRNA and tRNA genes, and other genomic features. Prokka assigns putative functions to genes by comparing them against curated reference databases, producing standardized annotation files suitable for downstream analysis.

By annotating MAGs, Prokka enables genome-resolved interpretation of metabolic potential, allowing researchers to determine which specific organism encodes particular genes or pathways. This complements community-level functional profiling tools such as HUMAnN by linking function directly to reconstructed genomes. The output files (e.g., GFF, GBK, TSV, FAA) can be used for pathway analysis, comparative genomics, and integration with other functional databases.

### References: 
Prokka GitHub repository (software and documentation):
[https://github.com/tseemann/prokka](https://github.com/tseemann/prokka)

Publication:
Seemann T. (2014). Prokka: rapid prokaryotic genome annotation. Bioinformatics, 30(14), 2068–2069.
[https://doi.org/10.1093/bioinformatics/btu153](https://doi.org/10.1093/bioinformatics/btu153)

## When to use either HUMAnN or Prokka

Use HUMAnN when:
- You want quantitative community-level comparisons
- You are performing statistical modelling
- You are linking function to host phenotypes

Use Prokka (MAGs) when:
- You want to know which organism encodes a pathway
- You want to assess pathway completeness
- You want genome-resolved interpretation

Both are necessary for robust microbiome functional interpretation.
## Functional capacity vs functional potential

| Approach | Input | Output | Biological Interpretation |
|-----------|--------|--------|----------------------------|
| HUMAnN3 | Short reads | Relative abundance of pathways | Community-level functional capacity |
| Prokka on MAGs | Genome FASTA | Annotated genes & CDS | Genome-resolved functional potential |

## Useful concepts

* **MetaPhlAn (Metagenomic Phylogenetic Analysis)**
A computational tool used to profile the composition of microbial communities from metagenomic sequencing data using clade-specific marker genes.

* **ChocoPhlAn**
A reference database used by HUMAnN that contains annotated microbial genomes and gene sequences, enabling species-level functional profiling of metagenomic samples.

* **UniRef (UniProt Reference Clusters)**
A set of clustered protein sequence databases (UniRef100, UniRef90, UniRef50) that group similar sequences together to reduce redundancy and improve computational efficiency in sequence analysis.

* **Gene families**
Groups of genes that share a common evolutionary origin and have similar sequences and often similar biological functions.


# Part I — Community-level functional profiling (HUMAnN3)
## Overview

This part introduces functional profiling of shotgun metagenomic data using **HUMAnN3**, followed by normalization, merging, and preparation of gene family and pathway abundance tables for downstream statistical analysis.

By the end of this part, participants will be able to:

- Run HUMAnN3 on quality-controlled reads
- Interpret gene family and pathway outputs
- Normalize outputs to relative abundance
- Merge sample-level outputs into cohort-level matrices
- Perform sanity checks before downstream modelling

> **Schematic workflow**
```text
QC Reads
    ↓
HUMAnN3 (Community-level function)
    ↓
Normalize & Merge
```
---
HUMAnN3 (The HMP Unified Metabolic Analysis Network) reconstructs:

- Gene families (e.g., UniRef)
- Metabolic pathways (MetaCyc-based)
- Stratified functional contributions by taxa

Functional outputs represent **community-level functional capacity** infered from reads, not genome completeness and they tell you “What functions are abundant in this microbial community?”
---

# Exercise 
The next part will explain how to run HUMAnN on one sample.

If you are interested in learning how to run HUMAnN on multiple samples, please go to [Running_HUMAnN_on_an_HPC_using _Nextflow.md](Running_HUMAnN_on_an_HPC_using _Nextflow.md).

# Running the pipeline on one sample(live demo)

## Step 1 — Choose one FASTQ file

Example:
```bash
mkdir -p humann_output/Sample1
qc_cleaned_reads/Sample1.fastq.gz
```

## Step 2 — Run HUMAnN directly
```bash
humann \
  --input qc_cleaned_reads/Sample1.fastq.gz \
  --output humann_output/Sample1 \
  --threads 8 \
  --resume
```
What this does:
- Runs MetaPhlAn prescreen
- Maps reads to ChocoPhlAn
- Performs translated search with UniRef
- Reconstructs gene families and pathways
- Writes output to humann_output/Sample1/

# Understanding HUMAnN Outputs
## Each sample produces:
        *_genefamilies.tsv
        *_pathabundance.tsv
        *_pathcoverage.tsv

## Gene Families
- UniRef identifiers
- May include stratified entries (gene|taxon)
- Include UNMAPPED

### Stratified vs Unstratified Entries

HUMAnN outputs contain two types of gene family entries:

- **Unstratified entries**: represent the overall community-level abundance of a gene family.
- **Stratified entries (`gene|taxon`)**: represent the contribution of a specific taxon to that gene family.

For example:

- `UniRef90_A0A123` → total community abundance  
- `UniRef90_A0A123|g__Faecalibacterium` → contribution from *Faecalibacterium*

Stratified outputs allow you to link function to specific microbial taxa.

## Pathway abundance
- Quantitative abundance values

## Pathway Coverage
- 0–1 confidence score
**Do not normalize coverage files  (*_pathcoverage.tsv).**

---

# Normalizing Gene Families
Create: gene_normalize_rel_ab.sh

```bash
#!/bin/bash

INPUT_DIR="/path/to/humann_output/"       # EDIT THIS
OUTPUT_DIR="/path/to/gene_normalize/"     # EDIT THIS

mkdir -p "$OUTPUT_DIR"

find "$INPUT_DIR" -type f -name "*_genefamilies.tsv" | while read SAMPLE_FILE; do
    
    BASENAME=$(basename "$SAMPLE_FILE")
    OUTPUT_FILE="$OUTPUT_DIR/${BASENAME%.tsv}_relab.tsv"
    
    echo "Normalizing gene families: $BASENAME"
    
    humann_renorm_table \
        --input "$SAMPLE_FILE" \
        --output "$OUTPUT_FILE" \
        --units relab

    if [ $? -eq 0 ]; then
        echo "✅ Successfully processed: $BASENAME"
    else
        echo "❌ Failed to process: $BASENAME"
    fi
done
```

Make executable: 
```bash
chmod +x gene_normalize_rel_ab.sh
```

Run: 
```bash
./gene_normalize_rel_ab.sh
```

---

# Normalizing Pathway abundance
Create: path_normalize_rel_ab.sh

```bash
#!/bin/bash

INPUT_DIR="/path/to/humann_output/"        # EDIT THIS
OUTPUT_DIR="/path/to/path_normalize/"      # EDIT THIS

mkdir -p "$OUTPUT_DIR"

find "$INPUT_DIR" -type f -name "*_pathabundance.tsv" | while read SAMPLE_FILE; do
    
    BASENAME=$(basename "$SAMPLE_FILE")
    OUTPUT_FILE="$OUTPUT_DIR/${BASENAME%.tsv}_relab.tsv"

    echo "Normalizing pathway abundances: $BASENAME"

    humann_renorm_table \
        --input "$SAMPLE_FILE" \
        --output "$OUTPUT_FILE" \
        --units relab

    if [ $? -eq 0 ]; then
        echo "✅ Successfully processed: $BASENAME"
    else
        echo "❌ Failed to process: $BASENAME"
    fi
done
```

Make executable: 
```bash 
chmod +x path_normalize_rel_ab.sh 
```
Run:
```bash 
./path_normalize_rel_ab.sh
```
---

# Merging gene families and pathway abundance across samples
## Merge gene families
```bash
humann_join_tables \
  --input /path/to/gene_normalize/ \
  --output merged_genefamilies_relab.tsv \
  --file_name genefamilies
```
## Merge pathway abundance
```bash
humann_join_tables \
  --input /path/to/path_normalize/ \
  --output merged_pathabundance_relab.tsv \
  --file_name pathabundance
```

# Sanity Checks
## In R:
```r
before_sum <- sum(merged_genes[[2]])
print(before_sum)
```

### Expected:
- Sum close to 1
- No values >1
- UNMAPPED present

# 11. Feature filtering before statistical modelling
HUMAnN outputs may contain hundreds of thousands of features therefore filtering reduces noise and improves statistical power.

> **Recommended filtering**
Minimum prevalence ≥ 10%; 
Minimum mean abundance ≥ 1e-05

### Example in R:
rowMeans(data > 0) >= 0.10
rowMeans(data) >= 1e-05

# Common Mistakes
- Forgetting normalization
- Mixing normalized and non-normalized tables
- Normalizing pathcoverage files
- Incorrect input directory paths
- Not making scripts executable

# Key Take-Home Concepts
- HUMAnN quantifies community-level functional capacity
- Stratified outputs show taxon-specific contributions
- Relative abundance enables cross-sample comparison
- Coverage indicates pathway presence confidence

---
---

# Part II — Genome-Resolved Functional Annotation (Prokka on MAGs)

## Overview

In Part II, we will annotate **Metagenome-Assembled Genomes (MAGs)** using **Prokka**, a rapid prokaryotic genome annotation tool.

In this section, we shift perspective:

> Instead of asking *“What can the community do?”*  
> We now ask:  
> **“What can this specific reconstructed genome do?”**

Prokka on MAGs tells you:

“Which specific genome encodes which functional genes?”

> **Schematic workflow**
```text
MAG Assembly & Binning
    ↓
Prokka Annotation (Genome-level function)
    ↓
Integrate function + taxonomy
```
---

# 1. Conceptual Background

## What is a MAG?

A Metagenome-Assembled Genome (MAG) is a draft genome reconstructed from metagenomic assembly and binning.

MAGs allow us to:

- Assign functions to specific organisms
- Assess pathway completeness within a genome
- Explore strain-level metabolic potential
- Link taxonomy to metabolism mechanistically

---

# 2. Input Requirements

You will need:

- MAG FASTA files  
```text
  Example:
    MAG1.fa
    MAG2.fa
    MAG3.fa
```
These should be:

- Binned
- Quality controlled
- Preferably with completeness > 70% and contamination < 10% from module 2.

---

# 3. Install Prokka

If using conda/mamba:

```bash
mamba create -n prokka_env -c conda-forge -c bioconda prokka
mamba activate prokka_env
```

Confirm installation:
```bash
prokka --version
```

# 4. Running Prokka on a Single MAG
Basic command:
```bash
prokka MAG1.fa --outdir MAG1_annotation --prefix MAG1

```

What this does:
- Predicts coding sequences (CDS)
- Identifies rRNA and tRNA genes
- Assigns functional annotations using internal databases
- Produces multiple output files

# 5. Understanding Prokka Outputs
Inside:
MAG1_annotation/
You will see:
- .gff  Annotation file (recommended master file)
- .gbk  GenBank format
- .faa  Predicted protein sequences
- .ffn  Nucleotide sequences of genes
- .tsv  Tab-delimited annotation summary    #Important output
- .txt  Summary statistics 

Check the .tsv file output is typically used for downstream functional exploration and contains 
- Locus tags
- Gene names
- Product descriptions
- Database hits

```bash
head MAG1_annotation/MAG1.tsv
```

# 6. Running Prokka on multiple MAGs

Create a simple loop script:
```bash
nano run_prokka.sh
```
copy this into that

```bash
#!/bin/bash

INPUT_DIR="/path/to/MAGs/"          # EDIT THIS
OUTPUT_DIR="/path/to/prokka_output/" # EDIT THIS

mkdir -p "$OUTPUT_DIR"

for MAG in "$INPUT_DIR"/*.fa; do
    
    BASENAME=$(basename "$MAG" .fa)
    
    echo "Annotating $BASENAME"
    
    prokka "$MAG" \
        --outdir "$OUTPUT_DIR/$BASENAME" \
        --prefix "$BASENAME"

done

echo "All MAGs annotated."

```
save and exit

Make executable:
```bash
chmod +x run_prokka.sh
```

Run:
```bash
./run_prokka.sh
```
---

# 7. Interpreting Genome-Resolved functional potential
After annotation, you can:
> **Search for specific genes:**
```bash
grep -i "butyrate" MAG1_annotation/MAG1.tsv
```
> **Count total predicted genes:**
```bash
grep -c "CDS" MAG1_annotation/MAG1.gff
```
>**Extract protein sequences:**
```bash
less MAG1_annotation/MAG1.faa
```

---
# 8. Summary

Using Prokka on MAGs provides:
- Genome-resolved functional annotation
- Organism-specific metabolic potential
- Complementary insight to HUMAnN3 community-level profiling

> **After Prokka, you may:**
```text
- Map proteins to KEGG orthologs (KO)
- Use eggNOG-mapper for expanded annotation
- Assess pathway completeness manually
- Integrate with HUMAnN stratified outputs
```
⸻