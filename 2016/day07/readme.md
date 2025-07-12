Day 07 - Internet Protocol Version 7

This was fun. We are given a long list of IPv7 codes which look like
```
abba[mnop]qrst
abcd[bddb]xyyx
aaaa[qwer]tyui
ioxxoj[asdfgh]zxcvbn
```
The stuff outside square brackets are the supernet sequences and the stuff inside are the hypernet sequences. There could be more than one hypernet sequence.

An ip is said to support TLS (transport-layer snooping) if there's a 4-letter sequence that looks like `?!!?` in any of the supernet sequences but in none of the hypernet sequences. An ip is said to support SSL (super-secret listening) if there's a 3-letter sequence `?!?` in some supernet sequence with a corresponding `!?!` in any hypernet sequence.

The difficult part is in collecting the supernet and hypernet sequences. At first I tried using `splitOn` but it wasn't worth the trouble of importing `Data.Text` and figuring out the conversions from `String` to `Text` type and back (although I did do this for [2015 Day 07](https://github.com/shrivathsap/advent_of_code/tree/main/2015/day07)).

Instead, I simply recursed using `takeWhile` and `dropWhile` because the format of the ips were fixed. Some care had to be taken with taking the `tail` of an empty list, so I wrote a simple modified version `mtail`. For hypernet sequences, it's the same method with slight changes and it does give an empty hypernet sequence in the end, but that doesn't matter.

I then wrote the `has_tls` and `has_ssl` functions. For `has_tls`, I basically go through every possible starting point and check if there's a 4-letter sequence of the type `?!!?` and keep track of how many such sequences exist. The `has_ssl` function takes in two phrases to compare and does pretty much the same thing. Both functions are a bunch of comparisions chained together with logical ANDs.

So, I loop through the ips, figure out the supernet and hypernet sequences and then check if there's any tls or ssl and get a list of those ips and look at the length. That's all folks!