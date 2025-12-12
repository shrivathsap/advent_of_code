Day 11 - Reactor

This was somewhat hard. Our input is a directed acyclic graph. The [problem page](https://adventofcode.com/2025/day/11) didn't mention the acyclicity and I was careless enough to assume that there could be cycles and spent quite some time thinking about how to avoid cycles.

The first part is about finding the number of paths from a node named `you` to a node named `out`. I, foolishly, enumerated all paths. This was done with a helper function `extend_path` that takes a path and extends it by one steps while avoiding cycles. Then the `generate_paths` function looks at the nodes `to_explore` generates paths out of those and adds any path from `start` to `end` to the `paths_found` list and continues to explore the rest. This is a simple enough function and works. But it works only because the answer to part one is small.

For the second part we have to find the number of paths from `svr` to `out` that pass through `dac` and `fft` in any order. It is important that there is no cycle containing `dac, fft` as otherwise our answer is infinite.

A few days before this, I had done [Day 12 of 2017](https://github.com/shrivathsap/advent_of_code/tree/main/2017/day12) where we had a graph and wanted to find components and such. There, I built "layers" from a starting vertex consisting and the `k`th layer would be vertices `v` where paths from `start` to `v` have length at least `k`. I decided to try the same thing here. I have now commented out all that code, but the idea was to `build_layers` that look like
```
[[start], [>= 1 step away], [>=2 steps away],...]
```
Having obtained these layers, I tried to iteratively find the number of paths between vertices. Say I have two vertices `x` in `layer1` and `y` in `layer2` and there is a gap of `k` between these layers. If `k` is `1`, then I mistakenly assumed that there is a path `x->y` if and only if there is an edge `x->y` (this is the `paths_between` sub-function) and if `k>1`, then I look at the neighbours of `x` in the `layer1+1`th layer and add up the number of paths from those neighbours to `y`. This looks like it should work, but it misses many paths. Here is an example
```
a: b, c
b: d
c: e
e: d
```
In this graph, the layers from `a` to `d` would be `[[a], [b,c], [e,d]]` and the algorithm mentioned above would tell me that there are no paths from `c` to `d` because I'm skipping the possibility of in-between vertices.

Having figured this out, the way out was to do something I did for [Day 10](https://github.com/shrivathsap/advent_of_code/tree/main/2025/day10). I used my code for the change-making problem which was useless for Day 10, but very useful here. It's essentially the same code where I now have a `cache` to keep track of any computations I make along the way.

Finally, to compute the answer to part two: note that the number of paths from `svr` to `out` through `dac, fft` would be the product of paths `svr->dac, dac->fft, fft->out` or `svr->fft, fft->dac, dac->out` and this is because of the acyclicity of the graph. I compute all of these distances in a fraction of a second and see what multiplications need to be done. And with that, we are one day away from finishing this years AoC.