BEGIN {
	cwd = "/"
	filenum = 0
	dirnum = 0
}
/^\$ cd/ {
	if ($3 == "..") sub(/[^/]+[/]$/, "", cwd)
	else if ($3 == "/") cwd = "/"
	else cwd = cwd $3 "/"
}
/^[0-9]/ {
	filenames[filenum] = cwd $2
	filesizes[filenum] = $1
	filenum++
}
/^dir/ {
	dirnames[dirnum] = cwd $2
	dirnum++
}
END {
	# Calculate directory sizes
	for (i = 0; i < dirnum; i++) {
		for (j = 0; j < filenum; j++) {
			if (filenames[j] ~ "^"dirnames[i]) {
				dirsizes[i] += filesizes[j]
			}
		}
	}
	# Ex1: Sum of small directories
	small_directory = 100000
	for (i = 0; i < dirnum; i++) {
		if (dirsizes[i] <= small_directory) {
			ex1_total += dirsizes[i]
		}
	}
	print "Ex1: " ex1_total

	# Ex2: Smallest "big" directory
	for (i = 0; i < filenum; i++) used += filesizes[i]
	total = 70000000
	free = total - used 
	wanted_free = 30000000
	should_free = wanted_free - free
	best_directory = used # Deleting the root directory should work
	for (i = 0; i < dirnum; i++) {
		if (should_free <= dirsizes[i] && dirsizes[i] < best_directory) {
			best_directory = dirsizes[i]
		}
	}
	print "Ex2: " best_directory
	
}
