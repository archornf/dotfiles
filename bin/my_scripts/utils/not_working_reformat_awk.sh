#!/bin/bash

# Iterate over all .c files
for file in *.c; do
    echo "Processing file: $file"

    # Use awk to transform the function declarations
    awk '
        # Buffer four lines
        {
            line1 = line2
            line2 = line3
            line3 = line4
            line4 = $0
        }

        # Check the pattern and merge lines when matched
        NR > 3 && line1 ~ /^[[:space:]]*$/ && line2 ~ /^[[:alnum:]_]+/ && line3 ~ /.*\)$/ && line4 ~ /^\s*{/ {
            print line1
            print line2 " " line3
            print line4
            line1 = line2 = line3 = line4 = ""
            next
        }

        # Print the first line in the buffer if its not part of the pattern
        NR > 3 {
            print line1
            line1 = ""
        }

        # At the end of the file, print any remaining lines
        END {
            if (line2 != "") print line2
            if (line3 != "") print line3
            if (line4 != "") print line4
        }
    ' "$file" > temp && mv temp "$file"
done

# To reset files:
# git restore *.c
