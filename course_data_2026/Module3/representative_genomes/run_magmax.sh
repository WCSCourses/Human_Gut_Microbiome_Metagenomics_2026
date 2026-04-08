#!/bin/bash
#BSUB -J magmax
#BSUB -q long
#BSUB -n 32
#BSUB -W 48:00
#BSUB -M 30000
#BSUB -R "span[hosts=1] select[mem>30000] rusage[mem=30000]"
#BSUB -o magmax_out
#BSUB -e magmax_err

module load magmax/1.1.0
module load skani/0.3.0

/nfs/users/nfs_y/ya4/software/MAGmax/target/debug/magmax -b /data/pam/team162/bg7/scratch/Bednarski_2025/raw_mags/qc_mags_dir/pass/Hq_MAGs_fastas/hq_final_mags -i 95 -c 90 -p 95 -q genome_quality.tsv --no-reassembly -t 32 -f fa
