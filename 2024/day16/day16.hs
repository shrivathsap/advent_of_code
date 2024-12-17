import Data.List
import Data.Maybe
import qualified Data.Map as Map
import System.IO
import Debug.Trace

draw :: [String]-> IO ()
draw grid = mapM_ putStrLn grid

data Weight = Weight (Int, [((Int, Int), (Int, Int))]) deriving (Show, Eq)
cost :: Weight -> Int
cost ((Weight (x, _))) = x
pnodes :: Weight -> [((Int, Int), (Int, Int))]
pnodes ((Weight (_, a))) = a

--assumes the two positions are in a straight line, so I can get away with `div`
expense :: ((Int, Int), (Int, Int))->((Int, Int), (Int, Int))->Int
expense from to =
    let
        ((x1, y1), (u1, v1)) = from
        ((x2, y2), (u2, v2)) = to
        xdiff = x2-x1
        ydiff = y2-y1
        lin_cost = (abs xdiff + abs ydiff)
        xdir = if lin_cost /= 0 then xdiff `div` lin_cost else u2
        ydir = if lin_cost /= 0 then ydiff `div` lin_cost else v2
    in
        if lin_cost /= 0 then abs(xdiff)+abs(ydiff)+1000*(1-(u1*xdir)-(v1*ydir))+1000*(1-(u2*xdir)-(v2*ydir))
        else 1000*(1-(u1*xdir)-(v1*ydir))

update_weights :: ((Int, Int), (Int, Int))->Map.Map ((Int, Int), (Int, Int)) Weight  -> ((Int, Int), (Int, Int)) -> Map.Map ((Int, Int), (Int, Int)) Weight
update_weights currentNode mapObject nextNode =
    let
        new_cost = cost (fromJust (Map.lookup currentNode mapObject))+(expense currentNode nextNode)
        current_cost = cost (fromJust (Map.lookup nextNode mapObject))
        current_pnode = pnodes (fromJust (Map.lookup nextNode mapObject))
        in_the_way = ([t|t<-pnodes (fromJust (Map.lookup currentNode mapObject)), t`elem`pnodes (fromJust (Map.lookup nextNode mapObject))]/=[])
    in
        if (current_cost == new_cost) && (not in_the_way) then
            Map.adjust (\_->Weight (current_cost, current_pnode++[currentNode])) nextNode mapObject
        else if new_cost<current_cost then
            Map.adjust (\_->Weight (new_cost, [currentNode])) nextNode mapObject
        else
            mapObject

least :: Map.Map ((Int, Int), (Int, Int)) Weight -> (((Int, Int), (Int, Int)), Weight)
least m =
    let min_cost = minimum [cost x|x<-Map.elems m]
    in head (filter (\x-> (cost(snd x)==min_cost)) (Map.toList m))

is_corner :: [String]->(Int, Int)->Bool
is_corner maze (x, y) = 
    if (maze!!x)!!y == '#' then False
    else
        let
            roads = [n|n<-[(x-1, y), (x, y+1), (x+1, y), (x, y-1)], (maze!! fst n)!!snd n == '.']
        in
            if length roads > 2 then True
            else if (length roads == 2) && (fst (roads!!0)/=fst (roads!!1)) && (snd(roads!!0)/=snd (roads!!1)) then True
            else False

corners :: [String] -> Int -> Int -> [(Int, Int)]
corners maze rows cols = [(x, y)|x<-[0..rows-1], y<-[0..cols-1], is_corner maze (x, y)]

seats_between :: (Int, Int)->(Int, Int)->[(Int, Int)]
seats_between (x1, y1) (x2, y2) 
    |(x1/=x2)&&(y1/=y2) = []
    |(x1==x2)&&(y1/=y2) = [(x1, y)|y<-[(min y1 y2)..(max y1 y2)]]
    |(x1/=x2)&&(y1==y2) = [(x, y1)|x<-[(min x1 x2)..(max x1 x2)]]
    |otherwise = [(x1, y1)]

get_next :: [[Char]] -> (Int, Int) -> [(Int, Int)] -> [(Int, Int)]
get_next maze (x, y) corners = concat [filter (\x->(x`elem` corners)) (takeWhile (\(x, y)-> (((maze!!x)!!y)/='#'))[(x+i*dx, y+i*dy)|i<-[1..]])|(dx, dy)<-[(-1, 0), (0, 1), (1, 0), (0, -1)]]

dijkstra maze nodes (unvisited, visited) =
    let
        current = least unvisited--a vertex with direction, and its cost etc.
        next_nodes = get_next maze (fst(fst current)) nodes
        dirs = [(-1, 0), (0, 1), (1, 0), (0, -1)]
        next_states = [(n, d)|n<-next_nodes, d<-dirs, (n, d)`elem` (Map.keys unvisited)]
        dirs_at_current = [(fst(fst current), d)|d<-dirs, (fst(fst current), d) `elem` (Map.keys unvisited)]
        new_unvisited = Map.delete (fst current) (foldl (update_weights (fst current)) unvisited (next_states++dirs_at_current))
        new_visited = Map.insert (fst current) (snd current) visited
    in
        (new_unvisited, new_visited)

solve maze start end =
    let
        dirs = [(-1, 0), (0, 1), (1, 0), (0, -1)]
        inf = 10000000000--arbitrary big number because I don't know how to have an abstract "infinity"
        nodes = (corners maze (length maze) (length (maze!!0)))++[start, end]
        buffer = Map.fromList[((x, y), Weight (inf, []))|x<-nodes, y<-dirs]
        initial_unvisited = Map.adjust (\_->Weight (0, [])) (start, (0, 1)) buffer
        initial_visited = Map.empty
        --iterate dijkstra's algorithm and drop them until the end is visited
        --need to run dijkstra again for some reason so that the end is added to visited nodes(?)
        just_before = head (dropWhile (\(x, y)-> not(end `elem` [fst z|z<-Map.keys y])) ((iterate (dijkstra maze nodes)) (initial_unvisited, initial_visited)))
        finals = snd(dijkstra maze nodes just_before)
    in
        finals

main = do
    handle <- openFile "day16.txt" ReadMode
    contents <- hGetContents handle
    let
        grid = lines contents
        rnum = length grid
        cnum = length (grid!!0)
        start = (rnum-2, 1)
        end = (1, cnum-2)
        solution = Map.lookup (end, (-1, 0)) (solve grid start end)--I know that all best paths approach in that direction to the end
    print(solution)

