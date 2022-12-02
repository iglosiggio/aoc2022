BEGIN {
	total = 0
	rock = 1
	paper = 2
	scissors = 3

	win = 6
	lose = 0
	draw = 3
	results[rock][draw] = rock
	results[rock][win] = paper
	results[rock][lose] = scissors
	results[paper][lose] = rock
	results[paper][draw] = paper
	results[paper][win] = scissors
	results[scissors][win] = rock
	results[scissors][lose] = paper
	results[scissors][draw] = scissors
}
{
	first = $1 == "A" ? rock : $1 == "B" ? paper : scissors
	second = $2 == "X" ? lose : $2 == "Y" ? draw : win
	total += results[first][second]
	total += second
}
END {
	print total
}
