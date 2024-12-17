#!/bin/bash
LC_ALL=C

declare -A cache=()

doit() {
    local stone=$1 num_blinks=$2
    if (( num_blinks == 0 )); then
        res=1
        return
    fi

    if [[ -v cache["$stone $num_blinks"] ]]; then
        res=${cache["$stone $num_blinks"]}
        return
    fi

    if (( stone == 0 )); then
        doit 1 $((num_blinks - 1))
    elif (( ${#stone} % 2 == 0 )); then
        local k=$((${#stone} / 2))
        doit ${stone:0:k} $((num_blinks - 1)); local left=$res
        doit $((10#${stone:k})) $((num_blinks - 1)); local right=$res
        (( res = left + right ))
    else
        doit $((stone * 2024)) $((num_blinks - 1))
    fi

    cache["$stone $num_blinks"]=$res
}

read -a input

part1=0
part2=0
for stone in ${input[@]}; do
    doit $stone 25
    (( part1 += res ))
    doit $stone 75
    (( part2 += res ))
done

echo $part1
echo $part2
