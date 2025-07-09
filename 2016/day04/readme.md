Day 04 - Security Through Obscurity

This was a fun challenge. The hard part is to parse all the data. We are given a long list of codes that look like
```
aaaaa-bbb-z-y-x-123[abxyz]
a-b-c-d-e-f-g-h-987[abcde]
not-a-real-room-404[oarel]
totally-real-room-200[decoy]
```
where the first mess of letters is some kind of encrypted data, the number is a sector ID and the letters in the brackets form a checksum.

To evaluate the checksum, take the mess of letters, order them by frequency and take the first 5 letters - with any ties broken alphabetically. So, the first code has a valid checksum whereas the last one doesn't.

Part one involves figuring out which codes in our input have a valid checksum and adding up all the valid sector IDs. For this, I first used `isDigit` and `isLetter` to break the code into the first mess, the sector ID and the checksum. Then with `sort, sortBy, group, groupBy` I order the mess of letters so that the most frequent letters come first and ties are broken alphabetically. This gives me `["aaaaa", "bbb", "x", "y", "z"]` from the first code.

Then I used `concat` and `nub` to concatenate the output and remove duplicates. `take 5` out of that and compare with the checksum. Then I select those that have a valid checksum and add up the sector IDs to get the answer to part one.

For part two, we are to decrypt the first mess using Caesar cipher with the sector ID as the shift. This is simple using some basic modular arithmetic. Knowing that the first part is all lower case or hyphens, I ignore the hyphens and shift the letters. Once done, I used `isInfixOf` to figure out which decrypted code had the word "north" in it. That gave me the answer to part two.