import System.IO
import Data.List
import Debug.Trace
import GHC.Base (build)

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

to_vec :: [String] -> (Int, Int, Int)
to_vec nums = (inums!!0, inums!!1, inums!!2) where inums = map (read::String->Int) nums

dist2 :: Num a => ((a, a, a), (a, a, a)) -> a
dist2 ((a, b, c), (e, f, g)) = (u*u+v*v+w*w) where (u, v, w) = (a-e, b-f, c-g)

merge :: Eq a => [[a]] -> [a] -> [a] -> [[a]]
merge components c1 c2 = [g x | x<-components, x /= c2] --merge c1, c2 lists which are disjoint
    where g x = if x==c1 then c1++c2 else x

add :: Eq a => [[a]] -> [a] -> a -> [[a]]
add components comp x = [g c | c<-components] --add x to the list comp
    where g c = if c==comp then c++[x] else c

find_component :: Eq a => [[a]] -> a -> [a]
find_component components c = if [x | x<-components, elem c x]==[] then [] else head [x | x<-components, elem c x]

build_network :: ([((Int, Int, Int), (Int, Int, Int))], [[(Int, Int, Int)]], Int)->Int->([((Int, Int, Int), (Int, Int, Int))], [[(Int, Int, Int)]], Int)
build_network (sorted_pairs, components, prod) target
    |sorted_pairs == [] = ([], components, prod)
    |(components/=[])&&(length(head components)==target) = (sorted_pairs, components, prod)
    |otherwise = build_network (new_pairs, new_components, new_prod) target
    where
        (p, q) = head sorted_pairs
        fst (a, b, c) = a
        c1 = find_component components p
        c2 = find_component components q
        new_pairs = tail sorted_pairs
        (new_components, new_prod)
            |(c1 == [])&&(c2 == []) = (components++[[p, q]], (fst p)*(fst q))
            |(c1 == [])&&(c2 /= []) = (add components c2 p, (fst p)*(fst q))
            |(c1 /= [])&&(c2 == []) = (add components c1 q, (fst p)*(fst q))
            |c1==c2 = (components, prod)
            |otherwise = (merge components c1 c2, (fst p)*(fst q))

main = do
    input <- lines <$> readFile "day08.txt"
    let
        target = length input
        sorted = sortBy (\a b->compare (dist2 a) (dist2 b)) (pairs $ map (to_vec.parse) input)
        (a, b, c) = build_network (take 1000 sorted, [], 1) target
        (_, _, part_two) = build_network (sorted, [], 1) target
        part_one = take 3 $ reverse $ sort $ map length b
    print(part_one)
    print(part_two)