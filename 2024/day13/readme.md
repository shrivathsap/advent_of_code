Day 13 - Claw Contraption

This was easy, just a linear alebra problem. Moreover, all of them were invertible matrices. I have a case to check whether a matrix is not invertible, but at the moment it does nothing.

The input consists of lines
```
Button A: X+94, Y+34
Button B: X+22, Y+67
Prize: X=8400, Y=5400

Button A: X+26, Y+66
Button B: X+67, Y+21
Prize: X=12748, Y=12176
```

I like the way I handled parsing of the input files in Haskell:
```machines = [take 3 (drop (4*i) all)|i<-[0..(length all - 1)`div`4]]```
to group things into threes and
```f string = (map (read::String->Int))(getAllTextMatches(string =~ "[0-9]+")::[String])```
to obtain numbers and convert them to integers.