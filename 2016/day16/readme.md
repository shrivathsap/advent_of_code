Day 16 - Dragon Checksum

This was quite simple. The dragon curve for binary strings works as follows: take a binary string `s`. Reverse it and take a bitwise `not` to get a string `t`. Concatenate `s, '0', t`.

We start with an input `s` and iterate this process until our string has a length exceeding a certain disc size. Once that is achieved, take exactly as many characters as the disc size to get an output `o`. Now we compute the checksum.

To compute the checksum, take non-overlapping pairs of characters from `o` and perform a bitwise `and`. This halves the size of `o`. Repeat until the size of `o` is an odd number. That is our final answer. The difference between the two parts is with the disc size.

The dragon curve is computed quite quickly and I don't see any optimizations there. Computing the checksum takes time. First, I tried a recursive approach of iteratively computing the checksum. This was fine for the first part, but took forever for the second part (though, probably would have finished earlier than the second part of [Day 11](https://github.com/shrivathsap/advent_of_code/tree/main/2016/day11)).

So, I optimized the checksum function to compute the checksum in one go. The bitwise `and` operation is associative and commutative. If a string has length `2^n*m`, then there are going to be `n` applications of the checksum function. In the final result, the first character is going to be the bitwise `and` of the first `2^n` characters of the string, the second character is the bitwise `and` of the next `2^n` characters and so on, resulting in a final checksum that is `m` characters long.

Given a string that looks like `01101010`, because the bitwise `and` is also commutative, we can rearrange the characters to the form `11110000` where all the `1`s are at the start. Computing the bitwise `and` of these characters is now simply (this is an exercise for the reader) a matter of looking at the parity of the number of `0`s in the string: the bitwise `and` is `1` if it is even and `0` if it is odd. This is what my second checksum function does and it runs pretty quickly compared to the first one, but still takes just over a minute.