Day 20 - Race Condition

Another grid problem. This was fairly straightforward and would have taken me less time had I not misunderstood part 2. There's a grid which has a racetrack. But for a limited time, the racers can clip through walls. In part one, the time is 2 picoseconds, and in part two it is 20 picoseconds.

So, in part 2, if you can go between a normal start and end point in under 20 steps, that counts as a valid cheat. This valid cheat will save the racers some time. The goal is to find the total number of valid cheats that save at least 100 steps.

I first parse the grid and find the racetrack - this is done in steps: pick a point, find the unique next point and so on. I also keep track of the time it takes to get to each point: so starting point is at 0, the next point is at 1 and so on.

In Python, I also kept track of the direction to move from that point, so I had a dictionary that looked like `{start: ((0, 1), 0)}` where the first thing is the direction, and the second number is the time it takes to reach the point from the start point.

For the first part, I simply looped through all points on the racetrack, checked if I could go through one wall and compute the time saved provided I saved more time than the threshold (100 picoseconds).

Then came the second part. I assumed that you must stay outside the racetrack for the duration of the "cheating", i.e., if there's a cheating path `P` then only the start and end points of `P` must be on the racetrack with all other points being walls. My solution was to use Dijkstra's algorithm again, find the shortest path and that would be it. Oh, also if two cheating paths have the same start and end point then they are counted as the same, so shortest path works to save the most time.

Then I thought I'd loop through pairs of points on the racetrack that were far enough and look at what Dijkstra's algorithm tells me. To reuse my old code, I first inverted my grid so that all `#` become `.` and all non `#` become `#`, and also padded the grid with a wall on the outside. Because of the padding, I had to add `(1, 1)` to all my start and end points.

This failed because the cheating path doesn't have to stay outside the racetrack - it can go in and out of the race track, what matters is that it have a length less than 20 picoseconds.

So, I wrote a second function. This time again, I loop through pairs of points on the racetrack but instead of using Dijkstra to compute the length of the cheating path, I simply use the taxicab metric (or Manhattan metric, or the `l1` metric). Other than that, the logic is the same. It was very confusing why my original code using Dijkstra's algorithm gave fewer cheating paths for some times and more for others. For example, the example on the website says there are 32 shortcuts that save 50 picoseconds whereas I was getting 36, and the website said there were 31 that saved 52 picoseconds whereas I was getting 27.

In Haskell, I wrote just a single function to handle both parts. But Haskell is really slow for some reason - part 2 takes about 90 seconds. Not just that, even finding a path takes a lot of time. I don't know how to optimize this. I tried `Data.Map` but it's no better. I've left the code as is with the `Data.Map` version as well.