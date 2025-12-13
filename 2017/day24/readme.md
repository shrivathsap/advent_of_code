Day 24 - Electromagnetic Moat

This was pretty neat, but my approach is the same as the one in [Day 12](https://github.com/shrivathsap/advent_of_code/tree/main/2017/day12). Our input looks like
```
0/2
2/2
2/3
3/4
3/5
0/1
10/1
9/10
```
and these are "cables". The component `0/2` has `0` ports on one end and `2` ports on the other. We should start with a component that has zero ports on one end and attach components to it always matching ports. So, an example of a bridge constructed this way is
```
0/2--2/2--2/3--3/4
```
Each bridge has a strength which is the sum of all numbers appearing here. The one above has strength `0+2+2+2+2+3+3+4 = 18`. In part one, we should find the bridge with the largest strength, in part two we should find largest strength among the longest bridges.

I represent each component as a tuple `(a, b)`, then I start with an initial set of bridges by finding out which components have a zero end (turns out there were two), and then recursively building the bridges. Initially, I ended up discarding short ones and only focusing on the ones I could extend until I found all bridges I couldn't extend. Taking `maximum $ map strength` of this gave the answer to part two! Then I realized my mistake and instead had a `filtered_bridges` variable that consisted of a list of lists of bridges, sorted by lengths.

In the end, `generate_bridges` gives me a list `[[bridges of length 1], [bridges of length 2], ...]` until it has found all bridges. This was really convenient for part two. In order to be able to pick the next possible components, I present bridges as a data type consisting of its components and the number of ports on the free end; this way it was easy to look up which components are valid.

It's not the fastest program - it takes about 44 seconds after compilation - but it works. I don't have any ideas on how to optimize this. I thought this could be translated to some kind of a maximal spanning tree problem, but the issue is that the set of "out" edges from a component depends on which "in" edge you come along. Compare with [longest path problem](https://en.wikipedia.org/wiki/Longest_path_problem), an [NP-hard](https://en.wikipedia.org/wiki/NP-hardness) problem. Afterwards, I looked at other solutions over on the subreddit and found a link to [this blogpost](https://blog.jle.im/entry/unique-sample-drawing-searches-with-list-and-statet.html) which talks about `StateT` which looks really cool!