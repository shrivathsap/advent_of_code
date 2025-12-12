Day 11 - Plutonian Pebbles

This puzzle was a huge learning experience. I learnt about memoization and I learnt something about `Data.Map` in Haskell. The puzzle itself is quite simple to state: we start with some numbers. If the number is 0, then it becomes a 1, otherwise look at its length. If the length is even, split the number in the middle and ignore any leading zeroes, so `1000` becomes `10 0`. If the length  is odd, then multiply by 2024. Repeat.

An example that came with the puzzle: `125 17-> 253000 1 7->253 0 2024 14168` and so on. So, after two "blinks" (there's a story about how these are labels on Plutonian pebbles and how the stones change every time you blink), we have 4 numbers. The first part is about the number of numbers after 25 blinks and the second part is the same but after 75 blinks.

As usual, I solved it first with Python and then took my time with learning Haskell. I'll go over my Python solution first. For the first part, I just brute forced by keeping count of all the stones in a list and seeing how they change. Then just looked at the length of the list after 25 iterations. The process was fast, but my final list had around 200000 elements. That's a lot of numbers!

For the second part, I bluntly changed the 25 to a 75 and waited...and waited...and waited...and waited. My laptop would have run out of memory before the answer compiled! My part 2 answer has 15 digits...and 10^15 bits is 125000 gigabytes, but each number surely doesn't occupy one bit, so the actual space needed to store the final list would be a lot lot more than 125000GB!

This is when I started looking for hints. Memoization is one word that came up - cache your results so that the program doesn't have to compute the entire thing. But memoization isn't really what I wanted. I had a look at the 8th or so iteration and noted that a lot of the numbers repeat.

So, what was needed was a dictionary that kept track of the labels and how many times they appear and we simply add to the number of occurences rather than keep that many copies of the same label. It turns out that collapsing my list this way leads to a final list that has around 3000 elements - much more manageable.

In Haskell, before I knew about `Data.Map` I wrote a function that took in a list of tuples `(count, label)` and gave the new list. The issue was that to update the counts, I needed to traverse the list multiple times - once for each label - and add the counts. This was time consuming.

Then I learnt of `insertWith` which is a very useful tool here. It takes a `Map` object - which behaves more like a Python dictionary than the list of tuples I had earlier - and inserts a new "element" except if the element already exists, then it updates the value.

Consider the line `insertWith (+) "a" 3 fromList [("a", 1), ("b", 2)]`. First we have a list of tuples. The `fromList` thing converts this list into a `Map` object which is essentially a function that sends `"a"` to `1` and `"b"` to `2` and is not defined on anything else. Then I'm asking it to insert the "tuple" `("a", 3)` with the addition operation - because my function is already defined at `"a"`, it adds `3` to the existing value. If my function wasn't previously defined at `"a"` then it simply extends the definition of the function.

The way the Haskell functions work is that I start with a list of tuples. Then I use `foldl` to add elements of this list to the empty list. I use `iterate` to do this however many times I want - note that iterate gives an infinite list that is computed only when the program needs to, thanks to Haskell's lazy evaluation. Then I take the 25th or 75th element of this infinite list, use `elems` to get the values of the functions - this will be the number of occurences - and then sum them up.

The first time I used `fromList, toList` to convert between lists and mapping objects and this was expensive, but it did compute correctly. It took around 50-60 seconds for part 2. Then I came across `foldlWithKey` which lets me fold through a mapping object. The procedure is same as the first one, except thousands of conversions between list and mapping types are avoided and the program halts in a fraction of a second. Perfect!

The current Haskell file includes only the last version which runs very quickly. The one with lots of conversions between data types was only slightly different with a bunch of `fromLists, toLists` thrown in. This was fun.