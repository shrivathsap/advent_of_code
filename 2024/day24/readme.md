Day 24 - Crossed Wires

This was a really fun puzzle! There are some initial bits loaded into variables/bits `x00, x01, ..., x44, y00, y01, ..., y44`, something like `x00=1, x01=0, ..., y44=1`. Then there are instructions about other variables, something like `z00 = x00 XOR y00, pfw = tnz AND gwe, ggf = bne OR fda` etc. The bits labeled `z..` are the final bits and indicate a binary number `z44 z43...z00`.

The first part is to take the initial data, compute everything else and figure out what the `z..` number is in decimal. The hardest part here was parsing the input text file into a dictionary/mapping object. After that, I just update things until I run out of instructions.

The second part was really fun. It turns out that some of the labels have been swapped. The program was supposed to put the sum `x44...x00+y44...y00` into `z45..z00`, but it doesn't Fortunately, only 8 labels (i.e., 4 pairs) have been swapped, the goal is to find which ones (note that once swapped, those labels aren't swapped again).

How to approach this? The obvious first thought is to try all swaps. But there were 200+ labels. To brute force, you would need to try more than a quadrillion possibilities!

With care, we first find out which bits are wrong in the final output. To do so, I add `0+2^i` and `2^i+2^i` and check which bits fail. It turns out that the first place that fails is `0+2^8`.

Let's look closely at the 7th position (with `carry, a, b` being `0` or `1`):
```
9       8       7
.       .       carry
.       .       a
.       .       b     
```
where `carry` is everything that carried through from the previous positions while adding. What appears at position 7 in the final answer? The units place for `a+b` is `a XOR b`. This is true for every position. We then need to `XOR` this with the carry to get
```
7th bit = (carry) XOR (a XOR b)
```
except the last bit: if we were only adding 6 bit numbers, then `a, b` are zeros and we only have the carry which itself has some logic from the previous positions. But we can worry about the last bit later.

So, all bits except the last should involve `XOR` in their instructions. It turns out that `3` bits `z..` didn't involve this in my input.

Ok, what's the carry to position 8? The carry from `a, b` is `a AND b`. We will have a carry forward to position 8 if either `a AND b` is `1` or if the units have a carry, i.e., if `carry AND (a XOR b)` is `1`. Therefore,
```
carry on position 8 = (carry AND (a XOR b)) OR (a AND b)
```
It is an easy exercise to verify this. Note what happens if we were adding 7 bit numbers - this `OR` operation would be position 8.

Because I had my instructions in a dictionary, it was easy to look at which bit had the instruction:
```
(carry on position 8) XOR (x08 XOR y08)
```
That was my first swap. It turned out that the carry to position 9 and bit 8 were swapped.

After undoing this swap, I ran the check again, adding `0, 2^i` until an error. The next was at position 16 which wasn't a position where the `z16` didn't have an `XOR` instruction. Here, the error was that the units place `XOR` bit and the carry `AND` bit were swapped.

Undo that swap and repeat. The next two errors were similar to position 8 with a carry forward and result bit being swapped. That was the end of part two.

To figure out which bit was a carry bit and so on, I used pen and paper, but this was a very satisfying, fun puzzle. I only coded the first part in Haskell and I don't feel like coding the rest (a function to swap bits, a function to add two numbers based on the program - this second one involves converting the numbers to binary strings, and formatting it into the same shape as the input, i.e., saying `x00` should be `1, x01` should be `0` etc).