Day 21 - Scrambled Letters and Hash

This one was simple, but required so much tinkering because of a few mistakes while reusing snippets. We are given a set of instructions on how to scramble a password. The implementation is very simple and similar to some of the VM kind of situation in [Day 12](https://github.com/shrivathsap/advent_of_code/tree/main/2016/day12).

There are 6 types of instructions:
- swap two positions
- swap two letters
- move position X to position Y
- rotate the string left/right by a certain amount
- rotate the string to the right based on the index of a certain letter
- reverse the characters between two indices

I opted to use `Data.Sequence` as it is easier to manipulate `Sequence` than `List` in Haskell, especially with all the insertions and deletions. The 6 instructions were easy to code.

My first mistake was in parsing the input. I copy-pasted the "rotate left" code and forgot to change it to "rotate right"! Since all the individual instructions were right, I eventually resorted to manually going through the instructions until the 27th instruction (!) which was the first "rotate right" instruction.

Once I fixed that, the first part was done.

The second part was to do the reverse of the first part, i.e., to start from a scrambled password and obtain the password. All the instructions above are easy to invert - the swaps and reverses are already self-inverses, inverse of the move is simple too, and so are the "rotate left/right" inverses. The hard one is the rotation based on the index.

So, if a letter is at index `0`, then as per the instructions, we rotate right by 1. If it is at index `1`, then we rotate to the right by `3`, and so on. I manually inverted this function (the 7 lines of `rot`), and did the opposite rotation. It took me a while to figure this out (especially after being drained by manually following 27 lines of instructions!). Checked that my `unscramble` function works for my part one answer, and then part two was also done. Simple problem, easy to make mistakes.