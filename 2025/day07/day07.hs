import System.IO
import Data.List ( findIndices, intersect )
import qualified Data.Map as Map

split_beams :: (Foldable t, Num a1, Num a2, Ord a2) => t [a2] -> Map.Map a2 a1 -> Int -> (Map.Map a2 a1, Int)
split_beams splitters beams split_count =
    let
        adjust_pos beam_map pos =
            Map.insertWith (+) (pos+1) num $ Map.insertWith (+) (pos-1) num $ Map.delete pos beam_map
            where num = (Map.!) beam_map pos
        process_layer (beam_map, count) layer = (new_beam_map, new_count)
            where
                active_splitters = Map.keys beam_map `intersect` layer
                new_beam_map = foldl adjust_pos beam_map active_splitters
                new_count = count+(length active_splitters)
    in
        foldl process_layer (beams, split_count) splitters

main = do
    input <- lines <$> readFile "day07.txt"
    let
        source = head $ findIndices (=='S') (input!!0) --findIndex returns Maybe Int, this is simpler
        splitters = [findIndices (=='^') x | x<-(tail input)]
        init_beam = Map.fromList [(source, 1)]
        (final_dist, final_count) = split_beams splitters init_beam 0
    print("part one:", final_count)
    print("part two:", sum $ Map.elems final_dist)