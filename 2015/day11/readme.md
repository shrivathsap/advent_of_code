Day 11 - Corporate Policy

It might have been possible to do this by hand. We have an 8 letter starting password and we need to "increment" it by 1 until
- the password has an ascending sequence of three letters: `abc, bcd, ..., xyz`
- the password has no `i, o, l`
- the password has at least two non overlapping sequence of doubles: `aa, bb, ..., zz`

The hardest of these was to implement the `increment` function. I take a list, convert it into base 26 by using `ord x - ord 'a'` where `ord` is the letter to ASCII map. Then I convert that to a number and add `1`. After that, I convert it back to base 26 by repeatedly taking `mod` and `div` with `26`. But the result need not be 8 "bits" long now, so I take the last 8 bits and pad with zeroes if needed. Then I convert it back to letters with `chr (x+ord 'a')`.

The checks are simple, but may be not very efficient. I could have incremented more intelligently: I can directly increment from `aidf` password to `ajaa`, but my current code goes through `aidg, aidh, aidi,..., aieg, aieh,..., aizz` and then to `ajaa`. That is, I can increment by a step that looks like `26^2-?` but I don't feel like figuring out the `?`.