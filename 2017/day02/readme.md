Day 02 - Corruption Checksum

We are given a small table of numbers. In the first task we should find the range (max value - min value) of each row and sum them up. I just had to use the built in `maximum` and `minimum` functions.

It turns out that in each row there is exactly one pair where one number divides another. In the second task, we are to sum up such quotients over the rows. Because the table is quite small, I opted to simply run through all possible pairs, but if it were longer may be I could incorporate some size comparisons and such. But it's again a simple list comprehension problem.