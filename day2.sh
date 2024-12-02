#!/bin/bash
check_pair() {
    local d
    if (( $1 < 0 || $2 >= n )); then
        return 0
    fi

    (( d = record[$2] - record[$1] ))
    (( lo <= d && d <= hi ))
}

check_record() {
    local n="${#record[@]}" lo hi i ok=1 skipped=0
    (( DEBUG )) && declare -p record

    if (( record[0] < record[1] )); then
        lo=1; hi=3
    else
        lo=-3; hi=-1
    fi
    for (( i = 0; i < n - 1; i++ )); do
        if ! check_pair i i+1; then
            if check_pair i i+2; then
                (( DEBUG )) && echo skipping ${record[i+1]} at $((i+1))
                (( i++, skipped++ ))
            elif check_pair i-1 i+1; then
                (( DEBUG )) && echo skipping ${record[i]} at $i
                (( skipped++ ))
            else
                ok=0
            fi
        fi
    done

    if (( skipped == 0 && ok )); then
        (( safe++ ))
        (( DEBUG )) && echo safe
    fi

    if (( skipped <= 1 && ok )); then
        (( safe_with_dampen++ ))
        (( DEBUG )) && echo safe with dampen
        return 0
    else
        return 1
    fi
}

safe=0
safe_with_dampen=0
while read -a record; do
    check_record
done

echo $safe
echo $safe_with_dampen
