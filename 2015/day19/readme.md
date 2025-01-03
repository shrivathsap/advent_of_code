Day 19 - Medicine for Rudolph

This was kind of fun, but unfortunately my original solution doesn't work for all inputs.  This problem reminded me of 2024 [Day 11](https://github.com/shrivathsap/advent_of_code/tree/main/2024/day11) and [Day 17](https://github.com/shrivathsap/advent_of_code/tree/main/2024/day17) - which I did before 2015's AOC. Here's a sample input
```
e => H
e => O
H => HO
H => OH
O => HH

HOHOHO
```
The first block is all valid substitutions and the last line is a target string. Parsing wasn't too hard and I made a dictionary out of the substitution rules and for the sample it would look like `[(e, [H, O]), (H, [HO, OH]), (O, [HH])]`.

The first part asks how many distinct strings can be obtained from the given string once we do a single valid substitution. This was easy: find all occurences of an element, substitute and then use `concat, nub`.

The second part asks the shortest way to get to the given string from `e` using the substitution rules. This was hard. With little hope, I tried brute forcing and unsurprisingly it failed.

My next attempt (not in code) was to only look at those substitutions that matched the string from the left. This didn't really work, because I could start with say `HF` and from `H` I could go to `CRn` or `SiAl`. If my string started with `CRn` then I would focus on the first branch and completely ignore the second, but may be the `Si` can be substituted with exactly what I want.

Then I tried to greedily reverse substitute. This is what `reverse_engineer` does. Look at everything that can be reverse-substituted, choose the longest ones. Of these, choose the one whose replacement has the shortest length. For example, in my target string I may be able to replace `CaSiRn` and `CaCaCa` (both have length 6) but the predecessor for the first might be `H` and for the second might be `Ca`, so I'd prefer to replace the first.

I repeat this until my string becomes `e` and check how many steps it took. This worked for my input...but it doesn't always work. It's possible that greedily I arrive at a string where no reverse substitutions are possible.

After solving, I tried to find other inputs and found one on Reddit where the greedy algorithm fails. There are some interesting approaches on this [old thread](https://www.reddit.com/r/adventofcode/comments/3xflz8/day_19_solutions/). I have hacked together an function that looks at all possible reverse substitutions, but there are too many so I just look at the first 1000 after sorting by length. This approach takes a long time but works on the input where my greedy algorithm failed. I don't know what the best way to proceed is (the linked thread does have a lot of fast solutions). Some people have used certain parsing algorithms of which I have no idea about. I just got lucky that my greedy algorithm worked for my particular input and that's where I'll leave this problem. If ever I look back at these, may be I'll try again.

P.S. In the function `reverse_engineer`, it might also be useful to look at how many elements are replaced rather than just the length (the current code works like this, simply uncomment the lines to compare actual lengths): for example, it might be better to replace `HOHOHO` (6 elements) instead of `CaCaCa` (3 elements). But even this doesn't always work.