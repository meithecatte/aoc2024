#!/bin/bash

rules=()
while IFS="|" read a b && [[ -n "$a" ]]; do
    rules+=("$a $b")
done

check_line() {
    for rule in "${rules[@]}"; do
        set -- $rule
        if [[ -v occurs[$1] && -v occurs[$2] ]]; then
            if (( occurs[$1] >= occurs[$2] )); then
                return 1
            fi
        fi
    done

    return 0
}

find_ready() {
    for x in "${!num_before[@]}"; do
        if (( num_before[x] == 0 )); then
            return 0
        fi
    done
}

sort_line() {
    local -ai num_before=()
    local -a after=()
    local x
    for x in "${line[@]}"; do
        num_before[$x]=0
    done

    for rule in "${rules[@]}"; do
        set -- $rule
        if [[ -v occurs[$1] && -v occurs[$2] ]]; then
            (( num_before[$2]++ ))
            after[$1]+=" $2"
        fi
    done

    output=()

    while (( ${#num_before[@]} > 0 )); do
        if ! find_ready; then
            echo "Cycle detected" >&2
            return
        fi

        output+=("$x")
        unset num_before[x]
        for y in ${after[x]}; do
            (( num_before[y]-- ))
        done
    done
}

total1=0
total2=0
while IFS="," read -a line; do
    declare -a occurs=()
    for i in ${!line[@]}; do
        if [[ -v occurs[${line[i]}] ]]; then
            echo "Duplicate entry ${line[i]}" >&2
        fi

        occurs[line[i]]=$i
    done
    
    (( mid = ${#line[@]} / 2 ))
    if check_line; then
        (( total1 += line[mid] ))
    else
        sort_line
        (( total2 += output[mid] ))
    fi
done

echo $total1
echo $total2
