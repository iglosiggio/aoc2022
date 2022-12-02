BEGIN {
	total = 0
	rock = 1
	paper = 2
	scissors = 3
	results[rock][rock] = 3
	results[rock][paper] = 6
	results[rock][scissors] = 0
	results[paper][rock] = 0
	results[paper][paper] = 3
	results[paper][scissors] = 6
	results[scissors][rock] = 6
	results[scissors][paper] = 0
	results[scissors][scissors] = 3
}
{
	first = $1 == "A" ? rock : $1 == "B" ? paper : scissors
	second = $2 == "X" ? rock : $2 == "Y" ? paper : scissors
	total += results[first][second]
	total += second
}
END {
	print total
}
