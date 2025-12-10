import System.IO
import Data.List
import Debug.Trace

pairs :: Eq a => [a] -> [(a, a)]
pairs nums
    |nums == [] = []
    |length nums == 1 = []
    |otherwise = [(head nums, x) | x<-tail nums]++pairs (tail nums)

parse :: [Char] -> [[Char]]
parse [] = []
parse (c:cs)
    |c==',' = parse cs
    |otherwise = [takeWhile (/=',') (c:cs)]++(parse $ dropWhile (/=',') (c:cs))

to_vec :: [String] -> (Int, Int)
to_vec nums = (inums!!0, inums!!1) where inums = map (read::String->Int) nums

area :: Num a => (a, a) -> (a, a) -> a
area (a, b) (c, d) = (1+abs(a-c))*(1+abs(b-d))

line :: (Ord a, Ord t, Enum a, Enum t) => (t, a) -> (t, a) -> [(t, a)]
line (a, b) (c, d)
    |(a==c)&&(b==d) = [(a, b)]
    |(a==c)&&(b<d) = [(a, x) | x<-[b..d]]
    |(a==c)&&(b>d) = [(a, x) | x<-[d..b]]
    |(a<c)&&(b==d) = [(x, b) | x<-[a..c]]
    |(a>c)&&(b==d) = [(x, b) | x<-[c..a]]
    |otherwise = []

get_loop :: (Ord a, Ord t, Enum a, Enum t) => [(t, a)] -> [(t, a)]
get_loop red_tiles = (concat $ [line (red_tiles!!i) (red_tiles!!(i+1)) | i<-[0..(length red_tiles-2)]])++(line (head red_tiles) (last red_tiles))

get_loop2 :: [b] -> [(b, b)]
get_loop2 red_tiles = [(red_tiles!!i, red_tiles!!(i+1)) | i<-[0..length red_tiles-2]]++[(last red_tiles, head red_tiles)]

-- is_in :: (Eq a, Eq b, Enum a) => (a, b) -> [(a, b)] -> a -> Bool
-- is_in (a, b) cycle width
--     |elem (a, b) cycle = True
--     |score`mod`2 == 1 = True
--     |otherwise = False
--     where
--         score = length (([(x, b) | x<-[a..width]]) `intersect` cycle)

is_in2 :: (Num b, Ord b) => (b, b) -> [((b, b), (b, b))] -> Bool
is_in2 (a, b) cycle =
    let
        in_segment ((x0, y0), (x1, y1))
            |(x0==x1)&&(a==x0) = (min y0 y1 <= b)&&(b <= max y0 y1)
            |(y0==y1)&&(b==y0) = (min x0 x1 <= a)&&(a <= max x0 x1)
            |otherwise = False
        f ((x0, y0), (x1, y1))
            |(x0==x1) = if (a<=x0)&&(min y0 y1 <= (x0+b-a))&&((x0+b-a) <= max y0 y1) then 1 else 0
            |otherwise = if (b<=y0)&&(min x0 x1 <= (y0+a-b))&&((y0+a-b) <= max x0 x1) then 1 else 0

        --need to check if it is transversal or tangent...
        problematic_nodes = [(x0, y0) | ((x0, y0), (x1, y1))<-cycle, (x0>=a)&&(y0==x0+b-a)]
        line_to pnode = head [x | (x, y)<-cycle, y==pnode]
        line_from pnode = head [y | (x, y)<-cycle, x==pnode]
        is_transverse pnode = (r-t)*(q-s)<0
            where
                (q, r) = line_to pnode
                (s, t) = line_from pnode
        double_counted = [pnode | pnode<-problematic_nodes, is_transverse pnode]
        
    in
        if any (==True) $ (map (\x-> in_segment x) cycle) then True
        else ((sum $ map f cycle)-length double_counted)`mod`2==1

-- valid (a, b) (c, d) loop width
--     |(a==c)||(b==d) = True
--     |otherwise = all_sides_in
--     where
--         rectangle = get_loop [(a, b), (a, d), (c, d), (c, b)]
--         all_sides_in = not $ (any (==False)) $ map (\x-> is_in x loop width) rectangle

valid2 :: (Enum a, Num a, Ord a) => (a, a) -> (a, a) -> [((a, a), (a, a))] -> Bool
valid2 (a, b) (c, d) loop
    |(a==c)||(b==d) = True
    |otherwise = all_sides_in
    where
        rectangle = (get_loop [(a, b), (a, d), (c, d), (c, b)]) \\ [(a, b), (a, d), (c, d), (c, b)]
        all_sides_in = (dropWhile (\x-> is_in2 x loop) rectangle)==[]

rect_check :: (Ord a1, Ord a2) => (a1, a2) -> (a1, a2) -> [((a1, a2), (a1, a2))] -> Bool
rect_check (a, b) (c, d) loop
    |(a==c)||(b==d) = False --ignore lines, want opposite corners of rectangle
    |otherwise = all (==True) $ map f loop
    where
        (lx, hx, ly, hy) = (min a c, max a c, min b d, max b d) -- low and high x, y coords
        f ((x0, y0), (x1, y1))
            |(x0==x1)&&(lx<x0)&&(x0<hx) = (hy<=min y0 y1)||(ly>=max y0 y1)
            -- |(x0==x1)&&(x0==lx) = (hy<=min y0 y1)||(ly>=max y0 y1)||((min y0 y1)<=ly&&hy<=(max y0 y1))
            -- |(x0==x1)&&(x0==hx) = (hy<=min y0 y1)||(ly>=max y0 y1)||((min y0 y1)<=ly&&hy<=(max y0 y1))
            |(y0==y1)&&(ly<y0)&&(y0<hy) = (hx<=min x0 x1)||(lx>=max x0 x1)
            -- |(y0==y1)&&(y0==ly) = (hx<=min x0 x1)||(lx>=max x0 x1)||((min x0 x1)<=lx&&hx<=(max x0 x1))
            -- |(y0==y1)&&(y0==hy) = (hx<=min x0 x1)||(lx>=max x0 x1)||((min x0 x1)<=lx&&hx<=(max x0 x1))
            |otherwise = True

main = do
    input <- lines <$> readFile "day09.txt"
    let
        coords = map (to_vec.parse) input
        loop = get_loop2 coords
        corners = pairs coords
        f (x, y) = area x y
        part_one = maximum $ map (\(x, y)->area x y) corners
        sorted_rects = reverse $ sortBy (\x y->compare (f x) (f y)) corners
        part_two_fast = filter (\(x, y)-> (rect_check x y loop)) sorted_rects
        part_two = head $ dropWhile (\(x, y)-> (trace $ show (area x y)) not (valid2 x y loop)) part_two_fast
    print(part_one)
    print(length sorted_rects)
    print(part_two)