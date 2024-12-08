import System.IO
import Data.List
antenna_names :: [[Char]] -> [Char]
antenna_names grid = [(grid!!i)!!j|i<-[0..length grid-1], j<-[0..length(grid!!0)-1], (grid!!i)!!j /= '.']

antenna_position :: [[Char]] -> Char -> [(Int, Int)]
antenna_position grid name = [(i, j)|i<-[0..length grid-1], j<-[0..length(grid!!0)-1], (grid!!i)!!j == name]

generate :: (Enum a, Num a, Ord a) => [(a, a)] -> a -> a -> Bool -> [(a, a)]
generate list_of_tups num_r num_c resonant = 
    if not resonant then
        nub [(x1+2*(x2-x1), y1+2*(y2-y1))|(x1, y1)<-list_of_tups
            , (x2, y2)<-list_of_tups
            , (x1, y1)/=(x2, y2)
            , x1+2*(x2-x1) `elem` [0..num_r-1]
            , y1+2*(y2-y1) `elem` [0..num_c-1]]
    else
        nub [(x1+i*(x2-x1), y1+i*(y2-y1))|(x1, y1)<-list_of_tups
            , (x2, y2)<-list_of_tups
            , i<-[0..(max num_r num_c)]
            , (x1, y1)/=(x2, y2)
            , x1+i*(x2-x1) `elem` [0..num_r-1]
            , y1+i*(y2-y1) `elem` [0..num_c-1]]

main = do
    handle <- openFile "day8.txt" ReadMode
    contents <- hGetContents handle
    let 
        grid = lines contents
        rnum = length grid
        cnum = length (grid!!0)
        antennas = antenna_names grid
        antinodes = (nub.concat)[generate (antenna_position grid x) rnum cnum False | x<-antennas]
        resonant_antinodes = (nub.concat)[generate (antenna_position grid x) rnum cnum True | x<-antennas]
    print(length antinodes)
    print(length resonant_antinodes)
    hClose handle
