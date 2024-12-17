#!/bin/bash
LC_ALL=C

declare -A map=()
y=0
while read -r line; do
    for (( x=0; x < ${#line}; x++ )); do
        map["$x $y"]=${line:x:1}
    done
    (( y++ ))
done

width=$x height=$y

consider() {
    if [[ ! -v visited["$1 $2"] && ${map["$1 $2"]} == $next ]]; then
        queue+=("$1 $2")
        visited["$1 $2"]=
    fi
}

# explore "x y"
# where map["x y"]=0
explore() {
    local -A visited=(["$1"]=)
    local queue=("$1") x y at cur next

    while (( ${#queue[@]} )); do
        at="${queue[-1]}"
        unset queue[-1]
        cur=${map["$at"]}
        if (( cur == 9 )); then
            (( score++ ))
        else
            (( next = cur + 1 ))
            set -- $at; x=$1 y=$2

            consider $((x+1)) $y
            consider $((x-1)) $y
            consider $x $((y+1))
            consider $x $((y-1))
        fi
    done
}

score=0
for at in "${!map[@]}"; do
    if [[ ${map["$at"]} == 0 ]]; then
        explore "$at"
    fi
done

echo $score
