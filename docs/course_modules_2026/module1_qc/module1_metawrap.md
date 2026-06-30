# A guide to preprocessing metagenomic data with metaWRAP

Note: This pipeline is only a guide. None of metaWRAP's modules are dependant of each other, so if you want to do certain steps with another software, you are free to do so. For example, if you want to try the Reassemble_bins module on your own bins, you do not need to run the other modules just to get to that point. Or if you want to use a different assembler that metaSPAdes of MegaHit, you can do so, and then proceed to the rest of the pipeline with your own assembly.

## Step 1: Run metaWRAP-Read_qc to trim the reads and remove human contamination
Note: you will need the bmtagger hg38 index to remove the human reads - see the metaWRAP database installation instructions. You may also use another host genome to filter against with the `-x` option. Alternatively, use the `--skip-bmtagger` flag of of the ReadQC module to only do the read trimming.

Individually process each sample
```text
mkdir READ_QC
metawrap read_qc -1 /data/microbiome_course2026/course_data2026/Module1/raw_reads/SRR30598619_1.fastq -2 /data/microbiome_course2026/course_data2026/Module1/raw_reads/SRR30598619_2.fastq -t 24 -o READ_QC/SRR30598619
```

Alternatively, process all samples at the same time with a parallel for loop (especially if you have many samples):
```bash
for F in RAW_READS/*_1.fastq; do 
	R=${F%_*}_2.fastq
	BASE=${F##*/}
	SAMPLE=${BASE%_*}
	metawrap read_qc -1 $F -2 $R -t 1 -o READ_QC/$SAMPLE &
done	
```

Or as a one-liner: `for F in RAW_READS/*_1.fastq; do R=${F%_*}_2.fastq; BASE=${F##*/}; SAMPLE=${BASE%_*}; metawrap read_qc -1 $F -2 $R -t 1 -o READ_QC/$SAMPLE & done`


Lets have a glance at one of the output folders: `ls READ_QC/SRR30598622`

These are html reports of the read quality before and after QC:
```text
post-QC_report
pre-QC_report
```

Original raw reads:
![Read quality before QC](https://i.imgur.com/x8aaFWs.png)
Final QC'ed reads:
![Read quality before QC](https://i.imgur.com/drJfxC9.png)


These are the final trimmed and de-contaminated reads:
```text
final_pure_reads_1.fastq
final_pure_reads_2.fastq
```

Move over the final QC'ed reads into a new folder
```text
mkdir CLEAN_READS
for i in READ_QC/*; do 
	b=${i#*/}
	mv ${i}/final_pure_reads_1.fastq CLEAN_READS/${b}_1.fastq
	mv ${i}/final_pure_reads_2.fastq CLEAN_READS/${b}_2.fastq
done
```



