#!/bin/env bash

accumulated=0
cycle=1
x=1

check_signal () {
	if [ $((cycle % 40)) = 20 ]; then
		echo "[$cycle] Signal strength is: $((cycle * x))"
		accumulated=$((accumulated + cycle * x))
		echo "[$cycle] Accumulated signal strength is: $accumulated"
	fi
}

addx () {
	echo "[$cycle] RUNNING addx $1 (next X will be $((x + $1)))"
	cycle=$((cycle+1))
	check_signal
	cycle=$((cycle+1))
	x=$((x + $1))
	check_signal
}

noop () {
	echo "[$cycle] RUNNING noop"
	cycle=$((cycle+1))
	check_signal
}

. ./ej10.input
echo "[$cycle] Accumulated signal strength is: $accumulated"
