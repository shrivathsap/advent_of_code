Day 08 - I Heard You Like Registers 

This is a puzzle where we modify registers! Having done these quite a few times, I've grown fond of these. Our input has instructions of the form
```
b inc 5 if a > 1
a inc 1 if b < 5
c dec -10 if a >= 1
c inc -20 if c == 10
```
where the `a, b, c` are register names. We are to infer all the register names from the given instructions. All registers are initialized with a value of `0` and we are to pass through the instructions. For part one, we should find the maximum value in the final state of all registers, for part two we should find the maximum value stored in any register at any point while evaluating the instructions.

There's not a significant jump in difficulty between the parts and part two only requires a small modification. First I parse the instructions: nothing elaborate, just read the lines and separate the words. Each instruction has 6 words and looks like `[reg, operation, number, "if", reg, compare, number]`. I made a `Data.Map` object that is initialized with `0` (so it takes `reg_name` and sends it to `0`). I used `Data.Map` because adjusting values is easy.

In my `modify` function, I have a triple `(registers, instructions, current_max)` as input (initially, this was a function with two inputs, I made it a triple for part two to keep track of the current maximum). I take the first instruction, make the appropriate modifications, then pass the new state, remaining instructions into the function. In part two, I also update the `current_max` variable. Pretty simple recursive solution, this was fun.