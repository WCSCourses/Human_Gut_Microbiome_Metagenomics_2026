# 🧬 Functional Annotation of Metagenomic Data  
## AMR Gene Profiling in Human Gut Microbiome MAGs


# 👩🏽‍🏫 Module Leads

Rahma Golicha   
Caroline Tigoi  



## 📌 Module Overview

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

# 🎯 Learning Outcomes

By the end of this session, participants will be able to:

- Create a clean Conda environment (This has already been done for you)
- Install RGI and dependencies (BLAST, DIAMOND, Prodigal) (This has already been done for you)
- Load the CARD database locally
- Run RGI on MAGs
- Merge multiple RGI outputs
- Prepare results for downstream analysis in R

---

# 🧠 Where This Fits in Gut Metagenomics

```
QC → Assembly → Binning → MAG refinement → AMR profiling → Ecological interpretation
```

This module focuses on the **AMR profiling step**.

---

# 🖥️ Requirements

Participants should have:

- Basic Linux command-line familiarity
- Conda or Miniconda installed
- Access to a Linux environment
- Human gut MAG FASTA files

---


## Load Database into RGI

```bash
rgi load --card_json card.json --local
rgi database --version
```

---

# 🧬 Activity 3 — Run RGI on Human Gut MAGs

Place MAG FASTA files in a directory, for example:

```
Clean_Mags/
```

### Run RGI on a Single MAG

```bash
rgi main \
  --input_sequence Clean_Mags/mag1.fa \
  --output_file Clean_Mags/mag1_amr_out \
  --local \
  --clean \
  --include_nudge \
  --num_threads 8
```

---

# 📊 Activity 4 — Understanding Output Files

Each genome produces:

- `*.txt` → Tabular AMR predictions  
- `*.json` → Structured results for visualization  

The `.txt` file includes:

- Gene name
- Resistance mechanism
- Drug class
- Percent identity
- Model type (Perfect / Strict / Loose)

---

# 🔄 Activity 5 — Merge Multiple MAG Outputs

Create a combined file with MAG identifiers:

```bash
out_file="combined_rgi_results.tsv"

# Extract header
header=$(head -n1 mag1_amr_out.txt)
echo -e "MAG_ID\t$header" > $out_file

# Loop through all output files
for f in *_amr_out.txt; do
    mag_id=$(basename "$f" _amr_out.txt)
    tail -n +2 "$f" | awk -v id="$mag_id" 'BEGIN{OFS="\t"} {print id, $0}'
done >> $out_file
```

This file can now be imported into **R** for downstream ecological analysis.

---

# 🌍 Biological Interpretation in Human Gut Context

When analyzing gut microbiome MAGs:

Consider:

- Core resistome genes shared across commensals
- Pathogen-enriched resistance genes
- Ecological and clinical relevance


Ask:

- Do certain taxa carry higher AMR burden?

---

# 📈 Downstream Analysis In R-Studio

- Compare AMR load per MAG
- Compare AMR diversity across samples
- Stratify by taxonomic identity
- Visualize resistome profiles using heatmaps
- Identify multidrug-resistant genomes

---

# 🧪 Optional: Visualize JSON Output

Upload `.json` files to the CARD website for interactive visualization: https://card.mcmaster.ca/analyze/rgi 

---

# 📚 References

- CARD Database  
- RGI documentation  
 
---

