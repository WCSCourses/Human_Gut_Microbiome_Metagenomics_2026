# Module 5b 
## AMR Gene Profiling in Human Gut Microbiome MAGs

#Module Lead
Rahma Golicha   
Caroline Tigoi  

## Module Overview

This module introduces **Antimicrobial Resistance Gene (ARG) profiling** using the **Resistance Gene Identifier (RGI)** tool in metagenomic mode (`rgi main`).

We will profile the **resistome of human gut microbiome MAGs** using the Comprehensive Antibiotic Resistance Database (CARD).

RGI predicts AMR genes using:

- **Perfect hits** (exact matches)
- **Strict hits** (high-confidence matches)
- Optional **Loose / Nudged hits** (exploratory mode)

In this training, we focus on:

- Protein homolog model  
- Protein variant model (point mutations)

RGI workflow:
- Predicts ORFs using Prodigal  
- Compares sequences against CARD resistance models  
- Outputs structured AMR predictions  

📖 Documentation:  
https://github.com/arpcard/rgi/blob/master/docs/rgi_main.rst  

---

# Learning Outcomes

By the end of this session, participants will be able to:

- Create a clean Conda environment
- Install RGI and dependencies (BLAST, DIAMOND, Prodigal)
- Load the CARD database locally
- Run RGI on MAGs
- Merge multiple RGI outputs
- Prepare results for downstream analysis in R

---

# Where This Fits in Gut Metagenomics

```
QC → Assembly → Binning → MAG refinement → AMR profiling → Ecological interpretation
```

This module focuses on the **AMR profiling step**.

---

# Requirements

Participants should have:

- Basic Linux command-line familiarity
- Conda or Miniconda installed
- Access to a Linux environment
- Human gut MAG FASTA files

---

# Exercise 1 — Environment Setup
You can skip the Environment Setup in the classroom. The environment has been already setup for you.

## 1️⃣ Initialize Conda

#Download and Initialize conda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
/scratch/home/train6/miniconda3/bin/conda init bash

```bash
conda init bash
source ~/.bashrc
```

---

## 2️⃣ Install Mamba (Faster Package Manager)

```bash
conda install -n base -c conda-forge mamba
mamba --version
```
---
## 3️⃣ Create a Clean Environment

```bash
conda create -n rgi_env
conda activate rgi_env
```
---

## 4️⃣ Configure Channels

```bash
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge
conda config --set channel_priority strict
```
---

## 5️⃣ Install RGI

```bash
mamba install rgi
rgi main --version
```
---
# Exercise 2 — Download and Load CARD Database

## Download CARD. You can skip this in the classroom. Move to loading the database into RGI.

```bash
wget https://card.mcmaster.ca/latest/data
tar -xvf data
```
## Load Database into RGI. This is quite slow.

```bash
rgi load --card_json card.json --local
rgi database --version
```
---
# Exercise 3 — Run RGI on Human Gut MAGs
## Input Data
Participants will use pre-generated Metagenome-Assembled Genomes (MAGs) in FASTA format. 
The MAGs are stored in Module3/MAGS/cleaned_fasta.

Example files:

Module3/MAGS/cleaned_fasta/cleaned_SRR30598619_bin.3.orig_filtered_kept_contigs.fa
Module3/MAGS/cleaned_fasta/cleaned_SRR30598619_bin.8.orig_filtered_kept_contigs.fa

Each FASTA file represents a single MAG (assembled genome bin).


### Run RGI on the first MAG

```bash
rgi main \
  --input_sequence /data/microbiome_course2026/course_data_2026/Module3/MAGs/cleaned_fasta/ \
  --output_file /data/microbiome_course2026/course_data_2026/Module5b/output/ \
  --local \
  --clean \
  --include_nudge \
  --num_threads 8
```
### Run RGI on the second MAG 

```bash
rgi main \
  --input_sequence module3/cleaned_fasta/cleaned_SRR30598619_bin.8.orig_filtered_kept_contigs.fa \
  --output_file module5b/output/mag8_test_amr_out \
  --local \
  --clean \
  --include_nudge \
  --num_threads 8
```
---

# Exercise 4 — Understanding Output Files

### location:
Outputs are saved in the same directory as the input unless specified.

Each ```rgi main``` command run for each genome produces:

- `*.txt` → Tabular AMR predictions  
- `*.json` → Structured results for visualization 

### 📄 Files to inspect:

- `mag3_test_amr_out.txt` ✅ (MAIN file for analysis)
- `mag3_test_amr_out.json` (optional visualization)

- `mag8_test_amr_out.txt` ✅ (MAIN file for analysis)
- `mag8_test_amr_out.json` (optional visualization)
- 
The `.txt` file includes:

- ORF_ID → predicted gene
- Contig → source contig
- Best_Hit_ARO → resistance gene
- Drug_Class → antibiotic class
- Resistance Mechanism
- % Identity
- Cutoff → Perfect / Strict / Loose


### Goal:
If you have more MAGs, combine into a single table with MAG identifiers.

Create a bash script in the module5b directory.


###Command

```bash
out_file="combined_rgi_results.tsv"

# Extract header
header=$(head -n1 module5b/output/mag3_test_amr_out.txt)
echo -e "MAG_ID\t$header" > $out_file

# Loop through all output files
for f in output/*_amr_out.txt; do
    mag_id=$(basename "$f" _amr_out.txt)
    tail -n +2 "$f" | awk -v id="$mag_id" 'BEGIN{OFS="\t"} {print id, $0}'
done >> $out_file
```

This file can now be imported into **R** for downstream ecological analysis.

---

# Biological Interpretation in Human Gut Context

When analyzing gut microbiome MAGs:

Consider:

- Core resistome genes shared across
- Pathogen-enriched resistance genes
- Ecological and clinical relevance


Ask:

- Do certain taxa carry higher AMR burden?

---
#Note: AMR analysis has already been performed on all MAGs for you; participants can access the results in course_data_2026/module5b/output/Complete_all_mags_Amr_Analysis.xlsx.

# Generating a Heatmap from RGI Results

rgi heatmap can be used to visualise AMR profiles across samples using pre-computed RGI JSON outputs. The tool generates heatmaps in both PNG and EPS formats.

In this example, AMR genes are grouped by drug class, and samples are clustered based on resistome similarity (refer to https://github.com/arpcard/rgi/blob/master/docs/rgi_main.rst).

Run the following command:
```bash
rgi heatmap \
  --input /data/microbiome_course2026/course_data_2026/Module5b/output \
  --output rgi_heatmap \
  -cat drug_class \
  -clus samples
```
Output:
rgi_heatmap-2.png
rgi_heatmap-2.eps
rgi_heatmap-2.csv (underlying matrix)

###Downloading the Heatmap to Your Local Computer

To copy the generated PNG file from the cluster to your local machine, run the following command from your local terminal:
```bash
scp train6@keklf-cls04:/scratch/home/train6/module5b/output/rgi_heatmap-2.png /path/to/your/localpc/
```
Replace /path/to/your/localpc/ with the destination directory on your computer.

###Notes

Ensure that the input directory contains only valid RGI JSON output files.

The .csv file can be used for custom visualisation in R (e.g., using ggplot2 or pheatmap).


# 📈 Downstream Analysis In R-Studio


Analysis can be performed:

- On the HPC (if R is installed), OR
- Locally in RStudio after downloading results

### Input for R:

- `combined_rgi_results.tsv`

This merged file contains:
- MAG_ID
- AMR gene annotations

#The aim here is to 
- Compare AMR load per MAG
- Compare AMR diversity across samples
- Stratify by taxonomic identity
- Visualize resistome profiles using heatmaps
- Identify multidrug-resistant genomes

---

# Optional: Visualize JSON Output

Upload `.json` files to the CARD website for interactive visualization: https://card.mcmaster.ca/analyze/rgi 

---

# References

- CARD Database  
- RGI documentation  
 
---

