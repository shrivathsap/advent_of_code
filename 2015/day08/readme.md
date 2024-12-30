Day 8 - Matchsticks

This was confusing. The input is a bunch of strings of the form `"\x27", "asd\x43gfg\\sfds\"sda"` etc. There are three kinds of escape characters: `\", \\, \x`. The given input is how you would enter the string into a programming language if you wanted to have those characters in the string, i.e., with escape characters. The first part asks how many extra characters are there in the string like this compared to how many character the computer sees (the computer will ignore the escaping backslashes and convert the hex code to a single character). The second part asks how many characters you would need to add to store `\x27` etc, i.e., including the escape characters and all.

The issue is that when Haskell (or any programming language) reads the lines form a `.txt` file, it adds its own escape characters to escape the escape characters, and that makes everything very confusing (at least to me).

I wrote two functions `parsed` and `unparsed` that manipulate these strings (seen as an array of `Char`), and then I take the lenght. Except, there's going to be an offset of `2` because of the surrounding quote marks. When I parse them, I will be including two extra backslashes and when I unparse them I will be not including two extra quote marks.