Day 7 - Bridge Repair

The input has lines that look like `21037: 9 7 18 13` and the first goal is to figure out whether the first number can be computed from the rest using addition and multiplication with evaluation happening from the left side. Part two is similar, except concatenation is also allowed.

Brute forcing can be done with recursion, but I felt that it might be faster to "process from the last number". In the example above, I would first consider ``computes(21037, [9, 7, 18, 13])` in my code (both Haskell and Python have the same program) which would ask wheter `21037/13` and `21037-13` can be computed from `[9, 7, 18]` and so on.

At any stage if I don't have an integer or a negative number, then I immediately return False. This is fine because the input doesn't have negative numbers. To check for concatenation, I wrote a `deconcat` function which takes two inputs `a, b` and returns the string `-1` if `b` cannot be removed from `a` and returns (the string) `c` if `a` is the concatenation of `c` with `b`. There is the special case of when `a == b` and in this case, my function returns the empty string. This is implemented by first converting the integers to strings, then treating the strings as lists and doing some basic list manipulation. It might have been faster to deal with itegers and logarithms.

If `deconcat` ever returns an empty string then I know that the number can be "computed" from the list, if it returns `-1` then I know to halt the recursion. That's pretty much all there was to `compute`.

Division in Haskell is a bit weird and requires care about the typing, so I had to be careful with that unlike in Python.

In Python I also wrote two other functions - a plain recursion method that computes all possible outputs form a given list and checks if the target number is there in that list, and another that does almost the same thing, except excludes those combinations that are larger than the target number at each stage of the recursion.

I only wrote the fastest method of computing from the end in Haskell. In my Python file I wrote all three functions and compared how long they took. Processing from the end takes a fraction of a second, bruteforcing with the check of not exceeding the target number takes about 1.5-2 seconds and bruteforcing all possibilities takes around 16 seconds. All in all, this was fun.