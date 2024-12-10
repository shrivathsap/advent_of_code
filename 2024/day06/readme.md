Day 6 - Guard Gallivant

The input is a grid with '.' for free spaces, '#' for an obstacle and one of '^, >, v, <' for the position and direction of a guard. The guard moves in a straight line and upon reaching an obstacle turns 90 degrees clockwise.

The input also comes with the initial position and direction (which seems to be always up, but my code should handle other initial directions) and part one asks the number of distinct positions the guard touches before exiting the grid.

The second part asks about those spots in the grid where introducing an obstacle would lead to the guard walking in circles.

In Python, I simply make a list of positions and then add the new position based on whether I need to rotate etc. I then convert this into a set and look at its length. This works, but is slow and I only realized that during part 2. The faster approach is to have positions and directions as a tuple and deal with sets from the get go rather than convert long lists to set. That seems obvious in hindsight, but I've almost always worked with lists before this.

In Haskell, I found a very neat way to do this, although it probably isn't optimal. I first made a function `next_pos` that takes in the grid, current position and direction and returns a list containing the next position and direction. Then to actually compute the path of the guard, I create an infinite list using `iterate` starting from the initial direction and position. Because of Haskell's lazy evaluation, this infinite list doesn't "exist". When I need to, I `takeWhile` elements from this list as long as they are within the bounds of the grid, and then remove duplicates using the `nub` function from `Data.List`. I like how this works.

The second part taught me some stuff about optimization. To check for loops, we need to keep track of the positions we have visited and the directions at those positions. First reduction - we only need to keep track of the obstacles that we encounter, and the newly introduced obstacles have to be along the path the guard takes from part 1.

In Python, I wrote a function that takes in the grid, initial position and direction, and candidate obstacle position and returns a boolean on whether the candidate works or not. Here it is really important that I use sets of tuples and not touch lists. It's far more efficient to add to and look up elements in sets than it is for lists. Other than that, it's simply a matter of updating a set of obstacles we have visited and checking whether we ever repeat one, or go out of bounds. In the end, I simply count all "good" candidate obstacle positions.

In Haskell, I learnt something new! The `until p f` notation, where `p` is a predicate and `f` is a function. This lets me apply `f` to a starting seed value until the condition `p` is met. It took me a lot of time to figure out how to install `Data.Set` modules and how to make this `until` thing work. But eventually, I think it turned out pretty.

Basically, my `possible` function which takes in the grid, initial data and candidate data and returns a boolean. In between, I created a triple `(end_pos, end_dir, visited)` where `end_pos, end_dir` have type `[Int]` and `visited` is a `Set` of lists of `Int`, i.e., a `Set.Set [[Int]]` object keeping track of all (obstacle, direction) pairs previously encountered.

I start with `(start_pos, start_dir, Set.empty)` and "update" it using the `until` block. Although, Haskell doesn't really update it, it applies a function to this triple until something happens - in this case, until a loop is encountered or I go out of bounds. Once this iteration stops, I have my end position, direction and all the obstacles encountered till then. I check if I'm out of bounds - if yes, then there's no loop, else there is a loop!

My Python code runs in around 4 seconds, but my Haskell code takes around 3 minutes! There's a bunch of issues like having multiple calls to unnecessary functions to add vectors or check whether I'm within bounds etc. I could change it, but I'm going to leave it at this. My Python code probably could use some more optimization as well. There's also parallel processing/multi-threading that might make things significantly faster, but eh.