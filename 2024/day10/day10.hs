import System.IO
import Data.Char(digitToInt)
import Data.List

find_trailheads :: [[Char]] -> [(Int, Int)]
find_trailheads grid = [(x, y)|x<-[0..length grid-1], y<-[0..length (grid!!0)-1], (grid!!x)!!y == '0']

find_next (x, y) grid = 
    let
        neighbours = [(x-1, y), (x, y+1), (x+1, y), (x, y-1)]
        numr = length grid
        numc = length (grid!!0)
        height = digitToInt ((grid!!x)!!y)
    in
        [(a, b)|(a, b)<-neighbours, ((0<=a)&&(a<numr)&&(0<=b)&&(b<numc)), (digitToInt ((grid!!a)!!b) == (height+1))]

trails pos grid = (iterate f [pos])!!9 --9 steps...
    where
        f [] = []
        f xs = nub (concat [find_next x grid|x<-xs]) --remove nub for part 2

main = do
    handle <- openFile "day10.txt" ReadMode
    contents <- hGetContents handle
    let 
        grid = lines contents
        rnum = length grid
        cnum = length (grid!!0)
        trailheads = find_trailheads grid
        scores = [length(trails pos grid)|pos<-trailheads]
    print(sum scores)
    hClose handle