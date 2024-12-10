Day 9 - Disk Fragmenter

This was a head-scratcher. It took me a long while to figure out the optimal route. Basically, we are given a string, say `'123'` then this translates to a string `'0..111'`. What it means is that there are 6 blocks of memory, the first block is of size 1 and has a file with index 0, the second block is of size 2 but is free, the third block is of size 3 and has a file with index 1.

The first part is to move the bits on the right to the empty spaces on the left. So, `'0..111'` becomes `'0111..'`. In the second part we want to move entire files rather than bits. In this case, because the block of 1s can't fit in the block of dots, nothing moves and `'0..111'` is our end result. Then there's a check sum computation where we sum up the file indices multiplied by their positions.

First I brute-forced the first part on Python. It took a while, but not too long. Then came part 2. I couldn't figure out a neat way to brute force the movement of chunks. After some thought, I realized that a good way to compactly handle all the information is to create a data type called `block` that keeps track of `size, start, label, is_num` where `size` is the size of the block, `start` is the where the block starts, `label` is the file index and `is_num` is a boolean tracking whether the chunk is free memory or filled. So above, `111` would be represented as `block{size = 3, start = 3, label = '1', is_num = True}`.

The `is_num` flag is not really necessary because I can simply check whether the label is an integer or not. There are solutions that don't need the creating of this data type and all that jazz, but this is how I thought through the problem.

I would then convert the input string into a list of these blocks and then modify the blocks. The check sum computation is an easy thing to do because each block has its starting position and label.

In Python, to move files or bits, I start with an empty list and then add to it the appropriate blocks from the forward or reverse direction depending on whether my current position points to a filled or free space. There's some logic to it and when moving bits, I transferred as much as I could in hopes of shaving off some compute time. But other than that the two functions are very similar.

In Haskell, I cannot start with an empty list and add to it. Instead I had to do some recursion where the output is the final string. To handle the recursion, I take my list to look like `(b:bs)` and if `b` is a filled block, then send my function returns `(b:move_files bs)`, i.e., keep `b` as it is and modify the rest.

If `b` is free, then I `break` `bs` at the last place where certain conditions are met (this would be the last block that is filled and is smaller than `b` in case I want to move files). Then there's some rudimentary logic to handle the recursion after this breaking. Haskell's `break` tool was new for me and really handy for this task. Before coming across `break` I wrote a small bit of code which travelled through the list thrice, but now I only need to do so once (it wouldn't make much of a difference ordinarily, but with recursion there would be an extra 3^n or type factor...).

The Python code takes about 16 seconds to execute, the Haskell code is slightly better on the first part taking about 13 seconds, but worse on the second part somehow, taking about 50 seconds. Still, these times are much better than my initial attempts with brute-forcing for those did not even complete.

In both languages I wrote a `draw` function that draws out the strings of allocated memory such as the `0..111` above. That was fun.