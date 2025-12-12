Day 18 - Duet

The two parts are quite distinct. Our instructions look like
```
set a 1
add a 2
mul a a
mod a 5
snd a
set a 0
rcv a
jgz a -1
set a 1
jgz a -2
```
There are 5 registers (which I got to know by looking at the input; I could have coded this but it's unnecesssary work) `a, b, f, i, p` all set to 0 initially. `set, add, mul, mod, jgz` commands take in two inputs and except for `jgz` the first input is always a register.
- `set` sets the register to a value given by the second input which may be a number or a register.
- `add` increases the value of the register by the second value (if the second input is a register, use its value)
- `mul` multiplies
- `mod` takes the remainder
- `jgz` shifts the pointer by the value of the second input if the first value is positive, else the pointer moves up by one as usual

The instruction pointer moves ahead by 1 unless `jgz` is triggered. The commands `snd, rcv` take one input.
- `snd` sends out a value
- `rcv` behaves differently in the two parts

#### Part one
In part one, `snd` sends out a sound of a frequency dictated by its argument and `rcv` recovers the frequency of the last sound transmitted provided its input has a positive value. Our task is to find the first frequency recovered.

I wrote `process` to process what happens at a given pointer. Registers are stored as a `Data.Map` object and this allows me to easily apply the `set, add, mul, mod` operations. I kept a list of `sounds, recovered` of sent and recieved sounds.

To find the answer of part one, I `iterate` until `recovered` is no longer empty, then take `head` and find the value. This was the easy part.

#### Part two
Now there are two programs running simultaneously. I will call them `progA, progB`. These programs have their own pointers, registers, an outbox and an inbox. The registers are initialized to 0 as before, except the `p` register of `progB` is initialized to 1.
- `snd` sends a value to the inbox of the other program (and this is appended at the end)
- `rcv` now sets its register to the value of the first number in the inbox. If the inbox is empty, then the program is stuck at this instruction until it recieves something

So, I made a data type `Prog` that keeps track of all this information. I rewrote `process` as `process2` with the main modification being the `rcv` command. Instead of giving out a tuple like `process`, `process2` gives out a `Prog`.

A program can halt if either its pointer goes out of bounds or if it is on a `rcv` instruction with an empty inbox. This is easily handled by my `halt` function which checks if a program has halted. Note that `progA` might be stuck on an `rcv` instruction, but `progB` might eventually send some value. A [deadlock](https://en.wikipedia.org/wiki/Deadlock_(computer_science)) can occur only when both are stuck on `rcv` instructions or the pointers are out of bounds or a combination of these.

Now we come to the `duet` function. This is `process2` but it modifies both programs. There might be cleaner ways to write this, but this is the mess I've settled on. Most of the ugliness is in unwinding `Prog` into its components. `process2` doesn't update the inbox of the other program and this is what `duet` fixes. The definition of these functions are fairly straightforward as they are simply updating a bunch of variables, but its lengthy because there are 8 variables.

Finally, to get the answer for part two which asks how many times does `progB` send out a value, i.e., the length of `out progB`. So, I `iterate` the `duet` function until both programs halt (this is what the `dropWhile` does), then take `out progB` of the resulting state and find its length. The problem looked very intimidating at first, but the logic is pretty simple; the hard work is in keeping track of everything.