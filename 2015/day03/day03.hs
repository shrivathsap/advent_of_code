import Data.List
import System.IO
move :: (Int, Int)->Char->(Int, Int)
move (x, y) '^' = (x, y+1)
move (x, y) '>' = (x+1, y)
move (x, y) 'v' = (x, y-1)
move (x, y) '<' = (x-1, y)

move_list:: [(Int, Int)]->Char->[(Int, Int)]
move_list pos dir = pos++[move (last pos) dir]

main = do
    handle <- openFile "day03.txt" ReadMode
    contents <- hGetContents handle
    let
        instructions = (lines contents)!!0
        santa = [(instructions!!i)|i<-[0..length instructions-1], i`mod`2==0]
        robo_santa = [(instructions!!i)|i<-[0..length instructions-1], i`mod`2==1]
        houses = foldl move_list [(0, 0)] instructions
        santa_houses = foldl move_list [(0, 0)] santa
        robo_santa_houses = foldl move_list [(0, 0)] robo_santa
    print("Part one:", length (nub houses))
    print("Part two:", length (nub (santa_houses++robo_santa_houses)))
