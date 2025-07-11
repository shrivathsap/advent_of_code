import System.IO
import Data.List
import Data.Ord

mostFreq :: Ord a => [[a]] -> Int -> a
mostFreq words position =
    let
        letters = [x!!position|x<-words]
        ordered = reverse (sortBy (comparing length) (group (sort letters)))
    in
        (ordered!!0)!!0

leastFreq :: Ord a => [[a]] -> Int -> a
leastFreq words position =
    let
        letters = [x!!position|x<-words]
        ordered = reverse (sortBy (comparing length) (group (sort letters)))
    in
        last(last ordered)

main = do
    handle <- openFile "day06.txt" ReadMode
    contents <- hGetContents handle
    let
        codes = lines contents
    print(map (mostFreq codes) [0..7])
    print(map (leastFreq codes) [0..7])