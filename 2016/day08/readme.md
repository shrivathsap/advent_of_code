Day 08 - Two-Factor Authentication

I liked this. It's the first challenge for the year 2016 that involves 2D grid manipulations. We start with a grid that's 50 pixels wide and 6 pixels tall with all pixels turned off. There are three commands:

- `rect axb` turns on all pixels in the top left rectangle that is `a` pixels wide and `b` tall.
- `rotate row y=a by b` shifts the pixels in row `a` by `b` units while wrapping around.
- `rotate column x=a by b` rotates column `a` by `b` units downward.

First I created some global variables, although it wasn't really necessary. I also wrote a `transpose` function so that I wouldn't have to make two rotation functions. There is a `transpose` in `Data.List` but since I had already written one, I decided to use mine.

With some careful index tracking `rect` function was easily implemented. For `rot_row`, I had to read the height and width again because my grid might be transposed. Except for that, it is again a careful tracking of indices and modular arithmetic. `rot_col` was implemented by transposing the grid, then rotating the appropriate row and then transposing again.

Next came the part where I had to parse the instructions and figure out which transformation to apply. At first I was going to write out a function to extract the numbers in the instructions. Each instruction has two numbers. I simply used regex and grabbed one line of code from [2024 Day 14](https://github.com/shrivathsap/advent_of_code/tree/main/2024/day14).

Next, using `isInfixOf` from `Data.List`, I was able to figure out what the instruction said. Using `foldl`, I apply all the instructions one by one, and grabbing the `draw` function from [2024 Day 15](https://github.com/shrivathsap/advent_of_code/tree/main/2024/day15) I am able to draw out the grid.

Counting how many pixels are on was easy and gave the first part. For the second part, I just had to read from what my code drew on the screen. I tried to animate the moves on the ghci terminal, but it didn't quite work as intended and my `handle_mult` function breaks when it runs out of instructions.