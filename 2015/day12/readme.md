Day 12 - JSAbacusFramework.io

This was hard because I didn't use a JSON parser. So there's a massive JSON file with properties that could be a string, an array or a furthoer JSON dictionary (I'm going to call it a dictionary, and an `object` as in the puzzle text).

Part one asks to find all numeric values and sum them (there are positive and negative numbers). This was trivial with regex:

```
map (read::String->Int) (getAllTextMatches (long_line=~"[0-9]+|-[0-9]+")::[String])
```
Here `long_line` is my input wihch happens to be a really long line because that's what the input `.txt` file is. Then I find all matches with `[0-9]+|-[0-9]+`. This regex code looks for substrings that use multiple (`+`) characters from `0-9`, or (`|`) substrings that are of the form `-[0-9]+`. Then I convert the type from `String` to `Int` and then sum it up.

The second part asks us to ignore all dictionaries where at least one key has `"red"` as its value. This was hard without JSON, but I managed to do it with a little bit of help (Python with the json library) for debugging.

At first I thought of the regext code `{[^}]+}`. This looks for strings starting with `{`, followed by many characters that are not `}` (the `^` means "not") and then followed by `}`, i.e., it captures from an open brace till the first closing brace. But this obviously isn't what I want.

Then I thought of `{[^}^{]+}` which is similar but ignores all nested dictionaries. Again, not what I want. At this stage (and after some searching), I understood that regex is not the tool to use.

So, I want to find all possible proper substrings that are enclosed in braces (by proper, I mean it should have the same number of `{` as `}`). To do this, take the string, convert `{` to `1` and `}` to `-1` and every other character to zero and check if the sum is zero or not. If it is zero, then the substring is balanced, if not then not.

Initially, I tried to take the first `n` characters where I have a balanced substring, and then recursing on the rest of the string. But this fails because the first time I have a balanced substring could still have nested dictionaries: `{"a":{"b":"red", "c":"green"}, "d":124}` has a nested dictionary, but I would be ignoring the inner dictionary.

Then I thought of taking all pairs of `{, }` and checking if the string in between was balanced. Taking all possible pairs is expensive, so I had to recurse.

I would take one such balanced pair with index, say 6, 16, i.e., position 6 has `{` and position 16 has `}` and in between things are balanced (but could still be nested). So, I add positions 6 through 16 to my list and break my string into three parts: everything up to position 6, everything beyond position 16 and everything strictly between position 6, 16 and then find the balanced pairs on these three parts.

I don't think I need to look at the "up to position 6" part but it doesn't matter. It's important to go between 6 and 16 because I could have a string that looks like
```
{"a":{"a":"red", "b":6}, "b":5}
```
where I want to avoid the inner dictionary in my total sum, but I want to keep the outer dictionary.

This recursive approach ran much faster because I wasn't going to compare the open braces within a balanced string with closed braces outside.

Once I find the balanced strings, I check for two things:
- does it have `:"red"` as a substring?
- does this `:"red"` appear as a property of some object?

The first question is easy to answer with `isInfixOf`. For the second, I check whether everything up to the occurence of `:"red"` is balanced or not: if it is not balanced that means there is an open braces and so this `:"red"` is not a property of some object in the larger dictionary. But care has to be taken to `drop 1` from my balanced string as my balanced string starts with a `{` making everything unbalanced.

Having fixed that, my code should have given the correct answer...but it was giving a lower answer. That meant that I was somehow double counting something. The issue is this, say I was looking at the string
```
{"a":{"a":"red", "b":6}, "b":"red", "c":7}
```
In my list `red_objects` I would have this string and the substring `{"a":"red", "b":6}` because both are balanced and both have `"red"` as a property - which means that the `6` is being double counted.

So I wrote the `double_counted` function (which again makes use of `isInfixOf`) to check if something is double counted and I filter those that are. Now it works. This could have been a lot easier if I used a library capable of handling JSON, but I find Haskell packages difficult to use. I ended up learning a little about regex.