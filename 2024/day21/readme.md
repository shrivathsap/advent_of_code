Day 21 - Keypad Conundrum

This was brutal. I spent pretty much the entire day on it. There are two keypads, one numpad and another arrow keys. We control with arrow keys a robot that controls with arrow keys a robot that controls with arrow keys...a robot that controls with arrow keys a robot that controls the numpad. We want to enter passcodes such as `029A`, but because of the layers in between our actual input will be a whole lot of arrow keys and `A`s (which are there to push the keys, whereas the arrows are only there to position the robotic arms).

The first part had only 3 layers, and I simply brute forced it pretty quickly by keeping track of all possible move sequences and looking at the one with minimal length.

I assumed that the second part would ask something about the number of valid move sequences (oh, the keypads are not rectangular, they have one corner missing), so in part one I kept track of all possible moves. If I want to go from `(x0, y0)` to `(x1, y1)` then the shortest ways involve `|x1-x0|` left-rights and `|y1-y0|` up-downs and this corresponds to looking at binary sequences and choosing `1`s to be left/right and `0`s to be up/down as needed.

But part 2 simply increased the number of layers to 25. The brute force is not going to cut it. I couldn't even increase to 4 layers with brute force!

The first reduction is to minimize the number of changes, i.e., too many turnings will only increase the number of moves required (compare `<<^` with `<^<`, you are making more trips in the second one). I implemented a function that checked how many changes were happening and made sure to keep it under `3` (because if I want to avoid the missing corner, that's three turns). But this was still too much.

Then I thought that instead of discarding those with too many turns, why not only generate those moves with few turns? So, instead of having all binary sequences with a given number of ones and zeroes, I only focused on those with at most 3 changes in levels. A little later I realized that only one change in level is always possible because if `<<<^^^` is not possible, then `^^^<<<` should be as only one corner is missing (this is just an example, the actual keypads aren't that large). Anyway, that was the first reduction.

But it was still taking too long. Then there's another insight. The arrow keypad is arranged like this:
```
 |^|A
<|v|>
```
All moves start from the `A`, so you want to stay away from `<` as much as possible. For this reason, the two paths from `A` to `v` are not the same, going `<v` is less expensive than `v<` because in the next layer, we would be doing `v<<A>A` vs `v<A<A` (`A` means "press that button") where it seems like `v<` is preferable, but in the third layer we have
```
v<A<AA>>^AvA against v<A<A>>^Av<<A>>^A
```
because in the first one, we are finishing both `<` in one go, whereas in the second one, we go to `<`, then to `A` and back to `<`.

I did this by hand (there are four cases to look at, they are in the code), but I also verified it against my part one answer just to be sure (i.e., preferring one over the other and seeing whether I get the same answer). There is some intuition to it though: you want to stay close to `A` and if at all you must go far, then finish everything go to the farthest button first without clicking anything in between because each click means a trip back to `A` in the next layer.

At first, I did this for both the numpad and arrow keypad, but later I realized it doesn't work the same for both but I had already wasted too much time. Once I did realize it, my line of attack was to do the first numpad layer like I did before and only optimize the subsequent layers.

But that still wasn't enough. My code was still taking too long. Now, I had noticed that all movements start from `A` because in the previous layer we have to press some keys. However, it was only after I tried some steps by hand that I figured out it was the same thing as the blinking pebbles from [Day 11](https://github.com/shrivathsap/advent_of_code/tree/main/2024/day11).

You see, I looked at some of the lengths of these strings and already by layer 4 they were 80000 characters long! Ok, a dictionary to hold the repetitions it was. I split the string using `.split('A')`, but guess what? This removes all appearances of `A`. Ok, so I wrote a couple lines to split strings the way I wanted: `<<AvAA` should become `[<<A, vA, A]`. That was fine.

Then I managed to write an `update_dict` function but it took me a second to figure out the exact new count (I have to multiply the old count with the new multiple and so on). Fine. That worked just as expected.

Now that I had removed repetitions, this should work, right? It worked properly on part one...but my answer for part two was just wrong. I couldn't figure out why.

I thought I had the preferences wrong, I changed them but my answer was just suspiciously low. I tried bruteforcing again now that I had something about the preferences but I couldn't brute force beyond 11 layers (the strings were getting too long).

On top of that, I tried something like brute force three layers and then use dictionary on the remaining 22 and so on. But I did these changes in different places and forget to undo them, so that was very annoying because my previous correct answers for part one were suddenly wrong!

After a lot of fudging about, I found the bug that was at the root cause of this wasted day. Well, there were two bugs.

The first is that when I split my string into this dictionary thing, I had to take into account that I would have solo `A` letters for which the optimal move is to stay at `A` and press the button. My original `key_sequence` function did not account for this, so was returning `[]` whenever I encountered a solo `A` and this was lowering the count a lot. That was a quick fix, just an `if..else` block.

The second more subtle bug was serious. The way I was returning paths, say for `>>^A` was that I would first start with the empty list `[]` and then add the path for `>`, which is `v` in the arrow keypad. Then I would attack `A` to this, and then move from `>` to the next key which is still `>`. Repeat.

But the way I was getting this path was by my `valid_moves` function which generates the empty path to move from `>` to `>` because we are already there. I then had this line
```
all_paths = [x+y for x in all_paths for y in valid_moves(cur, nex, board)]
```
where `cur` is the current position, `nex` is the next position. In Python, this returns the empty list when `valid_moves(...)` is empty! Which means that everything I had built up till then was disappearing - thus the suspiciously low lengths. This took so long to discover, sigh. The fix was adding
```
 if temp == []:
        return ['']
```
to my `valid_moves` function and finally it was done. Well, not yet. Because if you remember, I was randomly changing how many layers there were - first three bruteforced, then 21 via dictionaries and such. That was handled with something like `layers-4` and I forgot to remove that `4`, even though I had removed the bruteforcing. This was really frustrating because I couldn't figure out what I was still miscounting!

Very fun, but I spent way too much time on this.