Day 03 - Lobby

This was an easy, fun puzzle. We are given a list of numbers such as
```
987654321111111
811111111111119
234234234234278
818181911112111
```
The digits represent the "joltage" of the corresponding battery and we are to switch on a few batteries and look at the resulting joltage: if I switch on the second and fourth batteries in the first line, then I get a joltage of `86`.

For part one, we should switch on 2 batteries in each bank (the lines) and find the maximum joltage per bank and add them up. In the second part, we should switch 12 batteries on.

The logic is pretty simple and I'll explain it for the case of 3 batteries but it's the same no matter how many batteries. To select 3 digits, we'll start with the leading one. This digit cannot be among the last two as otherwise we can't select 3 digits. Say the line has `n` digits, then the first digit should be among the first `n-3+1` digits. Moreover, it better be the largest digit as anything smaller will give a smaller joltage. Furthermore, if there are many appearances of the largest digit, then we should choose the first appearance to maximize the joltage.

Say this happens in the 4th position. The second digit of our maximal joltage should come after position `4` but cannot be the last digit. Now the problem is smaller, I should find the maximal 2-digit joltage from a string after dropping the first 4 digits and I can solve this recursively. This was fun.