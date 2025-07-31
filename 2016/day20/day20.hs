import System.IO
import Data.List

start :: [Char] -> Int
start line = read(takeWhile (/= '-') line)::Int

end :: [Char] -> Int
end line = read $ tail(dropWhile (/='-') line)::Int

next :: [(Int, Int)] -> Int -> Int
next pairs test =
    let
        included = [x | x<-pairs, ((fst x)<=test) && (test<=(snd x))]
    in
        if included == [] then test
        else next pairs ((snd $ head included)+1)

make_disjoint :: Ord a => [(a, a)] -> [(a, a)]
make_disjoint (a:[]) = [a]
make_disjoint ((a, b):(x, y):xs) =
    if x<b then make_disjoint ((a, max b y): xs)
    else ((a, b): make_disjoint ((x, y):xs))

main = do
    handle <- openFile "day20.txt" ReadMode
    contents <- hGetContents handle
    let
        test_input = ["5-8", "0-2", "4-7"]
        pairs = [(start x, end x) | x<-(lines contents)]
        sorted_pairs = sortBy (\(a, b) (x, y) -> compare a x) pairs --need to sort before merging
        total_banned = sum [(snd x)-(fst x)+1 | x<-(make_disjoint sorted_pairs)]
        wtf = sum [(snd x)-(fst x)+1 | x<-(make_disjoint sorted_pairs)]
        max = 4294967295
    print(next pairs 0)
    print(total_banned)
    print(max+1-wtf)