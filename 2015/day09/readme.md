Day 9 - All in a Single Night

The (short) input consists of 8 locations and all distances between pairs of nodes. The first part is to find the shortest path that visits every node, the second part is to find the longest. You can tell this was the initial days of AOC.

I wrote a simple code that starts with a current path and adds the next optimal node in a greedy manner. For the second part, I changed a `minimum` to a `maximum`. I could have parsed the input a little better, but at the moment I simply take the lines and look at specific words. At first, I only looked at the "from" part (the input has lines that look like `PointA to PointB = distance`), but that was a mistake because there was one location that only appeared as a destination, that's why I have the `nub ([(words x)!!0|x<-dists]++[(words x)!!2|x<-dists])` line.

To compute the distances, I pick a location and update the path (using `iterate`) until I run out of locations. Do this for every starting location and then take the minimum/maximum as needed.

---
### Added: Why it shouldn't work

My greedy algorithm somehow gave the correct answers, but it wouldn't work always. The reason being that there could be paths that are a little less greedy at the start, but end up being minimal overall. Here's an example:

Say there are four nodes `A, B, C, D` with costs: `AB = 1, AC = 1.1, AD = 1.5, BC = 1, BD = 0.5, CD = 1.5`. Starting from `A`, the greedy algorithm would go to `B`, then to `D` and then to `C` for a total cost of `1+0.5+1.5 = 3`. However, the optimal path is `ACBD` which has a cost of `1.1+1+0.5 = 2.6`.

I just happened to get lucky with my greedy algorithm providing the correct answers and didn't think too much about my approach because I was set on using Dijkstra's algorithm (2024's AOC had more than one problem where Dijkstra's algorithm provided the answer).

The problem at hand is similar to the [Travelling Salesman Problem](https://en.wikipedia.org/wiki/Travelling_salesman_problem) which is NP-hard (the difference being that TSP wants a loop, whereas we only want a path). The only way to solve this is to look at all possible permutations.