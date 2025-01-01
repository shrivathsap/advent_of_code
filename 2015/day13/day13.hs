import Text.Regex.TDFA
import System.IO
import qualified Data.Set as Set
import qualified Data.Map as Map
import Data.List

f "gain" = 1
f "lose" = -1

parse_dist string = ([w!!0, last w], (f (w!!2))*((read::String->Int) $ w!!3)) where w = words (init string)

cost_of path distances =
    if length path==2 then (Map.!) distances (path)
    else ((Map.!) distances ([path!!0, path!!1]))+(cost_of (tail path) distances)

add_me dictionary =
    let
        people = nub [head x|x<-Map.keys dictionary]
        f dictionary x = Map.insert x 0 dictionary
    in
        foldl' f dictionary ([["Me", x]|x<-people]++[[x, "Me"]|x<-people])

main :: IO ()
main = do
    handle <- openFile "day13.txt" ReadMode
    contents <- hGetContents handle
    let
        adjacency = lines contents
        people = nub [(words x)!!0|x<-adjacency]
        happiness = Map.fromList [parse_dist x|x<-adjacency]
        happiness_with_me = add_me happiness
        all_costs = [(cost_of (x++[head x]) happiness)+(cost_of (reverse (x++[head x])) happiness)|x<-(permutations people)]
        all_costs_with_me = [(cost_of (x++[head x]) happiness_with_me)+(cost_of (reverse (x++[head x])) happiness_with_me)|x<-(permutations (people++["Me"]))]

    print(people)
    print(maximum all_costs)
    print(maximum all_costs_with_me)