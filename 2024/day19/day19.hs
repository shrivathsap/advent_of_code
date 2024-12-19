import System.IO
import Data.Map (Map)
import qualified Data.Map as Map
import Data.Maybe
import Data.List
import Data.Ord

starts_with :: String -> String -> Bool
starts_with towel pattern = (pattern == (take (length pattern) towel))

is_possible :: [Char] -> [String] -> Bool
is_possible towel patterns =
    if towel == "" then True
    else
        let
            buffer = [x|x<-patterns, ((starts_with towel x)&&(is_possible (drop (length x) towel) patterns))]
        in
            if buffer == [] then False
            else True

update_possibilities :: String -> [String] -> Map String Int -> Map String Int
update_possibilities towel patterns current =
    let
        test s p = (starts_with towel (s++p)) && (is_possible (drop (length (s++p)) towel) patterns)
        f counts (string, pattern) = if ((string++pattern)`Map.member` counts) then Map.insertWith (+) (string++pattern) (fromJust(Map.lookup string counts)) counts else counts
        g counts string = foldl f counts [(string, p)|p<-patterns]
        updated_counts = foldl g current (Map.keys current)
        h counts (string, pattern) = Map.insertWith (+) (string++pattern) (fromJust(Map.lookup string updated_counts)) counts
        next_strings = [(s, p)|s<-Map.keys current, p<-patterns, (test s p), not ((s++p)`Map.member`current)]++[(towel, "")|towel `Map.member` current]
        next_count = foldl h Map.empty next_strings
    in
        Map.fromList(sortBy (comparing (length.fst))(Map.toList next_count))

part_one :: [[Char]] -> [String] -> [[Char]]
part_one towels patterns = [x|x<-towels, (is_possible x patterns)]

part_two :: [Char] -> [[Char]] -> Map [Char] Int
part_two towel patterns =
    let
        sorted_patterns = sortBy (comparing length) patterns
        current = Map.fromList [(p, 1)|p<-sorted_patterns, (starts_with towel p)&&(is_possible (take (length p) towel) patterns)]
    in
        head((dropWhile (\x-> ((length (Map.keys x)/=1)||not(towel `elem` Map.keys x)))) (iterate (update_possibilities towel patterns) current))

part_two_total :: [[Char]] -> [[Char]] -> Int
part_two_total towels patterns =
    sum [(Map.elems (part_two x patterns))!!0|x<-towels]

main = do
    handle <- openFile "day19.txt" ReadMode
    contents <- hGetContents handle
    let
        patterns = [init x|x<-init(words((lines contents)!!0))]++[last(words((lines contents)!!0))]
        towels = drop 2 (lines contents)
        sorted_patterns = sortBy (comparing length) patterns
        good_towels = part_one towels patterns
        towel = good_towels!!0
        current = Map.fromList [(p, 1)|p<-sorted_patterns, (starts_with towel p)&&(is_possible (drop (length p) towel) patterns)]
    print(length (good_towels))
    print(part_two_total good_towels patterns)