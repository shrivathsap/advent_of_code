import Data.List
import Data.Maybe
import qualified Data.Map as Map
import System.IO
import Debug.Trace
import Text.Regex.TDFA.Common (snd3, thd3)

draw :: [String]-> IO ()
draw grid = mapM_ putStrLn grid

get_grid::[(Int, Int)]->Int->Int->[String]
get_grid coords r c = 
    let
        top = concat(replicate (c+2) "#")
        f (i, j) = if (i, j) `elem` coords then '#' else '.'
        rows = ["#"++[f (x, y)|y<-[0..c-1]]++"#"|x<-[0..r-1]]
    in
        [top]++rows++[top]

--assumes the two positions are in a straight line, so I can get away with `div`
expense :: (Int, Int)->(Int, Int)->Int
expense from to =
    let
        (x1, y1) = from
        (x2, y2) = to
        xdiff = x2-x1
        ydiff = y2-y1
    in
        abs xdiff + abs ydiff
        

update_weights :: (Int, Int)->Map.Map (Int, Int) Int  -> (Int, Int) -> Map.Map (Int, Int) Int
update_weights currentNode mapObject nextNode =
    let
        new_cost = (fromJust (Map.lookup currentNode mapObject))+(expense currentNode nextNode)
        current_cost = (fromJust (Map.lookup nextNode mapObject))
    in
        if new_cost<current_cost then
            Map.adjust (\_->new_cost) nextNode mapObject
        else
            mapObject

least :: Map.Map (Int, Int) Int -> ((Int, Int), Int)
least m =
    let min_cost = minimum [x|x<-Map.elems m]
    in head (filter (\x-> ((snd x)==min_cost)) (Map.toList m))


dijkstra maze nodes (previous, unvisited, visited) =
    let
        current = least unvisited--a vertex with direction, and its cost etc.
        (x, y) = fst current
        inf = 10000000000
    in
        if snd current /= inf then
            let
                next_nodes = [n|n<-[(x-1, y), (x, y+1), (x+1, y), (x, y-1)], ((maze!!(fst n))!!(snd n))/='#', n`elem`(Map.keys unvisited)]
                new_unvisited = Map.delete (fst current) (foldl (update_weights (fst current)) unvisited (next_nodes))
                new_visited = Map.insert (fst current) (snd current) visited
            in
                (current, new_unvisited, new_visited)
        else
            (current, unvisited, visited)

solve maze start end =
    let
        inf = 10000000000--arbitrary big number because I don't know how to have an abstract "infinity"
        nodes = [(x, y)|x<-[0..length maze-1], y<-[0..length(maze!!0)-1], (maze!!x)!!y/='#']
        buffer = Map.fromList[(x, inf)|x<-nodes]
        initial_unvisited = Map.adjust (\_->0) start buffer
        initial_visited = Map.empty
        initial = least initial_unvisited
        just_before = head (dropWhile (\(z, x, y)-> not(end `elem` Map.keys y)&&(snd z/=inf)) ((iterate (dijkstra maze nodes)) (initial, initial_unvisited, initial_visited)))
        finals = thd3(dijkstra maze nodes just_before)
    in
        finals

shorten_range coords rnum cnum start end (lower, upper) =
    let
        mid = (lower+upper)`div`2
        maze = get_grid (take mid coords) rnum cnum
        solution = solve maze start end
    in
        if end `elem` Map.keys solution then (mid, upper)
        else (lower, mid)

main = do
    handle <- openFile "day18.txt" ReadMode
    contents <- hGetContents handle
    let
        pairs = lines contents
        swapped_coords = [((read::String->Int)(takeWhile (/=',') x), ((read::String->Int)(tail(dropWhile (/=',')x))))|x<-pairs]
        coords = [(y, x)|(x, y)<-swapped_coords]
        rnum = 71
        cnum = 71
        start = (1, 1)
        end = (rnum, cnum)
        solution = Map.lookup (end) (solve (get_grid (take 1024 coords) rnum cnum) start end)
        range = head(dropWhile (\(x, y)->(y-x>5)) (iterate (shorten_range coords rnum cnum start end) (1024, length coords)))
    print(solution)
    print([swapped_coords!!x|x<-[fst range..snd range]])

