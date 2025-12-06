Day 06 - Trash Compactor

This was a neat little puzzle. Our input looks like
```
123 328  51 64 
 45 64  387 23 
  6 98  215 314
*   +   *   +  
```
a column of numbers followed by an operation. For the first part, we are to do the computation each column dictates and add up the results, so for the example above we get
- `123*45*6`
- `328+64+98`
- `51*387*215`
- `64+23+314`
and we add up the results.

For part two, we are to read the numbers along the columns instead of as rows, so the actual computations should be
- `1*24*356`
- `369+248+8`
- `32*581*175`
- `623+431+4`

Well, technically, I should also read these from right to left, so the order of the summands and products is going to be reversed, but that doesn't matter because both `+, *` are commutative.

The difficulty is with parsing. For part one, I used `transpose $ words` to transpose the input, then `calc` is very simple. For the second part, the way the numbers are written is important, I cannot `transpose` the list of numbers because the spacing matters. In Haskell, `transpose` works even if the list of lists is not rectangular: it simply takes the first of each element, then the second and so on. For example,
```
transpose [[1,2],[3,4,5]] = [[1,3],[2,4],[5]]
```
However, transposing the first column in the example above, would give `146*25*3` which is not what we want. To solve this, I started by "salting" the input by adding a `.` wherever there was an important space. This way the first column would become
```
123
.45
..6
*
```
I do this for my entire input, then `transpose $ words` to get `["123", ".45", "..6", "*"]` and then transpose the list of numbers to get `["1..", "24.", "356"]` and finally `unsalt` these strings to remove the `.` characters before converting to `Int` and doing the required calculation. This was pretty fun.