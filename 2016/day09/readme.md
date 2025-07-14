Day 09 - Explosives in Cyberspace

This seemed at first a daunting task, but it wasn't too bad. We are given a list of compressed codes of the form
```
A(1x5)BC
(3x3)XYZ
A(2x2)BCD(2x2)EFG
(6x1)(1x3)A
X(8x2)(3x3)ABCY
```
The pairs `(axb)` tells that we need to take the `a` characters after `)` and repeat them `b` times, and if those `a` characters contain some parentheses, we can leave them as they are. We then jump the cursor to _after_ those `a` characters and continue with the decompression.

So, `(6x1)(1x3)A` becomes `(1x3)A` (6 characters repeated once) and that's the end of it, because the cursor is now just after the `A`. Similarly, `X(8x2)(3x3)ABCY` decompresses to `X(3x3)ABC(3x3)ABCY`.

Our first task is to decompress all our codes and figure out the total length. I used regex to take the compressed code and split it into three parts: before the marker, the marker, and after the marker.

Rather than repeat the code `x` times, I make note of the code as a pair `(x, code)`. This is memoization that I learnt from doing the 2024 Advent of Code.

My `decompress` function takes the code and splits it into three parts. The `pre` part is repeated once, then I `take` however many characters I need from the `post` part and make note of the repetitions, and I `drop` those many characters from the `post` part and recurse. Taking the length is an easy matter after that.

The second part asks us to decompress further. So, `X(8x2)(3x3)ABCY` first decompresses to `X(3x3)ABC(3x3)ABCY` which then decompresses to `XABCABCABCABCABCABCY`. Something like `(27x12)(20x12)(13x14)(7x10)(1x12)A` decompresses to the letter `A` repeated `241920` times.

This is where memoization shines. I wrote a `decompress2` function to handle secondary decompressions - because I'm keeping track of the number of repetitions, I simply need to multiply stuff. Then I wrote a `fully_decompressed` function that applies an `iterate` and then clumsily searches for the first duplicate. It works fast enough and I'm ok with the clumsiness. Taking the length is again a simple matter. This was a good challenge.