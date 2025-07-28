Day 13 - A Maze of Twisty Little Cubicles

**Disclaimer:** The program as it is has 0 as the input and it hangs because `(1, 1)` and it's neighbours (non-diagonal) are walls. My input was not 0.

This was simple too. We are in a maze and there's a function that tells us whether a particular coordinate is a wall or not. The function is simple enough. We start at `(1, 1)` and need to reach `(31, 39)` with the fewest number of steps.

I thought of using Dijkstra's algorithm, but resorted to a simple, quick flood-fill type algorithm. Made a data type called `Node` that keeps track of coordinates and the cost to get there. Of the visited locations, take those with the largest cost, find their neighbours which aren't walls and add them to the list of visited locations with their costs increased by 1. Simple.

Iterate this expansion procedure until `(31, 39)` is visited. For the second part, we need to find the number of locations that can be visited with at most 50 steps. Because my first answer was larger than 50, all I had to do was filter out the right coordinates and take the length. For the sake of completeness, you can also do this with an iteration until the step count becomes 51 or more.