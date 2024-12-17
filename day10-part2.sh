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

declare -A score=()

for at in "${!map[@]}"; do
    if [[ ${map["$at"]} == 9 ]]; then
        score["$at"]=1
    fi
done

total=0
for h in {8..0}; do
    for at in "${!map[@]}"; do
        if [[ ${map["$at"]} == $h ]]; then
            set -- $at
            here=0
            for nh in \
                "$(($1 + 1)) $2" "$(($1 - 1)) $2" \
                "$1 $(($2 + 1))" "$1 $(($2 - 1))"
            do
                (( map["$nh"] == h + 1 )) && (( here += score["$nh"] ))
            done
            score["$at"]=$here
            (( h == 0 )) && (( total += here ))
        fi
    done
done

echo $total
