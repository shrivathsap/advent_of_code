import System.IO
import Text.Regex.TDFA
import Data.List (isInfixOf)
import qualified Data.Map as Map
import qualified Data.Maybe as Maybe

bots :: Map.Map Int [Int]
bots = Map.fromList []
outputs :: Map.Map Int [Int]
outputs = Map.fromList []

my_low = 17
my_high = 61

load :: RegexContext Regex p (AllTextMatches [] String) => Map.Map Int [Int] -> p -> Map.Map Int [Int]
load bot_list inst = 
    let
        nums = (map (read::String->Int))(getAllTextMatches(inst =~ "[0-9]+|-[0-9]+")::[String])
    in
        Map.insertWith (++) (nums!!1) [nums!!0] bot_list

check_bots :: Map.Map Int [Int] -> Bool
check_bots bot_list =
    let
        bots_with_two = [x | x<-Map.keys(bot_list), length(Maybe.fromJust(Map.lookup x bot_list)) == 2]
        low bot = 
            let values = Maybe.fromJust(Map.lookup bot bot_list)
            in min (values!!0) (values!!1)
        high bot =
            let values = Maybe.fromJust(Map.lookup bot bot_list)
            in max (values!!0) (values!!1)
        found = [x | x<-bots_with_two, (low x == my_low)&&(high x == my_high)]
    in
        if found==[] then False else True

transfer :: (Map.Map Int [Int], Map.Map Int [Int]) -> [Char] -> (Map.Map Int [Int], Map.Map Int [Int])
transfer (bot_list, output_list) inst = do
    let
        nums = (map (read::String->Int))(getAllTextMatches(inst =~ "[0-9]+|-[0-9]+")::[String])
        bot = nums!!0
        values = Maybe.fromJust (Map.lookup bot bot_list)
        low = (words inst)!!5 --I counted
        high = (words inst)!!10 --I counted
        low_value = min (values!!0) (values!!1)
        high_value = max (values!!0) (values!!1)
    if (low == "bot") && (high == "bot") then
        let
            b1 = Map.insertWith (++) (nums!!1) [low_value] bot_list
            b2 = Map.insertWith (++) (nums!!2) [high_value] b1
        in
            (Map.delete bot b2, output_list)
    else if (low == "bot") && (high == "output") then
        let
            b1 = Map.insertWith (++) (nums!!1) [low_value] bot_list
        in
            (Map.delete bot b1, Map.insertWith (++) (nums!!2) [high_value] output_list)
    else if (low == "output") && (high == "bot") then
        let
            b1 = Map.insertWith (++) (nums!!2) [high_value] bot_list
        in
            (Map.delete bot b1, Map.insertWith (++) (nums!!1) [low_value] output_list)
    else
        let
            o1 = Map.insertWith (++) (nums!!1) [low_value] output_list
            o2 = Map.insertWith (++) (nums!!2) [high_value] o1
        in
            (Map.delete bot bot_list, o2)


transfer_many :: ((Map.Map Int [Int], Map.Map Int [Int]), [String]) -> ((Map.Map Int [Int], Map.Map Int [Int]), [String])
transfer_many ((bot_list, output_list), insts_to_do) =
    let
        nums x = (map (read::String->Int))(getAllTextMatches(x =~ "[0-9]+|-[0-9]+")::[String])
        bots_with_two = [x | x<-Map.keys(bot_list), length(Maybe.fromJust(Map.lookup x bot_list)) == 2]
        current_insts = [x | x<-insts_to_do, (nums x)!!0 `elem` bots_with_two]
        rest = [x | x<-insts_to_do, not (x `elem` current_insts)]
    in
        (foldl transfer (bot_list, output_list) current_insts, rest)
            
check ((bot_list, output_list), insts) = check_bots bot_list

main = do
    handle <- openFile "day10.txt" ReadMode
    contents <- hGetContents handle
    let
        insts = lines contents
        loading_insts = [x | x<-insts, "value" `isInfixOf` x]
        transfer_insts = [x | x<-insts, not ("value" `isInfixOf` x)]
        loaded = foldl load bots loading_insts
    --print(loaded)
    print(head (dropWhile (\x -> not(check x)) (iterate transfer_many ((loaded, outputs), transfer_insts))))
    print(head (dropWhile (\x -> (snd x)/=[]) (iterate transfer_many ((loaded, outputs), transfer_insts))))