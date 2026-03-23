module load humann3/3.8

humann_join_tables \
  --input . \
  --file_name pathcoverage \
  --output humann3_pathcoverage_merged_UG.tsv
