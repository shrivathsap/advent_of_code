--this is much slower than a python program that does the same exact thing...
import System.IO

directions = [[1, 0], [-1, 0], [0, 1], [0, -1],
              [1, 1], [1, -1], [-1, 1], [-1, -1]]

--merge two lists
merge :: [a] -> [a] -> [a]
merge xs [] = xs
merge [] ys = ys
merge (x:xs) (y:ys) = x : y : merge xs ys

--custom function to add vectors before I realized zipWith exists
add_vects :: (Integral n)=>[n]->[n]->[n]
add_vects [] [] = []
add_vects (x:xs) (y:ys)
    |(length (x:xs) /= length (y:ys)) = []
    |otherwise = (x+y:add_vects xs ys)

scale_vect :: (Integral n)=> n->[n]->[n]
scale_vect x ys = [x*y|y<-ys]

cartesian_prod xs ys = [[x, y]|x<-xs, y<-ys]

within_bounds :: Foldable t => Int->Int->[t a]->Bool
within_bounds x y array = (x `elem` [0..length array - 1]) && (y `elem` [0..length (array!!0) - 1])

indices :: Foldable t => [Int] -> [Int] -> t a -> Int -> [[Int]]
indices position direction word offset = [add_vects position (scale_vect (i - offset) direction)| i<-[0..length word-1]]

word_check position direction word big_list =
    let
        --check whether the word can fit in the grid by looking at whether the last position is within
        last_position = add_vects position (scale_vect (length word-1) direction)
        indices_to_check = indices position direction word 0
        x = (last_position !! 0)
        y = (last_position !! 1)
    in
        if not (within_bounds x y big_list) then False
        else (word == [(big_list !!(x!!0))!!(x!!1)|x<-indices_to_check])

x_word_check position word big_list = 
    let
        diag = indices position [-1, 1] word 1
        anti_diag = indices position [-1, -1] word 1
        all_pos = merge diag anti_diag
    in
        if False `elem` [within_bounds (pos!!0) (pos!!1) big_list | pos<-all_pos] then False
        else
            let
                diag_word = [(big_list !!(x!!0))!!(x!!1)|x<-diag]
                anti_diag_word = [(big_list !!(x!!0))!!(x!!1)|x<-anti_diag]
            in
                (diag_word == word || reverse diag_word == word) && (anti_diag_word == word || reverse anti_diag_word == word)

main = do
    handle <- openFile "day4.txt" ReadMode
    contents <- hGetContents handle
    let
        big_list = lines contents
        all_positions = cartesian_prod [0..length big_list - 1] [0..length (big_list!!0) - 1]
        checks = [word_check pos direction "XMAS" big_list| pos<-all_positions, direction<-directions]
        x_checks = [x_word_check pos "MAS" big_list|pos<-all_positions]
    print(length [1|x<-checks, x])
    print(length [1|x<-x_checks, x])
    hClose handle