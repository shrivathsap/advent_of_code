Day 15 - Warehouse Woes

Woes indeed. This was a very nice problem but my code is terribly slow. This is also the first day where my Python and Haskell approaches are completely different and for good reason.

My Python code is long (300+lines!) but fast (takes about 16 seconds, though) whereas my Haskell code is about a third as long but runs at a snail's pace.

The problem is that there's a grid with a bunch of walls marked by `#`, a robot marked by `@`, bunch of empty spaces marked by `.` and a bunch of boxes marked by `O`. In the second part, these are replaced by `##, @., .., []` respectively. The robot moves according to some instructions and pushes the boxes in its way until it reaches walls. We have to compute the final configuration and some kind of a sum out of the final locations of the boxes.

In my first approach (Python), I made a function to move right and for the other directions, I transformed the grid, moved right and then undid the transformations. Not very efficient, but it works. For the second part, it's pretty much the same, except I now need two functions - one to go up and one to go right - because the transpose doesn't work.

This led to a lot of cases, but essentially to each box I am able to answer 1. whether it is pushed by the robot (through other boxes)? 2. can it move up? 3. does it actually move up?

I'm sure it's not very efficient. To answer 1. I recursively work downward until I reach the robot. To answer 2. I work upwards and check if there's space. 3. is tricky and I realized I needed it only while debugging:
```
..##
[][]
.[].
.@..
```
In this case, the top left box can move up and is pushed but doesn't actually move up because the other boxes are blocked. So, to check if this box does move up, I go down and check if those move up and so on. It's a mess.

In the end, I find out which boxes can move up etc. and based on that, I build a new grid by adding characters. Moving horizontally is much easier.

To move horizontally, I simply look at the present character, check if it can move right, whether there are empty spaces or walls etc. and move based on that information.

This is fine, works reasonably fast and gave the right answer.

Then comes the Haskell program. Here I decided to instead find in one go all the boxes that should move and move them at once. I have a `next_layer` function that takes the current "wave front" and updates it in the given direction. I then remove those positions that aren't boxes. I use `iterate` to apply this repeatedly and stop when it spits out `[]` which happens either when I reach a wall or if I reach all empty spaces.

In hindsight, I should have handled these two cases a little differently and my program might have run a little faster. The issue is that I need to apply it once more to get the "free spaces" where the wave front moves into.

At the moment I concatenate the results of the iteration, then look at the next layer and use `nub` to remove duplicates. Presumably, this is the place that's taking a lot of time.

There's also a `build` function that's there to generate the next grid and this might also be time consuming. Other than that, I don't know why the code takes so long. It could also be simply because I'm handling lists very poorly.

I finally learnt how to print to console in Haskell and to use `Debug.Trace`. Debugging in Haskell is painful because even though there's this way to print to the console it's not as neat as in Python. Debugging in Python was pretty fun, and even though I have a `draw` function in both codes, the one in Python was so much faster that I could afford to see the individual frames. I doubt I'd be able to finish the challenge in a single day had I tried to print each frame through Haskell (not to mention how awful it would be to even code that because the program doesn't run sequentially and you can't print "in between" steps...)

I'm not going to spend any more time on optimizing either code. At this point, I'm fine with knowing that both codes give the same output and one runs decently fast.