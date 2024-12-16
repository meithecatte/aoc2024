#!/bin/bash
LC_ALL=C
read input
len=${#input}

segments=() # start_lba size
gaps=() # start_lba size
lba=0

for (( i=0; i < len; i+=2 )); do
    size=${input:i:1}
    segments+=("$lba $size")
    (( lba += size ))
    size=${input:i+1:1}
    (( size )) && gaps+=("$lba $size") && (( lba += size ))
done

find_gap() {
    local orig_lba=$1 size=$2 i
    for i in ${!gaps[@]}; do
        set -- ${gaps[i]}
        (( $1 >= orig_lba )) && unset gaps[i] && return 1
        if (( $2 >= size )); then
            new_lba=$1
            if (( $2 == size )); then
                unset gaps[i]
            else
                gaps[i]="$(($1 + size)) $(($2 - size))"
            fi
            return 0
        fi
    done

    return 1
}

for (( i=${#segments[@]} - 1; i >= 0; i-- )); do
    (( i % 100 == 0 )) && echo $i ${#gaps[@]}
    set -- ${segments[i]}
    if find_gap $1 $2; then
        segments[i]="$new_lba $2"
    fi
done

checksum=0
for file_id in ${!segments[@]}; do
    set -- ${segments[file_id]}
    (( checksum += file_id * (2 * $1 + $2 - 1) * $2 / 2 ))
done

echo $checksum
