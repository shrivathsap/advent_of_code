Day 25 - Let It Snow

And that concludes another AOC for me. This was an easy problem. We cover the grid by moving along the diagonal, which means each cell in the grid gets a position number (this is what the `cantor` function finds, see [Cantor's diagonal argument](https://en.wikipedia.org/wiki/Cantor's_diagonal_argument)). We have a number at the first cell and all other numbers are computed using a simple modular multiplication/exponentiation rule.

I tried using `take n $ iterate`, but it threw `stack overflow` errors (probably all that laziness), so I went ahead and wrote something quick in Python. Then in Haskell, I wrote a fast exponentiation function: to find `a^b` you can reduce the number of computations by finding `(a^2)^(b//2)` or `a*(a^2)^(b//2)` depending on whether `b` is even or odd; this reduces the number of exponentiations required greatly. This runs very fast.

---

Most of the problems were easy, but then again this was the first year. I suppose my favourites are [Day 7](https://github.com/shrivathsap/advent_of_code/tree/main/2015/day07) about the bit operations and finding out what happens eventually, although it was a little annoying to parse, [Day 14](https://github.com/shrivathsap/advent_of_code/tree/main/2015/day14) about the reindeer races was fun: each reindeer has some travel time and some rest time, and we need to find the leading reindeer after a number of seconds and in the second part we also had to keep track of a score function, [Day 18](https://github.com/shrivathsap/advent_of_code/tree/main/2015/day18) about Conway's game of life, and [Day 22](https://github.com/shrivathsap/advent_of_code/tree/main/2015/day22) about the battle between a wizard and an enemy.


[Day 12](https://github.com/shrivathsap/advent_of_code/tree/main/2015/day12) was hard but I learnt a little bit about regex. I suppose [Day 19](https://github.com/shrivathsap/advent_of_code/tree/main/2015/day19) and [Day 24](https://github.com/shrivathsap/advent_of_code/tree/main/2015/day24) are the ones I'm not really satisfied with because there are some deficiencies in the solutions, but it's fine. Well, that's that, I had fun.