Day 23 - LAN Party

Well, this wasn't too hard, but I don't like my solution that much because I use external libraries. There's a graph whose nodes have two letter names, such as `ad, tq` etc and the first part asks for all 3-cycles where at least one node starts with `t`. The second part asks for nodes in the largest complete subgraph. A complete subgraph is a subgraph where every vertex is connected to every other vertex.

At first, I assumed part two would ask for all cyles or something like that. I thought it would be best to first obtain a spanning tree. So, that's what I did. I parsed the input into a list of edges `[(u, v), (x, y),...]` and then I converted it into a dictionary `graph` which looked like `{vertex:[neighbours]}`. This was easy.

To obtain a spanning tree, I start with a random vertex as `root`, and use `current_gen, next_gen` lists and add things to a dictionary that looks like `{vertex:(parent, generation_number)}`. This is also quite quick - but only works if the graph is already connected.

To find all spanning trees, I find _some_ spanning tree, delete those vertices, and recurse until the graph becomes empty.

Then I learnt something new. Adding edges to a spanning tree creates cycles, this I knew before. But I hadn't really thought about how to get _all_ cycles. It turns out that all cycles are obtained by "bitwise xor"-ing the base cycles - the base cycles are the cycles obtained by adding one edge to the spanning tree.

To generate all cycles, I start with the first base cycle. Look at the next one, check if there's intersection (if there's no intersection, then xor-ing gives a disjoint union of cycles). If there is an intersection, I look at the new cycle, check if I've seen it before, if not add it to the list of cycles. Repeat this until you've checked all base cycle combinations. Of course, there are `2^|base cycles|` many combinations to check!

 Because there's ordered and unordered edges and whatnot flying around, I had to use a function that retrieves a _set_ of vertices from a cycle and then compare vertices etc. Had I been a little more systematic with my edges/parsing of input (eg. use alphabetical order on the edges from the get go), then things might have been a bit faster.

 It turns out that for the test input there were a 1000 cycles, and for the actual input my program didn't finish, but I know there are over 85000 cycles. My plan was to get all cycles first, then look at only those that have length 3 and at least one node starting from `t`.

 Once this didn't work, I tried to manually xor two and three basic cycles (because a three cycle has at most three edges that are not in the spanning tree). Turns out this too is very time consuming.

 I gave in and used libraries that others had written: `networkx`.

 The second part about the maximal clique also has a direct solution with `networkx` and just does the job. Turns out that there is only one maximal clique. With a little bit of string manipulation I have my answer to part two as well.

 Unsatisfied, I then wrote the part one solution in the most straightforward manner possible: brute force. Loop through all nodes starting from `t` and check if any two of the neighbours have an edge between them. One thing to be careful about is when there's a cycle with more than two nodes starting from `t` - we don't want to double count cycles! So, I kept track of a list of vertex _sets_ and increased the count only when I encountered a new three cycle. This runs in an instant.

 In Haskell, I did pretty much the same thing. Coded the first part as in Python, and for the second part I used the library `Data.Algorithm.MaximalCliques` which does exactly what it says it does. The code runs in an instant, compared to about 7 seconds with `networkx` on Python - I think this is the first time in this AOC that my Haskell code ran faster than Python.

 Both packages use the [Bron-Kerbosch algorithm](http://en.wikipedia.org/wiki/Bron%E2%80%93Kerbosch_algorithm) to find maximal cliques. This is also something new for me. I could write it on my own, but may be some other day. I've already written an algorithm for spanning trees and basic cycles today.