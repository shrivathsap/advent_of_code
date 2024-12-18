Day 17 - Chronospatial Computer

This was a delightful challenge. Given the time, one can do this by hand once you figure out what exactly to do. This is the first puzzle where I didn't bother to parse the input from a `.txt` file and simply pasted it into the code. As per the site's rules I have removed the input from the code...Let's look at the example
```
Register A: 729
Register B: 0
Register C: 0

Program: 0,1,5,4,3,0
```
There are certain programs to run for each number `0, 1, ..., 7` and these either alter the values (by some basic arithmetic manipulations) in the registers or add something to the output. The `Program` is a bunch of 3-bit numbers. There's an instruction pointer that starts out at position `0`, takes the next number as input for that program. In the above example, the `0`th position has the `0` (program which is `adv`) and takes in `1` as the input and alters the `A` register. Then the instruction pointer moves to position 2 which is program `5` above. This takes the next number `4` as input and does something to the output (which is a list of numbers). Then we move to position 4 which has the program `3` and takes in `0` as input. This program is special and sends the instruction pointer to wherever its input tells it to go (there's some processing done on the input before changing the instruction pointer).

The first part is very simple and asks to compute the output given an input like above. This doesn't require much serious thought.

In Python I made certian global variables and wrote the programs to edit those global variables and spit out the output. In Haskell I had to be more careful because there are no mutable variables, so I created a data type called `Comp` that had the program, the register values, the current instruction pointer and the output. Each program was written so that it takes in a `Comp` variable, does the changes and gives out a `Comp` variable.

I wrote a program called `step` which takes in a `(Comp, Bool)` pair and returns a `(Comp, Bool)` pair and the `Bool` is there just to know whether to halt or not (halting occurs when the instruction pointer goes beyond the length of the program). Then I iterate this function on the pair `(initial, True)` until the second coordinate becomes false and look at the output of what remains. Because `iterate` together with `takeWhile` gives a list, I had to use a `last` to get the last element (which is the state when the program finishes), then look at its `fst` to retrieve the `Comp` object from the `(Comp, Bool)` pair and look at the output.

The second part required a lot of thought and reverse engineering and I don't think there's a general solutions. So, someone else will have a different approach to it because their input is different. The second part was about finding an input value for the `A` register so that the output is the program we started with. See [Quine](https://en.wikipedia.org/wiki/Quine_(computing)).

At first, I tried to construct inverses of each of the functions involved. But this is not doable because there are a bunch of floor functions/truncations involved. Then I thought that may be I could keep a list of all possibilities (say, I know that upon flooring `A/8` I should get `20`, then I know that `A` should be one of `160, 161, ..., 167` etc.) but this still wasn't well defined.

The only way out is to carefully analyze what my particular program does and figure out from there. Here's a second example from the AOC website
```
Register A: 2024
Register B: 0
Register C: 0

Program: 0,3,5,4,3,0
```
If `A` register started out with `117440` (and `B, C` were still `0`) then this program would output `0,3,5,4,3,0`. I am not going to tell you what each of the "`opcode`" does, but the `0` code is the only one that actually changes `A`'s value, here it does `A->A//(2^3)`. And `5` is the only thing that adds to the output and `3` jumps the instruction pointer back to start (because position 6 is `0` and that's the input for code `3`).

It is very convenient to think in binary here. With each pass of the program, the last 3 bits of `A` are discarded (in our case, they go to the output).

In the input I recieved, the output was obtained as follows: suppose `A` is `b_n...b_2 b_1` where each `b_i` is 3-bits. Then a single pass of the program reduced `A` to `b_n...b_2` and added
```
b_1 xor 4 xor (last 3 bits of (drop b_1 xor 1 trailing bits of A))
```
For example, if `b_1 = 000` and `A` was `101001000`, then because `b_1 xor 1 = 001`, we will drop the last bit of `A` then take the last 3 bits which are `100`. The number `b_1 xor 4 xor 100 = 000` is `0` in decimal and this is added to the output (on the right). Now, `A` has lost `3` bits.

My program had `16` numbers, so that tells me that `A` should have `48` bits - brute force is out of the question, but I think brute force is the only option if we want to be able to generate an arbitrary output.

Well, that's that. I start with the empty string `""` and then loop through all possible `b_n` first, find solutions, add them to my string, then repeat. Of course, I need to go backwards, i.e., first make sure I get `0` as the output, then get `3` as the output and so on and this builds `A` as `b_n->b_nb_{n-1}->` etc.

Once I figured out what my "program" did, this backwards algorithm is doable by hand (of course, you still have to do `48*8` checks, but still doable). At this stage, we can forget about the "program" etc and it's more or less just string manipulation.

Handling the padding of zeroes in case there weren't enough digits in `A` to take from was a little tricky, but I got it alright. In Haskell, rather than using a whole lot of `reverses` (because there aren't in built splicing functions like in Python), I started with reversed everything (reversed target string, reversed `A` etc) and this caused some bugs because in Python it was the other way round.

I think the input was very kind with the jump instruction always being at the end and jumping to the beginning. If there were more than one jump instruction or if they happened somewhere in between, this would be a lot more difficult. With the jump being at the end I know that the program does one full pass before repeating, so the jump instruction can be "ignored" for the most part. I'm curious about how the inputs were generated, it seems everyone got similar looking inputs. All in all, a good puzzle!

