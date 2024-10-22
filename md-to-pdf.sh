#!/bin/bash

# This script converts a markdown file to a pdf file using pandoc
# It requires you to pass the file to convert as an argument
# It will out the pdf file in the same directory as the markdown file
# The output file will have the same name as the markdown file but with a .pdf extension
# This script depends on pandoc, basename and dirname
FILE=$1

if [[ ! -f $FILE ]]; then
    echo "File not found!"
    exit 1
fi

DIR=$(dirname "$FILE")
BASE=$(basename "$FILE" .md)

pandoc -f markdown-implicit_figures "$FILE" -o "$DIR/$BASE.pdf" 
