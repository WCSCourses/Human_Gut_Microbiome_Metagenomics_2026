out_file="combined_rgi_results.tsv"

# Extract header
header=$(head -n1 mag3_test_amr_out.txt)
echo -e "MAG_ID\t$header" > $out_file

# Loop through all output files
for f in *_amr_out.txt; do
    mag_id=$(basename "$f" _amr_out.txt)
    tail -n +2 "$f" | awk -v id="$mag_id" 'BEGIN{OFS="\t"} {print id, $0}'
done >> $out_file
