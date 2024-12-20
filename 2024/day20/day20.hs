import System.IO
import qualified Data.Map as Map
import Data.Maybe
find_ends grid =
    let
        start = head [(x, y)|x<-[0..length grid-1], y<-[0..length(grid!!0)-1], (grid!!x)!!y=='S']
        end = head [(x, y)|x<-[0..length grid-1], y<-[0..length(grid!!0)-1], (grid!!x)!!y=='E']
    in
        (start, end)

update_path grid current_path =
    let
        dirs = [(-1, 0), (0, 1), (1, 0), (0, -1)]
        ((x, y), t) = last current_path
        next = [((x+dx, y+dy), t+1)|(dx, dy)<-dirs, (grid!!(x+dx)!!(y+dy))/='#', not(((x+dx, y+dy), t-1)`elem`current_path)]
    in
        current_path++next

get_path grid start end =
    let
        current = [(start, 0)]
    in
        head (dropWhile (\x->not(end`elem`[fst y|y<-x])) (iterate (update_path grid) current))

get_cheats grid path cheat_time time_to_save =
    let
        possible_ends = [(x, y)|x<-path, y<-path, (snd y-snd x)>=time_to_save]
        f pointA pointB = abs(snd pointB - snd pointA)+abs(fst pointB-fst pointA)
        cheats = [(x, y)|(x, y)<-possible_ends, (f (fst x) (fst y))<= cheat_time]
        time_saved pointA pointB = (snd pointB)-(snd pointA)-(f (fst pointA) (fst pointB))
    in
        [(x, y, time_saved x y)|(x, y)<-cheats, time_saved x y >= time_to_save]

update_path2 :: [String]->Map.Map Int (Int, Int)->Map.Map Int (Int, Int)
update_path2 grid path =
    let
        time = last (Map.keys path)
        (x, y) = fromJust(Map.lookup time path)
        dirs = [(-1, 0), (0, 1), (1, 0), (0, -1)]
        next = head [(x+dx, y+dy)|(dx, dy)<-dirs, (grid!!(x+dx)!!(y+dy))/='#', not((x+dx, y+dy)`elem`Map.elems path)]
    in
        Map.insert (time+1) next path

get_path2 grid start end =
    let
        path = Map.fromList [(0, start)]
    in
        head (dropWhile(\x->not(end`elem`Map.elems x)) (iterate (update_path2 grid) path))

get_cheats2 :: [String] -> Map.Map Int (Int, Int) -> Int -> Int -> [(Int, Int)]
get_cheats2 grid path cheat_time time_to_save =
    let
        total_time = last (Map.keys path)
        possible_ends = [(i, j)|i<-[0..total_time], j<-[0..total_time], j-i>=time_to_save]
        f pointA pointB = abs(snd pointB - snd pointA)+abs(fst pointB-fst pointA)
        cheats = [(i, j)|(i, j)<-possible_ends, (f (fromJust (Map.lookup i path)) (fromJust (Map.lookup j path)))<=cheat_time]
    in
        [(i, j)|(i, j)<-cheats, j-i-(f (fromJust (Map.lookup i path)) (fromJust (Map.lookup j path)))>=time_to_save]


main = do
    handle <- openFile "day20.txt" ReadMode
    contents <- hGetContents handle
    let
        grid = lines contents
        (start, end) = find_ends grid
        path = get_path2 grid start end
    print(path)
    print(length(get_cheats2 grid path 2 100))
    print(length(get_cheats2 grid path 20 100))
