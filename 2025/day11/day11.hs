import System.IO
import qualified Data.Map as Map
import Data.List
import Debug.Trace

parse :: [String] -> Map.Map [Char] [String]
parse stream = Map.fromList [(init((words x)!!0), tail (words x)) | x<-stream]

extend_path :: Ord a => Map.Map a [a] -> [a] -> [[a]]
extend_path graph path =
    let
        last_node = last path
        nbs = [x | x<-(Map.!) graph last_node, not $ x `elem` path]
    in
        if not (last_node `elem` (Map.keys graph)) then error "Vertex not found"
        else [path++[v] | v<-nbs]

generate_paths :: Ord t1 => Map.Map t1 [t1] -> t2 -> t1 -> [[t1]] -> [[t1]] -> [[t1]]
generate_paths graph start end paths_found to_explore
    |to_explore == [] = paths_found
    |otherwise = generate_paths graph start end updated_paths updated_explore
    where
        one_more_step = concat $ map (extend_path graph) [x | x<-to_explore, (last x)`elem`(Map.keys graph)]
        reach_end = [x | x<-one_more_step, last x == end]
        updated_paths = paths_found++reach_end
        -- dead_ends = [x | x<-one_more_step, x `elem` to_explore] --means that it ends with a leaf node
        updated_explore = (one_more_step)\\(reach_end)

-- build_layers graph start end layers
--     |layers==[] = build_layers graph start end [[start]]
--     |next_layer==[] = layers
--     |otherwise = build_layers graph start end (init layers++[last_layer, next_layer])
--     where
--         nodes_visited = concat layers
--         last_layer = last layers
--         nodes_to_explore = [x | x<-last_layer, x `elem` (Map.keys graph)] --only select those that have out edges
--         pruned = nub [x | x<-last_layer, (x `elem` nodes_to_explore) || x==end] --these are leaf nodes different from end
--         next_nodes = concat $ map ((Map.!) graph) nodes_to_explore
--         next_layer = nub [x | x<-next_nodes, not(x `elem` nodes_visited)]

-- count_paths graph layers dist counts
--     |dist>n = counts
--     |otherwise = count_paths graph layers (dist+1) new_counts
--     where
--         n = length layers
--         dist_apart = [(layers!!i, layers!!(i+dist)) | i<-[0..n-dist-1]]
--         pairs (layer1, layer2) = [(x, y) | x<-layer1, y<-layer2]
--         all_new_pairs = concat $ map pairs dist_apart
--         paths_between (x, y)
--             |dist==1 = if y `elem` ((Map.!) graph x) then 1 else 0
--             |otherwise = sum [Map.findWithDefault 0 (v, y) counts | v<-(Map.!) graph x]
--             -- |otherwise = sum [(Map.!) counts (v, y) | v<-(Map.!) graph x, (v, y) `elem` (Map.keys counts)]
--         new_counts = foldr (\(x, y) z -> Map.insert (x, y) (paths_between (x, y)) z) counts all_new_pairs

count_paths2 :: Map.Map String [String]->String->String->Map.Map String Int -> (Int, Map.Map String Int)
count_paths2 graph start end cache =
    let
        nbs = (Map.!) graph start
        unsolved = [x | x<-nbs, not $ x `elem` (Map.keys cache)]
        update x m = (Map.insert x num_paths) (Map.union new_info m)
            where
                (num_paths, new_info) = count_paths2 graph x end m
        new_cache = foldr (\x y->update x y) cache unsolved
    in
        if start==end then (1, Map.insert start 1 cache)
        else if not(start `elem` (Map.keys graph)) then (0, cache)
        else if start `elem` (Map.keys cache)then ((Map.!) cache start, cache)
        else (sum [(Map.!) new_cache x | x<-nbs], new_cache)

main = do
    input <- lines <$> readFile "day11.txt"
    let
        graph = parse input
        (you, out, svr, dac, fft) = ("you", "out", "svr", "dac", "fft")
        part_one = length $ generate_paths graph you out [] [[you]]
        svr_to_dac = fst $ count_paths2 graph svr dac (Map.fromList [])
        svr_to_fft = fst $ count_paths2 graph svr fft (Map.fromList []) 
        dac_to_fft = fst $ count_paths2 graph dac fft (Map.fromList []) 
        fft_to_dac = fst $ count_paths2 graph fft dac (Map.fromList [])
        dac_to_out = fst $ count_paths2 graph dac out (Map.fromList [])
        fft_to_out = fst $ count_paths2 graph fft out (Map.fromList [])

    print(part_one)
    print(svr_to_dac, svr_to_fft, dac_to_fft, fft_to_dac, dac_to_out, fft_to_out)