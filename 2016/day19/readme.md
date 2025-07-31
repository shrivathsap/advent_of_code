Day 19 - An Elephant Named Joseph

I didn't like this much because it's mostly maths. This is related to the [Josephus problem](https://en.wikipedia.org/wiki/Josephus_problem) which is explained very neatly in this [Numberphile video](https://youtu.be/uCsD3ZGzMgE?si=MayTI23QGLw6R8cP).

Basically, there are elves in a circle and starting with the first elf, each elf steals the presents of the next elf and we skip over those elves that don't have any presents. Repeat this until there's only one elf left. The second part is a variation where instead of the next elf, they steal from the diametrically opposite elf - stealing from the nearer on in case there are two.

For the first part, my first approach was to remove one elf at a time. But my input is 7 digits long, so it would take that many operations. To speed things up, I removed all elves in even numbered positions taking care to move the last elf to the start in odd cases. This takes roughly `log(n)` many steps.

However, there's a much simpler way to do it as in the Numberphile video. If `n = 2^m+l`, then the last surviving elf is elf number `2*l+1`.

For the second part, no optimization comes to mind. If you simulate the naive algorithm you can spot a pattern and that's what I've done for the second part. Eh.