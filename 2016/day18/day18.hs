import System.IO

next_char :: [Char] -> Int -> Bool
next_char line i
    |i==0 = (line!!0=='^' && line!!1=='^')||((line!!0/='^' && line!!1=='^'))
    |i==(length line-1) = (line!!(i-1)=='^' && line!!i/='^')||((line!!(i-1)=='^' && line!!i=='^'))
    |otherwise = (line!!(i-1)=='^' && line!!i/='^' && line!!(i+1)/='^')||
                 (line!!(i-1)=='^' && line!!i=='^' && line!!(i+1)/='^')||
                 (line!!(i-1)/='^' && line!!i/='^' && line!!(i+1)=='^')||
                 (line!!(i-1)/='^' && line!!i=='^' && line!!(i+1)=='^')

next :: [Char] -> [Char]
next line =
    let
        f True = '^'
        f False = '.'
    in
        (map (f.(next_char line)) [0..(length line)-1])

main = do
    handle <- openFile "day18.txt" ReadMode
    contents <- hGetContents handle
    let
        part_one = concat(take 40 (iterate next contents))
        part_two = concat(take 400000 (iterate next contents))
    print(length([x | x<-part_one, x=='.']))
    print(length([x | x<-part_two, x=='.'])) --takes a while, no idea how to optimize