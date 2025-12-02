import System.IO

parse :: [Char] -> [[Char]]
parse [] = []
parse (c:cs)
    |c==',' = parse cs
    |otherwise = [takeWhile (/=',') (c:cs)]++(parse $ dropWhile (/=',') (c:cs))

read_range :: [Char] -> [Int]
read_range range = map (read::String->Int) [takeWhile (/='-') range, tail $ dropWhile (/='-') range]

rot :: Int -> [a] -> [a]
rot x string = [string !! ((i+x)`mod`(length string)) | i<-[0..(length string-1)]]

is_dub :: Show p => p -> Bool
is_dub num =
    (take m snum == drop m snum)
    where
        snum = show num
        m = (length snum)`div`2

is_rep :: Show p => p -> Bool
is_rep num = 
    elem True [((rot x snum) == snum) | x<-[1..length snum-1], (length snum)`mod`x==0]
    where snum = show num --replace [1...length snum-1] with divisors(length snum) to make it slightly faster

find_dubs :: (Enum a, Show a) => (a, a) -> [a]
find_dubs (a, b) = [x | x<-[a..b], is_dub x] --gives all invalid IDs in a range

find_reps :: (Enum a, Show a) => (a, a) -> [a]
find_reps (a, b) = [x | x<-[a..b], is_rep x]

part_one :: (Num a, Enum a, Show a) => [[a]] -> a
part_one ranges = sum $ map sum $ map find_dubs $ [(x!!0, x!!1) | x<-ranges] --double sum because find_dubs is a list of IDs

part_two :: (Num a, Enum a, Show a) => [[a]] -> a
part_two ranges = sum $ map sum $ map find_reps $ [(x!!0, x!!1) | x<-ranges]

main :: IO ()
main = do
    handle <- openFile "day02.txt" ReadMode
    contents <- hGetContents handle
    let
        input = lines contents !! 0
    print(part_one(map read_range $ parse input))
    print(part_two(map read_range $ parse input))        