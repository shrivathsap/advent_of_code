Day 22 - Grid Computing

This was a very interesting problem. So, there's a grid of nodes with some data stored and our input looks like
```
Filesystem            Size  Used  Avail  Use%
/dev/grid/node-x0-y0   10T    8T     2T   80%
/dev/grid/node-x0-y1   11T    6T     5T   54%
/dev/grid/node-x0-y2   32T   28T     4T   87%
/dev/grid/node-x1-y0    9T    7T     2T   77%
/dev/grid/node-x1-y1    8T    0T     8T    0%
/dev/grid/node-x1-y2   11T    7T     4T   63%
/dev/grid/node-x2-y0   10T    6T     4T   60%
/dev/grid/node-x2-y1    9T    8T     1T   88%
/dev/grid/node-x2-y2    9T    6T     3T   66%
```

A pair of nodes is viable if data can be moved from one to the other and the first part is about finding the number of viable pairs. This is a simple exercise in parsing and list comprehension.

For the second part, we are to move data from `(x_max, y_0)` to `(x_0, y_0)` where `max` is whatever the largest index of `x` is. There is a detailed description of how this is to be done in the [problem page](https://adventofcode.com/2016/day/22) (assuming you have unlocked part two), but briefly, the best way to do this is to draw out the grid to get a feel for the structure.

There is one node that doesn't have any data, there are some nodes that are so full that their data cannot be moved around (for example, the `(x_0, y_2)` node above has 28T of data and it cannot be filled into any other node). Having drawn out my grid, I need to first move the blank node all the way to the bottom left (my grid is flipped, compared to the one in the problem page). Having done that, I need to then move it upwards and each step required me to move the blank space around the target data and then move the target data - a manoeuvre that takes 5 moves. In the end, part two is a simple counting question (and the simplest approach as indicated by the problem page).