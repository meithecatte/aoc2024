#!/bin/bash
LC_ALL=C

doit() {
    local stone=$1 num_blinks=$2
    if (( num_blinks == 0 )); then
        (( total++ ))
        return
    fi

    if (( stone == 0 )); then
        doit 1 $((num_blinks - 1))
    elif (( ${#stone} % 2 == 0 )); then
        local k=$((${#stone} / 2))
        doit ${stone:0:k} $((num_blinks - 1))
        doit $((10#${stone:k})) $((num_blinks - 1))
    else
        doit $((stone * 2024)) $((num_blinks - 1))
    fi
}

read -a input

total=0
for stone in ${input[@]}; do
    doit $stone 25
done

echo $total
