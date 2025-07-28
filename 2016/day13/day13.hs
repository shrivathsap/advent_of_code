import Data.Bits
import Data.List

data Node = Node {coords::(Int, Int), cost::Int} deriving Show

secret :: Int
secret = 0 --input

num_ones :: Int -> Int
num_ones n
    |n==0 = 0
    |otherwise = 1+(num_ones ((.&.) n (n-1)))

neighbours :: (Int, Int) -> [(Int, Int)]
neighbours (x, y) = [(x-1, y), (x+1, y), (x, y-1), (x, y+1)]

is_wall :: (Int, Int) -> Bool
is_wall (x, y)
    |x<0||y<0 = True
    |otherwise = ((num_ones (x*x + 3*x + 2*x*y + y + y*y+secret))`mod` 2 == 1)

add_nodes :: [Node] -> [Node]
add_nodes visited = 
    let
        so_far = cost(last(visited)) -- adding vertices at the ends, so this should have max cost
        to_expand = [coords x | x<-visited, cost x == so_far]
        new_nodes = nub [(x, y) | (a, b)<-to_expand, (x, y)<-(neighbours (a, b)), not(is_wall (x, y))]
    in
        visited ++ [Node x (so_far+1) | x<-new_nodes, not(x `elem` (map coords visited))]

main = do
    let
        init = Node (1, 1) 0
        end = (31, 39)
        stop_here = head(dropWhile (\x -> not(end `elem` (map coords x))) (iterate add_nodes [init]))
        part_two = last(takeWhile (\x -> all (<=50) (map cost x)) (iterate add_nodes [init]))
    print(stop_here)
    print(length(part_two))