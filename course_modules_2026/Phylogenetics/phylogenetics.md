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
- Track pathogen spread  

### Newick Format

Phylogenetic trees are commonly stored in **Newick format**, which represents tree structure using parentheses.

Example:


### Methods for Inferring Trees

Common tree inference approaches include:

- Distance-based methods  
- Maximum Parsimony  
- Maximum Likelihood  
- Bayesian inference  

### Assessing Tree Uncertainty (Bootstrap)

Bootstrap analysis evaluates confidence in tree branches by resampling alignment columns and reconstructing trees multiple times.

---

## Multiple Sequence Alignments

Phylogenetic inference requires a **multiple sequence alignment (MSA)**.  
The alignment ensures homologous positions are compared across sequences.

Alignment quality directly affects tree accuracy. Always inspect alignments before proceeding with inference.

---

## Building a Phylogenetic Tree

### Extracting Variable Sites with SNP-sites

`SNP-sites` extracts variable positions from an alignment to generate a reduced alignment containing informative sites only.

```bash
snp-sites -o core_snps.aln alignment.fasta
