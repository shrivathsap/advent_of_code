Day 16 - Permutation Promenade

This might be my favourite problem so far from 2017's AoC. There are 16 dancers in positions 0 through 15 and they have names `a` through `p`. We have a list of moves`
- `sX` means the list rotates by `X` amount, so `s3` makes `abcde` into `cdeab`
- `xA/B` exchanges the dancers in positions `A, B`
- `pA/B` exchanges the dancers named `A, B`
For part one, we should follow the moves and find the final configuration. For part two, we should follow the given moves a billion times and then find the final configuration. Obviously, my computer cannot handle a billion cycles.

Parsing: this is fairly simple. A `comma_split` function takes my input, splits on the commas and gives me a list of moves.

Individual moves: I wrote the functions `rot, exchange, partner` to rotate, exchange or exchange based on names.

I wrote a function `dance` that takes in a string and performs the appropriate move. For part one, I `foldl` through the given input to get the final answer.

Now we come to the more interesting part. There are two properties being permutated: the positions of the dancers and their names. Imagine each dancer to be a person holding a label. For moves `s, x` the people physically move, but for move `p` they only exchange their labels. This way, I can keep track of the two permutations separately and this is what the `dance2` function does. Say `dance2` gives the output
```
[1,2,0,4,3], ["e","c","d","a","b"]
```
The way I have written my code, this says that the person who was in position `1` is now in position `0`, person in position `2` is now in position `1` and so on. At the same time, the person in position `1` had the name in position `1` (which was `b`) but the current name in position `1` is `c` (i.e., the `b` became a `c`), so ultimately the person in position `1` is now in position `0` with the name `c`. Reading it out, the new configuration is `cdeba`. Think about this kind of representation for each of the `s, x, p` moves.

There are `16!` possible configurations and `Dance` (I'm using capital `D`) is a function that takes one configuration to another based on my given input. This means that `Dance` is an element of `S(16!)`, the permutation group on `16!` elements, which is a huge group with `(16!)!` elements. However, because the permutations of positions and permutations of names pass through each other, `Dance` is actually the product of two permutations from `S(16)`, the permutation group on `16` elements.

Mathematically, there is a group homomorphism `S(16)xS(16)->S(16!)` and `Dance` is in the image of this homomorphism. The main point is that `Dance` has an order that is quite small (here, order means the smallest `n` such that `Dance^n` is the identity permutation).

The [Landau function](https://en.wikipedia.org/wiki/Landau%27s_function) at `n` is the largest order of elements in `S(n)` and it [turns out](https://oeis.org/A000793) that Landau's function at `16` is `140`. The order of a pair of permutations `(f1, f2)` is the `lcm` of the orders of `f1, f2`. The permutation `f1` can be decomposed into a bunch of cycles and it's order is the `lcm` of the lengths of cycles. To find the maximal order for pairs `(f1, f2)`, we should run through pairs of [partitions](https://en.wikipedia.org/wiki/Partition_function_(number_theory)) of `16` and look at the `lcm`s. This [turns out](https://www.reddit.com/r/adventofcode/comments/7k5mrq/comment/drcb51m/?st=jb9xazve&sh=08fdcbe7) to be `5460`, i.e., `Dance` has an order at most `5460`.

The exact numbers aside, we can apply `Dance` a bunch of times until we get back to the initial configuration `ab...p`. This will be our order `m`. To find the answer for part two, we simply need to compute `Dance^(1000000000%m)`. Without knowing the exact order, one can run `iterate` until you get back to the starting configuration and find the order. This is what my current code does.

In my case, `dance2` gave permutations `(f1, f2)` where `f1` had a cycle decomposition `1-3-3-9`, hence order `9` and `f2` had a cycle decomposition `7-9`, hence order `63`, so together `Dance` had order `63`, which means I only need to compute the `55`th power. The cycle decompositions where computed by hand knowing the value `final2`.

However, at first I confused `Dance` to be a thing permuting 16 things and assumed the order would be at most 140 and computed those powers (`pairs`, now commented out). But this was after trying to get `dance2` to work and that confused me because `dance2` outputs the images of permutations and not the permutations themselves, and I am so used to working with permutations that I was lost when I couldn't combine the two results of `dance2` to get the output of part one. At that point, I decided that it would be good to check until the 140th power and learn how bad the problem was, but that ended up giving me the answer to part two. It was only after solving both parts did I unravel my confusion with `dance2`. I had lots of fun thinking about this problem..