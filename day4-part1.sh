#!/bin/bash
declare -a board=()
while read -r line; do
    board+=("$line")
done

width="${#board[0]}"
height="${#board[@]}"

pattern="XMAS"

# check_at x y dx dy
check_at() {
    local x=$1 y=$2 dx=$3 dy=$4 xx yy

    for i in {0..3}; do
        (( xx = x + i*dx, yy = y + i*dy ))
        if [[ ${board[yy]:xx:1} != ${pattern:i:1} ]]; then
            return 1
        fi
    done
}

count=0

for d in "1 0" "0 1" "-1 0" "0 -1" "-1 -1" "-1 1" "1 -1" "1 1"; do
    set -- $d; dx=$1 dy=$2
    (( minx = dx < 0 ? 3 : 0 ))
    (( maxx = dx > 0 ? width-3 : width ))
    (( miny = dy < 0 ? 3 : 0 ))
    (( maxy = dy > 0 ? height-3 : height ))
    for (( y=miny; y < maxy; y++ )); do
        for (( x=minx; x < maxx; x++ )); do
            if check_at $x $y $dx $dy; then
                (( count++ ))
            fi
        done
    done
done

echo $count
