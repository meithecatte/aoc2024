#!/bin/bash
declare -a board=()
while read -r line; do
    board+=("$line")
done

width="${#board[0]}"
height="${#board[@]}"

count=0

for (( y=1; y < height-1; y++ )); do
    for (( x=1; x < width-1; x++ )); do
        if [[ "${board[y]:x:1}" == A ]]; then
            a="${board[y-1]:x-1:1}" b="${board[y+1]:x+1:1}"
            if [[ "$a" == M && "$b" == S ]] || [[ "$a" == S && "$b" == M ]]; then
                a="${board[y-1]:x+1:1}" b="${board[y+1]:x-1:1}"
                if [[ "$a" == M && "$b" == S ]] || [[ "$a" == S && "$b" == M ]]; then
                    (( count++ ))
                fi
            fi
        fi
    done
done

echo $count
