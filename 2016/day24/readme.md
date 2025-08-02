Day 24 - Air Duct Spelunking

This was quite easy because of a few things I had done previously. So, there is a maze with 8 marked spots. We are to move a robot from spot 0 to all the others exactly once in the fewest number of steps. The second part requires us to return to the origin.

I modified my Dijkstra's algorithm from [2024 Day 16](https://github.com/shrivathsap/advent_of_code/tree/main/2024/day16) - it is now an even simpler code because it costs nothing to turn the robot around.

Then I found out all the pairwise distances - this could be slightly optimized by taking care to only find the distances one way instead of two ways as I have done, but with just so few nodes, it doesn't matter much.

Then I solved the [travelling salesman problem](https://en.wikipedia.org/wiki/Travelling_salesman_problem) by brute force - look at all permutations, find the least distance. Easy.