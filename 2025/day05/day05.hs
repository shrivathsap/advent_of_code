import System.IO
import Data.List ( sortBy )

parse :: [String] -> ([(Int, Int)], [Int])
parse stream =
    let
        ranges = takeWhile (/="") stream
        ids = map (read::String->Int) $ tail $ dropWhile(/="") stream
        split_ranges = [(low x, high x) | x<-ranges]
            where
                low x = (read::String->Int) $ takeWhile (/= '-') x
                high x = (read::String->Int) $ tail $ dropWhile (/= '-') x
    in
        (split_ranges, ids)

is_fresh :: Ord a => [(a, a)] -> a -> Bool
is_fresh ranges id = any (==True) [a<=id && id<= b | (a, b)<-ranges]

merge_ranges :: Ord a => [(a, a)] -> [(a, a)]
merge_ranges ranges = 
    let
        sorted = sortBy (\(x1, y1) (x2, y2)->compare x1 x2) ranges
        (a, b) = head sorted
        intervals = tail sorted
        (c, d) = head intervals
    in
        if intervals == [] then [(a, b)]
        else if b<c then [(a, b)]++merge_ranges intervals
        else if c<=b&&b<d then merge_ranges ([(a, d)]++tail intervals)
        else merge_ranges ([(a, b)]++tail intervals)

part_one :: Ord a => ([(a, a)], [a]) -> Int
part_one (ranges, ids) = length [x | x<-ids, (is_fresh ranges x)]

part_two :: (Num a, Ord a) => [(a, a)] -> a
part_two ranges = sum [(b-a+1) | (a, b)<- merge_ranges ranges]

main :: IO ()
main = do
    input <- lines <$> readFile "day05.txt"
    print(part_one $ parse input)
    print(part_two $ fst $ parse input)