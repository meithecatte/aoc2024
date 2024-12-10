#!/bin/bash
gcd() {
    local a=$1 b=$2 c
    (( a < 0 )) && (( a = -a ))
    (( b < 0 )) && (( b = -b ))
    while (( b > 0 )); do
        ((
            c = a%b,
            a = b,
            b = c
        ))
    done
    gcd=$a
}

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

declare -A nodes=()

for c in "${!antennas[@]}"; do
    gender=(${antennas["$c"]})
    for (( i=0; i < ${#gender[@]}; i+=2 )); do
        (( x1 = gender[i], y1 = gender[i+1] ))
        for (( j=i+2; j < ${#gender[@]}; j+=2 )); do
            ((
                x2 = gender[j], y2 = gender[j+1],
                dx = x2 - x1, dy = y2 - y1
            ))
            gcd $dx $dy
            (( dx /= gcd, dy /= gcd ))
            for (( x = x2, y = y2; x >= 0 && y >= 0 && x < width && y < height; x += dx, y += dy )); do
                nodes["$x $y"]=
            done
            for (( x = x1, y = y1; x >= 0 && y >= 0 && x < width && y < height; x -= dx, y -= dy )); do
                nodes["$x $y"]=
            done
        done
    done
done

echo ${#nodes[@]}
