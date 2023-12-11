#!/bin/bash

checkFirstLine() {
    local line="$1"
    [[ -z "$line" || "$line" == /* || "$line" == \** ]] && [[ "$line" != \#* ]]
}

checkForComment() {
    local line="$1"
    [[ "$line" == /* || "$line" == \** ]]
}

checkForContent() {
    local line="$1"
    [[ -n "$line" && ! $(checkForComment "$line") && "$line" != \#* ]]
}

checkForParen() {
    local line="$1"
    [[ "$line" == *'('* ]]
}

checkForEndParen() {
    local line="$1"
    [[ "$line" == *')' ]]
}

checkForFuncStart() {
    local line="$1"
    [[ "$line" == '{'* ]]
}

processFile() {
    local filename="$1"
    local changeCounter=0
    local lines
    mapfile -t lines < "$filename"
    local i=0
    local len=${#lines[@]}
    local newLines=()

    while [[ $i -lt $len ]]; do
        if [[ $i -lt $((len - 3)) ]] && checkFirstLine "${lines[$i]}" && checkForContent "${lines[$((i + 1))]}" && checkForEndParen "${lines[$((i + 2))]}" && checkForFuncStart "${lines[$((i + 3))]}"; then
            newLines+=("${lines[$i]}")
            newLines+=("${lines[$((i + 1))]} ${lines[$((i + 2))]}")
            newLines+=("${lines[$((i + 3))]}")
            ((i += 4))
            ((changeCounter++))
        else
            newLines+=("${lines[$i]}")
            ((i++))
        fi
    done

    printf "%s\n" "${newLines[@]}" > "$filename"
    echo $changeCounter
}

dirPath="./" # Current directory
totalChangeCount=0

for file in "$dirPath"*.c; do
    if [[ -f "$file" ]]; then
        echo "Processing file: $file"
        fileChangeCount=$(processFile "$file")
        echo "Done! Changes done: $fileChangeCount"
        ((totalChangeCount+=fileChangeCount))
    fi
done

echo "Done processing files! Total changes done: $totalChangeCount"
