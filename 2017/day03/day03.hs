import System.IO
import qualified Data.Map as Map
import Data.Maybe (fromJust)

dist::Int->Int
dist num
    |extra==0 = 2*m --this is if num is a square
    |r<=m+1 = (m+1)+(m+1-r)
    |otherwise = (m+1)+(r-m-1)
    where
        n = floor $ sqrt (fromIntegral num)
        m = if n`mod`2==0 then (n`div`2)-1
            else n`div`2
        --(2m+1)^2 is the lower right corner of the previous square
        --square containing num has corners: (2m+1)^2+(2m+2), (2m+1)^2+2(2m+2), (2m+1)^2+3(2m+2), (2m+1)^2+4(2m+2)
        extra = num - ((2*m+1)*(2*m+1))
        q = extra `div`(2*m+2) --this is 0, 1, 2, or 3
        r = extra `mod` (2*m+2)

get_coords::Int->(Int, Int) --gets the coordinates of a given number using the same logic as dist function
get_coords num
    |extra==0 = (m, -m)
    |q==0 = (m+1, -m+r-1)
    |q==1 = (m+1-r, m+1)
    |q==2 = (-m-1, m+1-r)
    |q==3 = (-m-1+r, -m-1) --taxicab distance to these coords is the dist function
    where
        n = floor $ sqrt (fromIntegral num)
        m = if n`mod`2==0 then (n`div`2)-1
            else n`div`2
        extra = num - ((2*m+1)*(2*m+1))
        q = extra `div`(2*m+2) --this is 0, 1, 2, or 3
        r = extra `mod` (2*m+2)

next_coord::(Int, Int)->(Int, Int)
next_coord (x, y)
    -- |x==0 && y==0 = (1, 0)
    |x-y>0 && x+y>0 = (x, y+1)
    |x-y>=0 && x+y<=0 = (x+1, y)
    |x-y<=0 && x+y>0 = (x-1, y)
    |x-y<0 && x+y<=0 = (x, y-1)

neighbours :: (Num a, Num b) => (a, b) -> [(a, b)]
neighbours (x, y) = [(x-1, y+1), (x, y+1), (x+1, y+1),
                     (x-1, y),             (x+1, y),
                     (x-1, y-1), (x, y-1), (x+1, y-1)]

build_list :: Num c1 => (Map.Map (Int, Int) c1, (Int, Int), c2) -> (Map.Map (Int, Int) c1, (Int, Int), c1)
build_list (list_so_far, coord_to_add, last_value) = 
    let
        next = next_coord coord_to_add
        coords_so_far = Map.keys list_so_far
        valid = [x | x<-neighbours coord_to_add, elem x coords_so_far]
        values = map fromJust [Map.lookup x list_so_far | x<-valid]
    in
        (Map.insert coord_to_add (sum values) list_so_far, next, sum values)

    

main = do
    handle <- openFile "day03.txt" ReadMode
    contents <- hGetContents handle
    let
        input = (read::String->Int) $ (lines contents)!!0
        initial_list = Map.fromList [((0, 0), 1), ((1, 0), 1)] --including one more step because starting with (0,0) breaks it
        final_list = until (\(a, b, c)->c>input) build_list (initial_list, (1, 1), 1)
        third (a, b, c) = c
    print(dist input)
    print(third final_list)