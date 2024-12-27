Day 06 - Probably a Fire Hazard

`foldl` vs `foldl'` which one to use?

There's a `1000x1000`grid of lights and a bunch of instructions telling us to toggle/turn on/turn off lights within a rectangular patch. We need to compute how many lights are on in the end. In part two, there's a brightness element and "toggle" means increase brightness by 2, "turn on" means increase brightness by 1, and "turn off" means decrease brightness by 1, unless the brightness for that light is already 0.

At first, I created a `Map.map` object to hold the state as a Boolean and `foldl` through the list. But this took too long. Then, for the first part, I simply kept track of a `Set` of lights that were turned on and then found the size of this set. This was reasonably fast.

For the second part, the obvious thing to do was to have a `Map.Map (Int, Int) Int` object to have a brightness at each coordinate and use `Map.adjust` or `Map.insertWith` to modify the brightness levels. That should work and be reasonably fast. But I used `foldl` to loop through the instruction list and it caused stack overflows. I wrote a Python script just to make sure my idea was correct and to check if it failed so badly on Python (it didn't). Turns out `foldl` is lazy and `foldl'` is eager and does the operations before going to the next element in the list. With `foldl'` the code runs faster without any stack overflows. I also used `Debug.Trace` to see where I was along the instruction list, but Haskell being lazy used to output the command to the screen before it updated the brightness list.