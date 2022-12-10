#!/bin/env bash

cycle=0
x=1

addx () {
	noop
	noop
	x=$((x + $1))
}

noop () {
	[ $((x-1)) = $cycle -o $x = $cycle -o $((x+1)) = $cycle ] && echo -n '#' || echo -n '.'
	cycle=$((cycle+1))
	if [ $cycle = 40 ]; then
		cycle=0
		echo
	fi
}

. ./ej10.input
