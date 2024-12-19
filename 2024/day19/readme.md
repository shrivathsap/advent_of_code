Day 19 - Linen Layout

This was fun. There are towels with labels like `brwrr` and there are basic patterns like `r, wr, b, g, bwu, rb, gb, br`. The first part asks which labels can be built out of the given patterns, and the second part asks the number of different ways to do so. So, `brwrr` is possible to be built out of the blocks above, and there are two ways to do so: `br+wr+r, b+r+wr+r`.

I first wrote a function `starts_with` that takes in a long string and a short string and tells if the long one starts with the short one. Then I wrote a function `is_possible` that takes in a string and all patterns and recurses to check if the string can be built out of the given patterns. That solves the first part and is fast (it is important to break out of the loop the moment you find a possible way to build the string).

For the second part, with low hopes of success, I tried bruteforcing. Unsurprisingly, that didn't finish. I analyzed first few steps of the bruteforcing and remembered [Day 11](https://github.com/shrivathsap/advent_of_code/tree/main/2024/day11) with the blinking pebbles thing.

There are going to be a lot of repetitions. For example, when considering `brwrr`, we may start by looking at `[br, b]`. In the next step, we would get `[brwr, br]` but this second `br` is redundant because we have already encountered `br` in the first step. Which means that we just remember to double the number of ways to get `brwrr` starting from the pattern `br` instead of having to compute all ways ot build `brwrr` by starting form `br`.

In Python, I made a dictionary and in Haskell, this is a `Data.Map` object. Ok, how do I go about it? First, it's important to sort things: say we are looking at `[br, b, brwr]` (and say `b, r, wr, rwr` are the basic patterns). Now, the middle `b` can give rise to `br` and to `brwr` say. But the first `br` can also give rise to `brwr`. If I were to go sequentially, then I'd update the "multiplication" factor for `brwr` to `2`(once for `brwr`, once for `br`). Then when I'm looking at `b`, I would increase the multiplication factor for `br` (to `2`, say), and increase the `brwr` factor to `3`.

But, because `br` actually has a multiplication factor of `2`, the factor for `brwr` should be `4`: once for `brwr`, twice for `br` (honest `br` and `b+r`) and once for `b` (`b+rwr`). This problem goes away if first sort the list, that way there are no "backwards updating".

In Python, I can sort a dictionary using
```
dict(sorted(next_.items(), key=lambda item: len(item[0])))
```
because there's no direct way to sort. In Haskell, I use
```
Map.fromList(sortBy (comparing (length.fst))(Map.toList next_count))
```

I make two passes through my dictionary, once to update the counts and again to get the next generation of strings. In Haskell, this was confusing because there are no `for` loops as far as I'm aware. Instead, I used `foldl` to loop through a list and accumulate things. A nested `for` loop would mean two layers of `foldl`s. I'm not too happy with these long lines, but this is what I have
```
f counts (string, pattern) = if ((string++pattern)`Map.member` counts) then Map.insertWith (+) (string++pattern) (fromJust(Map.lookup string counts)) counts else counts
g counts string = foldl f counts [(string, p)|p<-patterns]
updated_counts = foldl g current (Map.keys current)
h counts (string, pattern) = Map.insertWith (+) (string++pattern) (fromJust(Map.lookup string updated_counts)) counts
```
`f` says if I have a dictionary of counts, and a `(string, pattern)` pair, then if `string++pattern` is there in my dictionary, increase its count (i.e., if `b+r` is there in my list, increase the multiplication factor of `br`) and if it isn't there, do nothing. The `g` function is a `for` loop through all possible patterns.

The `updated_counts` updates counts by folding along `g`. Then I have the function `h`. This is there because it's not enough to simply take `(string++pattern, count_of_string)` pairs in the final answer, because `string++pattern` could be repeated, so I need to add their respective counts. The only way I know how to do this is via `insertWith (+)`, so that's why `h` is there. I then `foldl` along `h` starting with the empty list.

Then in the `update_possibilities` function, I sort everything before returning.

The `part_two` function takes a target string and possibilities and iterates `update_possibilities` until there's only one string to look at and that string is the target string. It's output looks like `(target, number of ways to get to target)`. The `part_two_total` function loops through all "good" target strings (obtained form part one) and adds up the number of ways to get them. Part one is very fast, part two takes about 40 seconds in Haskell, 5 seconds in Python.