Day 20 - Firewall Rules

We are given a long list of ranges and we need to remove those ranges from `[0..2^32]` and find the smallest remaining number for part one, and the number of remaining numbers for part 2.

The naive approach of forming a union and then removing doesn't work. Instead, for part one, I start with `0` and check if it is in some range. If it is contained in an interval `[a, b]` then I move to `b+1`. Repeat until the number is not contained in any range. This recursion ends pretty quickly.

For the second part, what we do is to merge the intervals so that there is no overlap. Once this is done, we can simply add up the lengths of the ranges and take a difference. Merging them was a little tricky because the input is not ordered. First, I tried sorting by the lengths of intervals and used a convoluted merging function, but it didn't work because each merge changes the lengths and I'd have to sort things again. Instead, sort by the starting end point, and then merge by looking at the other end point.