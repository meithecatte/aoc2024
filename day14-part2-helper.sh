#!/bin/sh
for (( i = 0; i < 101 * 103; i++ )); do
    if (( i % 101 == 8 && i % 103 == 78 )); then
        echo $i
    fi
done
