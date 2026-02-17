# Module 5: Functional prediction and annotation from shotgun metagenomic data
Provide participants with the knowledge and practical skills to predict functional potential from shotgun metagenomic data. Participants will learn how to infer functional capacity and genome-resolved metabolic potential using complementary approaches based on quality controlled reads and metagenome-assembled genomes.

## When to use either HUMAnN or Prokka/Bakta 

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

# Part I — Community-level functional profiling (HUMAnN3)
## Overview

This module introduces functional profiling of shotgun metagenomic data using **HUMAnN3**, followed by normalization, merging, and preparation of gene family and pathway abundance tables for downstream statistical analysis.

By the end of this module, participants will be able to:

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

# 1. Scientific background

Shotgun metagenomic sequencing generates millions of short DNA reads per sample. While taxonomic profiling tells us *who is present*, functional profiling answers:

> **What can this microbial community do?**

HUMAnN3 (The HMP Unified Metabolic Analysis Network) reconstructs:

- Gene families (e.g., UniRef)
- Metabolic pathways (MetaCyc-based)
- Stratified functional contributions by taxa

Functional outputs represent **community-level functional capacity** infered from reads, not genome completeness and they tell you “What functions are abundant in this microbial community?”

## What you will do
1. Set up your environment and HUMAnN databases  
2. Run HUMAnN3 on QC’d FASTQ files using Nextflow (Slurm)  
3. Normalize gene families and pathway abundance tables to relative abundance  
4. Merge per-sample outputs into cohort-level tables  
5. Run basic sanity checks and prepare for downstream analysis

---

# 2. Environment setup and activation and checks
## Prerequisites
- QC’d metagenomic reads (from Module 1)
- A working HUMAnN3 installation (conda/mamba or module)
- HUMAnN databases available and configured:
  - ChocoPhlAn (nucleotide)
  - UniRef (protein)
- Nextflow installed (and Slurm available if running on HPC)

## Organise your working directory
### Create a clean folder for this module and place the pipeline files inside it
```bash
mkdir -p module_humann
cd module_humann
```

> **Recommended layout and make the dir's:**
```text
module_humann/
  humann2.nf
  nextflow.config
  qc_cleaned_reads/  # INPUT_DIR points here (contains *fastq.gz)
  humann_output/     # OUTPUT_DIR points here (created during run)
```

### Create/activate a dedicated conda/mamba environment
```bash
mamba create -n phlan3 -c conda-forge -c bioconda -c biobakery metaphlan=3.0 humann=3.9
mamba activate phlan3
```

### Upgrading your databases 
To upgrade your pangenome database:
```bash
humann_databases --download chocophlan full /path/to/databases --update-config yes
```
To upgrade your protein database:
```bash
humann_databases --download uniref uniref90_diamond /path/to/databases --update-config yes
```
To download or update utility mapping databases
```bash
humann_databases --download utility_mapping full /path/to/databases --update-config yes
```

### Confirm installation and that tools are available
```bash
which humann
humann --version
which metaphlan
metaphlan --version
nextflow -version
```

### Configure HUMAnN database paths
HUMAnN needs to know where its databases are located.
Check current config:
```bash
humann_config --print
```

Set database folders (edit paths):
```bash
humann_config --update database_folders nucleotide /path/to/chocophlan/
humann_config --update database_folders protein /path/to/uniref/
```

Confirm again:
```bash
humann_config --print
```

### Prepare input FASTQ files
Your Nextflow pipeline expects files matching:
    ```text
    /*fastq.gz
    ```
Place your sample FASTQs in:
    ```text
    qc_cleaned_reads/
    ```

Example:
```text
    qc_cleaned_reads/
        Sample1.fastq.gz
        Sample2.fastq.gz
        Sample3.fastq.gz
```
Note: This pipeline assumes one FASTQ per sample (merged). If you have paired-end reads, merge them upstream according to your course QC workflow.

---

# 3. Prepare your nextflow configuration and hummann pipeline nextflow files
### What is `nextflow.config` and why do we need it?

`nextflow.config` is a small configuration file that tells Nextflow:

- Where your input files are located
- Where results should be written
- How many CPU threads to use
- How much memory to allocate
- Whether to run jobs on a cluster (e.g., Slurm)

You do **not** need to understand scripting to edit this file.  You only need to change the file paths and resource values.

Think of this file as the “settings page” for your pipeline.

## Prepare a nextflow.config
```bash
nano nextflow.config
```
NB: Update these paths:

```groovy
params {

   input_dir="/path/to/module_humann/qc_cleaned_reads/"   # EDIT THIS
   output_dir="/path/to/module_humann/humann_output/"     # EDIT THIS
   threads=8
   memory="32GB"

}

profiles {
   slurm {
       process.executor = 'slurm'
     }
}
```

Save and exit.

#### What do these parameters mean?

- `input_dir` → Folder containing your QC’d FASTQ files  
- `output_dir` → Folder where HUMAnN results will be saved  
- `threads` → Number of CPU cores to use per sample  
- `memory` → Amount of RAM allocated per job  


If you are unsure what values to use:
- 8 threads and 32GB RAM are usually safe starting points.

### What is `humann2.nf`?

This is a Nextflow workflow file.

Nextflow is a workflow manager that allows us to:
- Run multiple samples in parallel
- Submit jobs to a computing cluster
- Resume interrupted runs safely

You do not need to write Nextflow code yourself.

This file simply tells Nextflow: “For every FASTQ file in the input folder, run HUMAnN and save the results.”

## Prepare your humman.nf file

```bash
nano humman2.nf
```

```groovy
process run_humann {
  maxForks 10
  cpus params.threads
  memory params.memory
  input:  path(sample_file)
  output:
     path("${base}_temp")
  publishDir "${params.output_dir}${base}"
  script:
     base = sample_file.simpleName
  sample_output_dir = "${base}_temp"
  """
  mkdir -p $sample_output_dir
  humann --threads ${params.threads} --input $sample_file --output $sample_output_dir --resume
  """
}

workflow  {
   fq_ch = Channel.fromPath(params.input_dir+"*fastq.gz")
   main:
     run_humann(fq_ch)
}
```
Save and exit.

---
#### What is happening inside this script?

- `process run_humann` → Defines one unit of work (running HUMAnN on one sample)
- `cpus params.threads` → Uses the number of threads defined in the config file
- `memory params.memory` → Uses the memory defined in the config file
- `Channel.fromPath(...*fastq.gz)` → Looks for all FASTQ files in the input directory
- `run_humann(fq_ch)` → Runs HUMAnN on each file found
- `maxForks` → controls how many samples can run **in parallel at the same time**.

In simple terms: Nextflow finds all FASTQ files and runs HUMAnN on each one automatically.

# 4.Running the pipeline on all samples
```bash
nextflow run humann2.nf -profile slurm --resume 2>&1 | tee -a run.log
```
NB:
- `-profile slurm` → submits jobs to the cluster.
- `--resume` → allows continuation of interrupted runs.
- `tee -a` → run.log records output logs.

---
# 5. Running the pipeline on one sample(live demo)
If you want to run only one sample for demonstration purposes, you can run HUMAnN directly without using Nextflow
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

# 6. Understanding HUMAnN Outputs
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

# 7. Normalizing Gene Families
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

# 8. Normalizing Pathway abundance
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

# 9. Merging gene families and pathway abundance across samples
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

# 10.Sanity Checks
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

# 12. Common Mistakes
- Forgetting normalization
- Mixing normalized and non-normalized tables
- Normalizing pathcoverage files
- Incorrect input directory paths
- Not making scripts executable

# 13. Key Take-Home Concepts
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