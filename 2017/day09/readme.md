Day 09 - Stream Processing

A puzzle based on finite state machines. Finite state machines are really cool.

We have a stream of symbols, say `{{<a!>},{<a!>},{<a!>},{<ab>}}`. Garbage segements are those within angle brackets and group segments are those within curly brackets, but there are more rules. The state switches as follows:
- if you are not in garbage and encounter a '{' then the group layer increases
- if you are not in garbage and encounter a '}' then the group layer decreases
- if you are not in garbage and encounter a '<' then you enter into garbage, so the garbage layer increases
- while in garbage, none of the symbols matter be they '{' or '}' or even '<', and so garbage doesn't have further layers (I didn't notice this last point at first and so allowed for deeper layers of garbage leading to wrong results)
- if you encounter a `!`, then the next symbol is skipped (even if the next symbol is a `!`). So, `!>` cannot close a garbage segment, but `!!>` can

Now that I have written it out in English, it's a simple matter to translate this into code. For part two, we should count the characters inside garbage segments. However, the opening `<` and closing `>` don't count, nor do any skipped characters, nor do any `!`. This again translates easily into code as it is simply a bunch of checks and increasing a counter, so I took my part one function and added another variable (`garbage_count`) to keep track of.

My first function `parse` is simply translating all of this logic into a whole bunch of `if-else` blocks and I don't really like it much. The code is simple enough: there are a bunch of variables to track various states and I move one character at a time. Having done the problem, I then remembered that Haskell has pattern matching. Using this, I rewrote `parse` as `parse2` and it is more compact, easy to read and simply looks good (of course, part of this is the shorter variable names).