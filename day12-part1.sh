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

declare -A visited=()
total=0

visit_first() {
    local area=0 perimeter=0
    local ch=${map["$1 $2"]}
    visit $1 $2
    (( total += area * perimeter ))
}

visit() {
    local x=$1 y=$2
    [[ -v visited["$x $y"] ]] && return
    (( area++ ))
    visited["$x $y"]=
    for nh in "$((x+1)) $y" "$((x-1)) $y" "$x $((y+1))" "$x $((y-1))"; do
        if [[ ${map["$nh"]} == $ch ]]; then
            visit $nh
        else
            (( perimeter++ ))
        fi
    done
}

for at in "${!map[@]}"; do
    if [[ ! -v visited["$at"] ]]; then
        visit_first $at
    fi
done

echo $total
