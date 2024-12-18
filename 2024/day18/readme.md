Day 18 - RAM Run

Well, this was easy because of [Day 16](https://github.com/shrivathsap/advent_of_code/tree/main/2024/day16).

The set up is that there's a grid where certain coordinates are being blocked by "falling memory". The input is a list of coordinates that are going to be blocked. the first part is to find the shortest path from the start to the end after 1024 coordinates have been blocked. The second part is about finding the first coordinate to be blocked so that there is no path from the start to the end point.

Well, that's just Day 16 with a slightly different setup! I parsed the coordinates (one thing I had to be careful about was that the input had `(x, y)` coordinates, but my code was using `(y, x)` coordinates, so I had to do some reflections after parsing), added a padding of `#`s so that I can reuse my Dijkstra algorithm from Day 16. There are a couple small differences. Obviously, there's no need to look at the directions, so I removed all mention of directions.

There are also no well defined corners, or at least my previous definition fails. Instead, because the grid is small (71x71), I can get away with finding the weights for every non-blocked coordinate. This simplifies the program a bit, but makes it slightly inefficient.

Other than that, it's pretty much the same algorithm. For the second part, I modified things a little more and instead of running the algorithm till the end point is visited I run it till either the end point is visited, or the next smallest cost node has infinite cost.

As for searching for the first coordinate with no solution, I first thought of brute forcing - there's only around 3000 coordinates that are going to be blocked and we know that the first 1024 don't close the grid - but settled on a binary search. It was fun to code a binary search on Haskell. In Python, I did the binary search until the range was 10, then brute forced; in Haskell, it's just the binary search and I didn't write the extra code to find the exact coordinate (right now, it gives 5 coordinates and the middle one is the solution to part two).