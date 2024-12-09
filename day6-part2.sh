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

function check_loops() {
    local -A visited=()
    local dx=0 dy=-1 x=$x0 y=$y0 a

    while (( x >= 0 && y >= 0 && x < width && y < height )); do
        [[ -v visited["$x $y $dx $dy"] ]] && return 0
        visited["$x $y $dx $dy"]=
        if [[ -v obstacles["$((x+dx)) $((y+dy))"] ]]; then
            (( a = dx, dx = -dy, dy = a ))
        else
            (( x += dx, y += dy ))
        fi
    done

    return 1
}

loopable=0
checked=0
for a in "${!visited[@]}"; do
    [[ "$a" == "$x0 $y0" ]] && continue
    obstacles["$a"]=
    check_loops && (( loopable++ ))
    unset obstacles["$a"]
    (( ++checked % 100 == 0 )) && echo -n .
done

echo
echo $loopable
