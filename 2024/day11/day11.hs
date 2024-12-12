import Data.List
import qualified Data.Map as Map
import System.IO

blink_many :: Map.Map String Int -> String -> Int -> Map.Map String Int
blink_many scores label count = 
    if label == "0" then (Map.insertWith (+) "1" count scores)
    else
        let n = length label
        in
            if (n`mod` 2) == 0 then
                let
                    left = show((read::String->Int)(take (n`div`2) label))
                    right = show((read::String->Int)(drop (n`div`2) label))
                in
                    (Map.insertWith (+) right count (Map.insertWith (+) left count scores))
            else (Map.insertWith (+) (show (2024*read label)) count scores)
main = do
    handle <- openFile "day11.txt" ReadMode
    contents <- hGetContents handle
    let
        numbers = words contents
        initial = [(x, 1)|x<-numbers] --there are no repetitions; I don't want to write a whole thing to count
        final_stones = (iterate (Map.foldlWithKey blink_many Map.empty) (Map.fromList initial))!!75
    print(sum (Map.elems final_stones))
