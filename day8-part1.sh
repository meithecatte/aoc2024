#!/bin/bash
declare -A antennas=()

y=0
while read -r line; do
    for (( x=0; x < ${#line}; x++ )); do
        c=${line:x:1}
        if [[ "$c" =~ [A-Za-z0-9] ]]; then
            antennas["$c"]+=" $x $y"
        fi
    done
    (( y++ ))
done

width=$x height=$y
declare -p width height

declare -A nodes=()

for c in "${!antennas[@]}"; do
    gender=(${antennas["$c"]})
    for (( i=0; i < ${#gender[@]}; i+=2 )); do
        (( x1 = gender[i], y1 = gender[i+1] ))
        for (( j=0; j < ${#gender[@]}; j+=2 )); do
            (( i == j )) && continue
            ((
                x2 = gender[j], y2 = gender[j+1],
                x3 = 2*x2 - x1, y3 = 2*y2 - y1
            ))
            (( x3 < 0 || x3 >= width || y3 < 0 || y3 >= height )) && continue
            nodes["$x3 $y3"]=
        done
    done
done

echo ${#nodes[@]}
