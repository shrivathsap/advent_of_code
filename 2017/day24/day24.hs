import System.IO
import Debug.Trace
data Bridge = Bridge {components::[(Int, Int)], free::Int}deriving(Show, Eq)

get_parts :: [Char] -> (Int, Int)
get_parts line = (f $ takeWhile (/= '/') line, f $ tail $ dropWhile (/='/') line) where f = read::String->Int

strength :: Bridge -> Int
strength bridge = sum [x+y | (x, y)<- components bridge]

generate_bridges :: [(Int, Int)] -> [[Bridge]] -> [[Bridge]]
generate_bridges parts filtered_bridges
    |all (==[]) $ map next_step bridges = filtered_bridges
    |otherwise = (trace $ show (length filtered_bridges, length bridges)) generate_bridges parts (filtered_bridges++[(concat $ map next_step bridges)])
    where
        bridges = last filtered_bridges
        next_part bridge = [(x, y) | (x, y)<-parts, (not ((x,y)`elem` c)) && ((x==e)||(y==e))] where (c, e) = (components bridge, free bridge)
        next_step bridge = [Bridge (c++[(x, y)]) (end (x, y)) | (x, y)<-next_part bridge]
            where
                c = components bridge
                e = free bridge
                end (x, y) = if x==e then y else x

main = do
    input <- lines <$> readFile "day24.txt"
    let
        parts = map get_parts input
        zeroes = [(x, y) | (x, y)<-parts, x==0||y==0]
        nonzero (x, y) = if x==0 then y else x
        bridges_sorted = generate_bridges parts [[Bridge [z] (nonzero z) | z<-zeroes]]
    print(maximum $ map strength $ concat bridges_sorted)
    print(maximum $ map strength $ last bridges_sorted)