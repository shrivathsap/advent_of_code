import System.IO
import Text.Regex.TDFA

get_marker :: RegexContext Regex source1 (String, String, String) => source1 -> (String, String, String)
get_marker code = (code =~ "\\([0-9]+x[0-9]+\\)")::(String, String, String)
    
get_nums :: RegexContext Regex source1 (AllTextMatches [] String) => source1 -> [Int]
get_nums marker = (map (read::String->Int))(getAllTextMatches(marker =~ "[0-9]+|-[0-9]+")::[String])

decompress :: [Char] -> [(Int, String)]
decompress code
    |marker=="" = [(1, code)]
    |otherwise = let
        chars = (get_nums marker)!!0
        reps = (get_nums marker)!!1
        in
            [(1, pre)]++[(reps, take chars post)]++(decompress (drop chars post))
    where
        (pre, marker, post) = get_marker code

decompress2 :: [(Int, [Char])] -> [(Int, String)]
decompress2 codes = [(fst x*fst y, snd y) | x<-codes, y<-decompress (snd x)]

fully_decompressed :: [Char] -> [(Int, [Char])]
fully_decompressed code =
    let
        all_decompressions = iterate decompress2 [(1, code)]
    in
        head [all_decompressions !! n | n<-[0..], (all_decompressions !! n) == (all_decompressions !! (n+1))]

get_length :: Foldable t => [(Int, t a)] -> Int
get_length pairs = sum ([fst x*(length (snd x)) | x<-pairs])
main = do
    handle <- openFile "day09.txt" ReadMode
    contents <- hGetContents handle
    print(sum (map get_length (map decompress (lines contents)))) --part one
    print(sum (map get_length (map fully_decompressed (lines contents)))) --part two
