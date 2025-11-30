Day 05 - A Maze of Twisty Trampolines, All Alike

This was a good puzzle. We are given a sequence of jump instructions, say `0, 3, 0, 1, -3` and we start at position/index `0`. Every time we jump, we have to increase the current jump instruction by `1` in part one, and in part two, we increase by `1` if the jump was less than `3`, otherwise we decrease by `1`. So, with this example (the one given in the [problem page](https://adventofcode.com/2017/day/5)), our sequence would change as follows
```
Instructions        Position
0, 3, 0, 1, -3      0           <-start
1, 3, 0, 1, -3      0
2, 3, 0, 1, -3      1
2, 4, 0, 1, -3      4
2, 4, 0, 1, -2      1
2, 5, 0, 1, -2      5
```
and then we halt because we are out of bounds. It took 5 steps to get out of bounds. In part two, it takes 10 steps and we end with the instructions being `2, 3, 2, 3, -1`. Our task in both parts is to find the number of steps it takes to get out of bounds.

This is simple enough to answer: represent the instructions as a list, keep track of your position and modify the list as you move. This works, but the issue is that in part two it takes a lot of time.

Here's the first problem: because Haskell doesn't treat lists as mutable objects, every time I run my `modify_list` function, it creates a whole new list instead of modifying it in place. This makes it costly space-wise and it takes time to copy the entire list. With the same approach, my second part never completed.

To solve this, we can instead create a `Data.Map` object which I can edit in place without having to duplicate the entire `Map`. I don't fully understand how, but this has something to do with how `Map` is [implemented](https://hackage-content.haskell.org/package/containers-0.8/docs/Data-Map.html) using "size balanced trees". Also, according to the linked documentation, I could get better performance using `Data.IntMap.Lazy` but maybe some other time.

I represent the instruction list as a `Map` object: the example above would be the map `0->0, 1->3, 2->0, 3->1, 4->-3`. Using `Map.adjust` I can adjust particular values easily.

This should work, but there's another issue. So far, in all the Advent of Code challenges, I have only written the Haskell code and used `ghci` to run the file in my terminal without actually compiling anything. It turns out that the compiler does a bunch of optimization that isn't done with the interpreter. Running the current code with `ghci` produces a stackoverflow error. I learnt that I should perhaps compile and then run the resulting `.exe` file from [this thread](https://stackoverflow.com/q/47653454) where the poster had the same problem (small world!).

Compiling with `ghc` produces some linker files (I don't understand how any of this works) and a `.exe` file which takes about 7.5 seconds for part 1 and about 28 seconds for part 2 (I timed these manually). Someday I hope I'll understand compilers and such a little more.