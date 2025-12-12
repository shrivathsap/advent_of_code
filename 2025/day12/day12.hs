import System.IO
import Text.Regex.TDFA

check_area areas constraint = a-box_areas
    where
        nums = map (read::String->Int) (getAllTextMatches(constraint =~ "[0-9]+"))
        a = (nums!!0) * (nums!!1)
        boxes = drop 2 nums
        box_areas = sum $ zipWith (*) boxes areas

main = do
    input <- lines <$> readFile "day12.txt"
    let
        constraints = drop 30 input
        areas = [7,5,6,7,7,7]
        areas2 = [9,9,9,9,9,7]
        satisfied = filter (>0) $ map (check_area areas2) constraints
    print(satisfied)