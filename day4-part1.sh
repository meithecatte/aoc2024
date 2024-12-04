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
    local x=$1 y=$2 dx=$3 dy=$4
    local xx=$((x + 3*dx)) yy=$((y + 3*dy))
    if (( xx < 0 || xx >= width || yy < 0 || yy >= height )); then
        return 1
    fi

    for i in {0..3}; do
        (( xx = x + i*dx, yy = y + i*dy ))
        if [[ ${board[yy]:xx:1} != ${pattern:i:1} ]]; then
            return 1
        fi
    done
}

count=0

for (( y=0; y < height; y++ )); do
    for (( x=0; x < width; x++)); do
        for d in "1 0" "0 1" "-1 0" "0 -1" "-1 -1" "-1 1" "1 -1" "1 1"; do
            if check_at $x $y $d; then
                (( count++ ))
            fi
        done
    done
done

echo $count
