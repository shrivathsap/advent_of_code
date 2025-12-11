Day 10 - Factory

Mathematically, this was a very simple problem. If I had used some external libraries to solve certain things, this would have continued to be simple, but I decided to implement my own code and made the problem that much frustrating for myself. However, I learnt a few things along the way and that's what I want out of this anyway. For part two, I decided to use Python because it's much easier to be careless about types and such with Python than with Haskell. It would probably have been a nightmare to deal with `Int, Frac, RealFrac` and so on and so in Haskell whereas in Python I can turn a blind eye to such issues. While I am aware of the importance of care with such matters (in fact, I'm sure I had a couple of overflow/underflow things happening in my Python code), for doing this the first time I don't want to worry about representation of numbers. More importantly, I can insert `print` statements willy nilly in Python to know what goes on compared with the mess it is in Haskell (`Debug.Trace` works, but is not good enough as Haskell's lazy evaluation changes the order of the print statements).

Our input looks like
```
[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
```
except there are close to 200 lines and many of the numbers within curly braces are 3 digits long. The things in the middle are to be interpreted as binary vectors where the numbers are indices of `1`s and the length is the length of the thing within `[]`. So, in the first line, we have
```[0001], [0101], [0010], [0011], [1010], [1100]```
where I've skipped the commas for easier reading.

The left side `[.##.]` characters indicate the state of lights we want (so the first and last are switched off, the middle two are on). For the first part, the vectors are buttons that toggle lights on or off - so the button `[0101]` means that it toggles the second and fourth lights. Starting with all lights switched off, we want to find the smallest number of button presses that give the desired light configurations. Pressing a button twice does nothing, so what I did was to look at all subsets of buttons, see which ones add up to the vector of lights and find the smallest possible number of button presses. A simple brute force that runs really fast because the maximum number of buttons in the input was less than 10. This part was super easy with brute force.

For the second part, we now want to find the smallest button presses that add up to the vector within curly braces. That is, for the first line, we want to find the smallest number of button presses such that if I add up the corresponding binary vectors I get the vector `[3,5,4,7]`. In this example, this number is 10: press (3) once, (1,3) three times, (2,3) three times, (0,2) once, and (0,1) twice.

I knew this was a linear algebra problem: we have a binary matrix `A` and want a vector `x` so that `Ax=b` where `b` is the vector within `{}`. The straightforward way to do this is to reduce `A` to a nice form called the [row echelon](https://en.wikipedia.org/wiki/Row_echelon_form) and find out the degrees of freedom and vary those to then find out a minimum. A slightly different but similar approach would be the [simplex algorithm](https://en.wikipedia.org/wiki/Simplex_algorithm) but this still proceeds via matrix manipulations and such. However, I didn't want to write up anything to do with matrix manipulations.

Instead, I thought of the [change making problem](https://en.wikipedia.org/wiki/Change-making_problem). For example, say you have coins `5,10,20,25` and want to make change for `40`. What is the least number of coins you need to do so? This is approachable by [dynamic programming](https://en.wikipedia.org/wiki/Dynamic_programming), which I've come to understand is a fancy way of saying "remember what you've already computed" and trades time for space (which makes things really fast). In our case, we have a bunch of vectors and we want to add them up to another vector, i..e, change making with vectors.

So, I coded this up because it felt easier than matrix manipulations and this was the first time I ever coded an algorithm for this problem. Note that the greedy algorithm doesn't work, in the example above, greediness gives `25+10+5` but the optimal solution is `20+20`.

But my problems had only begun. It took me a while to figure out how to program a top-down solution to this problem. Let's stick with the coin problem, the vector thing is the same except I have a `is_larger` function to check if I can subtract a vector from another and remain positive or not.

My `coin_solve` program takes as input the available coins, the target to reach and the known solutions. Then I do all possible subtractions from target (so, if my target was `19` above, then I would subtract `5,10` but not `20` or `25`). This gives me some sub-targets. I find the cost for these sub-targets, find the smallest and add `1`. For these sub-targets, I check if I already know the solution, if not I recurse. But the recursion output better return any new solutions that I compute so that I can reuse them in a different branch of recursion.

For example, `19` gives sub-targets `9,14`. May be I don't know the cost for both of these, so I'll start by solving for `9`. Along this path, I might end up computing the cost of `4`, say which I previously didn't know. I sould be able to pass this new knowledge onto the branch where I'm solving for `14`. This is why my `coin_solve` function returns both the cost and all the knowledge generated in the process. Then with `union` I am able to add that output to my current knowledge. A `foldr` folds along the sub-targets (updating my knowledge along the way), and that completes the `coin_solve` function. It took me a while to figure this out.

Then I translated this into vectors resulting in the function `solve2`. It worked great for the test input. Surely, it will spit out the answer for the actual input in no time? I couldn't be further from the truth. I let the program run for a few minutes and nothing happened. Then I tried to run it just for the first line in my input and even that never completed. The problem is that the increments are so small and we need to reach 3-digit numbers!

At this point, I decided to see what others had been up to on the [subreddit](https://www.reddit.com/r/adventofcode/). I saw that many people used [Z3](https://en.wikipedia.org/wiki/Z3_Theorem_Prover) or other such libraries that are built to handle such integer linear programming problems and more. I had heard of [SAT solvers](https://en.wikipedia.org/wiki/Boolean_satisfiability_problem) before, but I have never worked with them. There is a [Data.SBV](https://hackage.haskell.org/package/sbv) package for Haskell but I didn't feel like it.

What now? Well, the only thing I could think of was to finally code matrix manipulations. For reasons mentioned above, I did this with Python. Honestly, it's not too bad to code basic row swaps, row clearings and bringing matrices to row echelon forms. It was straightforward to code the reduced row echelon part too - just find the leading nonzero term, then scale and adjust other rows to clear out that column.

So we are on the same page, the problem now is `Ax=b` and I am reducing `A` to be nice. Row operations affect only `A, b` while column operations affect `A, x`. I didn't want to touch `x`, so I only used row operations. Doing this brings us to `A'x = b'` where `A'` has some columns which can be permuted to form the identity matrix. That is, `A' = [I|B]` up to column permutations. Say `A=[I|B], x = (v1,v2)`, then `Ax=b` gives `v1+Bv2 = b => v1 = b-Bv2`.

Of course, without column manipulations, I need to find out which entries form `v1` and which form `v2` and this is taken care of by the `free_cols` in the `solve` function ("free" meaning those entries can be anything).

To actually solve the problem, I then go through all possibilities for `v2` and check if `b-Bv2` is nonnegative and then minimize `sum(v2)+sum(b-Bv2)`.

To generate all possibilities for `v2` I wrote the `generate` function which initially took in a maximum bound, say `5` and generated all vectors like `[000],[001],...[554],[555]` assuming `v2` had length 3. But later, I got a little smarter with it. Say the first entry of `v2` corresponds to a free column that looked like `[0101]` in the original matrix (I've written the column vector as a row here), this means the first entry of `v2` affects the second and fourth numbers. If these numbers are `5,7`, then the corresponding entry in `v2` cannot be larger than `5 = min [5,7]` because that would cause the resulting sum to have something larger than `5` in the second position. So, I take the `min` over nonzero positions in the target vector to get a bound on that particular entry of `v2`. Doing this for every entry gives `bounds = [3,4,5]` say, then I `generate` vectors that look like `[ijk]` where `i` can be anything from `0` to `3` (inclusive), `j` from `0` to `4` and so on. This drastically reduced the time for some of the problems in my input (reducing the search space by orders of magnitude compared to naively using the global maximum).

This was it. I had done what I loathed to do and the answer was right around the corner. Exciting? Nope!

The first problem. Even though `b-Bv2` might have positive entries, they need not be integral, which means I can get an answer smaller than what I want by minimizing outside the integral region. What I needed to do was to check if `b-Bv2` was nonnegative and had integral entries. Still, the program ran and gave me a fractional answer about `8` shorted than my actual answer.

I thought of working with `int(x)==x`, but this is bad because the divisions in `reduced_row_echelon` can give things like `1.999999999999954` which is really `2` but written like this because of the specifics of the Python language.

Then I thought of `from fractions import Fraction` and dealing purely with fractional entries. For some reason, this never completed computations.

I then decided to use `round`. This worked, sort of. I first checked if rounding to 3 decimal digits then taking `int` was the same as rounding to the nearest integer. It was still short `2.5` from my actual answer. I looked at where the `0.5` was coming from (the `print` statements helped massively in this operation) and figured out that for one of my inputs, the numbers where like `8.5` and for such numbers, `int(round(8.5,3)) = 8 = round(8.5,0)`. Not good.

So, I added a `tolerance` level and now I check whether `int(round(x))` is within `tolerance` of `x`. This worked, but gave me an answer `1` more than my true answer. I should mention at this point that I "borrowed" someone's code (which used `scipy`) to figure out how off I was from my actual answer. When I realized that I was only `8` short, I knew where the issue was but needed to do more work to pinpoint it out.

Where was the error this time? Well, when I was checking for positivity of entries in `b-Bv2`, I simply asked whether `x>0`. This was wrong because in some cases `x` was a number like `-1.000e-16`, i.e., a vanishingly small negative number. This is again a quirk of Python. So, I decided to arbitrarily round to `4` decimal spaces before checking if it was negative and now my program finally works!

Once I had coded the row reduction functions, the hard part was in figuring out why the numericals didn't work out. Well, I learnt something - be very careful with computer computations and integer representations.

My code runs in about 50 seconds. But this problem has opened up a whole world of SAT solvers, Hilbert's 10th problem and so on, a rabbit hole I don't mind going down. This was a frustrating yet fun problem and I'm glad I decided to hack it out on my own.