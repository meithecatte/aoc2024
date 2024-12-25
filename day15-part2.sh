#!/bin/bash
LC_ALL=C

declare -A map=()
y=0
while IFS= read -r line && [[ -n "$line" ]]; do
    for (( x=0; x < 2*${#line}; x+=2 )); do
        case "${line:x/2:1}" in
        '.') ;;
        '@') rx=$x ry=$y ;;
        '#')
            map["$x $y"]="#"
            map["$((x+1)) $y"]="#"
            ;;
        'O')
            map["$x $y"]="["
            map["$((x+1)) $y"]="]"
            ;;
        esac
    done
    (( y++ ))
done

width=$x height=$y

try_move_horizontal() {
    local dx=$1 x=$rx y=$ry
    while :; do
        (( x += dx ))
        [[ ! -v map["$x $y"] ]] && break
        [[ ${map["$x $y"]} == "#" ]] && return 1
    done

    for (( ; x - dx != rx; x -= dx )); do
        map["$x $y"]="${map["$((x-dx)) $y"]}"
    done
    unset map["$((rx+dx)) $y"]
    (( rx += dx ))
}

# takes as arguments the coordinates of the space we'd need cleared
prepare_shift() {
    local x=$1 y=$2
    case ${map["$x $y"]} in
    "#") return 1;;
    "]") (( x-- ));&
    "[")
        if [[ ! -v need_move["$x $y"] ]]; then
            need_move["$x $y"]=
            queue+=("$x $y")
        fi;;
    esac

    return 0
}

try_move_vertical() {
    local dy=$1

    if [[ ! -v map["$rx $((ry + dy))"] ]]; then
        (( ry += dy ))
        return
    fi

    # List of boxes whose dependencies we haven't processed yet
    # (using coordinate on the left)
    local queue=()
    local -A need_move=()
    prepare_shift $rx $((ry + dy)) || return 1

    while (( ${#queue[@]} )); do
        set -- ${queue[-1]}; unset queue[-1]
        local x=$1 y=$2
        prepare_shift $x $((y + dy)) || return 1
        prepare_shift $((x + 1)) $((y + dy)) || return 1
    done

    for at in "${!need_move[@]}"; do
        set -- $at; local x=$1 y=$2
        unset map["$x $y"]
        unset map["$((x+1)) $y"]
    done

    for at in "${!need_move[@]}"; do
        set -- $at; local x=$1 y=$2
        map["$x $((y + dy))"]="["
        map["$((x+1)) $((y + dy))"]="]"
    done

    (( ry += dy ))
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
        [[ -v DEBUG ]] && echo "Move ${line:i:1}"
        case ${line:i:1} in
        '>') try_move_horizontal 1;;
        '<') try_move_horizontal -1;;
        '^') try_move_vertical -1;;
        'v') try_move_vertical 1;;
        esac

        [[ -v DEBUG ]] && show_map
    done
done

total=0
for at in "${!map[@]}"; do
    if [[ ${map["$at"]} == "[" ]]; then
        set -- $at
        (( total += 100 * $2 + $1 ))
    fi
done

echo $total
