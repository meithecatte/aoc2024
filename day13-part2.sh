#!/bin/bash
LC_ALL=C

while IFS=+, read -r _ ax _ ay; do
    IFS=+, read -r _ bx _ by
    IFS==, read -r _ px _ py
    read

    ((
        px += 10000000000000,
        py += 10000000000000
    ))

    # ax * i + bx * j = px
    # ay * i + by * j = py
    #
    # ax * ay * i + bx * ay * j = ay * px
    # ax * ay * i + ax * by * j = ax * py
    #
    # (bx * ay - ax * by) * j = ay * px - ax * py

    ((
        rhs = ay * px - ax * py,
        m = bx * ay - ax * by
    ))

    if (( rhs == 0 )); then
        echo ERROR, rhs = 0
        break
    fi

    ((
        j = rhs / m,
        j < 0 || rhs % m != 0
    )) && continue

    ((
        rhs = px - bx * j,
        rhs < 0 || rhs % ax != 0
    )) && continue

    (( i = rhs / ax ))

    if (( ax * i + bx * j == px && ay * i + by * j == py )); then
        (( total += 3 * i + j ))
    fi
done

echo $total
