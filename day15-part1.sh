#!/bin/bash
LC_ALL=C

declare -A map=()
y=0
while IFS= read -r line && [[ -n "$line" ]]; do
    for (( x=0; x < ${#line}; x++ )); do
        case "${line:x:1}" in
        '.') ;;
        '@') rx=$x ry=$y ;;
        *) map["$x $y"]="${line:x:1}";;
        esac
    done
    (( y++ ))
done

width=$x height=$y

try_move() {
    local dx=$1 dy=$2 x=$rx y=$ry
    while :; do
        (( x += dx, y += dy ))
        [[ ! -v map["$x $y"] ]] && break
        [[ ${map["$x $y"]} == "#" ]] && return 1
    done

    map["$x $y"]="${map["$((rx+dx)) $((ry+dy))"]}"
    unset map["$((rx+dx)) $((ry+dy))"]
    (( rx += dx, ry += dy ))
}

show_map() {
    local x y
    for (( y=0; y < height; y++ )); do
        for (( x=0; x < width; x++ )); do
            if (( x == rx && y == ry )); then
                echo -n '@'
            else
                echo -n "${map["$x $y"]-.}"
            fi
        done
        echo
    done
    echo
}

while read -r line; do
    for (( i=0; i < ${#line}; i++ )); do
        case ${line:i:1} in
        '>') try_move 1 0;;
        '<') try_move -1 0;;
        '^') try_move 0 -1;;
        'v') try_move 0 1;;
        esac

        [[ -v DEBUG ]] && show_map
    done
done

total=0
for at in "${!map[@]}"; do
    if [[ ${map["$at"]} == O ]]; then
        set -- $at
        (( total += 100 * $2 + $1 ))
    fi
done

echo $total
