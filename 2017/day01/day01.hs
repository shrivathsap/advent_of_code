import System.IO
import Data.Char(digitToInt) 

parse::String->Int->Int
parse num_list shift = 
    let n = length num_list
    in sum $ map digitToInt [num_list!!i | i<-[0..n-1], (num_list!!i) == num_list!!((i+shift) `mod` n)]

main = do
    handle <- openFile "day01.txt" ReadMode
    contents <- hGetContents handle
    let
        string = (lines contents)!!0
        len = length string
    print(parse string 1)
    print(parse string (len`div`2))