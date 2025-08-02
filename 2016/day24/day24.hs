import System.IO
import qualified Data.Map as Map
import Data.Maybe
import Data.List

data Weight = Weight (Int, [(Int, Int)]) deriving (Show, Eq)
cost :: Weight -> Int
cost ((Weight (x, _))) = x
pnodes :: Weight -> [(Int, Int)]
pnodes ((Weight (_, a))) = a

--assumes from and to are in a straight line
expense :: (Int, Int)->(Int, Int)->Int
expense from to =
    let
        (x1, y1) = from
        (x2, y2) = to
    in
        abs(x2-x1)+abs(y2-y1)

update_weights :: (Int, Int)->Map.Map (Int, Int) Weight  -> (Int, Int) -> Map.Map (Int, Int) Weight
update_weights currentNode mapObject nextNode =
    let
        new_cost = cost (fromJust (Map.lookup currentNode mapObject))+(expense currentNode nextNode)
        current_cost = cost (fromJust (Map.lookup nextNode mapObject))
        current_pnode = pnodes (fromJust (Map.lookup nextNode mapObject))
        in_the_way = ([t | t<-pnodes (fromJust (Map.lookup currentNode mapObject)), t`elem`pnodes (fromJust (Map.lookup nextNode mapObject))]/=[])
    in
        if (current_cost == new_cost) && (not in_the_way) then
            Map.adjust (\_->Weight (current_cost, current_pnode++[currentNode])) nextNode mapObject
        else if new_cost<current_cost then
            Map.adjust (\_->Weight (new_cost, [currentNode])) nextNode mapObject
        else
            mapObject

least :: Map.Map (Int, Int) Weight -> ((Int, Int), Weight)
least m =
    let min_cost = minimum [cost x|x<-Map.elems m]
    in head (filter (\x-> (cost(snd x)==min_cost)) (Map.toList m))

is_corner :: [String]->(Int, Int)->Bool --is an open space a corner
is_corner maze (x, y) = 
    if (maze!!x)!!y == '#' then False
    else
        let
            roads = [n | n<-[(x-1, y), (x, y+1), (x+1, y), (x, y-1)], (maze!! fst n)!!snd n == '.']
        in
            if length roads > 2 then True
            else if (length roads == 2) && (fst (roads!!0)/=fst (roads!!1)) && (snd(roads!!0)/=snd (roads!!1)) then True
            else False

corners :: [String] -> Int -> Int -> [(Int, Int)]
corners maze rows cols = [(x, y) | x<-[0..rows-1], y<-[0..cols-1], is_corner maze (x, y)]

seats_between :: (Int, Int)->(Int, Int)->[(Int, Int)]
seats_between (x1, y1) (x2, y2) 
    |(x1/=x2)&&(y1/=y2) = []
    |(x1==x2)&&(y1/=y2) = [(x1, y) | y<-[(min y1 y2)..(max y1 y2)]]
    |(x1/=x2)&&(y1==y2) = [(x, y1) | x<-[(min x1 x2)..(max x1 x2)]]
    |otherwise = [(x1, y1)]

get_next :: [[Char]] -> (Int, Int) -> [(Int, Int)] -> [(Int, Int)]
get_next maze (x, y) corners = concat [filter (\x->(x`elem` corners)) (takeWhile (\(x, y)-> (((maze!!x)!!y)/='#'))[(x+i*dx, y+i*dy) | i<-[1..]]) | (dx, dy)<-[(-1, 0), (0, 1), (1, 0), (0, -1)]]

dijkstra maze nodes (unvisited, visited) =
    let
        current = least unvisited--a vertex with direction, and its cost etc.
        next_nodes = get_next maze ((fst current)) nodes
        -- dirs = [(-1, 0), (0, 1), (1, 0), (0, -1)]
        next_states = [n | n<-next_nodes, n`elem` (Map.keys unvisited)]
        -- dirs_at_current = [(fst current|d<-dirs, (fst(fst current), d) `elem` (Map.keys unvisited)]
        new_unvisited = Map.delete (fst current) (foldl (update_weights (fst current)) unvisited (next_states))
        new_visited = Map.insert (fst current) (snd current) visited
    in
        (new_unvisited, new_visited)

solve maze start end =
    let
        -- dirs = [(-1, 0), (0, 1), (1, 0), (0, -1)]
        inf = 10000000000--arbitrary big number because I don't know how to have an abstract "infinity"
        nodes = (corners maze (length maze) (length (maze!!0)))++[start, end]
        buffer = Map.fromList[(x, Weight (inf, [])) | x<-nodes]
        initial_unvisited = Map.adjust (\_->Weight (0, [])) start buffer
        initial_visited = Map.empty
        --iterate dijkstra's algorithm and drop them until the end is visited
        --need to run dijkstra again for some reason so that the end is added to visited nodes(?)
        just_before = head (dropWhile (\(x, y)-> not(end `elem` [z | z<-Map.keys y])) ((iterate (dijkstra maze nodes)) (initial_unvisited, initial_visited)))
        finals = snd(dijkstra maze nodes just_before)
    in
        finals

get_coords :: [[Char]] -> Int -> Int -> [(Int, Int)]
get_coords grid rnum cnum = [(x, y) | x<-[0..rnum-1], y<-[0..cnum-1], ((grid!!x)!!y /= '.')&&((grid!!x)!!y /= '#')]

edit :: [[Char]] -> [[Char]]
edit grid =
    let
        f x
            |x=='#' = '#'
            |otherwise = '.'
    in
        [map f x | x<-grid]

part_one :: (Ord a, Num a) => [((Char, Char), a)] -> a
part_one dists = 
    let
        perms = ["0"++x | x<- permutations "1234567"]
        paths = [[(x!!i, x!!(i+1)) | i<-[0..(length x)-2]] | x<-perms]
        f x = snd $ head [z | z<-dists, fst z == x]
    in
        head $ sort $ map sum [map f x | x<-paths]

part_two :: (Ord a, Num a) => [((Char, Char), a)] -> a
part_two dists = 
    let
        perms = ["0"++x++"0" | x<- permutations "1234567"]
        paths = [[(x!!i, x!!(i+1)) | i<-[0..(length x)-2]] | x<-perms]
        f x = snd $ head [z | z<-dists, fst z == x]
    in
        head $ sort $ map sum [map f x | x<-paths]


main = do
    handle <- openFile "day24.txt" ReadMode
    contents <- hGetContents handle
    let
        grid = lines contents
        rnum = length grid
        cnum = length (grid!!0)
        destinations = get_coords grid rnum cnum
        edited = edit grid
        pairs = [(x, y) | x<-destinations, y<-destinations, x/=y]
        f x y = cost $ fromJust $ Map.lookup y $ solve grid x y
        g x = (grid!!(fst x))!!(snd x)
        all_dists = [((g x, g y), f x y) | (x, y)<-pairs]
    print(get_coords grid rnum cnum)
    print(part_one all_dists)
    print(part_two all_dists)