import System.IO

translate :: Num a => (a, a) -> a
translate (x, y) = x+3*y+1

translate2 :: (Eq a1, Eq a2, Num a1, Num a2) => (a1, a2) -> Char
translate2 (2, 0) = '1'
translate2 (1, 1) = '2'
translate2 (2, 1) = '3'
translate2 (3, 1) = '4'
translate2 (0, 2) = '5'
translate2 (1, 2) = '6'
translate2 (2, 2) = '7'
translate2 (3, 2) = '8'
translate2 (4, 2) = '9'
translate2 (1, 3) = 'A'
translate2 (2, 3) = 'B'
translate2 (3, 3) = 'C'
translate2 (2, 4) = 'D'

next :: (Ord b, Ord a, Num b, Num a) => (a, b) -> Char -> (a, b)
next (x, y) dir
    |dir == 'U' = (x, max 0 (y-1))
    |dir == 'L' = (max 0 (x-1), y)
    |dir == 'D' = (x, min 2 (y+1))
    |dir == 'R' = (min 2 (x+1), y)
    |otherwise = (x, y)

next2 :: (Eq a, Num a) => (a, a) -> Char -> (a, a)
next2 (x, y) dir
    |dir == 'U' && (x+y==2||x-y==2) = (x, y)
    |dir == 'U' = (x, y-1)
    |dir == 'L' && (x+y==2||y-x==2) = (x, y)
    |dir == 'L' = (x-1, y)
    |dir == 'D' && (y-x==2||x+y==6) = (x, y)
    |dir == 'D' = (x, y+1)
    |dir == 'R' && (x-y==2||x+y==6) = (x, y)
    |dir == 'R' = (x+1, y)
    |otherwise = (x, y)
main = do
    handle <- openFile "day02.txt" ReadMode
    contents <- hGetContents handle
    let
        insts = lines contents
        num1 = foldl next (1, 1) (insts!!0)
        num2 = foldl next num1 (insts!!1)
        num3 = foldl next num2 (insts!!2)
        num4 = foldl next num3 (insts!!3)
        num5 = foldl next num4 (insts!!4)

        num6 = foldl next2 (0, 2) (insts!!0)
        num7 = foldl next2 num6 (insts!!1)
        num8 = foldl next2 num7 (insts!!2)
        num9 = foldl next2 num8 (insts!!3)
        num10 = foldl next2 num9 (insts!!4)
    print(map translate [num1, num2, num3, num4, num5])
    print(map translate2 [num6, num7, num8, num9, num10])