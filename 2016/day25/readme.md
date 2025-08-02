Day 25 - Clock Signal

And here we are, the last day of the 2016 Advent of Code. We are given another [assembunny code](https://adventofcode.com/2016/day/12) with no `tgl` instruction, but a new instruction `out` which, for my input, outputs the value in `register B`.

I didn't want to figure out how to do this on Haskell and it seemed simple enough to figure out what my assembunny instructions did, so I did it by hand. It's kind of cheating, but eh.

My instruction takes the value in `register A`, adds a certain amount (`365x7` for my input), then reads of the binary representation from the right end, and repeats that ad infinitum.

The goal is to find the smallest input so that the output stream looks like `0, 1, 0, 1, 0, 1, ...`. I wrote a quick, short Python script to find this value. Of course, I could have done that by hand as well. If I were to write a program for this, then I would use Python and discard those values that deviate from the `0, 1, 0, 1, ...` sequence until I end up in an infinite loop or something like that.

As with other events, there is no second part. I had loads of fun figuring stuff out. My favourite day was probably [Day 23](https://github.com/shrivathsap/advent_of_code/tree/main/2016/day23) and I learnt most from the hardest day which was [Day 11](https://github.com/shrivathsap/advent_of_code/tree/main/2016/day11). Most other days were relatively easy. [Day 24](https://github.com/shrivathsap/advent_of_code/tree/main/2016/day24) was fun too, with the travelling salesman problem. Anyway, I had fun and that's what matters.