Day 01 - Secret Entrance

Starting this year, Advent of Code will only run for 12 days instead of 25. This was a simple puzzle: we are given a dial which starts at position 50, and we have a list of instructions of the form
```
L68
L30
R48
L5
```
which means you turn left from 50 for 68 steps, then left again for 30 steps and so on. The dial has numbers from 0 to 99 and we are to wrap around (so 1 step left from 0 is 99, and 1 step right from 99 is 0). Part one asks how many times do we stop at 0, and part two asks how many times we pass through 0 (in particular, if I turn left from 50 for 200 steps, then I pass through 0 twice before stopping at 50 again).

Both parts are easily solved with some simple arithmetic: find the `new_pointer` by adding or subtracting the required amount, then go modulo 100 for part one. For part two, if the `new_pointer` is more than 99, then the number of times I pass through 0 is the number of multiples of 100 under `new_pointer` and this is given by the `div` function, if `new_pointer` is less than 0, then I have to be a little careful about whether I started out at position 0 or not (which is why I have two branches for `<=0`).

I did get stuck on part two for the following reason: `(-10) div 100` evaluates to `-1` instead of `0` as I was expecting, and this gave me too high of an answer. This is handled by taking `(-1)*new_pointer` before taking `div` in those branches.