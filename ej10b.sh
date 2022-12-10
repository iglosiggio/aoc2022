#!/bin/env bash

cycle=-1
x=1

addx () {
	noop
	x=$((x + $1))
	noop
}

noop () {
	cycle=$((cycle+1))
	if [ $cycle = 40 ]; then
		cycle=0
		echo
	fi
	[ $((x-1)) = $cycle -o $x = $cycle -o $((x+1)) = $cycle ] && echo -n '#' || echo -n '.'
}

noop
. ./ej10.input
