import System.IO
import Data.List

parse :: [Char] -> [[Char]]
parse [] = []
parse (c:cs)
    |c==',' = parse cs
    |otherwise = [takeWhile (/=',') (c:cs)]++(parse $ dropWhile (/=',') (c:cs))

vec :: Num a => String -> [a]
vec "n" = [1,0]
vec "nw" = [0,1]
vec "sw" = [-1,1]
vec "s" = [-1,0]
vec "se" = [0,-1]
vec "ne" = [1,-1]

dist :: (Ord a, Num a) => (a, a) -> a
dist (a, b)
    |a*b<0 = max (abs a) (abs b)
    |otherwise = abs (a+b)

part_one :: [Char] -> [Int]
part_one stream = map sum $ transpose $ map vec $ parse stream

part_two (cur, steps, cur_max) =
    let
        dir = vec $ head steps
        next = [cur!!0+dir!!0, cur!!1+dir!!1]
        new_max = max cur_max (dist (next!!0, next!!1))
    in
        if steps == [] then (cur, steps, cur_max)
        else part_two (next, tail steps, new_max)

-- part_two stream = maximum $ map (\x-> dist (x!!0, x!!1)) [map sum $ transpose $ map vec $ take n parsed | n<-[1..len]]
--     where
--         parsed = parse stream
--         len = length parsed

main = do
    handle <- openFile "day11.txt" ReadMode
    contents <- hGetContents handle
    let
        input = lines contents !! 0
    print(part_one input)
    print(part_two ([0,0], parse input, 0))