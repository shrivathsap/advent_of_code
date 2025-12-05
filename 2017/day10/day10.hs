import System.IO
import Data.Char (ord)
import Data.Bits (xor)

hex_digits :: [String]
hex_digits = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f"]

to_hex :: Int -> [Char]
to_hex num
    |q==0 = hex_digits!!r
    |otherwise = (to_hex q)++hex_digits!!r
    where
        q = num`div`16
        r = num`mod`16

parse :: [Char] -> [[Char]]
parse [] = []
parse (c:cs)
    |c==',' = parse cs
    |otherwise = [takeWhile (/=',') (c:cs)]++(parse $ dropWhile (/=',') (c:cs))

rot :: Int -> [a] -> [a]
rot x string = [string !! ((i+x)`mod`(length string)) | i<-[0..(length string-1)]]

hash :: ([Int], [Int], Int, Int) -> ([Int], [Int], Int, Int)
--lengths larger than size of nums should be ignored, but my input didn't have such lengths...
hash (nums, [], start, skip) = (nums, [], start, skip)
hash (nums, (l:ls), start, skip) =
    let
        recentred = rot (start) nums
        reversed = rot (-1*start) ((reverse $ take l recentred)++drop l recentred)
        new_start = (start+l+skip)`mod`(length nums)
    in
        hash(reversed, ls, new_start, skip+1)

hash2 :: (Eq t, Num t) => ([Int], [Int], Int, Int) -> t -> ([Int], [Int], Int, Int)
hash2 (nums, lengths, start, skip) 0 = (nums, lengths, start, skip)
hash2 (nums, lengths, start, skip) rounds =
    hash2 (a, lengths, c, d) (rounds-1)
    where (a, b, c, d) = hash(nums, lengths, start, skip)--output of hash has [] in second position

knot_hash :: [Char] -> [Char]
knot_hash string =
    let
        input = map ord string ++ [17, 31, 73, 47, 23]
        fst (a,b,c,d) = a
        permutation = fst $ (hash2 ([0..255], input, 0, 0) 64)
        f nums --nums is expected to be of length 16
            |(length nums==1) = nums!!0
            |otherwise = (head nums) `xor` (f $ tail nums)
        g nums --nums is expected to be of length 256
            |length nums==16 = [f nums]
            |otherwise = [f $ take 16 nums]++(g $ drop 16 nums)
        padded_hex num = if (length(to_hex num)==1) then "0"++(to_hex num) else to_hex num
    in
        concat $ map padded_hex $ g permutation

main = do
    handle <- openFile "day10.txt" ReadMode
    contents <- hGetContents handle
    let
        lengths = map (read::String->Int) $ parse (lines contents !! 0)
        fst (a,b,c,d) = a
    print(take 2 $ fst $ hash([0..255], lengths, 0, 0))
    print(knot_hash (lines contents !! 0))