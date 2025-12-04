Day 12 - Digital Plumber

This was surprisingly simple for a Day 12 problem. Basically, our input is a graph given in the form
```
0 <-> 2
1 <-> 1
2 <-> 0, 3, 4
3 <-> 2, 4
4 <-> 2, 3, 6
5 <-> 6
6 <-> 4, 5
```
where the left side is a vertex, and right side is all its neighbours. Part one is to find how many vertices are in the component of the vertex `0`, and part two is to find the number of components of this graph.

First I parsed the input into a `Data.Map` object so that I can look up the neighbours of a vertex easily. This was straightforward: except for the comma, I can get things by calling `words`, I remove the comma by the `comma` function, and then I take the head of the list to get the vertex and `drop 2` to get the neighbours - the input is given in a convenient form. I used `(read::String->Int)` to convert things into integers, but now that I think about it, that wasn't really necessary.

I then wrote a `build_layers` function that, for the example above outputs `[[0],[2],[3,4],[6],[5]]`: the zeroth layer contains only the vertex `0`, then `2` is in the first layer, `3, 4` are in the second layer and so on. This function works inductively. To get `[6]`, I look at the last layer found, look at their neighbours and filter out the nodes already visited. Here, the built-in list difference `\\` doesn't work because, for example, `[2,4,2,3,6]\\[0,2,3,4] = [2,6]` only the first appearance is removed. I keep building layers until there are no new nodes to visit. Then a `length $ concat` solves part one.

For part two, I first get hold of all nodes by `Map.elems`, then start from the first node, find its group, remove those nodes from the list of nodes. Each removal increases `count` by `1` and I do this until the list of nodes is empty.