#!/bin/bash

INPUT_DIR="/path/to/MAGs/"          # EDIT THIS
OUTPUT_DIR="/path/to/prokka_output/" # EDIT THIS

mkdir -p "$OUTPUT_DIR"

for MAG in "$INPUT_DIR"/*.fa; do
    
    BASENAME=$(basename "$MAG" .fa)
    
    echo "Annotating $BASENAME"
    
    prokka "$MAG" \
        --outdir "$OUTPUT_DIR/$BASENAME" \
        --prefix "$BASENAME"

done

echo "All MAGs annotated."