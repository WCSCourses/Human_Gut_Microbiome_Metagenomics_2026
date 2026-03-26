#!/bin/bash

# Define directories
INPUT_DIR="./"
OUTPUT_DIR="./path_normalize/"

# Create the output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Loop through each pathabundance.tsv file in the input directory
find "$INPUT_DIR" -type f -name "*_pathabundance.tsv" | while read SAMPLE_FILE; do
    BASENAME=$(basename "$SAMPLE_FILE")
    OUTPUT_FILE="$OUTPUT_DIR/${BASENAME%.tsv}_relab.tsv"

    humann_renorm_table --input "$SAMPLE_FILE" --output "$OUTPUT_FILE" --units relab

    if [ $? -eq 0 ]; then
        echo "✅ Successfully processed: $BASENAME"
    else
        echo "❌ Failed to process: $BASENAME"
    fi
done

echo "🎉 Pathway abundance normalization complete. Outputs stored in $OUTPUT_DIR"
