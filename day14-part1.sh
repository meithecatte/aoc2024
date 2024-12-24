#!/bin/sh
w=101
h=103
t=100

(( ww = w/2, hh = h/2 ))
while IFS='=, ' read _ px py _ vx vy; do
    ((
        x = px + vx * t, x %= w, x += w, x %= w,
        y = py + vy * t, y %= h, y += h, y %= h
    ))

    (( x < ww && y < hh )) && (( q1++ ))
    (( x < ww && y > hh )) && (( q2++ ))
    (( x > ww && y < hh )) && (( q3++ ))
    (( x > ww && y > hh )) && (( q4++ ))
done

echo $(( q1 * q2 * q3 * q4 ))
