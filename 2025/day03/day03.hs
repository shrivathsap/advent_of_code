import System.IO

get_best :: [Char] -> Int
get_best string =
    let
        nums = [(read::String->Int) [x] | x<-string] --convert Char x to String by [x] so read works
        first = maximum $ init nums
        idx = head [i | i<-[0..length nums-1], nums!!i == first]
        second = maximum $ drop (idx+1) nums
    in
        10*first+second

get_best2 :: [Char] -> Int -> Int -> Int
get_best2 string len result=
    let
        nums = [(read::String->Int) [x] | x<-string]
        first = maximum $ take (length nums - len + 1) nums
        idx = head [i | i<-[0..length nums-1], nums!!i == first]
    in
        if len == 0 then result
        else get_best2 (drop (idx+1) string) (len-1) (10*result+first)

main = do
    handle <- openFile "day03.txt" ReadMode
    contents <- hGetContents handle
    let
        batteries = lines contents
        part_one = sum $ map get_best batteries
        part_two = sum $ map (\x-> get_best2 x 12 0) batteries
    print(part_one)
    print(part_two)