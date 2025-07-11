Day 06 - Signals and Noise

This was simple. We are given a list of codes (see day06_test.txt) and are supposed to read it column-wise. Reusing the code from day 4 makes this easy. Then we are to find the most (for part 1) and least (for part 2) common letters per column. I simply sort the column, then group it and sort again based on length and take the first or last item of the list.