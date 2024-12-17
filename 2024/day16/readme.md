Day 16 - Reindeer Maze

Oh boy, another interesting challenge. I learnt a lot with this one - Dijkstra's algorithm! There's a maze and a cost function that has two ingredients: it costs one point to move, and 1000 points to turn 90 degrees. The first part asks the cost of getting to the end point and the second part asks how many nodes in the grid lie on optimal paths (including the start and end points).

I set up a graph whose vertices are `(corners, directions)` where I first build a list of corners from the given maze. From there I crudely wrote Dijkstra's algorithm (the [Wikipedia page](https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm) was sufficiently detailed).

In Python, I made a dictionary that had the form `{node: cost}` and first set the cost to infinity for all vertices except for `(start, initial_direction)`. I hard coded the start and end point because I had other things to do...

The algorithm keeps track of an unvisited nodes list and a visited nodes list, picks a vertex of least cost from the unvisited ones, updates the cost of its neighbours and we iterate this until the end point is visited.

Before Dijkstra's algorithm, as seen in my Python code, I wrote a very expensive search through all possible paths. This worked fine for the examples, but, unsurprisingly, failed for the actual input.

For the second part, I rewrote the algorithm, but this time I used a dictionary of the form `{node:(cost, best previous nodes)}` where `best previous nodes` is a list of all nodes that lie before `node` in the at least one current best path to `node`. If I am able to decrease the cost, then this list is replaced entirely. If I am able to maintain the cost, then I add the current vertex to the list if the current vertex is not already...let's use some letters and examples.

Say, I'm currently using the node `u` and `v` is one of its neighbours. Then in my dictionary, there's going to be an entry of the type `v:(100, [v1, v2, v3])` where `100` is the current best cost to reach `v` and any such path has `v1, v2` or `v3` before `v`. Then I look at the cost it takes to go to `v` via `u`: this will be the cost to get to `u` plus the cost of getting from `u` to `v`.

If this new cost is, say `50`, then I can ignore `v1, v2, v3` and update the dictionary to read `v:(50, [u])`, if this new cost is more than `100` then I don't there's no need to update anything. If this cost is precisely `100`, then I ask whether `u` is already on the paths from say `v1` to `v`. Because if it is, then I don't need to include it when counting the number of vertices that lie on optimal paths because `v1->v` path already has `u`.

I run Dijkstra's algorithm again to get all this information which I will then use to backtrack. I got a little lazy with my implementation here. I created a `seats` list started from the end.

At any point, I have a `current layer` (which starts out with just the finish point), and for each `x<-current_layer` I look at all `previous nodes` that lead to `x`. I add all the vertices of the grid in between to my `seats` list and once the starting point is in my `current layer` I stop. Then I remove duplicates in `seats` and call it a day.

In Haskell, things were so much more annoying but at the same time easier because I didn't have to solve it all over again. I did not write the backtracking algorithm because frankly I've had a long day today (outside of AOC) and I doubt I'll get back to completing it. However, I did manage to implement the full Dijkstra algorithm.

I learnt how to make my own data type `Weight` which has two functions `cost` and `pnodes` (previous nodes). The expense of moving from one `(position, direction)` pair to another is the same as in Python (I should've mentioned this earlier, but I used dot products here to figure out the change in rotation; that was interesting).

Rather than dictionaries, I used a `Data.Map` object to represent the things I wanted. The `update_weights` function takes in `currentNode mapObject nextNode` and updates the weight of `nextNode` in `mapObject` using the distance from `currentNode`. It's more or less straightforward, but the annoying thing is I don't know how not to write long list comprehensions in Haskell.

Also, I should've mentioned this earlier too, but there's some funny thing in the way I check whether `currentNode` is in the path from a `previousNode` or not: I make a list of all common previous nodes of `currentNode` and `nextNode` and check if that list is empty or not.

Back to the code, `Map.adjust` is also funny because it needs a function to adjust it, so I wrote a constant lambda function.

Then there's my `least` funciton in the Haskell file. In Python I can simply use `min[d, key=d.get]` or `min[d, key=lambda x->f(x)]` where `f` is a function on the keys, to obtain a key based on some critierion. I could not find such a function in Haskell, so I wrote my own little snippet. I think it's fairly self-explanatory.

Then there's this line
```
Map.delete (fst current) (foldl (update_weights (fst current)) unvisited (next_states++dirs_at_current))
```
in my `dijkstra` function. Here `next_states` is the next neighbours, `dirs_at_current` is the current position, but with different directions. These two together form a list of nodes that need some updating in the mapping dictionary `unvisited` with the current vertex being `fst current` (the `fst` is there so we ignore the weight associated to the current vertex and only look at the position and direction). I `foldl` along the list of nodes that need updating, then delete `fst current`. All in one line, but wait until you see
```
head (dropWhile (\(x, y)-> not(end `elem` [fst z|z<-Map.keys y])) ((iterate (dijkstra maze nodes)) (initial_unvisited, initial_visited)))
```
in the main `solve` function. Wow. I iterate the function `dijsktra maze nodes` (which now just needs the `(unvisited, visited)` pair) on the initial seed `(initial_unvisited, initial_visited)`. Then I drop elements that don't have the end point in the visited set. Then I take the first element of whatever remains.

For some reason I need to run `dijkstra` again, but I'm too tired to think why. Whatever the output is, it's a pair `(unvisited, visited)` and the `visited` object has the finish point. I take that, and use a `Map.lookup` to see what the score (and best previous nodes) of the end point are. That gives me the score.

I am too tired to do the backtracking on Haskell, and I really have other things going on. Both files run reasonably well. Of course, there's probably dozens of things that can be optimized and what not. Phew.