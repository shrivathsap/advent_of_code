import System.IO
import Data.List
import qualified Data.Map as Map

find_repeat :: Eq a => [a] -> a
find_repeat nums = head (nums\\nub nums) --I know that the list looks like [a, b, b, b]

find_weight:: Map.Map String (Int, [String]) -> String -> Int
find_weight tower_data name =
    let
        weight = fst (tower_data Map.! name) --Map.! is bad in general, but it's fine here
        kids = snd (tower_data Map.! name)
    in
        if kids == [] then weight
        else weight+sum(map (find_weight tower_data) kids)

part_one :: Eq a => [(a, (b, [a]))] -> [a]
part_one tower =
    let
        name (a, (b, c)) = a
        kids (a, (b, c)) = c
        all_programs = map name tower
        all_kids = foldl union [] (map kids tower)
    in
        all_programs\\all_kids

find_target :: Map.Map String (Int, [String]) -> String -> Int
find_target tower_data root = find_repeat $ map (find_weight tower_data) $ snd (tower_data Map.! root)

part_two :: Map.Map String (Int, [String]) -> String -> Int -> Int
part_two tower_data root current_target =
    let
        current_weight = fst (tower_data Map.! root)
        kids = snd (tower_data Map.! root)
        weights = map (find_weight tower_data) kids
        new_target = find_repeat weights
        wrong_kid = head [x | x<-kids, find_weight tower_data x /= new_target] --possibly empty
        all_kids_same = (length(nub weights) == 1)
    in
        if all_kids_same then current_target-sum(weights)
        else part_two tower_data wrong_kid new_target

main = do
    handle <- openFile "day07.txt" ReadMode
    contents <- hGetContents handle
    let
        input = lines contents
        convert weight = (read::String->Int) $ init $ tail weight --convert "(123)" into the number 123
        filter_comma name = if last name==',' then init name else name
        f line =
            if length(w)==2 then (w!!0, (convert(w!!1), []))
            else (w!!0, (convert(w!!1), map filter_comma $ drop 3 w))
            where w = words line
        input_data = map f input
        input_map = Map.fromList input_data
        root_name = head $ part_one input_data
    print(part_one input_data)
    print(part_two input_map root_name (find_target input_map root_name))