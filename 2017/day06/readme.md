Day 06 - Memory Reallocation

Another simple problem. We are given a bunch of blocks with certain memory used: say `0, 2, 7, 0` - which means there are 2 blocks in bank 1, 7 blocks in bank 2 etc. We should reallocate these as follows: pick the bank with the most number of blocks - 7 in this case - clear it, and distribute it one-by-one in a cycle starting from the next position. As described in the [problem](https://adventofcode.com/2017/day/6):
```
0 2 7 0->2 4 1 2->3 1 2 3->0 2 3 4->1 3 4 1->2 4 1 2
```
Any time there is a tie, pick the bank with the lower index (for example, with `3,1,2,3` the first `3` is emptied and redistributed). Continue until we reach an a state we have already seen - there are finitely many ways to arrange these blocks so a repetition is bound to occur and then we are stuck in an infinite loop.

Part one asks how many redistributions occur before a repetition and part two asks what the length of the cycle is once repetition occurs. I am doing double work in my solution, but it's okay.

This time I used `Data.IntMap.Lazy` but it's not very different from `Data.Map` - perhaps if I were to use max/min stuff on the keys it would make a difference. This library is [implemented](https://hackage-content.haskell.org/package/containers-0.8/docs/Data-IntMap-Lazy.html) with something called "big-endian patricia trees".

I first wrote a `get_max_pos` function that finds the maximum block and to handle ties, I used the `head` function. My input list had 17 numbers, so efficiency with this retrieval isn't a concern.

There's an `increase` function that uses `IntMap.adjust` to increment a block and move the pointer one step forward. This also keeps track of a `count` variable to be later used to check if I have redistributed all the blocks or not. The `redistribute` function finds the blocks to be redistributed, then runs `increase` a number of times until it's time to find the next highest block.

For both parts, I made a list of `memory_states`, take the last one, run the `redistribute` function then check if the resulting state is already in the list or not. If it is in the list, I return the length of `memory_states` for the first part, find the index for the second part (and take a difference to get the cycle length). Because the length is taken before increasing the `memory_states` list, there's no off-by-one stuff going on. I could have combined both of these functions but as it is right now, the iterations are done twice but it is good enough.