import Data.Map (Map)
import qualified Data.Map as Map
import Data.List ( intersect, isInfixOf, isPrefixOf, nub, sortBy )
import Debug.Trace (trace)
import Data.Char ( isUpper )

match_left :: Eq a => [a] -> [a] -> Int
match_left string substring = maximum matches where matches = [i | i<-[0..length substring], take i string == take i substring]

update :: Ord a => Map [a] [[a]] -> ([[a]], [a]) -> [a] -> ([[a]], [a])
update subs_dict (found, string) element =
    let
        indices = [i | i<-[0..length string-1], isPrefixOf element (drop i string)]
    in
        (found++ [take i string++x++drop (i+length element) string|x<-((Map.!) subs_dict element), i<-indices], string)

best_sub :: Map String [String] -> String -> [String]
best_sub inv_dict string =
    let
        elements = Map.keys inv_dict
        appears = [x | x<-elements, isInfixOf x string]
    in
        if appears == [] then if string=="e" then [string] else []
        else
             let
                --max = maximum [length x | x<-appears]
                best = appears -- [x | x<-appears, length x == max]
                indices x = [i | i<-[0..length string-1], isPrefixOf x (drop i string)]
            in
                concat [[take i string ++ (((Map.!) inv_dict x)!!0)++(drop (i+length x) string) | i<-indices x] | x<-best]

update_many :: Map String [String] -> [String] -> [String]
update_many inv_dict found = trace ((head found) ++ " " ++ (show $ length found)) take 1000 $ sortBy (\x y->compare (length x) (length y)) $ concat [best_sub inv_dict x | x<-found]

reverse_engineer :: Map [Char] [[Char]] -> [Char] -> [Char]
reverse_engineer subs_dict target =
    let
        values = concat $ Map.elems subs_dict
        appears = [x | x<-values, isInfixOf x target]
    in
        if appears == [] then target
        else
            let
                max = maximum [length [y | y<-x ,isUpper y] | x<-appears]--maximum [length x | x<-appears]
                best = [x | x<-appears, length [y | y<-x ,isUpper y] == max]--[x | x<-appears, length x == max]
                pres = [x | x<-Map.keys subs_dict, (intersect ((Map.!) subs_dict x) best) /= []]
                min = minimum [length x | x<-pres]
                best_pre = [x | x<-pres, length x == min]
                to_undo = head $ intersect ((Map.!) subs_dict (head best_pre)) best
                index = head [i | i<-[0..length target-1], isPrefixOf to_undo (drop i target)]
            in
                trace (target++" "++to_undo) (take index target)++(head best_pre)++(drop (index+length to_undo) target)

main :: IO ()
main = do
    grid <- lines <$> readFile "day19.txt"
    let
        subs = takeWhile (/="") grid
        subs_dict = foldl (\d x-> Map.insertWith (++) ((words x)!!0) [(words x)!!2] d) Map.empty subs
        inverse = foldl (\d x-> Map.insertWith (++) ((words x)!!2) [(words x)!!0] d) Map.empty subs
        string = last grid
        all_subs = fst $ foldl (update subs_dict) ([], string) (Map.keys subs_dict)
        till_found = takeWhile (\x->not (x=="e")) $ iterate (reverse_engineer subs_dict) string
        full_reverse = takeWhile (\x -> not (("e" `elem` x)||x==[])) $ iterate (update_many inverse) [string]
    print(length $ nub all_subs)
    --print(length full_reverse)
    print(length till_found)