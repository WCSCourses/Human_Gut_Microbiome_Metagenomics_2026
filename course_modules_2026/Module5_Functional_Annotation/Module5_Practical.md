# Functional Prediction Using HUMAnN

---

# Exercise overview

In this practical we will:
1.	Run HUMAnN on a demonstration sample
2.	Explore functional outputs
3.	Identify biologically relevant pathways

Because HUMAnN analyses can take time, pre-generated outputs are provided for exploration.

## Exercise 1: Run HUMAnN (Demo)
```bash
humann \
  --input demo/qc_cleaned_reads/Sample1_cleaned.fastq.gz \
  --output humann_output/Sample1 \
  --threads 8
```
This command performs:
1. Taxonomic prescreen using MetaPhlAn
2. Gene family mapping against ChocoPhlAn
3. Translated protein search using UniRef
4. Reconstruction of metabolic pathways

## Exercise 2: Explore pre-generated outputs
Navigate to the example outputs.
```bash
cd demo/humann_example_outputs
```
List files:
```bash
ls
```
Expected files:

```text
Sample1_genefamilies.tsv
Sample1_pathabundance.tsv
Sample1_pathcoverage.tsv
```
These represent the functional profile of the microbiome.

## Exercise 3: Inspect gene families
View the first lines:

```bash
head Sample1_genefamilies.tsv
```
Look for:
- UniRef identifiers
- Stratified entries (gene|taxon)
- UNMAPPED reads

Example:
```bash
UniRef90_A0A123
UniRef90_A0A123|g__Faecalibacterium
```
Interpretation:
- First row → ctotal abundance of the gene family
- Second row → contribution from a specific taxon

## Exercise 4: Inspect pathway abundance

View pathways:
```bash
head Sample1_pathabundance.tsv
```

Example:

```code
PWY-5676 glycolysis
PWY-6385 butyrate biosynthesis
```

These represent **metabolic pathways** encoded in the microbiome.

#### Exercise 5 — Identify the most abundant pathways

Sort the pathway table:
```bash
sort -k2 -nr Sample1_pathabundance.tsv | head
```

> ***Task:*** 
Identify the top 5 most abundant pathways in the sample.

#### Exercise 6 — Identify taxa contributing to functions 

Find stratified entries:

```bash
grep "|" Sample1_genefamilies.tsv | head
```

> ***Task:***
Identify an example where a **gene family is linked to a microbial taxon**.

Example:
```code
UniRef90_A0A123|g__Faecalibacterium
```
***This indicates that Faecalibacterium contributes to that gene family.

#### Exercise 7 — Search for health-relevant pathways
Search for metabolic pathways linked to host health.

Example: **short-chain fatty acid production**
```bash
grep -i butyrate Sample1_pathabundance.tsv
```
You can also search for:

```bash
grep -i glycolysis Sample1_pathabundance.tsv
grep -i vitamin Sample1_pathabundance.tsv
grep -i amino Sample1_pathabundance.tsv
```

> ***Task:***
Identify at least one pathway linked to host metabolism or microbial energy production.








