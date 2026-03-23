module load humann3/3.8

humann_join_tables \
  --input ./ \
  --output humann3_pathabundance_merged_normalised_UG.tsv \
  --file_name pathabundance_relab.tsv
