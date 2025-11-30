Day 03 - Spiral Memory

This was much harder than the first two days of 2017. The difficulty is with translating from a spiral to a linear story. For the first part, take the following spiral
```
17  16  15  14  13
18   5   4   3  12
19   6   1   2  11
20   7   8   9  10
21  22  23---> ...
```
We are to find the taxicab distance from `1` to a given number. For example, `12` has a distance of 3 from `1` because we have to take 2 steps horizontally and 1 step vertically. `23` has a distance of 2 and so on.

One pattern in this spiral is that as we move diagonally in the South-East direction, we encounter all the odd squares: this is simply because each layer is a square with odd side length and the largest number appears in the SE corner.

So, given a number `num`, first find the largest odd square smaller than `num`, let this be `(2m+1)^2`. `num` lives in the next square which has side length `2m+3` and corners `(2m+1)^2+(2m+2), (2m+1)^2+2(2m+2), (2m+1)^2+3(2m+2), (2m+1)^2+4(2m+2)` of which tha last one is a square number. I look at how much `extra` I need to get from `(2m+1)^2` to `num`, and look at the reminder `r` when divided by `2m+1`. Simply geometry/arithmetic tells me exactly how much I need to add to `(m+1)` - where `(m+1)` is the distance to get from `1` to a side of the square in which `num` lives.

The first part is doable by hand. The big difficulty, for me at least, with these types of problems is off-by-one errors.

For the second part, instead of labelling by the index, we label the coordinates by the sum of neighbours already entered. This leads to a spiral like this
```
147  142  133  122   59
304    5    4    2   57
330   10    1    1   54
351   11   23   25   26
362  747  806--->   ...
```
Here's a more detailed explanation: start by entering `1` in the `(0, 0)` position. The next position is `(1, 0)` and of it's neighbours, only the `(0, 0)` position has an entry. Summing it up gives `1` as the value of `(1, 0)`. Continue this way. For example, when we reach the `(-1, -2)` position, which was previously `22`, we note that the filled-in neighbours have values `11, 23, 351, 362` and summing these gives a value of `747`.

Our task is to find the first number to be entered larger than our input: so if our input was `400`, then the answer is `747`.

My first thought was to get hold of two functions: one to translate a coordinate into it's label in the original spiral, and another to translate a number into it's coordinates (in the original spiral). The second function is easy: basically do the same thing as in the first part with the reminders and such, but instead of adding up the taxicab distances, you add coordinates. But I found it much trickier to convert a given coordinate into it's number. This function should behave like this `(0, 0)->1, (1, 0)->2, (1, 1)->3, (0, 1)->4, (-1, 1)->5,...`. You can may be find the lower right corner, then do delicate casework and such.

Assuming I had these two functions, my idea was to build the list: assuming I have all the values up to `n`, find the coordinates of `n` in the original spiral, find the neighbouring coordinates, translate those coordinates back to numbers, then add up those values.

But this does so much extra work. There is no need to convert coordinates into numbers in the original spiral! I can simply work with coordinates.

Here's how it works: knowing which direction the spiral spirals, given `(x, y)` I can find the next coordinate on the spiral; this is some linear equation analysis. I start with a list (a `Map.Map` object) of known values and figure out what the next coordinate to add is. I know the neighbours of `(x, y)` by adding or subtracting `1`. Then all I have to do is to add the known values. This is what the `build_list` function does.

Then I use `until` to iterate the `build_list` function until I cross the input. I keep track of the last value added for precisely this check. I also need to start with my initial list having both `(0, 0), (1, 0)` coordinates because I didn't handle the edge case for `(0, 0)` but it's alright. Neat but somewhat annoying puzzle.