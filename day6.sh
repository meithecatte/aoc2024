#!/bin/bash
declare -A obstacles=() visited=()

y=0
while read -r line; do
    for (( x=0; x < ${#line}; x++ )); do
        case ${line:x:1} in
        "^") x0=$x y0=$y;;
        "#") obstacles["$x $y"]=;;
        esac
    done
    (( y++ ))
done

width=$x height=$y

dx=0 dy=-1 x=$x0 y=$y0

while (( x >= 0 && y >= 0 && x < width && y < height )); do
    visited["$x $y"]=
    if [[ -v obstacles["$((x+dx)) $((y+dy))"] ]]; then
        (( a = dx, dx = -dy, dy = a ))
    else
        (( x += dx, y += dy ))
    fi
done

echo ${#visited[@]}
