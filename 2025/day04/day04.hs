import System.IO

neighbours :: (Int, Int) -> Int -> Int -> [(Int, Int)]
neighbours (x, y) rows cols = [(a, b)|(a, b)<-nbd, 0<=a, a<rows, 0<=b, b<cols] where
    nbd = [(x-1, y-1), (x-1, y), (x-1, y+1),
           (x, y-1),             (x, y+1),
           (x+1, y-1), (x+1, y), (x+1, y+1)]

accessible :: [[Char]]->(Int, Int) -> Int -> Int -> Bool
accessible grid (x, y) rows cols
    |(grid!!x)!!y=='@' && length valid<4 = True
    |otherwise = False
    where
        nbs = neighbours (x, y) rows cols
        valid = [(a, b) | (a, b)<-nbs, (grid!!a)!!b == '@']

remove_rolls :: ([[Char]], Int, Int, Int) -> Int
remove_rolls (grid, rows, cols, removed)
    |rolls_to_remove==[] = removed
    |otherwise = remove_rolls (new_grid, rows, cols, removed+(length rolls_to_remove))
    where
        rolls_to_remove = [(x, y) | x<-[0..rows-1], y<-[0..cols-1], accessible grid (x, y) rows cols]
        g (x, y) = if elem (x, y) rolls_to_remove then '.' else (grid!!x)!!y
        new_grid = [[g (x, y) | y<-[0..cols-1]] | x<-[0..rows-1]]

main = do
    grid <- lines <$> readFile "day04.txt"
    let
        rnum = length grid
        cnum = length (grid!!0)
        part_one = length [(x, y) | x<-[0..rnum-1], y<-[0..cnum-1], accessible grid (x, y) rnum cnum]
        part_two = remove_rolls (grid, rnum, cnum, 0)
    print(part_one)
    print(part_two)