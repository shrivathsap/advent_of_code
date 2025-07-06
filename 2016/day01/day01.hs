import System.IO
import Data.List

updatePosition:: (Int, Int, Int, Int)->String->(Int, Int, Int, Int)
updatePosition (x, y, a, b) move
    |a == 0 && b == 1 && dir == 'R' = (x+steps, y, 1, 0)
    |a == 0 && b == -1 && dir == 'R' = (x-steps, y, -1, 0)
    |a == 1 && b == 0 && dir == 'R' = (x, y-steps, 0, -1)
    |a == -1 && b == 0 && dir == 'R' = (x, y+steps, 0, 1)
    |a == 0 && b == 1 && dir == 'L' = (x-steps, y, -1, 0)
    |a == 0 && b == -1 && dir == 'L' = (x+steps, y, 1, 0)
    |a == 1 && b == 0 && dir == 'L' = (x, y+steps, 0, 1)
    |a == -1 && b == 0 && dir == 'L' = (x, y-steps, 0, -1)
    |otherwise = (x, y, a, b)
    where
        dir = head move
        steps = read (tail move)::Int

keepTrack :: [(Int, Int, Int, Int)] -> Char -> Int -> [(Int, Int, Int, Int)]
keepTrack positions dir step
    |step == 1 = positions++[next]
    |otherwise = keepTrack ((positions)++[next]) dir (step-1)
    where
        prev = last positions
        opdir 'R' = 'L'
        opdir 'L' = 'R'
        next
            |step == 1 = updatePosition prev ([dir]++"1")
            |otherwise = updatePosition (updatePosition prev ([dir]++"1")) ([opdir dir]++"0")

allPositions :: [(Int, Int, Int, Int)] -> String -> [(Int, Int, Int, Int)]
allPositions positions move = keepTrack positions (head move) (read (tail move)::Int)

firstDup::Eq a => [a]->a--has no fail safe if there are no duplicates
firstDup list =
    let
        n = length list
        comp i = (take i list == nub (take i list))
    in list !! (head (dropWhile comp [0..n-1])-1)

main = do
    handle <- openFile "day01.txt" ReadMode
    contents <- hGetContents handle
    let
        input = lines contents
        moves = [takeWhile (/=',') x | x <- words (input!!0)]
        final = foldl updatePosition (0, 0, 0, 1) moves
        all_positions = [(x, y) | (x, y, a, b) <- (foldl allPositions [(0, 0, 0, 1)] moves)]
    print(final)
    print(all_positions)
    print(firstDup all_positions)