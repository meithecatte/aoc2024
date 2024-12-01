#!/bin/bash
sort_array() {
    local -n arr="$1"
    arr=($(printf "%d\n" "${arr[@]}" | sort -n))
}

declare -a l1 l2
while read a b; do
    l1+=($a)
    l2+=($b)
done
sort_array l1
sort_array l2

total=0
for i in ${!l1[@]}; do
    ((
        a = l1[i], b = l2[i],
        diff = a < b ? b - a : a - b,
        total += diff
    ))
done

echo $total

declare -a right_occurs
for x in "${l2[@]}"; do
    (( right_occurs[x] += 1 ))
done

total=0
for x in "${l1[@]}"; do
    (( total += x * right_occurs[x] ))
done
echo $total
