#!/bin/sh
LC_ALL=C

. bdsm/priority_queue.sh
declare -A map=()

y=0
while read -r line; do
    for (( x=0; x < ${#line}; x++ )); do
        case ${line:x:1} in
        "#") map["$x $y"]="#";;
        "S") sx=$x sy=$y;;
        "E") ex=$x ey=$y;;
        esac
    done
    (( y++ ))
done

# maps configuration ("x y dx dy") to best cost discovered so far
declare -A best=()
declare -A queue=()

# consider "config" cost
consider() {
    if [[ ! -v best["$1"] ]] || (( $2 < best["$1"] )); then
        best["$1"]=$2
        pq_push queue $2 "$1"
    fi
}

consider "$sx $sy 1 0" 0

while pq_pop queue cost config; do
    (( cost == best["$config"] )) || continue
    set -- $config
    x=$1 y=$2 dx=$3 dy=$4
    if (( x == ex && y == ey )); then
        echo $cost
        break
    fi

    if [[ ${map["$((x+dx)) $((y+dy))"]} != "#" ]]; then
        consider "$((x+dx)) $((y+dy)) $dx $dy" $((cost + 1))
    fi

    consider "$x $y $((-dy)) $dx" $((cost + 1000))
    consider "$x $y $dy $((-dx))" $((cost + 1000))
done
