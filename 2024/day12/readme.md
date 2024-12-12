Day 12 - Garden Groups

Eh, I don't like my solution for this one. So, there is a garden (a grid) with a bunch of different plants that are grouped into regions. The area of a region is the number of cells in that region, the perimeter is the number of edges of cells that face out of the region, the side of a region is the number of...sides. I'm not going to elaborate further.

The goal is to find `area*perimeter` for the first part and `area*sides` for the second part (or their sums over all the different regions). Finding the area is a piece of cake.

To find regions, I start with the entire grid, take the first position iterate it's neighbours with same labels until I reach a fixed point - which means that the region of the first position has been found. Add the region to a growing list of regions and remove all those positions from the starting grid. Repeat this until my grid is empty. This process is very quick in Python, but my implementation is slow in Haskell - I'm not going to improve it.

To find the perimeter of a region, I loop through the cell, look at its 4 neighbours and count how many are not in the region and add this up. This works great in both of my codes.

The hard part, and this required me to actually use a pen and paper to draw stuff out, is to count the number of sides. I have no idea what the best algorithm for this is. My code works as follows. I will explain the Haskell code, the Python code is similar, but some recursive element is built as a `for` loop.

Ok, so first I pick a corner. How do I know whether a cell is a corner or not? Look at it's neighbours and count how many are in the region. If there are 3 or 4, then its not a corner.

Suppose there are 2 neighbours. Then there are multiple cases and I've written some ugly long lines in my code to handle them. Basically, if the 2 neighbours are in the same line, then my cell is not a corner. If they are not in the same line, then it is a corner, except removing it might add 2 sides, remove 2 sides or have no change to the number of sides.

To figure that out, I have to look at the diagonal cells:
```
?X_
_XX
__?
```
If the cell in question is the central `X` and its neighbours are the two other `X`s, then I need to look at what the two `?`s are to figure out whether sides are added, subtracted or nothing happens. For a different shaped corner I will have to use the other diagonal. If both `?`s are filled, then upon removing the central `X, 2` sides are removed which means I'll have to add `2` to the answer I get by recursion. If only one `?` is filled, then nothing happens and if both are empty, then `2` sides are added upon the removal of the central `X`. Above, it doesn't matter whether the `_` are in the region or not (and we know that the ones to the left and belo of the central `X` are not because the central cell has only `2` neighbours).

Phew. Then we have the case where there is exactly one neighbour - which means the cell is a leaf node. In this case, we need to look at the corners of the `3x3` square next to the parent node:
```
?X?
_X_
___
```
Again, there are a bunch of cases depending on how many `?`s are in the region.

If there are no neighbours, then the cell is isolated, so removing it removes `4` sides.

All that's left is to remove the corners and keep track of the changes and recurse through to a final answer. There may be more efficient ways to do this. My Python code runs very fast, Haskell takes time figuring out all the regions but once that is done, it too runs fast. All the different cases were annoying to handle.
