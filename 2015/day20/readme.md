Day 20 - Infinite Elves and Infinite Houses

The logic is fairly simple. For the first part, find the smallest number whose sum of divisors exceeds the given input (well input divided by 10). For the second part, the input is slightly different (divide by 11 instead of 10), and instead of all divisors, use only those for which the quotient is less than 50, i.e., if my number was 200, then I'll ignore the divisors 1, 2 because 200/1, 200/2 are more than 50.

To compute the divisor sum fast, it's best to cache the results ahead of time. If my number is `n = (p^a)*m` where `p` is a prime not dividing `m`, then the divisor sum of `n` is `(1+p+...+p^a)*divisor_sum(m)`. I'm not going to explain why this is so, but you can look [here](https://en.wikipedia.org/wiki/Divisor_function#Formulas_at_prime_powers). With this, and caching, it's computed very quickly.

I did write a Python code first because my initial solution in Haskell was quite slow and I wanted to test it out in Python. While it is fast, my Haskell code still computes all divisors up to the target number instead of stopping at the first time the divisor sums exceed it (unlike in my Python code). I don't feel like optimizing it further.

For part two, we loop through the possible quotients which are in `[1, ..., 50]` and this happens in constant time.