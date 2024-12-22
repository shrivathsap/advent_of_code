import Data.Bits (xor)
import System.IO
import qualified Data.Map as Map
import Data.List
get_next num = 
    let
        first = (num `xor` (num*64))`mod` (2^24)
        second = (first `xor` (first`div`32))`mod` (2^24)
        third = (second `xor` (second*2048)) `mod` (2^24)
    in
        third

remove_dups list_of_pairs =
    if length list_of_pairs == 1 then list_of_pairs
    else
        let
            first = head list_of_pairs
            rest = [(x, y)|(x, y)<-list_of_pairs, x/=fst(first)]
        in
            [first]++(remove_dups rest)


changes digits =
    let
        diffs = [digits!!i-digits!!(i-1)| i<- [1..length digits]]
        temp = [((diffs!!i, diffs!!(i+1), diffs!!(i+2), diffs!!(i+3)), digits!!(i+4)) | i<-[0..length diffs-5]]
    in
        remove_dups temp

last_digits num = [x`mod`10|x<-(take 2000 (iterate get_next num))]

part_one nums = sum [(iterate get_next x)!!2000|x<-nums]

part_two nums =
    let
        g dict (a, b) =  Map.insertWith (+) a b dict
        f change_dict n = foldl g change_dict (changes (last_digits n))
        all_changes = foldl f Map.empty nums
    in
        (maximumBy (\x y->compare (snd x) (snd y)) (Map.toList all_changes))

main = do
    handle <- openFile "day22.txt" ReadMode
    contents <- hGetContents handle
    let
        nums::[Int]
        nums = [(read::String->Int) x|x<- lines contents]
    print(part_one nums)
    print(part_two nums)