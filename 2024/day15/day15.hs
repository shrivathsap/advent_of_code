import System.IO
import Data.Set (Set)
import qualified Data.Set as Set
import Data.List

find_robo :: [String] -> Int -> Int -> (Int, Int)
find_robo grid rows cols = head [(i, j)|i<-[0..rows-1], j<-[0..cols-1], (grid!!i)!!j == '@']

draw :: [String]-> IO ()
draw grid = mapM_ putStrLn grid

widen :: [[Char]] -> [[Char]]
widen grid =
    let
        f '#' = "##"; f 'O' = "[]"; f '.' = ".."; f '@' = "@."
    in
        [concat(map f x)|x<-grid]

build :: [[Char]] -> [(Int, Int)] -> Char -> (Int, Int) -> Char
build grid moved_list inst (x, y) = 
    let
        (a, b) = vec inst
    in 
        if (x, y) `elem` moved_list then
            if (x-a, y-b) `elem` moved_list then (grid!!(x-a))!!(y-b)--converting Char to String
            else '.'
        else (grid!!x)!!y

vec :: Char -> (Int, Int)
vec '^' = (-1, 0); vec '>' = (0 ,1); vec 'v' = (1, 0); vec '<' = (0, -1)

next_layer :: [String] -> Char-> [(Int, Int)] -> ([(Int, Int)], Bool)
next_layer grid inst positions =
    let
        to_check = [((x+fst (vec inst)), (y+snd(vec inst)))|(x, y)<-positions]
        closes = [(x, y+1)|(x, y)<-to_check, (grid!!x)!!y == '[']
        opens = [(x, y-1)|(x, y)<-to_check, (grid!!x)!!y == ']']
        extended = if (inst `elem` "^v") then nub(to_check++closes++opens) else to_check
        actual = [(x, y)|(x, y)<-extended, not ((grid!!x)!!y `elem` ".#")]
    in
        if '#' `elem` [(grid!!x)!!y|(x, y)<-extended] then ([], False)
        else if actual == [] then ([], True)
        else (actual, True)

movie :: ([String], (Int, Int)) -> Char -> ([String], (Int, Int))
movie (grid, start) inst = 
    if not (inst `elem` "^>v<") then (grid, start)
    else
        let
            f = fst.(next_layer grid inst)
            initial = [start]
            layers = takeWhile (/=[]) ((iterate f) initial)
            all = nub(concat (layers)++[((x+fst (vec inst)), (y+snd(vec inst)))|(x, y)<-concat layers])
            can_move = snd (next_layer grid inst (last layers))
        in
            if not can_move then (grid, start)
            else
                let
                    new_grid = [[build grid all inst (i, j)|j<-[0..length(grid!!0)-1]]|i<-[0..length(grid)-1]]
                    new_pos = (fst start+fst (vec inst), snd start+snd(vec inst))
                in (new_grid, new_pos)

all_moves :: [String] -> [Char] -> (Int, Int) -> [String]
all_moves grid moves start = fst(foldl movie (grid, start) moves)

partOne grid = sum [(100*i)+j|i<-[0..(length grid)-1], j<-[0..(length (grid!!0)-1)], (grid!!i)!!j == 'O']

partTwo grid = sum [(100*i)+j|i<-[0..(length grid)-1], j<-[0..(length (grid!!0)-1)], (grid!!i)!!j == '[']

main = do
    handle <- openFile "day15.txt" ReadMode
    contents <- hGetContents handle
    let
        grid = takeWhile (/= "") (lines contents)
        rnum = length grid
        cnum = length (grid!!0)
        moves = (concat(tail(dropWhile (/="") (lines contents))))
        start = find_robo grid rnum cnum
        wgrid = widen grid
        rnum_w = length wgrid
        cnum_w = length (wgrid!!0)
        start_w = find_robo wgrid rnum_w cnum_w
        fin1 = all_moves grid moves start
        fin2 = all_moves wgrid moves start_w

    -- draw(fin1)
    -- draw(fin2)
    print(partOne fin1)
    print(partTwo fin2)
