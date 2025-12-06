import System.IO
import Data.Char (ord)
import Data.Bits (xor)
import qualified Data.Map as Map
import Data.List ((\\))

chunksOf :: Int -> [a] -> [[a]]
chunksOf _ [] = []
chunksOf n l
  | n > 0 = (take n l) : (chunksOf n (drop n l))
  | otherwise = error "Negative or zero n"

neighbours :: (Int, Int) -> Int -> Int -> [(Int, Int)]
neighbours (x, y) rows cols = [(a, b)|(a, b)<-nbd, 0<=a, a<rows, 0<=b, b<cols] where
    nbd = [(x-1, y), (x, y-1), (x, y+1), (x+1, y)]

to_hex :: Int -> [Char]
to_hex num
    |q==0 = hex_digits!!r
    |otherwise = (to_hex q)++hex_digits!!r
    where
        hex_digits = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f"]
        q = num`div`16
        r = num`mod`16

to_bin :: Char -> String
to_bin c
    |c=='0' = "0000" |c=='4' = "0100" |c=='8' = "1000" |c=='c' = "1100"
    |c=='1' = "0001" |c=='5' = "0101" |c=='9' = "1001" |c=='d' = "1101"
    |c=='2' = "0010" |c=='6' = "0110" |c=='a' = "1010" |c=='e' = "1110"
    |c=='3' = "0011" |c=='7' = "0111" |c=='b' = "1011" |c=='f' = "1111"

rot :: Int -> [a] -> [a]
rot x string
    |x>=0 = (drop x string)++(take x string)
    |x<0 = (drop (length string + x) string)++(take (length string+x) string)

hash :: Foldable t => ([a], t Int, c, d) -> ([a], Int, Int)
hash (nums, lengths, start, skip) = foldl step (nums, 0, 0) lengths
    where
        -- a = nums, b = start, c = skip, x = head lengths
        step (a, b, c) x = (reversed a b x, (b+x+c)`mod`(length a), c+1)
        reversed a b x = rot (-1*b) ((reverse $ take x (recentred a b))++drop x (recentred a b))
        recentred a b = rot (b) a

knot_hash :: [Char] -> [Char]
knot_hash string =
    let
        input = map ord string ++ [17, 31, 73, 47, 23]
        cycled = take ((length input)*64) $ cycle input
        fst (a,b,c) = a
        permutation = fst $ (hash ([0..255], cycled, 0, 0))
        f = foldl1 xor
        g nums = chunksOf 16 nums
        padded_hex num = if (length(to_hex num)==1) then "0"++(to_hex num) else to_hex num
    in
        concat $ map to_bin $ concat $ map padded_hex $ map f $ g permutation

build_layers :: Ord a => (Map.Map a [a], [[a]]) -> [[a]]
build_layers (graph, layers) =
    let
        last_layer = last layers
        nodes_visited = concat layers
        to_visit = concat $ map (\x->graph Map.! x) last_layer
        new = [x | x<-to_visit, not (elem x nodes_visited)] -- \\ doesn't work as it only removes first occurence
    in
        if new == [] then layers
        else build_layers (graph, layers++[new])

find_groups :: (Num b, Ord a) => Map.Map a [a] -> b
find_groups graph = f (nodes, 0)
    where
        nodes = Map.keys graph
        group x = concat $ build_layers (graph, [[x]])
        f (nodes, count)
            |nodes==[] = count
            |otherwise = f (nodes \\( group $ head nodes), count+1)

used :: [Char] -> Int
used string = length [x | x<-string, x=='1']

part_one :: [Char] -> Int
part_one input = sum $ map used $ map knot_hash [input++"-"++(show x) | x<-[0..127]]

part_two :: Num b => [Char] -> b
part_two input = find_groups graph
    where
        grid = map knot_hash [input++"-"++(show x) | x<-[0..127]]
        grid_map = Map.fromList [((x, y), (grid!!x)!!y) | x<-[0..127], y<-[0..127]]
        ones = [(x, y) | x<-[0..127], y<-[0..127], (grid!!x)!!y=='1']
        graph =  Map.fromList [(x, [y | y<-neighbours x 128 128, grid_map Map.! y == '1']) | x<-ones]

main :: IO ()
main = do
    print(part_one "input")
    print(part_two "input")