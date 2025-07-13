import System.IO
import Text.Regex.TDFA
import Data.List
import Control.Concurrent
width :: Int
width = 50
height :: Int
height = 6

grid :: [[Char]]
grid = [['.'|i<-[0..width-1]]|j<-[0..height-1]]

draw :: [String]-> IO ()
draw grid = mapM_ putStrLn grid

my_transpose :: [[a]] -> [[a]]
my_transpose grid =
    let
        w = length(grid!!0)
        h = length grid
    in
        [[(grid!!j)!!i | j<-[0..h-1]]|i<-[0..w-1]]

rect :: [[Char]] -> Int -> Int -> [[Char]]
rect grid x y = [['#'|i<-[0..x-1]]++[(grid!!j)!!i|i<-[x..width-1]]|j<-[0..y-1]]++[grid!!j|j<-[y..height-1]]

rot_row :: [[a]] -> Int -> Int -> [[a]]
rot_row grid rnum shift =
    let
        w = length(grid!!0)
        h = length grid
    in
        [grid!!j | j<-[0..rnum-1]]++[[(grid!!rnum)!!((i-shift)`mod`w)|i<-[0..w-1]]]++[grid!!j | j<-[rnum+1..h-1]]

rot_col :: [[a]] -> Int -> Int -> [[a]]
rot_col grid cnum shift = my_transpose(rot_row (my_transpose grid) cnum shift)

get_nums :: RegexContext Regex source1 (AllTextMatches [] String) => source1 -> [Int]
get_nums inst = (map (read::String->Int))(getAllTextMatches(inst =~ "[0-9]+|-[0-9]+")::[String])

handle_insts :: [[Char]] -> [Char] -> [[Char]]
handle_insts grid inst
    |inst == "" = grid
    |"rect" `isInfixOf` inst = rect grid a b
    |"rotate column" `isInfixOf` inst = rot_col grid a b
    |"rotate row" `isInfixOf` inst = rot_row grid a b
    |otherwise = grid
    where
        a = (get_nums inst)!!0
        b = (get_nums inst)!!1
    

clear :: IO ()
clear = putStr "\ESC[2J"

handle_mult :: [[Char]] -> [[Char]] -> IO b
handle_mult grid insts =
    do
        draw(handle_insts grid (insts!!0))
        threadDelay 100000
        clear
        handle_mult (handle_insts grid (insts!!0)) (tail insts) 

main = do
    handle <- openFile "day08.txt" ReadMode
    contents <- hGetContents handle
    let
        insts = lines contents
        final_grid = foldl (handle_insts) grid insts
    draw final_grid
    print(length [y | x<-final_grid, y<-x, y=='#'])
    --handle_mult grid insts