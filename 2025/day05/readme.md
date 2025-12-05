Day 05 - Cafeteria

This was short and simple. Our input has two parts, the first part has a bunch of intervals and the second part is a bunch of numbers. For example,
```
3-5
10-14
16-20
12-18

1
5
8
11
17
32
```
For the first part, we need to find how many numbers in the second half are contained within at least one interval in the first half (the intervals are inclusive). So, in this example, `5, 11, 17` are included and the rest aren't.

The second part, as expected, requires some merging of the intervals. Specifically, we should merge the given intervals and figure out the total length. So, in the example above, the merger is `[3, 5] U [10, 20]` where `U` means a union. The total length is then `3+11 = 14` (note that the ends are included).

Parsing is simple and I have explained it a bunch of times now, so I won't get into it. Once parsed, part one is also very simple and it is simply a comparison. Part two is the interesting bit.

To merge intervals, I first sort it using `sortBy` based on the lower ends of the intervals. Given two intervals `[a, b], [c, d]` with `a<=c` there are only a few cases to look at. If `b<c` then the intervals are disjoint, so there is no merger. If `c<=b<d` then there is a merger and we get `[a, d]` as the final interval. And lastly, if `d<b` then there is no merger and we get `[a, b]` as the final interval. Recursing over the list solves the problem.