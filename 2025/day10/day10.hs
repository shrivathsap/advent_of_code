import System.IO
import qualified Data.Map as Map
import Debug.Trace ()
import Data.List ( nub )

comma_split :: [Char] -> [[Char]]
comma_split [] = []
comma_split (c:cs)
    |c==',' = comma_split cs
    |otherwise = [takeWhile (/=',') (c:cs)]++(comma_split $ dropWhile (/=',') (c:cs))

subsets [] = [[]]
subsets (x:xs) = subsets xs ++ [[x]++y | y<-subsets xs]

parse :: (Num b, Num a) => [Char] -> ([b], [[a]], [Int])
parse light_data =
    let
        strip_ends things = init $ drop 1 things--to remove brackets etc
        read_target x = if x=='.' then 0 else 1
        target = map read_target $ strip_ends $ head $ words light_data
        num_lights = length target
        to_bin_vec positions = [g x | x<-[0..(num_lights-1)]] where g x = if elem x positions then 1 else 0
        switches = [to_bin_vec $ map (read::String->Int) $ comma_split $ strip_ends x | x<-strip_ends $ words light_data]
        weights = map (read::String->Int) $ comma_split $ strip_ends $ last $ words light_data
    in
        (target, switches, weights)

add_bin_vecs :: Integral a => [[a]] -> [a]
add_bin_vecs vecs
    |vecs == [] = []
    |otherwise = foldl f zero vecs
    where
        f vec1 vec2 = map (`mod`2) $ zipWith (+) vec1 vec2
        size = length (head vecs)
        zero = replicate size 0

add_vecs :: (Eq a, Num a) => [[a]] -> [a]
add_vecs vecs
    |vecs == [] = []
    |otherwise = foldl f zero vecs
    where
        f vec1 vec2 = zipWith (+) vec1 vec2
        size = length (head vecs)
        zero = replicate size 0

is_larger :: Ord a => [a] -> [a] -> Bool
is_larger vec1 vec2
    |(length vec1)/=(length vec2) = False
    |otherwise = all (==True) [(vec1!!i)>=(vec2!!i) | i<-[0..(length vec1-1)]]

solve :: Integral a => ([a], [[a]], c) -> [[[a]]]
solve (target, matrix, _) = [x | x<-(subsets matrix), add_bin_vecs x == target]

part_one :: Integral a => ([a], [[a]], c) -> Int
part_one x = minimum $ map length $ solve x

solve2 :: (Ord a1, Ord a2, Num a1, Num a2) => [[a2]] -> [a2] -> Map.Map [a2] a1 -> (a1, Map.Map [a2] a1)
solve2 matrix weights solved =
    let
        negate nums = [-1*x | x<-nums]
        to_try = (map negate) $ filter (\x->is_larger weights x) matrix
        sub_weights = nub (map (\x->add_vecs [weights, x]) to_try)
        unsolved = [x | x<-sub_weights, not $ elem x (Map.keys solved)]
        update t m = (Map.insert t cost) (Map.union new_info m)
            where
                (cost, new_info) = solve2 matrix t m
        new_solved = foldr (\x y->update x y) solved unsolved
    in
        if to_try == [] then (1000000, solved)
        else if elem weights matrix then (1, solved)
        else if elem weights (Map.keys solved) then ((Map.!) solved weights, solved)
        else (1 + minimum [(Map.!) new_solved x | x<-sub_weights], new_solved)

coin_solve :: (Ord a, Ord k, Num a, Num k) => [k] -> k -> Map.Map k a -> (a, Map.Map k a)
coin_solve coins target solved = 
    let
        to_try = filter (\x->x<=target) coins
        sub_targets = nub (map (\x->target-x) to_try)
        unsolved = [x | x<-sub_targets, not $ elem x (Map.keys solved)]
        update t m = (Map.insert t cost) (Map.union new_info m)
            where
                (cost, new_info) = coin_solve coins t m
        new_solved = foldr (\x y->update x y) solved unsolved
    in
        if to_try == [] then (1000000, solved)
        else if elem target coins then (1, solved)
        else if elem target (Map.keys solved) then ((Map.!) solved target, solved)
        else (1 + minimum [(Map.!) new_solved x | x<-sub_targets], new_solved)

main = do
    input <- lines <$> readFile "day10.txt"
    let
        parsed = map parse input
        matrices = [(\(_, b, _)->b)x | x<-parsed]
        weights = [(\(_,_,c)->c)x | x<-parsed]
        part_two = sum $ map fst $ map (\(_, b, c)->solve2 b c (Map.fromList[])) parsed
        first_problem = fst $ (\(_, b, c)->solve2 b c (Map.fromList[])) (head parsed)
    print(sum $ map part_one parsed)
    -- print(part_two)
    print(first_problem)