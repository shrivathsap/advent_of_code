import System.IO
import qualified Data.Map as Map
import Data.List ( (\\) )

parse :: [String] -> Map.Map Int [Int]
parse stream = Map.fromList [(r (worded x !! 0), map r $ drop 2 $ worded x) | x<-stream]
    where
        comma x = if last x == ',' then init x else x
        worded x = map comma $ words x
        r = (read::String->Int)

build_layers :: Ord a => (Map.Map a [a], [[a]]) -> [[a]]
build_layers (graph, layers) =
    let
        last_layer = last layers
        nodes_visited = concat layers
        to_visit = concat $ map (\x->graph Map.! x) last_layer
        new = [x | x<-to_visit, not (elem x nodes_visited)] -- \\ doesn't work as it only removes first occurence
    in
        if new == [] then layers
        else build_layers (graph, layers++[new])

find_groups :: (Num b, Ord a) => Map.Map a [a] -> b
find_groups graph = f (nodes, 0)
    where
        nodes = Map.keys graph
        group x = concat $ build_layers (graph, [[x]])
        f (nodes, count)
            |nodes==[] = count
            |otherwise = f (nodes \\( group $ head nodes), count+1)
        
main = do
    input <- lines <$> readFile "day12.txt"
    let
        graph = parse input
        part_one = length $ concat $ build_layers (graph, [[0]])
        part_two = find_groups graph
    print(part_one)
    print(part_two)