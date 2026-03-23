#!/bin/bash

# Define directories
INPUT_DIR="./"
OUTPUT_DIR="./gene_normalize/"

# Create the output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Loop through each genefamilies.tsv file in the input directory
find "$INPUT_DIR" -type f -name "*_genefamilies.tsv" | while read SAMPLE_FILE; do
    BASENAME=$(basename "$SAMPLE_FILE")
    OUTPUT_FILE="$OUTPUT_DIR/${BASENAME%.tsv}_relab.tsv"
    
    echo "Normalizing: $BASENAME"
    humann_renorm_table --input "$SAMPLE_FILE" --output "$OUTPUT_FILE" --units relab

    if [ $? -eq 0 ]; then
        echo "✅ Successfully processed: $BASENAME"
    else
        echo "❌ Failed to process: $BASENAME"
    fi
done

echo "🎉 Gene family normalization complete. Outputs stored in $OUTPUT_DIR"
