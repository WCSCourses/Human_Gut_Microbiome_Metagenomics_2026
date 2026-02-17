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

N and - characters represent missing data and are interpreted by phylogenetic methods as such e.g. **AA-GT-T** and **AANGTNT**. The two most commonly used multiple sequence alignments in bacterial genomics are **reference-based whole genome alignments** and **core genome alignment**. Reference-based approaches align sequence reads to a single high-quality reference genome. In contrast, core genome alignments are generated by comparing genes across isolates and identifying those present in all or nearly all genomes (the core genome). As a general rule of thumb, if a species is extremely clonal (not genetically diverse) and doesn't recombine such as Mycobacterium tuberculosis or Brucella, a suitable reference-based whole genome alignment is often appropriate. However, for genetically diverse species with multiple divergent lineages, such as Escherichia coli, a single reference genome may not adequately capture the diversity present in the dataset. In these cases, it is more appropriate to generate de novo assemblies, annotate them, and infer the pangenome using tools such as **Roary** or **Panaroo**, from which a core genome alignment can be constructed. The same phylogenetic inference methods can then be applied to either type of multiple sequence alignment.

## Building a Phylogenetic Tree

### Extracting Variable Sites with SNP-sites

`SNP-sites` extracts variable positions from an alignment to generate a reduced alignment containing informative sites only.

```bash
snp-sites -o core_snps.aln alignment.fasta
