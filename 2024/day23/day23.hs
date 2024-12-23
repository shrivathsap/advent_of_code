import System.IO ( IOMode(ReadMode), hGetContents, openFile )
import Data.Map (Map)
import qualified Data.Map as Map
import Data.List
import Data.Algorithm.MaximalCliques
import Data.Function (on)

build_graph edges =
    let
        f dict (x, y) = Map.insertWith (++) y [x] (Map.insertWith (++) x [y] dict)
    in
        foldl f Map.empty edges

update_three_cycles :: Ord k => Map k [k] -> [[k]] -> k -> [[k]]
update_three_cycles graph cycles vertex =
    let
        neighbours = graph Map.! vertex
        new_cycles = [sort [vertex, x, y]|x<-neighbours, y<-neighbours, y `elem` (graph Map.! x)]
    in
        nub (cycles++new_cycles)

part_one edges = 
    let
        graph = build_graph edges
        nodes = Map.keys graph
        tnodes = [x|x<-nodes, head x=='t']
    in
        foldl (update_three_cycles graph) [] tnodes

part_two edges =
    let
        graph = build_graph edges
        nodes = Map.keys graph
        edge_present x y = (y `elem` (graph Map.! x))
    in
        intercalate "," (sort (last(sortBy (compare `on` length) (getMaximalCliques edge_present nodes))))
    

main = do
    handle <- openFile "day23.txt" ReadMode
    contents <- hGetContents handle
    let
        pairs = lines contents
        edges = [(take 2 s, drop 3 s)|s<-pairs]
    print(length (part_one edges))
    print(part_two edges)
