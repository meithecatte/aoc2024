#!/bin/bash
read input
len=${#input}
disk=()

segment() {
    local id=$1 size=$2
    for (( j=0; j < size; j++ )); do
        disk+=("$id")
    done
}

for (( i=0; i < len; i+=2 )); do
    if (( i % 1000 == 0 )); then
        echo ${#disk[@]}
    fi
    segment $((i/2)) ${input:i:1}
    segment -1 ${input:i+1:1}
done

trim() {
    while (( disk[${#disk[@]} - 1] == -1 )); do
        unset disk[${#disk[@]}-1]
    done
}

trim # probably no-op

for (( i=0; i < ${#disk[@]}; i++ )); do
    if (( i % 1000 == 0 )); then
        echo $i
    fi
    # invariant: disk is trimmed
    if (( disk[i] == -1 )); then
        # i cannot be the last index because of invariant
        (( disk[i] = disk[${#disk[@]} - 1] ))
        unset disk[${#disk[@]}-1]
        trim
    fi
done

checksum=0

for (( i=0; i < ${#disk[@]}; i++ )); do
    (( checksum += disk[i] * i ))
done

echo $checksum
