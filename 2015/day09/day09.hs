import Text.Regex.TDFA
import System.IO
import qualified Data.Set as Set
import qualified Data.Map as Map
import Data.List

parse_dist string = (Set.fromList [w!!0, w!!2], (read::String->Int) $ w!!4) where w = words string

update_path:: (Map.Map (Set.Set String) Int) -> ([String], [String])->([String], [String])
update_path distances (path, cities_left) =
    let
        current = last path
        min_dist = minimum [(Map.!) distances (Set.fromList [current, x])|x<-cities_left]
        next_city = head [x|x<-cities_left, (Map.!) distances (Set.fromList [current, x]) == min_dist]
    in
        (path++[next_city], [x|x<-cities_left, x/=next_city])

update_path_max distances (path, cities_left) =
    let
        current = last path
        min_dist = maximum [(Map.!) distances (Set.fromList [current, x])|x<-cities_left]
        next_city = head [x|x<-cities_left, (Map.!) distances (Set.fromList [current, x]) == min_dist]
    in
        (path++[next_city], [x|x<-cities_left, x/=next_city])

cost_of path distances =
    if length path==2 then (Map.!) distances (Set.fromList path)
    else ((Map.!) distances (Set.fromList [path!!0, path!!1]))+(cost_of (tail path) distances)

main :: IO ()
main = do
    handle <- openFile "day09.txt" ReadMode
    contents <- hGetContents handle
    let
        dists = lines contents
        cities = nub ([(words x)!!0|x<-dists]++[(words x)!!2|x<-dists])
        distances = Map.fromList [parse_dist x|x<-dists]
        f x = fst $ head (dropWhile (\(x, y)->y/=[]) (iterate (update_path distances) ([x], [y|y<-cities, y/=x])))
        g x = fst $ head (dropWhile (\(x, y)->y/=[]) (iterate (update_path_max distances) ([x], [y|y<-cities, y/=x])))
        paths = [(f x, cost_of (f x) distances)|x<-cities]
        max_paths = [(g x, cost_of (g x) distances)|x<-cities]
        all_costs = [cost_of x distances|x<-(permutations cities)]
    print(minimum [snd x|x<-paths])
    print(maximum [snd x|x<-max_paths])
    print(minimum all_costs, maximum all_costs)--this is the correct way to do it, greedy algorithm shouldn't work (see readme.md)