Day 23 - Safe Cracking

This was a fun problem. We return to the assembunny code from [Day 12](https://adventofcode.com/2016/day/12) with a new set of instructions. Along with the old commands, there is a new one called `tgl` which toggles instructions:
```
inc -> dec
dec -> inc
tgl -> inc
cpy -> jnz
jnz -> cpy
```
Part one is to read `register A` when the initial setup starts with `A:7, B:0, C:0, D:0` and part two is the same but with `A` set to `12`.

With some minor tweaks (for example, it's possible to encounter a `cpy` instruction that tries to copy a number into another), I modified my [Day 12](https://github.com/shrivathsap/advent_of_code/tree/main/2016/day12) code to be able to process the `tgl` instructions.

Part one ran relatively quickly but part two never completed. Now, the problem page gives a hint - it says that "rabbits multiply" - indicating that a careful analysis of the code is required.

I manually ran through the instructions. There are a few `jnz` instructions that create loops which have the effect of multiplying to numbers into `register A`. In my input, the `tgl` instruction appears once at position 17, followed by a `cpy` instruction and a `jnz` instruction which sends the pointer all the way to instruction 3, from where I have to repeat the entire thing.

Following it carefully, I figured out that the `tgl` instruction would end up toggling the future instructions an even distance apart, and eventually end up as an `inc` instruction after setting the first register to a factorial and the other registers to `0`.

So, I wrote a separate instruction file and modified the registers and set the instruction pointer to `17` (as we're counting from zero, this would be the instruction after the `tgl`). Then the program runs instantly.

The remaining 9 instructions don't do much except add `92x81` into `register A`, so my input ends up computing `a!+(92x81)`. It was fun to decipher what my program did.