Day 08 - Playground

We are given a list of points in 3 space:
```
162,817,812
57,618,57
906,360,560
592,479,940
352,342,300
466,668,158
```
and we first sort pairs of points based on their distances. Then we connect the first two closest points, then the next two closest points and so on. If points `p, q` are already in the same component, then we don't connect them and move on to the next closest pair. This is [Kruskal's algorithm](https://en.wikipedia.org/wiki/Kruskal's_algorithm), i.e., we are finding the least weight spanning tree of a complete graph.

In part one, we are to connect 1000 closest pairs and find the sizes of the three largest components (and multiply the sizes). In part two, we make all connections until there is only one component and we need to find the last connection made (and multiply the x-coordinates).

Parsing is pretty simple and I reused code from [Day 2](https://github.com/shrivathsap/advent_of_code/tree/main/2025/day02). To get all pairs, I wrote the `pairs` function which is pretty straightforward. I could have made things a little easier if I had used the `Data.Set` package, but I didn't feel like it. Because `parse` gives a list of strings, I used an ad hoc `to_vec` function. I didn't bother to take square roots of distances in `dist2` because it doesn't matter if I'm only comparing distances. The main part is the `build_network` function.

I keep track of components as a list of list of nodes. Then I look at the closest pair to connect, call this `(p, q)`. I use `find_component` to find the component `c1` of `p` and `c2` of `q`, it is possible that one or both of these are empty because I don't track singleton components (in general, if there are going to be isolated vertices or more than one component, I would have to keep track of singletons). Based on the situation, I may have to merge `c1, c2` which I do with the `merge` function, or add `p` to `c2` or add `q` to `c1` which is accomplished by the `add` function. Both `merge` and `add` are simple list comprehensions. If `c1 == c2` then I don't need to do anything. In each case, I also keep track of the product of x-coordinates of the last connection made. For part one, I didn't code the last multiplication of sizes so I did that manually.

Even though my components are represented as a list of nodes rather than a set, each component is represented only once, so `find_component` cannot give permuted representations of the same component. This means that running a `c1 == c2` check is enough and I don't need to check any permutations. Initially, I checked if `length (nub c1++c2)== length c1` because for some reason I thought `c1, c2` could be permuted versions of each other. This inefficient check blew up the run time to almost 2 minutes. Right now, most of the run time (about 4-5 seconds) is spent on finding all the distances and sorting them, the actual computation happens almost instantly. Pretty fun problem. Using `Debug.Trace` in `built_network` it's possible to see the components form, which I think is pretty neat. This also refreshed my memory of Kruskal's algorithm which has a complexity of `O(E log E)` where `E` is the number of edges (which in our case is about half a million as we have a complete graph on `1000` nodes).