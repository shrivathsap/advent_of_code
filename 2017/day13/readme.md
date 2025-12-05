Day 13 - Packet Scanners

There are walls at certain depths with scanners of certain range and it looks like this:
```
0   1   2   3   4   5   6
[S] [S] ... ... [S] ... [S]
[ ] [ ]         [ ]     [ ]
[ ]             [ ]     [ ]
                [ ]     [ ]
```
The input for this example would be
```
0: 3
1: 2
4: 4
6: 4
```
At time `0` all the scanners (`S`) are at the 0th position. Every picosecond they move down one step and once they reach the bottom of their range, they move back up until the 0th position and this cycle repeats. We are moving along the 0th positions.

For part one, every time we move into an `S` our "severity" increases by `d*r` where `d` is the depth or layer of the scanner and `r` is the range of that scanner. We take 1 picosecond to go from one layer to the next. Our task is to find the total severity. For part two, we have to find the shortest time to wait before starting our journey so that we avoid all scanners (this is not the same as having 0 severity - I got stuck on this point for part two).

The maths is quite simple: each scanner has a period of `2*(r-1)` and it takes us `delay+d` time to get there and we are caught by that scanner if `(delay+d) mod 2*(r-1) == 0`, and I think recognizing this is at the heart of this problem. So, in part one, we find all the scanners that catch us and find the severity, in part two I did the slow thing of increasing the `delay` by `1` until I was clear. The faster way would be to use (the opposite of) the [Chinese remainder theorem](https://en.wikipedia.org/wiki/Chinese_remainder_theorem) in a clever way to reduce the search space. This is good enough for me (and I like how short my current code is), although in `ghci` it takes about 33 seconds (~4 seconds after compiling).