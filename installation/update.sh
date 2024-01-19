#!/bin/bash

# Ensure the packages directory exists
mkdir -p packages

# Execute commands and save output to files
pacman -Qe | awk '{print $1}' > package_list.txt
pacman -Qm > other.txt
pip freeze > requirements.txt

# Calculate the number of lines approximately one-third of the file
total_lines=$(wc -l < package_list.txt)
lines_per_file=$(( (total_lines + 2) / 3 )) # Add 2 for rounding up on division

# Split the file into three parts
split -l "$lines_per_file" package_list.txt packages/pk --additional-suffix=.txt

# Rename the split files to pk1, pk2, pk3
mv packages/pkaa.txt packages/pk1.txt
mv packages/pkab.txt packages/pk2.txt
mv packages/pkac.txt packages/pk3.txt

# Sleep for 5 seconds
sleep 5
