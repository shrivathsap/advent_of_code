Day 10 - Balance Bots

I didn't like this much. I ended up doing the second part before the first. The setup is as follows: there are bots that behave independently and transfer microchips between themselves or to an output slot. A bot can transfer microchips only when it has two microchips, and in such a case, it has specific instructions on where to send the microchip with the lower label and where to send the one with the higher label. We are given instructions that look like
```
value 5 goes to bot 2
bot 2 gives low to bot 1 and high to bot 0
value 3 goes to bot 1
bot 1 gives low to output 1 and high to bot 0
bot 0 gives low to output 2 and high to output 0
value 2 goes to bot 2
```
We are to run all of these on a loop until we run out of instructions. This means that the instructions that start with "value" are evaluated first, and then the others are executed based on which bots have two microchips.

So, I first partitioned my instruction set into those that are for loading the bots and those that are for transfering microchips. I created two `Map` elements for the bots and outputs and loaded microchips into the bots using my `load` function. That was easy.

To handle the rest of the instructions, I wrote the `transfer_many` function which executes all valid instructions and returns those that haven't been executed. I can then `iterate` this function till there are no more instructions to be executed. To handle a single transfer, I wrote the `transfer` function - it is clumsy and convoluted but it does the job.

Since all the instructions have the same format, I know that the 5th position indicates whether the low value should go to an output slot or to a bot and the 10th position tells about the high value. Then using a bunch of `if-then-else` I handle the transfer together with `Map.insertWith` and `Map.delete`. The function returns a `(bot_list, output_list)` pair.

Executing `transfer_many` until we run out of instructions does part two. I forgot to work on part one! So, we are given two values and are to find which bot holds those two values. This was annoying because in Haskell it is hard to simply insert a `print` statement anywhere I want unlike in Python, say. If I could, then when doing a transfer, I could simply have checked the values and printed out the answer.

Instead, I wrote a `check_bots` function that looks at all bots that currently hold two microchips and whether any of them hold the values I want and returns a Boolean. After each application of `transfer_many` I `check` whether I have found the bot or not and that's part one.

Part two simply asks us to multiply the final values in output slots 0, 1 and 2 which was easy.