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
        echo $i
    fi
    filesize=${input:i:1}
    segment $((i/2)) $filesize
    gapsize=${input:i+1:1}
    segment -1 $gapsize
done

trim() {
    while (( disk[len - 1] == -1 )); do
        (( len-- ))
    done
}

trim # probably no-op

len=${#disk[@]}
echo len = $len

for (( i=0; i < len; i++ )); do
    if (( i % 1000 == 0 )); then
        echo $i
    fi
    # invariant: disk is trimmed
    if (( disk[i] == -1 )); then
        # i cannot be the last index because of invariant
        (( disk[i] = disk[len-- - 1] ))
        trim
    fi
done

checksum=0

for (( i=0; i < len; i++ )); do
    (( checksum += disk[i] * i ))
done

echo $checksum
