Day 10 - Knot Hash

This was quite fun to code. Our input is a comma separated list of numbers like `3,4,1,5` and we have a hashing algorithm that works like this:
- Start with all numbers from 0 to 255, a pointer initialized to 0 and a skip amount also initialized to 0.
- Take the first number in the input, in this case `3`, and from the pointer, consider `3` numbers to the right, wrapping around if necessary.
- Reverse this chunk.
- Move the pointer ahead by the number plus the skip amount, again wrapping around if necessary.
- Increase the skip amount by 1.
- Continue until all numers in the input have been processed.

If we do this for `[0,1,2,3,4]` with the given input, we end up with the list `[3,4,2,1,0]` with the pointer set to position `4` and skip also at `4`.

For the first part, once we do the hash we should find the product of the first two numbers in the resulting permutation of `[0,1,...,255]`. In the example, we get `3*4 = 12`.

For the second part, instead of treating our input as a list of numbers, we should treat it as a string of characters (including the commas). Convert this string into the corresponding [ASCII](https://en.wikipedia.org/wiki/ASCII#Printable_characters) representation to get a list of numbers between 0 and 255, and append the numbers `17, 31, 73, 47, 23` (this is our "salt" for the knot hash).

The example input `3,4,1,5` becomes `51,44,52,44,49,44,53,17,31,73,47,23`and this will be our new list of numbers.

Perform the permutation algorithm from the first part 64 times to get some permutation of `[0,1,2,...,255]`. Then group this into chunks of 16 numbers, perform an `XOR` operation on each chunk to get 16 numbers between 0 and 255. Finally, represent these 16 numbers as a 32-bit hexadecimal string. This is the knot hash algorithm.

What did I do? The first part is parsing - a simple use of pattern matching and `takeWhile, dropWhile`. To actually perform the reversals, I opted the following strategy: given the pointer, rotate the list backward, then choose however many numbers I need to reverse, reverse those and rotate the string forward. Then increase the pointer and skip amounts. This is what the `hash` function does.

For the second part, I don't need to parse my input into integers, a simple `map ord` function gives me the ASCII representation of the input and then I can add the salt. I wrote a `hash2` function that basically does what `hash` does except it also keeps track of a `rounds` variable - my first `hash` function already gave the `start, skip` numbers as outputs, so I could pass those numbers as they were to the next round.

The last bit of the puzzle is in making chunks of 16 and `XOR`-ing them; this is done by the `f, g` sub-functions within the main `knot_hash` function. And a simple `to_hex` converts everything to hexadecimal.