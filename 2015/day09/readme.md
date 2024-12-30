Day 9 - All in a Single Night

This was easy because 2024's Advent of Code made me code Dijkstra's algorithm. The (short) input consists of 8 locations and all distances between pairs of nodes. The first part is to find the shortest path that visits every node, the second part is to find the longest. You can tell this was the initial days of AOC.

I wrote a simple code that starts with a current path and adds the next optimal node. For the second part, I changed a `minimum` to a `maximum`. I could have parsed the input a little better, but at the moment I simply take the lines and look at specific words. At first, I only looked at the "from" part (the input has lines that look like `PointA to PointB = distance`), but that was a mistake because there was one location that only appeared as a destination, that's why I have the `nub ([(words x)!!0|x<-dists]++[(words x)!!2|x<-dists])` line.

To compute the distances, I pick a location and update the path (using `iterate`) until I run out of locations. Do this for every starting location and then take the minimum/maximum as needed.