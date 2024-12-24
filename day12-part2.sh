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
    local area=0 perimeter=0 corners=0
    local ch=${map["$1 $2"]}
    visit $1 $2
    echo $ch area $area perimeter $perimeter corners $corners
    (( total += area * corners ))
}

visit() {
    local x=$1 y=$2 i
    [[ -v visited["$x $y"] ]] && return
    (( area++ ))
    visited["$x $y"]=
    local rot=(
        "$((x+1)) $y"
        "$x $((y+1))"
        "$((x-1)) $y"
        "$x $((y-1))"
        "$((x+1)) $y"
    )
    for i in {0..3}; do
        local nh="${rot[i]}" mh="${rot[i+1]}"
        if [[ ${map["$nh"]} == $ch ]]; then
            visit $nh
        else
            (( perimeter++ ))
            if [[ ${map["$mh"]} != $ch ]]; then
                # Convex corner
                (( corners++ ))
            fi
        fi
    done

    for dx in 1 -1; do
        for dy in 1 -1; do
            if [[ ${map["$((x+dx)) $y"]} == $ch
                && ${map["$x $((y+dy))"]} == $ch
                && ${map["$((x+dx)) $((y+dy))"]} != $ch ]]
            then
                # Concave corner
                (( corners++ ))
            fi
        done
    done
}

for at in "${!map[@]}"; do
    if [[ ! -v visited["$at"] ]]; then
        visit_first $at
    fi
done

echo $total
