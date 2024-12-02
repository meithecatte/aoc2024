#!/bin/bash
check_part1() {
    local -n arr="$1"
    local n="${#arr[@]}" lo hi i ok=1 d

    if (( arr[0] < arr[1] )); then
        lo=1; hi=3
    else
        lo=-3; hi=-1
    fi

    for (( i = 0; i < n - 1; i++ )); do
        (( d = arr[i+1] - arr[i] ))
        if ! (( lo <= d && d <= hi )); then
            ok=0
            break
        fi
    done

    (( ok ))
}

check_part2() {
    local i
    for i in "${!record[@]}"; do
        local -a subrecord=(${record[@]:0:i} ${record[@]:i+1})
        if check_part1 subrecord; then
            return 0
        fi
    done

    return 1
}

safe=0
safe_with_dampen=0
while read -a record; do
    if check_part1 record; then
        (( safe++, safe_with_dampen++ ))
    elif check_part2; then
        (( safe_with_dampen++ ))
    fi
done

echo $safe
echo $safe_with_dampen
