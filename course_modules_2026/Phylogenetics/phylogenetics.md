# Building Phylogenetic Trees

## Learning Objectives

- Understand common methods of phylogenetic tree inference
- Use IQ-TREE and FastTree for phylogenetic tree inference from alignment data.
- Describe key steps in creating a phylogenetic tree.

## Contents
- [Introduction](#introduction)
- [Phylogenetic Tree Inference](#phylogenetic-tree-inference)
- [Multiple Sequence Alignments](#multiple-sequence-alignments)
- [Building a Phylogenetic Tree](#building-a-phylogenetic-tree)
- [Summary](#summary)


## Introduction

Understanding the genetic diversity, genome plasticity, and recombination patterns of the organism under study is an essential first step before conducting genomic analyses, as these factors influence the choice of analytical methods. In particular, phylogenetic reconstruction strategies vary depending on the evolutionary characteristics of the species. For example, approaches used to infer phylogenetic relationships in Mycobacterium tuberculosis, a largely clonal organism, differ from those applied to more recombinogenic bacteria such as Escherichia coli or Campylobacter. To guide the selection of appropriate methods for phylogenetic analysis, a flowchart outlining recommended strategies based on dataset composition is provided.


![Image of know your bug](images/know_your_bug.png)

---
## Phylogenetic Tree Inference
---

### Tree Topology

A phylogenetic tree is a graph representing evolutionary history and shared ancestry. It depicts the lines of evolutionary descent of different species, lineages or genes from a common ancestor. A phylogenetic tree is made of nodes and edges, with one edge connecting two nodes.
The topology describes how taxa are connected, independent of branch lengths.

### Terminologies
- **Leaves** (tips) - Represent actual observed data
- **Branches** - Represent evolutionary relationships or the amount of change along lineages.
- **Terminal nodes** - Are nodes in the tree connected to only one edge and are usually associated with the data, such as a genome sequence. A node can represent an extinct species or a sampled pathogen.
- **Internal nodes** - Represent the most recent common ancestors of groups of terminal nodes, and do not directly correspond to the observed data. They are hypothetical ancestors inferred from the observed genome sequences at the tips of the tree.
- **clade** - Is a set of all terminal nodes descending from the same ancestor. Each branch and internal node is associated with a clade. If trees have the same clade we say that they have the same topology. If trees have the same clades and same branch lengths, the two trees represent the same evolutionary history.

![Example of newick tree format](images/Newick.png)

For instance, the terminal nodes of this tree - A, B, C and D - represent sampled organisms. The internal nodes - E and F - are inferred from the data. In this case, there is also a multifurcation: nodes A, B and E all coalesce to the base of the tree. This can happen due to poor resolution in the data.

---

### Applications of Phylogenetic Trees

Phylogenetic trees are widely used to:

- Understand evolutionary relationships  
- Identify transmission clusters  
- Investigate population structure  
- Track spread of infectious diseases

### Newick Format

Phylogenetic trees are commonly stored in **Newick format**, which represents tree structure in text format using parentheses. the two child nodes of the same internal node are separated by a ",". At the end of a Newick tree there is always a ";".

For Example,the newick format of a rooted tree relating to two samples "S1" and "S2" with distances from the root respectively of 0.01 and 0.02, is **(S1:0.01,S2:0.02);**

If we add a third sample "S3" as an outgroup, the tree will look like **((S1:0.01,S2:0.02):0.03,S3:0.04);**

### Methods for Inferring Trees

Common tree inference approaches include:

- Distance-based methods such as Neighour-Joining and UPGMA
- Maximum Parsimony  
- Maximum Likelihood  
- Bayesian inference  

#### Distance-based methods
These are the simplest and fastest phylogenetic methods, they are often a useful way to have a quick look at your data before running more robust phylogenetic methods. Here we infer the evolutionary distances from a multiple sequence alignment. For example, if one nucleotide substitution is observed across 16 informative alignment positions (excluding columns containing gaps or ambiguous bases such as N), the estimated evolutionary distance between the sequences would be approximately 1/16.

![Example of maximum distance-based tree](images/distance_alignment.png)

It starts by generating a matrix of pairwise distances (distance matrix) between all samples in a multiple sequence alignment and then infer a phylogenetic relationship using UPGMA or Neigbour-joining.

![Example of maximum distance-based tree](images/phylo_matrix.png)

Distance matrix to Neighbour-Joining tree
---

#### Parsimony methods
Maximum parsimony method assume that the best phylogenetic tree requires the fewest number of mutations to explain the data.

![Example of maximum parsimony tree](images/max_parsimony.png)

For example, the tree topology on the left only requires one mutation to explain the data, whereas the tree on the right would require two mutations. Therefore, the maximum parsimony tree would be the one on the left.

---
Maximum parsimony is simple method and is very fast to run. However, because its always the shortest tree, compared to the hypothetical “true” tree it will often underestimate the actual evolutionary change that may have occurred.

#### Maximum likelihood methods
Maximum likelihood is the most commonly used phylogentic method in bacterial genomics. It evaluates alternative tree topologies using probabilistic models of genome evolution.
Compared with maximum parsimony, it offers greater statistical flexibility by permitting varying rates of evolution across different lineages and sites. However, this improved modelling approach comes with substantial computational demands than distance-based and Parsimony approaches.  

Common nucleotide substitution models include **Jukes-Cantor** model (JC69), which assumes only a single mutation rate across all nucleotides, and **Hasegawa-Kishino-Yano** model (HKY85), which assumes different mutation rates and accounts for unequal base frequencies. The simplest models to use such as **General time reversible (GTR)** allow different substitution rates for each nucleotide pair.

![Example of maximum likelihood tree](images/phylo_ml.png)

Additional assumptions can also be incorperated into substitution models. A proportion of sites may be specified as constant sites (invariant sites), meaning they are assumed not to undergo mutation. Rate heterogeneity among the remaining sites can be modeled using a gamma distribution, typically discretised into four categories (+G4).

For instance, the model HKY+G4+I account for unequal base frequencies, variation in substitution rates across sites (+G4), and proportion of invariant sites (I).

Maximum likelihood software commonly used to infer phylogenetics include **[FastTree](https://morgannprice.github.io/fasttree/)**, **[IQ-TREE](https://iqtree.github.io/)**, and **[RAxML-NG](https://github.com/amkozlov/raxml-ng)**. **IQ-TREE** is advantageous because it is fast and has broad model support to consider. Its integrated **ModelFinder** function automatically evaluates candidate substitution models and selects the best fitting model for a given dataset, thus removing the decision of which model to pick entirely.

### Assessing Tree Uncertainty (Bootstrap)

Bootstrap analysis evaluates confidence in a tree or individual 6tree branches by sampling a large number (say, 1000) of bootstap alignments. Each of this alignment has the same size as the original alignment, and is obtained by sampling with replacement the columns of the original alignment; in each bootstrap alignment some of the columns of the original alignment will usually be absent, and some other columns would be represented multiple times. We then infer a bootstrap tree from each bootstrap alignment. Because the bootstrap alignments differ from each other and from the original alignment, the bootstrap trees might differ between each other and from the original tree. The **bootstrap support** of a branch in the original tree is the proportion of times in which this branch is present in the bootstrap trees.

---

## Multiple Sequence Alignments

---

Phylogenetic inference requires aligned sequences. These may consist of a single orthologous gene across multiple taxa or whole genome alignments generated by mapping sequence reads to a reference genome. The purpose of alignment is to ensure that homologous nucleotides, those derived from a common ancestral position, are placed in the same column, enabling meaningful evolutionary comparison. One of the most widely used alignment formats in phylogenetic analysis is **FASTA**:

For example: **AACGTGT**

Alignment quality directly affects tree accuracy. Always inspect alignments before proceeding with inference.

N and - characters represent missing data and are interpreted by phylogenetic methods as such e.g. **AA-GT-T** and **AANGTNT**. 

The two most commonly used multiple sequence alignments in bacterial genomics are **reference-based whole genome alignments** and **core genome alignment**. Reference-based approaches align sequence reads to a single high-quality reference genome. In contrast, core genome alignments are generated by comparing genes across isolates and identifying those present in all or nearly all genomes (the core genome). As a general rule of thumb, if a species is extremely clonal (not genetically diverse) and doesn't recombine such as Mycobacterium tuberculosis or Brucella, a suitable reference-based whole genome alignment is often appropriate. However, for genetically diverse species with multiple divergent lineages, such as Escherichia coli, a single reference genome may not adequately capture the diversity present in the dataset. In these cases, it is more appropriate to generate de novo assemblies, annotate them, and infer the pangenome using tools such as **Roary** or **Panaroo**, from which a core genome alignment can be constructed. The same phylogenetic inference methods can then be applied to either type of multiple sequence alignment.

---
## Building a phylogenetic tree
---
### Marker gene based phylogenetic construction
In this section, you will learn how to:
- identify marker genes
- generate multiple sequence alignment
- Build a phylogenetic tree


```bash
# load modules
mamba activate gtdbtk
mamba activate fasttreemp
```

#### Identify Marker Genes
GTDB-Tk identifies conserved marker genes that are shared across bacteria.

```bash
gtdbtk identify --genome_dir . -x fa --cpus 24 --out_dir gtdbtk_identify_outdir
```

#### Align Marker genes
This step aligns marker genes across all genomes and produces a multiple sequence alignment

```bash
gtdbtk align --identify_dir ./gtdbtk_identify_outdir --skip_trimming --skip_gtdb_refs --out_dir gtdbtk_align_outdir --cpus 24
```

#### Unzip the alignment file before building the tree

```bash
# change directory
cd gtdbtk_align_outdir/align/

# unzip
gunzip *.gz
```

#### Build the phylogenetic tree

The code below builds a phylogenetic tree using maximum likelihood methods and outputs a tree file in newick format.

We will NOT run this command in the classroom, because it takes a long time to run.

```bash
fasttree \
FastTreeMP \
-wag \
-out gtdbtk_fullalign_bacteria.nwk \
gtdbtk_align_outdir/align/gtdbtk.bac120.user_msa.fasta
```
You can go to Phylogenetics/gtdb_phylogenetic_tree and inspect the output file gtdbtk_fullalign_bacteria.nwk. This file can be loaded into iTOL https://itol.embl.de/ for annotation and visualisation. 

### Rooting a phylogenetic tree
Rooting a phylogenetic tree is essential for interpreting evolutionary relationships and providing temporal context to species diversification. While an unrooted tree shows only relationships without direction, a rooted tree represents the evolutionary history of the taxa.

The most common method to root a tree is to include an **outgroup**—a taxon known to be more distantly related to the other sequences in the analysis. Alternatively, a reference genome can be used as an outgroup for all members of a species to establish the root.


## Tree Visualisation Using iTOL
There are many programs that can be used to visualise phylogenetic trees. Some of the popular programs include FigTree the R library ggtree. For this course, we’re going to use the web-based tool iTOL as it allows users to interactively manipulate the tree and add metadata.

In order to use this platform you will first need to create an account using this link: https://itol.embl.de/ (or sign-in through your existing Google account).


## Preparing Annotation file

This guide describes how to colour phylogenetic trees in iTOL (Interactive Tree of Life) using metadata.

You will:

- Extract phylum information from GTDB metadata
- Assign colours to each phylum
- Format the data for iTOL annotation
- Upload the annotation file to iTOL

#### Step 1: Extract Phylum Information from GTDB Metadata

- Open your GTDB metadata file in Excel.
- Insert a new empty column next to the classification column.
- Click on the first cell of the classification column and extract only the phylum-level classification from the taxonomy string to the first cell of the new column.

Example format:

```text
d__Bacteria;p__Firmicutes;c__...
```
→ Extract:

```text
p__Firmicutes
```

With the cursor in the new cell with the phylumn name, go to the Data tab in Excel and click Flash Fill to automatically populate the column

#### Step 2: Prepare a Clean Book for iTOL
Open a new sheet (e.g., Book2).
Copy the sample column and newly created Phylum column into Book2

#### Step 3: Assign Colours to Each Phylum

In the phylum column:

Use Find and Replace and Replace each phylum name with a hex colour code

Example:

```text
p__Firmicutes → #1f77b4
p__Proteobacteria → #ff7f0e
p__Actinobacteriota → #2ca02c
```

To ensure consistency Each phylum must map to one unique colour

#### Step 4: Format the iTOL Annotation File
Open your existing iTOL dataset text file (e.g., species_category.txt).

Locate the line below:

```text
Actual data follows after the "DATA" keyword    #
```
copy the two columns (sample and color codes) from excel and paste everything below "DATA" with your formatted data.

#### Step 5: Format Your Data Correctly

Your data must follow iTOL formatting rules. A typical structure is:

```text
genome_id    #hexcode
```
Example:

```text
cleaned_SRR30598619_bin.20.orig_filtered_kept_contigs #984ea3
cleaned_SRR30598619_bin.21.orig_filtered_kept_contigs #984ea3
```
⚠️ Important:

Columns must be separated by consistent spacing
Avoid extra spaces or missing values
Ensure genome IDs match the tree tip labels exactly

## Uploading tree files and metadata
Once you’ve logged into iTOL, you can upload `gtdbtk_fullalign_bacteria.nwk` tree file and annotate it with the metadata 

1. Click on the UPLOAD link in the bottom-right corner of the page:

![upload icon](images/upload.png)

2. Browse Files to upload the tree:

![browse files](images/browse.png)

3. This will open a file browser, where you can select the tree file and metadata from your local machine. Go to the gtdb_phylogenetic_tree directory where you have the tree and the species_category file. Click and select the `gtdbtk_fullalign_bacteria.nwk` file. Click Open on the dialogue window after you have selected the file.

![open files](images/open.png)

4. The tip labels are still the European Nuclotide Accessions we used to download the FASTQ files. Let’s change the tip labels to the phylum names using `species_category` annotation file.

![add annotation files](images/species_category.png)

5. From the rooted tree, we can see we have distinct clades within the tree. These are major clades we identified in our dataset. 
Visualise `gtdbtk_fullalign_bacteria.nwk` in iToL and add metadata

![tree file](images/tree.pdf)

## Exporting the tree to your local computer

Once your tree has been fully annotated, adjust any export settings if needed (e.g., resolution, labels, scaling) and click “Export” option in the top menu and select your preferred output format to download the file to your local machine.

The output formats include:
- SVG (Scalable Vector Graphics)
- PDF (Portable Document Format)
- EPS (Encapsulated PostScript)
- PNG (Portable Network Graphics)
- Newick tree
- phyloXML
- NEXUS tree
- Colors and styles annotation
- Collapsed nodes list

---
## Summary
---

- Tree inference methods include **neighbor-joining**, **maximum parsimony**, and **maximum likelihood**. The first two methods are simpler and computationally faster but do not fully capture important features of sequence evolution.
- **Maximum likelihood** methods are recommended because they incorporate relevant parameters such as varying substitution rates, invariant sites, and rate heterogeneity across the sequence.
- Regardless of the method used, phylogenetic inference requires a **multiple sequence alignment** as input. To reduce the computational burden of analyzing whole-genome alignments, we can extract only the **variable sites** using the snp-sites software.
- **IQ-TREE** is a widely used software for maximum likelihood tree inference and can take as input the variable sites extracted from the previous step.
