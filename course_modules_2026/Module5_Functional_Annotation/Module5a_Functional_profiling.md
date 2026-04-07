# Module 5a: Functional prediction and annotation from shotgun metagenomic data

---
editor_options: 
  markdown: 
    wrap: 72
---

## Introduction 

Functional prediction and annotation from shotgun metagenomic data are
essential because they shift microbiome research from describing which
organisms are present to understanding what biological functions they
are capable of performing. While taxonomic profiling identifies
community composition, functional profiling reveals the metabolic
pathways, gene families, and biochemical processes encoded within the
microbiome. In many systems, function is more informative than taxonomy:
different microbial species can perform similar metabolic roles, and it
is these functions—such as short-chain fatty acid production, vitamin
biosynthesis, iron metabolism, nitrogen fixation, or antimicrobial resistance—that
directly influence host health, disease progression, and ecosystem
dynamics.

By reconstructing functional capacity from DNA sequence data,
researchers can generate mechanistic hypotheses about how microbial
communities impact their environment or host. Functional annotation
enables the identification of metabolic pathways linked to clinical
phenotypes, environmental processes, or pathogen virulence, and provides
a foundation for integrating multi-omics data such as transcriptomics,
proteomics, and metabolomics. When combined with genome-resolved
approaches (e.g., annotation of metagenome-assembled genomes),
functional prediction also allows us to determine which specific
organisms encode particular traits, enabling deeper ecological and
translational insights.

![Functional prediction and annotation
mindmap](images/Functional_Annotation_Mind_Map.png)

## Goal of this module:

This module aims to provide participants with the knowledge and practical skills to characterize 
microbiome community composition and infer their functional potential from shotgun metagenomic data. 
Participants will learn how to assess community-level structure, functional capacity, and genome-resolved 
metabolic potential using complementary approaches based on quality-controlled reads and metagenome-assembled genomes (MAGs).

## Learning outcomes

By the end of this module, participants will be able to

-   Explain the principles underlying microbiome analysis from shotgun metagenomics data
    including the distinction between taxonomic composition, community-level functional capacity and genome-resolved metabolic potential.

-   Perform alpha and beta diversity analyses using phyloseq to characterise microbial community structure.
  
-   Apply computational tools (e.g., HUMAnN and Prokka) to quality-controlled metagenomic reads and MAGs to generate functional annotation outputs.

-   Conduct differential abundance analysis of taxa and functional features using statistical tools such as MaAsLin2.

-   Integrate and interpret taxonomic, functional, and genome-resolved results to derive biologically meaningful insights into microbial communities

## HUMAnN

HUMAnN (The HMP Unified Metabolic Analysis Network) is a bioinformatics
tool used to profile the functional potential of microbial communities
from shotgun metagenomic sequencing data. It takes quality-controlled
DNA reads as input and maps them to reference databases to identify gene
families and reconstruct metabolic pathways. In simple terms, HUMAnN
helps determine what biological functions are encoded within a
microbiome.

The software quantifies the relative abundance of genes and pathways
across samples, producing tables that can be used for statistical
analysis and comparison. It can also generate stratified outputs that
link specific functions to contributing microbial taxa. This allows
researchers to move beyond identifying which organisms are present and
instead understand what metabolic activities the community is capable of
performing.

### References:

Website: <https://huttenhower.sph.harvard.edu/humann/>

Publication: Abubucker S., et al. (2012) Metabolic Reconstruction for
Metagenomic Data and Its Application to the Human Microbiome. PLoS
Computational Biology (this earlier work describes the original HUMAnN
approach for functional profiling from metagenomes).
<https://journals.plos.org/ploscompbiol/article?id=10.1371%2Fjournal.pcbi.1002358>

## Prokka

Prokka is a rapid genome annotation tool designed for the functional
annotation of prokaryotic genomes, including bacterial and archaeal
isolate genomes and metagenome-assembled genomes (MAGs). It takes assembled
genome sequences (FASTA files) as input and predicts coding sequences
(CDS), rRNA and tRNA genes, and other genomic features. Prokka assigns
putative functions to genes by comparing them against curated reference
databases, producing standardized annotation files suitable for
downstream analysis.

By annotating MAGs, Prokka enables genome-resolved interpretation of
metabolic potential, allowing researchers to determine which specific
organism encodes particular genes or pathways. This complements
community-level functional profiling tools such as HUMAnN by linking
function directly to reconstructed genomes. The output files (e.g., FAA, GFF,
GBK, TSV) can be used for pathway analysis, comparative genomics,
and integration with other functional databases.

### References:

Prokka GitHub repository (software and documentation):
<https://github.com/tseemann/prokka>

Publication: Seemann T. (2014). Prokka: rapid prokaryotic genome
annotation. Bioinformatics, 30(14), 2068–2069.
<https://doi.org/10.1093/bioinformatics/btu153>

## When to use either HUMAnN or Prokka

Use HUMAnN when: - You want quantitative community-level comparisons -
You are performing statistical modelling - You are linking function to
host phenotypes.

Use Prokka (MAGs) when: - You want to know which organism encodes a
pathway - You want to assess pathway completeness - You want
genome-resolved interpretation.

Both are necessary for robust microbiome functional interpretation. \##
Functional capacity vs functional potential

| Approach | Input | Output | Biological Interpretation |
|--------------|--------------|--------------|-------------------------------|
| HUMAnN3 | Short reads | Relative abundance of pathways | Community-level functional capacity |
| Prokka on MAGs | Genome FASTA | Annotated genes & CDS | Genome-resolved functional potential |

## Useful concepts

-   **MetaPhlAn (Metagenomic Phylogenetic Analysis)** A computational
    tool used to profile the composition of microbial communities from
    metagenomic sequencing data using clade-specific marker genes.

-   **ChocoPhlAn** A reference database used by HUMAnN that contains
    annotated microbial genomes and gene sequences, enabling
    species-level functional profiling of metagenomic samples.

-   **UniRef (UniProt Reference Clusters)** A set of clustered protein
    sequence databases (UniRef100, UniRef90, UniRef50) that group
    similar sequences together to reduce redundancy and improve
    computational efficiency in sequence analysis.

-   **Gene families** Groups of genes that share a common evolutionary
    origin and have similar sequences and often similar biological
    functions.

# Part I — Community-level functional profiling (HUMAnN3)

## Overview

This part introduces functional profiling of shotgun metagenomic data
using **HUMAnN3**, followed by normalization, merging, and preparation
of gene family and pathway abundance tables for downstream statistical
analysis.

By the end of this part, participants will be able to:

-   Run HUMAnN3 on quality-controlled reads
-   Interpret gene family and pathway outputs
-   Normalize outputs to relative abundance
-   Merge sample-level outputs into cohort-level matrices
-   Perform sanity checks before downstream modelling

> **Schematic workflow**

``` text
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

***Due to time constraints, this step will not be run during the class.
Instead, we will examine how to normalise and merge outputs from humann3.***

The next part will explain how to run HUMAnN on one sample.

If you are interested in learning how to run HUMAnN on multiple samples,
please go to
[Module5a_Supplementary1_HUMAnN_on_Nextflow.md](Module5a_Supplementary1_HUMAnN_on_Nextflow.md)

# Running the pipeline on one sample.

***Due to time constraints, this step will not be run during the class.
Instead, we will examine and discuss its outputs.***

Download and HuMAnN pipeline from biobakery as indicated in
[Module5a_Supplementary1_HUMAnN_on_Nextflow.md](Module5a_Supplementary1_HUMAnN_on_Nextflow.md)
.

Ensure the databases are updated and the paths for the databases are set
correctly.

Also remember to activate your mamba environment before running the
HuMAnN pipeline.

### Create a clean folder for this module and place the pipeline files inside it

``` bash
mkdir -p module_humann
cd module_humann
mkdir -p humann_output
```

> **Recommended layout and make the dir's:**

``` text
Module1/cleaned_reads  # INPUT_DIR points here (contains cleaned from Module 1 *fastq.gz)
module_humann/
  humann_output/     # OUTPUT_DIR points here (created during run)
```

### Create/activate a dedicated conda/mamba environment

``` bash
mamba create -n phlan3 -c conda-forge -c bioconda -c biobakery metaphlan=3.0 humann=3.9
mamba activate phlan3
```

## Step 1 — Choose one FASTQ file

First combine or otherwise prepare the paired reads into the required
input format. Example:

``` bash
mkdir -p /humann_output/SRR30598619

mkdir -p /humann_combined
cd humann_combined
cat Module1/cleaned_reads/SRR30598619_clean_1.fastq.gz \
    Module1/cleaned_reads/SRR30598619_clean_2.fastq.gz \
    > /humann_combined/SRR30598619_combined.fastq.gz
```

## Step 2 — Run HUMAnN directly

``` bash
humann \
  --input /humann_combined/SRR30598619_combined.fastq.gz \
  --output /humann_output/SRR30598619 \
  --threads 8 \
  --resume
```

What this does:

\- Runs MetaPhlAn prescreen

\- Maps reads to ChocoPhlAn

\- Performs translated search with UniRef

\- Reconstructs gene families and pathways

\- Writes output to humann_output/SRR30598619/

# Understanding HUMAnN Outputs

## Each sample produces:

```         
    *_genefamilies.tsv
    *_pathabundance.tsv
    *_pathcoverage.tsv
```

You can see an example of these outputs in ***Module5a/SRR30598619/***
on the working station or on out course Github page:
<https://github.com/WCSCourses/Human_Gut_Microbiome_Metagenomics_2026/tree/main/course_data_2026/Module5a/SRR30598619>
.

## Gene Families

-   UniRef identifiers
-   May include stratified entries (gene\|taxon)
-   Include UNMAPPED

### Stratified vs Unstratified Entries

HUMAnN outputs contain two types of gene family entries:

-   **Unstratified entries**: represent the overall community-level
    abundance of a gene family.
-   **Stratified entries (`gene|taxon`)**: represent the contribution of
    a specific taxon to that gene family.

For example:

-   `UniRef90_A0A123` → total community abundance\
-   `UniRef90_A0A123|g__Faecalibacterium` → contribution from
    *Faecalibacterium*

Stratified outputs allow you to link function to specific microbial
taxa.

## Pathway abundance

-   Quantitative abundance values

## Pathway Coverage

-   0–1 confidence score \*\***Do not normalize coverage files
    (\*\_pathcoverage.tsv).**\*\*

------------------------------------------------------------------------

# Normalizing Gene Families

Gene families are normalised to remove technical biases (like sequencing
depth and gene length) so that observed differences reflect **true
biological variation**, not artefacts of the data.

Raw counts on their own are misleading for several reasons:

-   Different samples often have different numbers of reads. A sample
    with more reads will naturally have higher counts for every gene
    family—even if the underlying biology is the same.

-   Longer genes are more likely to be hit by sequencing reads than
    shorter ones.

-   Microbial communities differ in average genome size and in how many
    copies of a gene family organisms carry.

-   Without normalisation, you can’t reliably compare gene family
    profiles between samples, conditions, or experiments.

You can refer to the script located at
[`Module5a/scripts/gene_normalize_rel_ab.sh`](https://github.com/WCSCourses/Human_Gut_Microbiome_Metagenomics_2026/blob/main/course_data_2026/Module5a/scripts/gene_normalize_rel_ab.sh)
to see an example of how gene family data can be normalised.

# Normalizing Pathway abundance

Pathway abundances are normalised to make samples comparable. This
process corrects for differences in sequencing depth and underlying gene
abundances, ensuring that observed differences reflect true biological
variation rather than technical bias.

You can refer to the script located at
[Module5a/scripts/path_normalize_rel_ab.sh](https://github.com/WCSCourses/Human_Gut_Microbiome_Metagenomics_2026/blob/main/course_data_2026/Module5a/scripts/path_normalize_rel_ab.sh)
to see an example of how Pathway abundance data can be normalised.

# Merging gene families and pathway abundance across samples

Merging gene family and pathway abundances across samples is important
because it creates a single, consistent dataset that can be compared and
analysed collectively.

It allows you to identify patterns, differences, and trends across
samples (e.g. between conditions or groups), perform statistical
analyses, and generate visualisations. Without merging, each sample
remains isolated, making meaningful comparisons and downstream analysis
difficult.

***Below are example commands showing how to merge the files.***

#### Merge gene families

``` bash
humann_join_tables \
  --input /path/to/gene_normalize/ \
  --output merged_genefamilies_relab.tsv \
  --file_name genefamilies
```

#### Merge pathway abundance

``` bash
humann_join_tables \
  --input /path/to/path_normalize/ \
  --output merged_pathabundance_relab.tsv \
  --file_name pathabundance
```

#### Merge pathway coverage

``` bash
humann_join_tables \
  --input /path/to/humann_output/ \
  --output merged_pathcoverage.tsv \
  --file_name pathcoverage
```

# Sanity Checks

## In R:

``` r
before_sum <- sum(merged_genes[[2]])
print(before_sum)
```

### Expected:

-   Sum close to 1
-   No values \>1
-   UNMAPPED present

# 11. Feature filtering before statistical modelling

HUMAnN outputs may contain hundreds of thousands of features therefore
filtering reduces noise and improves statistical power.

> **Recommended filtering** Minimum prevalence ≥ 10%; Minimum mean
> abundance ≥ 1e-05

### Example in R:

rowMeans(data \> 0) \>= 0.10 rowMeans(data) \>= 1e-05

# Common Mistakes

-   Forgetting normalization
-   Mixing normalized and non-normalized tables
-   Normalizing pathcoverage files
-   Incorrect input directory paths
-   Not making scripts executable

# Key Take-Home Concepts

-   HUMAnN quantifies community-level functional capacity
-   Stratified outputs show taxon-specific contributions
-   Relative abundance enables cross-sample comparison
-   Coverage indicates pathway presence confidence

# Part II — Genome-Resolved Functional Annotation (Prokka on MAGs)

***Due to time constraints, this part will not be run during the class.
Instead, we will examine and discuss its outputs.***

## Overview

In Part II, we will annotate **Metagenome-Assembled Genomes (MAGs)**
using **Prokka**, a rapid prokaryotic genome annotation tool.

In this section, we shift perspective:

> Instead of asking *“What can the community do?”*\
> We now ask:\
> **“What can this specific reconstructed genome do?”**

Prokka on MAGs tells you:

“Which specific genome encodes which functional genes?”

> **Schematic workflow**

``` text
MAG Assembly & Binning
    ↓
Prokka Annotation (Genome-level function)
    ↓
Integrate function + taxonomy
```

------------------------------------------------------------------------

# 1. Conceptual Background

## What is a MAG?

A Metagenome-Assembled Genome (MAG) is a draft genome reconstructed from
metagenomic assembly and binning.

MAGs allow us to:

-   Assign functions to specific organisms
-   Assess pathway completeness within a genome
-   Explore strain-level metabolic potential
-   Link taxonomy to metabolism mechanistically

------------------------------------------------------------------------

# 2. Input Requirements

The files needed in this tutorial are stored here:
<https://github.com/WCSCourses/Human_Gut_Microbiome_Metagenomics_2026/tree/main/course_data_2026/Module2/MAG_practical>

They are:

-   MAG FASTA files

These should be:

-   Binned
-   Quality controlled
-   Preferably with completeness \> 90% and contamination \< 5% from
    module 2.

------------------------------------------------------------------------

# 3. Install Prokka

***You do not need to do this step during the class. Prokka has already
been installed for you.***

If using conda/mamba:

``` bash
mamba create -n prokka_env -c conda-forge -c bioconda prokka
mamba activate prokka_env
```

Confirm installation:

``` bash
prokka --version
```

# 4. Running Prokka on a Single MAG

The input for this command can be found on your work computer and also
at
<https://github.com/WCSCourses/Human_Gut_Microbiome_Metagenomics_2026/tree/main/course_data_2026/Module2/MAG_practical/assembly>

Basic command:

``` bash
prokka \
  --centre X \
  --compliant \
  --kingdom Bacteria \
  --outdir ./cleaned_SRR30598619_bin.20.orig_filtered_kept_contigs_prokka \
  --prefix cleaned_SRR30598619_bin.20.orig_filtered_kept_contigs \
  Module3/MAGs/cleaned_fasta/cleaned_SRR30598619_bin.20.orig_filtered_kept_contigs.fa
```

What this does:

\- Predicts coding sequences (CDS)

\- Identifies rRNA and tRNA genes

\- Assigns functional annotations using internal databases

\- Produces multiple output files

# 5. Understanding Prokka Outputs

Please check the outputs for each high quality MAG from one sample (SRR30598619) here:
<https://github.com/WCSCourses/Human_Gut_Microbiome_Metagenomics_2026/tree/main/course_data_2026/Module5a/prokka_annotation_SRR30598619>

Inside: cleaned_SRR30598619_bin.20.orig_filtered_kept_contigs_prokka/ you will see 12 files:
``` bash
cleaned_SRR30598619_bin.20.orig_filtered_kept_contigs.gff (Annotation file (recommended master file))
cleaned_SRR30598619_bin.20.orig_filtered_kept_contigs.faa (Predicted protein sequences)
cleaned_SRR30598619_bin.20.orig_filtered_kept_contigs.gbk (GenBank format)
cleaned_SRR30598619_bin.20.orig_filtered_kept_contigs.ffn (Nucleotide sequences of genes)
cleaned_SRR30598619_bin.20.orig_filtered_kept_contigs.tsv (Tab-delimited annotation summary #Important output)
cleaned_SRR30598619_bin.20.orig_filtered_kept_contigs.txt (Summary statistics)
cleaned_SRR30598619_bin.20.orig_filtered_kept_contigs.fna
cleaned_SRR30598619_bin.20.orig_filtered_kept_contigs.err 
cleaned_SRR30598619_bin.20.orig_filtered_kept_contigs.fsa
cleaned_SRR30598619_bin.20.orig_filtered_kept_contigs.log
cleaned_SRR30598619_bin.20.orig_filtered_kept_contigs.sqn
cleaned_SRR30598619_bin.20.orig_filtered_kept_contigs.tbl
```
Check the .tsv file output is typically used for downstream functional
exploration and contains

\- Locus tags

\- Gene names

\- Product descriptions

\- Database hits

``` bash
head cleaned_SRR30598619_bin.20.orig_filtered_kept_contigs_prokka/cleaned_SRR30598619_bin.20.orig_filtered_kept_contigs.tsv
```

# 6. Running Prokka on multiple MAGs

***Due to time constraints, this part will not be run during the class.
Instead, we will examine and discuss its outputs.***

Check the
[run_prokka.sh](https://github.com/WCSCourses/Human_Gut_Microbiome_Metagenomics_2026/blob/main/course_data_2026/Module5a/scripts/run_prokka.sh)
script.

The ***.gff*** files for the samples presented in this course can be
inspected here:
<https://github.com/WCSCourses/Human_Gut_Microbiome_Metagenomics_2026/tree/main/course_data_2026/Module5a/prokka_annotation>

------------------------------------------------------------------------

# 7. Interpreting Genome-Resolved functional potential

After annotation, you can:

S**earch for specific genes:**

``` bash
grep -i "coaA" cleaned_SRR30598619_bin.20.orig_filtered_kept_contigs_prokka/cleaned_SRR30598619_bin.20.orig_filtered_kept_contigs.tsv
```

> **Count total predicted genes:**

``` bash
grep -c "CDS" cleaned_SRR30598619_bin.20.orig_filtered_kept_contigs_prokka/cleaned_SRR30598619_bin.20.orig_filtered_kept_contigs.gff
```

> **Extract protein sequences:**

``` bash
less cleaned_SRR30598619_bin.20.orig_filtered_kept_contigs_prokka/cleaned_SRR30598619_bin.20.orig_filtered_kept_contigs.faa
```

------------------------------------------------------------------------

# 8. Summary

Using Prokka on MAGs provides:

\- Genome-resolved functional annotation

\- Organism-specific metabolic potential

\- Complementary insight to HUMAnN3 community-level profiling

> **After Prokka, you may:**

``` text
- Map proteins (.faa file) to KEGG orthologs (KO)
- Use eggNOG-mapper for expanded annotation (.faa file)
- Assess pathway completeness manually
- Integrate with HUMAnN stratified outputs
```

⸻
