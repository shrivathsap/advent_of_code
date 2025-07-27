Day 11 - Radioisotope Thermoelectric Generators

This might have been the hardest advent of code challenge so far. The problem is inspired by the [Jealous husbands problem](https://en.wikipedia.org/wiki/Missionaries_and_cannibals_problem). There are 4 floors in a building and a bunch of generators and microchips scattered across the 4 floors. The microchips and generators are paired and a microchip cannot be next to a different generator unless the paired generator is also on the same floor. For example, a hydrogen microchip cannot be on the same floor as a lithium microchip unless the hydrogen generator is also on the same floor. We start on some floor and our elevator can only move one floor at a time with either one or two objects. Our objective is to get all the microchips and generators to the top floor with the shortest number of steps.

That's a short description of the problem, for a more detailed description, check out the [problem page](https://adventofcode.com/2016/day/11). My input consisted of 5 generators and 5 microchips for part one, and 7 of each for part two.

Until this problem, I had never encountered the jealous husbands problem (although I had played a game inspired by the missionaries and cannibals problem - the difference being that the missionaries and cannibals don't have identities, unlike the husbands and wives), so I had no idea how to approach this. I tried some short examples by hand, but I didn't know how I could code the solution. After looking around a bit, I learnt that the most straightforward way is to bruteforce by checking all possible moves at each step. This leads to a tree structure and a breadth-first search for the solution.

I thought of using Python instead of Haskell, but I did not feel like using OOP in Python, so I resorted to making my own Types in Haskell (which basically amounts to the same type of code as OOP). There are a whole lot of optimizations that I did and probably a lot more that I could do. Although it does give the correct solutions, it is very slow
```
Part 1: 5min 20sec
Part 2: 1hr 3min
```
I almost aborted the code at the 1 hour mark, but just as I was about to do so it spit out the answer! Anyway, here's how the code works.

First, I made a few data types: `Generator, Microchip, Floor, State`. The first two just need a name, `Floor` needs a list of generators and a list of microchips, and `State` needs the floor number for the elevator and a list of `Floor`s.

I wrote a function `subsets` that returns all subsets of a list of a given size, and a function `compare_lists` that compares whether two lists are the same up to permutation. The first is useful in choosing stuff like 1 generator/2 generators etc. and the second is useful for an optimization.

There's a `safe_floor` function which checks if a configuration is safe. Given a floor, all I need to do is to check if the names of the microchips on that floor is a subset of the names of the generators on that same floor. This is accomplished by an `intersect`. To check if a `State` is valid, I check if the elevator is between floor 0 and the highest floor number, and whether all floors are safe; this is the `valid` function.

I could probably have done this more efficiently, but I have two functions `move_up, move_down` that are very similar. It takes the current state and produces all states that can be obtained by moving up or moving down. What I did is to take all possible choices - 1 generator, 2 generators, etc. - and look at which of those is a valid move and create a list out of those. Only two floors are modified this way while the rest stay unchanged (this is the `(lower++x)++higher` part). Care needs to be taken regarding off-by-one errors. There is an optimization to be done here which is that if I can go up with two items, then I should prefer that over going up with one item and conversely, going down with one item is preferable to going down with two.

Then there's the `pair_up` function. It takes a `State` and a `Microchip` and finds the floors where the corresponding microchip-generator pair is. For example, if the hydrogen microchip is on floor 2 and the corresponding generator is on floor 3, the function would return `(1, 2)` (because indexing starts from 0). This is then used in the `compare_states` function which takes two `State`s and tells whether they are the same up to relabelling.

This is one of the most important optimizations that one needs to do. Consider a state with some arrangement of generators and microchips. If I interchange the hydrogen microchip with the lithium micochip and simultaneously do the same for the generators, then the new state is the same as the old state as far as the optimal number of steps is concerned.  Given `state1, state2` I make a list out of all the microchip-generator pairs using `pair_up` and check if the two lists are the same using `compare_lists` - if they are then the two states are equivalent.

Then there is the `next_states` function which generates all states reachable from a given state. If the elevator is in floor 0, then I should move up, if it is in the top floor, I should move down, else I should consider both directions. There is another optimization: if all floors below the current floor are empty, then there's no point in going down.

Lastly, there's the `grow_tree` function, which takes a somewhat ugly list of list of states and returns another such list of lists by adding the next generation of states. One should take care to prune those states that are equivalent to previously seen states. Using `iterate` I grow the tree starting from the initial state and keep it growing until some state returns `True` for the `is_done` function which simply checks if all floors except the top floor are empty.

The input is entered manually, and that's that. Phew.