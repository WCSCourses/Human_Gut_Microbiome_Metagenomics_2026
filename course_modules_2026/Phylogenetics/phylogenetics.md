# Building Phylogenetic Trees

![Image of a DNA](images/DNA.png)

## Learning Objectives

- Understand common methods of phylogenetic tree inference
- Use IQ-TREE and FastTree for phylogenetic tree inference from alignment data.
- Describe key steps in creating a phylogenetic tree.

## Contents
- [Phylogenetic Tree Inference](#phylogenetic-tree-inference)
- [Multiple Sequence Alignments](#multiple-sequence-alignments)
- [Building a Phylogenetic Tree](#building-a-phylogenetic-tree)
- [Summary](#summary)

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
These are the simplest and fastest phylogenetic methods, they are often a useful way to have a quick look at your data before running more robust phylogenetic methods.
It starts by generating a matrix of pairwise distances (distance matrix) between all samples and then infer a phylogenetic relationship using UPGMA or Neigbour-joining.

#### Parsimony methods
Maximum parsimony method assume that the best phylogenetic tree requires the fewest number of mutations to explain the data.

Maximum parsimony is simple method and is very fast to run. However, because its always the shortest tree, compared to the hypothetical “true” tree it will often underestimate the actual evolutionary change that may have occurred.

#### Maximum likelihood methods
Maximum likelihood is the most commonly used phylogentic method in bacterial genomics. It evaluates alternative tree topologies using probabilistic models of sequence evolution.
Compared with maximum parsimony, it offers greater statistical flexibility by permitting variation in evolutionary rates across different lineages and sites. However, this improved modelling approach comes with substantial computational demands than distance-based and Parsimony approaches.  

Common nucleotide substitution models include **Jukes-Cantor** model (JC69), which assumes only a single mutation rate across all nucleotides, and **Hasegawa-Kishino-Yano** model (HKY85), which assumes different mutation rates and accounts for unequal base frequencies. More complex models such as **General time reversible (GTR)** allow different substitution rates for each nucleotide pair.

Additional assumptions can also be incorperated into substitution models. A proportion of sites may be specified as constant sites (invariant sites), meaning they are assumed not to undergo mutation. Rate heterogeneity among the remaining sites can be modeled using a gamma distribution, typically discretised into four categories (+G4).

For instance, the model HKY+G4+I account for unequal base frequencies, variation in substitution rates across sites (+G4), and proportion of invariant sites (I).

Maximum likelihood software commonly used to infer phylogenetics include **[FastTree](https://morgannprice.github.io/fasttree/)**, **[IQ-TREE](https://iqtree.github.io/)**, and **[RAxML-NG](https://github.com/amkozlov/raxml-ng)**. **IQ-TREE** is advantageous because its fast and has broad model support to consider. Its integrated **ModelFinder** function automatically evaluates candidate substitution models and selects the best fitting model for a given dataset, thus removing the decision of which model to pick entirely.

### Assessing Tree Uncertainty (Bootstrap)

Bootstrap analysis evaluates confidence in tree branches by sampling a large number (say, 1000) of bootstap alignments. Each of this alignment has the same size as the original alignment, and is obtained by sampling with replacement the columns of the original alignment; in each bootstrap alignment some of the columns of the original alignment will usually be absent, and some other columns would be represented multiple times. We then infer a bootstrap tree from each bootstrap alignment. Because the bootstrap alignments differ from each other and from the original alignment, the bootstrap trees might differ between each other and from the original tree. The **bootstrap support** of a branch in the original tree is the proportion of times in which this branch is present in the bootstrap trees.

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

### Core gene based Phylogenetic tree construction
#### Annotate all .fa files with prokka/Bakta using bsub.py commands

Build a phylogenetic tree using an alignment.

Activate prokka
```bash
mamba activate prokka
```

```bash
for f in *.fa; do     prefix="${f%.fa}";     echo bsub.py --threads 4 8 "$prefix" prokka --cpus 4 --centre X --compliant --kingdom Bacteria --outdir "${prefix}_prokka" --prefix "$prefix" "./$f"; done > run_prokka.sh
```

Make executable and run

```bash
chmod +x run_prokka.sh
bash run_prokka.sh 
```

Create a directory to store all the .gff files

```bash
cd <path>/results
mkdir gff_dir
find . -type f -iname "*.gff" ! -iname "*_protein.gff" -exec cp {} <path>/results/gff_dir/ \;

find . -iname "*.gff" -exec cp {} gff_dir/ \;

```

Copy all GFF files to the new directory and generate a gff file list containing absolute paths

```bash
find . -type f -iname "*.gff" ! -iname "*_protein.gff" -exec cp {} <path>/results/gff_dir/ \;

find . -iname "*.gff" -exec cp {} gff_dir/ \;

```

Navigate to the directory with gff files

```bash
cd <path>/results/gff_dir
```

List all .gff files (excluding _protein if needed) with full paths
```bash
find . -type f -iname "*.gff" ! -iname "*_protein.gff" -exec realpath {} \; > prokkagff.txt
```

### Run Panaroo
Run **[Panaroo](https://gthlab.au/panaroo/#/gettingstarted/params?id=gene-alignment)** using 95% cut-off (remove invalid genes to skip genes with premature stop codon common in MAGs)

Activate Panaroo software

```bash
mamba activate panaroo
```

Run Panaroo
```bash
panaroo -i prokkagff.txt -o panaroo_default_core --clean-mode strict -t 24 --remove-invalid-genes -a core --core_threshold 0.95	
```

### Extracting Variable Sites with SNP-sites

You could use the alignment generated by panaroo directly as input to **IQ-TREE**, this can be quite computationally intensive because whole genome alignment are often large. Instead you can use
`SNP-sites` to extract variable positions from an alignment, generating a reduced alignment that contains only informative sites.

 For example, consider the following three sequences, where 3 variable sites are present (indicated with an arrow):

- `s1  C G T A G C T G G T`
- `s2  C T T A G C A G G T`
- `s3  C T T A G C A G A T`
`      ↑         ↑   ↑`

For the purposes of phylogenetic tree construction, we use only the variable sites to assess the relationship between sequences. Therefore we can simplify our alignment by extract only the variable positions:

```text
s1  G T G
s2  T A G
s3  T A A
```

Activating the Software and Extracting Variable Sites
First, we activate the `snp-sites` software environment to make the tool available:

```bash
mamba activate snp-sites
```

Next, we create an output directory and run `snp-sites` to extract only the variable sites from our core gene alignment. The `-o` option allows us to save the reduced alignment to a new file:

```bash
# create output directory
mkdir results/snp-sites
# run SNP-sites to extract variable sites
snp-sites results/gff_dir/panaroo_default_core/core_gene_alignment_filtered.aln > results/snp-sites/core_gene_alignment_snps.aln
```
This reduced alignment will be used as input for constructing our phylogenetic tree.


### Counting Constant Sites

Before constructing the tree, we also need to know the **number of constant (invariable) sites** in the original alignment. These counts are important because the proportion of variable sites affects phylogenetic inference (e.g., 3 mutations in 10 sites vs. 3 mutations in 1000 sites). IQ-TREE can accept the counts of constant `A, C, G, and T` sites as input.

We can compute these using `snp-sites` with the `-C` option:

```bash
# Count constant/invaribale sites

snp-sites -C results/gff_dir/panaroo_default_core/core_gene_alignment_filtered.aln > results/snp-sites/constant_sites.txt
```

The key difference is the -C option, which produces the counts of constant sites. We redirect (>) the output to a file. We can inspect the results with:

```bash
cat results/snp-sites/constant_sites.txt
```
The resulting file contains the number of constant A, C, G, and T sites, which we will provide to IQ-TREE during tree construction.

### Tree inference with IQ-TREE

There are several methods for inferring phylogenetic trees from sequence alignments. Regardless of the method, the goal is to construct a tree that represents the evolutionary relationships between species or genetic sequences.

In this course, we will use **IQ-TREE**, which implements maximum likelihood methods for tree inference. **IQ-TREE** supports a wide range of sequence evolution models, allowing researchers to tailor analyses to their data and research questions. Additionally, it includes **ModelFinder**, which can automatically identify the most appropriate substitution model while accounting for model complexity.

We will run IQ-TREE on the output from snp-sites, i.e., using the variable sites extracted from the core genome alignment:

start by activating the `iqtee` software environment to make the tool available:

```bash
mamba activate iqtee
# Create output directory
mkdir -p results/iqtree

iqtree \
  -s results/snp-sites/core_gene_alignment_snps.aln \
  -fconst $(cat results/snp-sites/constant_sites.txt) \
  --prefix results/iqtree/final_tree \
  -nt AUTO \
  -m MFP \
  -bb 1000
```

### Explanation of Options

- `-s` – input alignment file (in this case, the variable sites extracted with `snp-sites`).
- `--prefix` – prefix for all output files.
- `-fconst` – counts of invariant sites estimated with `snp-sites` (see previous section).
- `-nt AUTO` – automatically detect available CPUs on the computer for parallel processing.
- `-ntmax 8` – maximum number of CPUs to use.
- `-mem 8G` – maximum memory allocation.
- `-m` – specifies the DNA substitution model. MFP runs ModelFinder to select the best-fit model.
- `-bb 1000` – perform 1000 ultrafast bootstrap replicates for branch support.

### Notes on the Model

When the `-m` option is not specified, **IQ-TREE** automatically runs **ModelFinder** to identify the substitution model that best fits the data. This can be time-consuming, as it fits trees multiple times. An alternative approach is utilizing a versatile model, like “GTR+F+I,” which is a generalized time reversible **[GTR](https://en.wikipedia.org/wiki/Substitution_model#Generalised_time_reversible)** substitution model. This model is a versatile choice that:

- Uses an estimate of the base frequencies from the alignment (`+F`).
- Accounts for rate variation across sites, including a proportion of invariant sites (`+I`).

This combination provides a reliable and efficient approach for phylogenetic inference.

We can look at the output folder

```bash
ls results/iqtree
```

### IQ-TREE Output Files

After running **IQ-TREE**, the results/iqtree folder contains several files:

- `.iqtree` – a text report of the IQ-TREE run, including a textual representation of the inferred tree and details about the model, likelihood, and bootstrap support.
- `.treefile` – the estimated phylogenetic tree in NEWICK format. This can be imported into visualization programs such as FigTree or iTOL.
- `.log` – a log file containing the messages printed to the screen during the run.
- `.bionj` – the initial tree estimated by neighbor joining (also in NEWICK format).
- `.mldist` – maximum likelihood distances between every pair of sequences.
- `.ckp.gz` – a checkpoint file that allows IQ-TREE to resume a run if it is interrupted (useful for very large trees).

The main files of interest for downstream analysis are the report file (.iqtree) and the tree file (.treefile) in standard **[Newick](https://en.wikipedia.org/wiki/Newick_format)** format. These contain the results needed to visualize and interpret the phylogenetic tree.

### Visualisation
Visualise `final_tree.treefile` in R or iToL and add metadata

### Rooting a phylogenetic tree
Rooting a phylogenetic tree is essential for interpreting evolutionary relationships and providing temporal context to species diversification. While an unrooted tree shows only relationships without direction, a rooted tree represents the evolutionary history of the taxa.

The most common method to root a tree is to include an **outgroup**—a taxon known to be more distantly related to the other sequences in the analysis. Alternatively, a reference genome can be used as an outgroup for all members of a species to establish the root.

---
## Summary
---

- Tree inference methods include **neighbor-joining**, **maximum parsimony**, and **maximum likelihood**. The first two methods are simpler and computationally faster but do not fully capture important features of sequence evolution.
- **Maximum likelihood** methods are recommended because they incorporate relevant parameters such as varying substitution rates, invariant sites, and rate heterogeneity across the sequence.
- Regardless of the method used, phylogenetic inference requires a **multiple sequence alignment** as input. To reduce the computational burden of analyzing whole-genome alignments, we can extract only the **variable sites** using the snp-sites software.
- **IQ-TREE** is a widely used software for maximum likelihood tree inference and can take as input the variable sites extracted from the previous step.
