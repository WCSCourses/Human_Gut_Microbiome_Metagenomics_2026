# Practical Exercise: Taxonomic Profiling in Metagenomics

In this exercise, participants will explore how taxonomic profiling can be performed using both **read-based** and **assembly-based** approaches.

Because taxonomic classification databases can be very large, we will use **pre-generated outputs** and run a small demonstration command on a single sample.

---

## Learning objectives

By the end of this exercise you will be able to:

- Run read-level taxonomic classification using **metaWRAP kraken**
- Explore taxonomic profiles using **Krona visualization**
- Inspect taxonomy assigned to **metagenome-assembled genomes (MAGs)**
- Compare **read-based vs genome-based taxonomic profiling**

---

# Part 1 — Read-based taxonomic classification

In read-based profiling, sequencing reads are classified directly against a reference database.

We will run the **metaWRAP Kraken module** on one sample.

### Input data

Quality-controlled reads generated in **Module 1**:

```text
DEHOSTED_READS/SRR30598619_dehosted.1.fastq.gz
DEHOSTED_READS/SRR30598619_dehosted.2.fastq.gz
```

## Exercise 1 – Run read-based taxonomic classification
### Run Kraken classification

```bash
metawrap kraken \
    -o kraken_output \
    -t 8 \
    -1 DEHOSTED_READS/SRR30598619_dehosted.1.fastq.gz \
    -2 DEHOSTED_READS/SRR30598619_dehosted.2.fastq.gz
```
### Exercise 2 — Inspect the output and explore Krona
List the output directory:

```bash
ls kraken_output
```

Expected files:
```text 
kraken_output.txt
krona.html
```

Open the Krona visualization:

```bash
firefox kraken_output/krona.html
```
If working on a remote server, download the file and open it locally.

Explore the taxonomic hierarchy
1. Click Bacteria in the center of the Krona plot.
2. Expand the next level to view phyla.
3. Continue expanding to reach genus-level taxa.

Questions
1. Which bacterial phylum dominates the sample?
2. Which genera are most abundant?
3. Are there low-abundance taxa present in the dataset?


# Part 2 — Assembly-based taxonomic annotation
Assembly-based profiling assigns taxonomy to reconstructed genomes (MAGs) generated in Module 2.

These genomes represent microbial populations that were successfully reconstructed during assembly and binning.

## Input data
```text
refined_bins/metawrap_bins/
```
### Exercise 3 — Inspect MAG taxonomy

In a full analysis, MAG taxonomy would be assigned using:
```bash
metawrap classify_bins \
    -b refined_bins/metawrap_bins \
    -o taxonomy_results \
    -t 8
```
Because this step can take several minutes depending on dataset size, we will instead explore pre-generated results.

Navigate to the provided results directory:
```bash
cd example_results/module4_taxonomy
or 
cd taxonomy_results/
```

View the taxonomy results:
```bash
cat bin_taxonomy_summary.txt
```
Example output:
```text
bin.1   Bacteria;Firmicutes;Clostridia
bin.2   Bacteria;Bacteroidota;Bacteroidia
```
Each bin corresponds to a reconstructed genome.

## Exercise 4 — Compare read-based and genome-based taxonomy
### Taxa detected from reads

Count the most abundant taxa detected by Kraken:

```bash
cut -f2 kraken_output/kraken_output.txt | sort | uniq -c | sort -nr | head
```

Example output:
```text
125000 Bacteria
45000 Firmicutes
38000 Bacteroidota
21000 Proteobacteria
```
### Taxa detected from MAGs

Extract taxa reconstructed as genomes:

```bash
cut -f2 taxonomy_results/bin_taxonomy_summary.txt | sort | uniq
```

Example output:

```text
Bacteria;Firmicutes;Clostridia
Bacteria;Bacteroidota;Bacteroidia
```

Questions
1. Does the read-based profile detect more taxa than MAG classification?
2. Which taxa appear in both analyses?
3. Why might some organisms be detected in reads but not reconstructed as genomes?

Possible explanations include:
- low abundance organisms
- fragmented assemblies
- insufficient coverage for genome reconstruction