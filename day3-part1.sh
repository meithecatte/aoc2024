#!/bin/bash
process_line() {
    local rest="$1"
    while [[ "$rest" =~ "mul("([0-9]+),([0-9]+)")"(.*) ]]; do
        local a=${BASH_REMATCH[1]} b=${BASH_REMATCH[2]}
        rest=${BASH_REMATCH[3]}
        (( total += a * b ))
    done
}

total=0
while read -r input; do
    process_line "$input"
done

echo $total
