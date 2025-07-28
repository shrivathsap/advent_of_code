Day 12 - Leonardo's Monorail

This was much easier than [Day 11](https://github.com/shrivathsap/advent_of_code/tree/main/2016/day11) as far as the coding was concerned. It does, however, take a while to spit out the answer - especially for the second part.

This was reminiscent of some other problems from the 2015 and 2024 advents with computers following certain assembly code instructions. Here we have a computer with 4 registers and 4 possible instructions: `cpy` to copy the value of some register or an integer into some other register, `inc, dec` to increase or decrease the value of a register by 1, and `jnz` that jumps the instruction pointer by a certain amount if a certain other value is nonzero.

I made a data type called `Comp` to store the instructions, the instruction pointer and the registers. I might have been able to make my life easier using the `Data.Vector` package because at the moment the registers are stored as a list - with no fixed size.

It was easy enough to code the instructions. The `process` function parses the current instruction and generates the next state. `iterate` this function until the instruction pointer is larger than the number of instructions.