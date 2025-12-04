Day 11 - Hex Ed

This was very fun to think about and easy to code. We are in a hexagonal grid with directions `n, nw, sw, s, se, ne`:
```
  \ n  /
nw +--+ ne
  /    \
-+      +-
  \    /
sw +--+ se
  / s  \
  ```
(copied from the [problem page](https://adventofcode.com/2017/day/11)). Our input is a bunch of steps to take starting from the centre: `n,ne,n,n,s,sw,se` etc. For part one, we should find the hexagonal taxicab distance of the final position and for part two, we should find the maximal distance that we stray away from the centre as we take the given sequence of steps. For example, if we had `se,sw,se,sw,sw` as our input, the final position is `3` steps away along `s,s,sw`.

Here's how I approached this: replace the tiles by their centres, this forms a [lattice](https://en.wikipedia.org/wiki/Lattice_(group)), specifically it is the lattice we get once we adjoin the sixth [root of unity](https://en.wikipedia.org/wiki/Root_of_unity) to the integers, followed by a clockwise quarter turn.

This lattice has a basis consisting of two elements `n, nw` which I represent by the vectors `[1,0], [0,1]`. One should think of these as complex numbers where `[1,0]` is `1` and `[0,1]` is a primitive sixth root (specifically, the one that makes 60 degrees with the positive x-axis). Every step is then one of these vectors and the final position is obtained by simply adding up these vectors.

I should also represent the other four directions in terms of these vectors: `sw = [-1,1], s = [-1,0], se = [0,-1], ne = [1,-1]`. Adding these up gives a vector `[a,b]`. Now, we need to find the analogue of the taxicab distance to `[a,b]`. If `a,b` are both positive or both negative, then this is simply `abs(a+b)`, however, if they have opposite signs, then something different happens. This is because `nw-n = sw`, i.e., two moves with this kind of sign parity can be replaced by one move in the appropriate direction. So, when `a, b` have opposite signs, we instead have a taxicab metric of `max |a| |b|` (I'll leave this as an exercise).

Now, coming to the code. I first parse my input, translate the directions into the vectors as above, then I took a transpose so that `sum` would sum up the `x, y`-coordinates. That concludes part one. For part two, a tracking variable `cur_max` is handy. I did write a "one-line" code (now commented out) for part two, but it takes longer because to compute the `n+1`st position, it recomputes the `n`th position as well. After completing this, I learnt of `scanl` which would have been useful for part two.