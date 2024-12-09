#!/bin/bash
total=0
while IFS=: read target parts; do
    parts=($parts)
    options=(${parts[0]})
    for part in ${parts[@]:1}; do
        declare -A new=()
        for opt in ${options[@]}; do
            new[$((opt*part))]=
            new[$((opt+part))]=
            new[$opt$part]=
        done
        options=(${!new[@]})
    done

    for opt in ${options[@]}; do
        if (( opt == target )); then
            (( total += target ))
            break
        fi
    done
    echo -n .
done

echo $total
