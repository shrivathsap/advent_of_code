Day 19 - A Series of Tubes

This was surprisingly simple for day 19 and for how daunting the task looked. Our input looks like
```
     |          
     |  +--+    
     A  |  C    
 F---|----E|--+ 
     |  |  |  D 
     +B-+  +--+ 

```
and we start just above the input. We start with the `|` character on the first line, then follow it along. We change direction only at the corners indicated by `+`. As we move along this path, we encounter some letters in some order; part one is about finding these letters in the correct order. Part two is about how many steps we take until we stop.

I see the input as a grid whose entries are spaces or characters `|, -, +` or some letters. My `next_char` function steps through this grid. It takes in the grid, the current position `(x, y)`, the current direction `(dx, dy)`, the letters visited so far and a flag indicating whether we have reached the end of the path. For part two, I added another variable that counted the number of steps. I didn't bother checking the bounds and such because I figured I would always stay on the path until I reach a space somewhere within the grid.

The directions perpendicular to `(dx, dy)` are `(-dy, dx)` and `(dy, -dx)` and I choose the one that doesn't take me into a space. Directions only change when I am currently at a `+`. The `count` variable is increased only after taking a step, so I should start with it set to `0` initially.