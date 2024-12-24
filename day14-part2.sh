#!/bin/sh
w=101
h=103

robots=()

while IFS='=, ' read _ px py _ vx vy; do
    robots+=("$px $py $vx $vy")
done

record_centered=0

for (( t = 0; t < w * h; t++ )); do
    declare -A grid=()

    for robot in "${robots[@]}"; do
        set -- $robot
        px=$1 py=$2 vx=$3 vy=$4

        ((
            x = px + vx * t, x %= w, x += w, x %= w,
            y = py + vy * t, y %= h, y += h, y %= h
        ))

        grid["$x $y"]="#"
    done

    echo t = $t

    for (( y = 0; y < h; y++ )); do
        for (( x = 0; x < w; x++ )); do
            echo -n ${grid["$x $y"]-.}
        done
        echo
    done
done
