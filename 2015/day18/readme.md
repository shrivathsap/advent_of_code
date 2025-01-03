Day 18 - Like a GIF For Your Yard

This was pleasant. It's a simulation of [Convway's Game of Life](https://en.wikipedia.org/wiki/Conway's_Game_of_Life). The amazing thing about this little automaton is that it is [Turing complete](https://en.wikipedia.org/wiki/Turing_complete) and can simulate other Turing machines. Here are some more links to check out:
[Tetris in game of life](https://codegolf.stackexchange.com/questions/11880/build-a-working-game-of-tetris-in-conways-game-of-life), [LifeWiki](https://conwaylife.com/wiki/). Really cool stuff that I don't understand!

Anyway, we are given an initial 100x100 state (unlike game of life, we have a finite grid) and need to find out how many cells are alive after 100 iterations. First, I tried to keep a list of alive and dead cells, but that was taking too long and I had to resort to dictionaries. My dictionary is a mapping object that looks like `(Int, Int)->Bool`.

An `update_state` function updates the dictionary by passing through each cell, and `iterate` 100 times. For part two, we are conditioning that the corner cells are always alive. This was just a small addition, although I messed up the order a bit (wrote `(cols-1, 0)` instead of `(0, cols-1)`) and had to write the `draw, draw_from` functions to figure out what was going wrong.
