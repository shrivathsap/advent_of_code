import System.IO
import Data.List (nub, transpose)
import qualified Data.Map as Map

chunksOf :: Int -> [a] -> [[a]]
chunksOf _ [] = []
chunksOf n l
    |n > 0 = (take n l) : (chunksOf n (drop n l))
    |otherwise = error "Negative or zero n"

parse_string :: [Char] -> [[Char]]
parse_string [] = []
parse_string (c:cs)
    |cs==[] = if c==',' then [] else [[c]]
    |c=='/' = parse_string cs
    |otherwise = [takeWhile (/= '/') (c:cs)]++(parse_string (dropWhile (/='/') (c:cs)))

rotate matrix = transpose $ map reverse matrix
reflect matrix = map reverse matrix
transformations matrix = [f matrix | f<-[(\x->x), r, r.r, r.r.r, s, s.r, s.r.r, s.r.r.r]] where (s, r) = (reflect, rotate)

parse stream = (parse_string (w!!0), parse_string (w!!2)) where w = words stream

break_into :: Eq a => [[a]] -> Int -> [[[a]]]
break_into machine groups --output is chunks read row-wise
    |machine==[] = []
    |(size`mod`groups)/=0 = error "Incorrect division"
    |otherwise = chunks
    where
        size = length (machine!!0) --get number of columns
        first_bit = take groups machine --will be the first few rows
        last_bit = drop groups machine
        broken_first = transpose $ map (chunksOf groups) first_bit
        chunks = broken_first++(break_into last_bit groups)

rebuild :: Eq a => [[[a]]] -> Int -> [[a]]
rebuild chunks target
    |chunks==[] = []
    |target`mod`(length (chunks!!0)) /= 0 = error "Incorrect build attempt"
    |otherwise = first_bit++last_bit
    where
        size = (target`div`(length (chunks!!0)))
        first_bit = map concat $ transpose $ take size chunks
        last_bit = rebuild (drop size chunks) target

update :: (Ord a1, Eq a2) => Map.Map [[a1]] [[a2]] -> [[a1]] -> [[a2]]
update rules machine
    |size`mod`2==0 = rebuild  (map f (break_into machine 2)) (size*3`div`2)
    |otherwise = rebuild (map f (break_into machine 3)) (size*4`div`3)
    where
        size = length machine
        f chunk = (Map.!) rules chunk

count_lights :: Num a => [[Char]] -> a
count_lights machine = sum $ map sum $ [map f x | x<-machine]
    where
        f '#' = 1
        f '.' = 0

main = do
    input <- lines <$> readFile "day21.txt"
    let
        rules = map parse input
        updated_rules = Map.fromList (nub $ concat [[(x, y) | x<-transformations a]|(a, y)<-rules])
        seed = [".#.","..#","###"]
        fifth_gen = (iterate (update updated_rules) seed)!!5
        eighteenth_gen = (iterate (update updated_rules) seed)!!18
    print(count_lights fifth_gen)
    print(count_lights eighteenth_gen)