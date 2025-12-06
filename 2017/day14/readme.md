Day 14 - Disk Defragmentation

This was hard because of some poor code (and a bug) I had previously written and quite long. So, we are given an input phrase, say `input`. We first compute all the knot hashes of `input-0, input-1,...,input-127` using the code from [Day 10](https://github.com/shrivathsap/advent_of_code/tree/main/2017/day10). Once we do that, we get 128 32-bit hex strings. For each hex string, we convert the characters into 4-bit binary codes, so `0->0000, 1->0001,...,f->1111`. This then gives us 128 128-bit binary strings which we arrange into a 128x128 grid.

For part one, we find the number of `1`s in this grid, for part two, we find the number of components in this grid where a tile is adjacent only to its vertical and horizontal neighbours. For part two, I reused code from [Day 12](https://github.com/shrivathsap/advent_of_code/tree/main/2017/day12).

Here is the first problem. My `knot_hash` program was really slow. It was fine for Day 10, but here I need to run it 128 times and it was taking forever. First, instead of having `hash2` keep track of the rounds and repeatedly call `hash`, I used `cycle` to loop the input and then `take (length*64)` to repeat the input 64 times. With this, I can call `hash` and get rid of `hash2`.

Second, my `hash` function was recursive, recursing on the first item of a list and then calling `hash` again on the tail. I converted this to a non-recursive function using `foldl` and wrote a short sub-function called `step` to step through each number in the input list of numbers. I'm not sure if this saved a lot of time.

The most important time save came from rewriting the `rot` function. Previously, my `rot` function had to read all the elements of a list and then create a new list. Calling this function 2 times per number in the input was taking an enormous amount of time. Rewriting this with `take, drop` made `knot_hash` run instantly.

To convert to binary, because we want 4-bit strings, I wrote out a manual conversion function. A chain of `map`s and `concat`s followed by a `sum` solves part one (one could do this directly without having to convert to hex first).

Before talking about part two, there is a mistake I need to mention. In my code for Day 10, while converting to hex, I didn't pad my output correctly (the `day10.hs` file has now been corrected). So, it converted `0-9` to a single character hex code when I needed a double character code. This is fine for part one because the leading `0` doesn't contribute to the sum. But this is not fine for part two because I don't get a 128x128 grid without the leading zeros (sure my `to_bin` has leading zeros, but `to_hex` doesn't which means `to_bin` misses out 4 zeroes).

I got lucky on Day 10 because my output answer never had any leading zeros and I got out a 32-bit answer as required. To solve this, I added a short `padded_hash` sub-function within `knot_hash`. It's one line and does the job.

Coming to part two, all I need to do is to represent the grid as a graph. The `build_layers, find_groups` functions from Day 12 work just fine and don't need any modifications. My `neighbours` function is self-explanatory, and converting the grid to a graph is simply about finding the neighbours for every `1` in the grid. `ghci` takes about 7 seconds for part one, 30 seconds for part two (and part two computes all the `knot_hashes` again), so it's quick enough.