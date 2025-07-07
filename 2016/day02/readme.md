Day 02 - Bathroom Security

This was easier than the previous one. So, there's a bathroom number code panel that looks like
``` 
1 2 3
4 5 6
7 8 9
```
and we are given a textfile with instructions on how to move. For example,
```
ULL
RRDDD
LURDL
UUUUD
```
We start at `5` and move according to these instructions. So, `ULL` means, we end up at `1` because we can't go to the left of `1`. Then, for the second line, we start at `1` and end up at `9`, and so on. The code becomes `1985`. Except, the instructions given to us are really long.

Using `min` and `max`, it's pretty simple to keep track of the borders. My `next` function takes a position (with `(0, 0)` being the top left corner) and a direction and gives the next position. Because there were only 5 lines of instructions, I manually handled the lines with `num1, num2, ..., num5`.

The second part changes the layout of the keypad to
```
    1
  2 3 4
5 6 7 8 9
  A B C
    D
```
This time, the borders are handled with 4 linear equations: `x+y=2, x-y=2, y-x=2, x+y=6`. My `next2` function works just like `next` except with these edge cases.

I wrote a `translate` and `translate2` function to translate from coordinates to the key presses. `translate` is a simple linear function, but `translate2` is manually handled. Pretty neat problem.