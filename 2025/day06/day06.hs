import System.IO
import Data.List ( transpose )

calc :: [String] -> Int
calc list
    |last list == "+" = sum nums
    |otherwise = foldl (*) 1 nums
    where
        nums = map (read::String->Int) (init list)

salt :: [[Char]] -> [[Char]]
salt stream =
    let
        has_num i = any (/=' ') [x!!i | x<-(init stream)]
        f line idx
            |line!!idx==' ' = if has_num idx then '.' else ' '
            |otherwise = line!!idx
    in
        [[f line idx | idx<-[0..length line-1]] | line<-init stream]++[last stream]

calc2 :: [[Char]] -> Int
calc2 list
    |last list == "+" = sum nums
    |otherwise = foldl (*) 1 nums
    where
        unsalt string = [if x=='.' then ' ' else x | x<-string]
        nums = map (read::String->Int) $ map unsalt $ transpose (init list)

main = do
    input <- lines <$> readFile "day06.txt"
    let
        parsed = transpose [words x | x<-input]
        salted = transpose $ [words x | x<-salt input]
        part_one = sum $ map calc parsed
        part_two = sum $ map calc2 salted
    print(part_one)
    print(part_two)