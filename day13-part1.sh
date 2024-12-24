#!/bin/bash
LC_ALL=C

while IFS=+, read -r _ ax _ ay; do
    IFS=+, read -r _ bx _ by
    IFS==, read -r _ px _ py
    read

    best=0
    for (( i=0; i <= 100; i++ )); do
        if ((
            x = px - i*ax,
            y = py - i*ay,
            j = x / bx,
            this = 3 * i + j,
            x % bx == 0 && by * j == y && (!best || best > this)
        )); then
            best=$this
        fi
    done
    (( total += best ))
done

echo $total
