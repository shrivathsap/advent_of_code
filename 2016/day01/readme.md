Day 01 - No Time for a Taxicab

It's been a while since I played with Haskell. This first task is as follows: we start at the origin facing North and are given a sequence of directions such as "R4, L34, R5" and so on. "R" means right, "L" means left and the number is the number of steps to take.

The first part is to follow the sequence and figure out how far from the origin we end up - measuring distance in the taxicab metric. I wrote an `updatePosition` function that takes in the current position and direction and updates it according to the steps to take. Using `foldl`, the first part was easy.

The second part is to figure out the first position we repeat. So, if the sequence is `R8, R4, R4, R8`, then we repeat `(4, 0)` first. At first, I only looked at the end points after completing the whole instruction, i.e., my list of positions would be `[(0, 0), (8, 0), (8, -4), (4, -4), (4, 4)]` which has no repetitions. Then I reread the prompt and made another attempt.

Admittedly, my solution is quite ugly. I wrote a `keepTrack` function that updates positions one step at a time using the previous `updatePosition` function. The problem is, it changes direction at each step, and my "turtle" ends up going in circles. To fix that, I had to make it move in the opposite direction for zero steps (this is the whole `opdir` part) - except when I only have to move one step in which case the direction should change and there should be no `opdir` business. Basically, it's a convoluted mess - one that I'm not going to clean up.

Also, I go through all instructions and then check for the first duplicate rather than checking at each step. This is also laziness - and my function to find the first duplicate crashes when there is no duplicate.

Anyway, it was a welcome distraction to think about.