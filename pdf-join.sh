#! /bin/bash

# This script (attempts to) join all files in the current directory into a single PDF file.
# Depends on libreoffice and poppler-utils (for pdfunite)

rm .pdf-join-tmp -r 2>/dev/null
mkdir .pdf-join-tmp
for f in *; do
    if [ -f "$f" ] && [ "$f" != "output.pdf" ]
    then 
        echo "Processing $f"
        if [[ $f == *.pdf ]]
        then
            cp "$f" .pdf-join-tmp
        else 
            libreoffice --writer --convert-to pdf "$f" --outdir .pdf-join-tmp
        fi
    fi
done

echo "Merging..."
pdfunite .pdf-join-tmp/* output.pdf

echo "Cleaning up..."
rm .pdf-join-tmp -r
