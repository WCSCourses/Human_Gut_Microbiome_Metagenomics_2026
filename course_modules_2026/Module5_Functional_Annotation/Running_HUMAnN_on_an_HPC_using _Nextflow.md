# Running HUMAnN on an HPC using Nextflow

# 1. Environment setup and activation and checks
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

# 2. Prepare your nextflow configuration and hummann pipeline nextflow files
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

# 3.Running the pipeline on all samples
```bash
nextflow run humann2.nf -profile slurm --resume 2>&1 | tee -a run.log
```
NB:
- `-profile slurm` → submits jobs to the cluster.
- `--resume` → allows continuation of interrupted runs.
- `tee -a` → run.log records output logs.

---