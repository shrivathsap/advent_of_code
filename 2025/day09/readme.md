Day 09 - Movie Theater

Oh boy, was this hard! This was the hardest one so far. We have a list of coordinates
```
7,1
11,1
11,7
9,7
9,5
2,5
2,3
7,3
```
where there are red tiles. Taking two of these red tiles gives us a rectangle (some rectangles are lines and that's ok). For part 1, we have to find the area of the largest such rectangle. This is trivial. I reused code from [Day 8](https://github.com/shrivathsap/advent_of_code/tree/main/2025/day08) for parsing, converting to vectors and forming pairs of coordinates. Then a simple brute force quickly solves part one - there are only about 500 points, so about 250000 many area calculations and then we find the maximum. I don't know if there are better ways to do this.

Part two is interesting. Notice that in the input two adjacent points have the same `x` or `y` coordinates. If we follow these coordinates, we get a polygon whose sides are all vertical or horizontal. This polygon [encloses](https://en.wikipedia.org/wiki/Jordan_curve_theorem) a region. We still want to choose opposite corners of the rectangle to be from the given input, but this time we also want the entire rectangle to be inside this region.

Here's the first observation: a point `(x, y)` is inside the region if any ray from `(x, y)` intersects an odd number of boundary lines of the polygon, except in the case when the ray lies along one of the line segments or passes through a vertex of the polygon:
- In case the ray lies along a line segment, then it doesn't make sense to ask how many times the ray intersects the polygon. I solved this problem by taking my rays to have slope 1 - all lines in the input are horizontal or vertical. That's the reason for the whole `(b-a)` part in my `is_in2` function.
- In case the ray passes through a vertex, there are two sub cases. Let the vertex be `p` and the two lines through `p` be `l1, l2`. Let `r` denote the ray.
    - If `r` passes between `l1, l2` (this is [transversality](https://en.wikipedia.org/wiki/Transversality)) then the two lines `l1, l2` should contribute a sum of `1` which means I should take the intersection number for `l1` and for `l2` (both of which are `1`) and subtract the double counting.
    - If `r` doesn't pass between them, then the count should be `0`.

One way of seeing why the count changes is to perturb the ray `r` slightly. In the transversal case, the intersection number is `1` because upon perturbation `r` intersects `l1` or `l2` but not both. In the non-transversal case, the count is `2` as `r` intersects both `l1, l2` or neither. Anyway, this is called the [ray casting](https://en.wikipedia.org/wiki/Point_in_polygon) technique.

Putting everything together, if I want to know if `(x, y)` is in the region, I first check if it is in any of the segments. If not, I count how many lines the ray with slope `1` intersects and subtract any transversal double counts.

How to represent the boundary of the polygon? Initially, I took every point in each segment determined by the input and put it in a giant list. This was inefficient. Later I simply kept track of the ends of each segment making up the polygon. So, in the example above, my boundary/loop/cycle would be represented as

```[((7, 1), (11, 1)), ((11, 1), (11, 7)), ((11, 7), (9, 7)), ...]```

But when it comes to checking whether a rectangle is contained inside the region, things are much more complication. The simplest thing to do is to ask if any line segment crosses an edge of the rectangle. More specifically, we ask whether it goes from the strict interior to the strict exterior. This is an easy check and done in the `rect_check` function and is pretty fast because it only needs to do at worst `4x500` many checks (4 for the sides of the rectangle, 500 for the input size). The tricky part is when one of the line segments only touches the boundary or if part of the boundary lies along the line segment. In this case, knowing only the line segment is insufficient information to tell if the rectangle is within the polygon or not. Some simple doodling should convince you of this.

The only solution I have is to then check every single point in the boundary of the rectangle (we don't need to check the inside of the rectangle). This is what the `valid2` function does and is what takes up most of the runtime. I did try to solve this problem within `rect_check` with a bunch of comparisons (all commented out now) but it didn't work even for the test input.

AS I mentioned above, initially I tried to keep track of the loop by looking at every point. This was accomplished by the `get_loop` function, which goes through each segment and concats the output of the `line` function. This is used only in `valid2` to get the boundary of rectangles (where I end up double counting the corners - something that should have been handled within `get_loop` but I didn't realize it then). The real loop is represented as above by only noting the end points.

`is_in` was the original function which used horizontal rays for the ray casting and is incomplete as it is right now - it doesn't really handle the case when the ray touches an edge (it also uses the `get_loop` output rather than the more efficient `get_loop2` output). This is improved upon with `is_in2` function. Then there's `valid` which was useless.

As for the `main` function, first I form all pairs. Then I sort them by the area (this also solves part one). First I filter out the obvious wrong rectangles using `rect_check`. This reduces the number of rectangles from `122760` to `1290`!. After this, I `dropWhile` those that are invalid using `valid2` until the first valid rectangle and because the list is sorted, this is a rectangle with maximal area for part two. In my case, it so happened that the very first rectangle is valid, but I still end up running `is_in2` about `213320` many times because that is the perimeter of the largest valid rectangle. However, after compiling with `ghc` this still runs in about 30 seconds. Before `rect_check` I did wait for 30 minutes (more than once) for an output that never arrived, so this is great improvement (I did do other stuff while the program was running :).

Having done all this, I quickly plotted what the polygon looks like using `matplotlib.pyplot`, have a look for yourself. Knowing the shape might make it easier to eliminate certain specific rectangles by hardcoding and simply rely on `rect_check`. All in all, this was hard and time consuming. Phew!