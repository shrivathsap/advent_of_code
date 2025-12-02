Day 02 - Gift Shop

This was a fun one. Our input is a bunch of ranges like `11-22,95-115,998-1012,1188511880-1188511890` (both ends included) and we are to find the sum of what I'll call rep numbers. These are numbers such as `121212, 123123` where some substring is repeated. In the first part we only care about numbers where there is only a double repetition, so `121212` doesn't count, in the second part we want all possible rep numbers.

Parsing the input was some work - I did some pattern matching with the commas, and then some more `takeWhile, dropWhile` things to handle the hyphens and a final `read::String->Int` to convert the string to an integer.

I wrote an `is_dub` function to check if a number is a double (I just noticed that I shortened double to dub). This works by simply taking the first half of the number and seeing if it is the same as the second half, `take, drop` are really useful here. The odd length strings are handled automatically, and `show` is useful to convert a number to its decimal representation. A few applications of `map` and `sum` handles the first part (I use `find_dubs` function to find all doubles in a given range).

For the second part, I need to first detect when a number is a rep number. One way would be to look at a starting substring, repeat it and check if I get the number. Instead, I opted to rotate my string and check if I get the number: `121212` rotated forwards by two steps is still `121212`. So, I first wrote a `rot` function that rotates my string.

Then I wrote an `is_rep` function that goes through all possible rotations and checks if there is any match. This replaces my `is_dub` function from part one and solves part two. But it took about 50 seconds to run (for part two alone).

So, instead of looking at all possible rotations, I only looked at those rotations which divide the length of the string. This got it down to about 37 seconds. Then I noticed that the largest possible number in my input had 10 digits, which means I can manually set the rotations to check on a case-by-case basis - that is, my rotations to check would be `[1]` for prime digit numbers, `[1,2,3]` for 6 digit numbers and so on. This brings it down to about 30 seconds, but now the solution is ugly, so I reverted back to the slightly slower solution. I wonder if there are ways to make this even faster.