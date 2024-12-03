#!/bin/bash
declare -A arity=([mul]=2 [do]=0 ["don't"]=0)

rINSTR='('
sep=''
for instr in "${!arity[@]}"; do
    rINSTR+="$sep${instr@E}"
    sep='|'
done
rINSTR+=")\(([0-9,]*)\)(.*)"

process_line() {
    local IFS=,
    local rest="$1"
    while [[ "$rest" =~ $rINSTR ]]; do
        local instr="${BASH_REMATCH[1]}" arglist="${BASH_REMATCH[2]}"
        rest=${BASH_REMATCH[3]}

        local args=($arglist)
        if (( ${#args[@]} != ${arity["$instr"]} )); then
            echo "Invalid arity for $instr($arglist) when $enabled" >&2
            continue
        fi

        case "$instr" in
        do) enabled=1;;
        "don't") enabled=0;;
        mul) (( enabled )) && (( total += args[0] * args[1] ));;
        esac
    done
}

total=0
enabled=1
while read -r input; do
    process_line "$input"
done

echo $total
