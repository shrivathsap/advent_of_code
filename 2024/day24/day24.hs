import System.IO
import qualified Data.Map as Map
import qualified Data.Text as T
import Data.List
import Data.Bits

convert :: String -> Int
convert [] = 0
convert s = ((read::String->Int) (take 1 s))*(2^ (length s-1))+ convert (tail s)

evaluate data_dict = 
    let
        sorted = [x|x<-sort (Map.keys data_dict), head x == 'z']
        string = concat [show (data_dict Map.! x)|x<-reverse(sorted)]
    in
        convert string

update :: (Map.Map String Int, Map.Map String [String]) -> (Map.Map String Int, Map.Map String [String])
update (data_dict, inst_dict) =
    if inst_dict == Map.empty then (data_dict, inst_dict)
    else
        let
            f bit1 bit2 op
                |op=="AND" = (.&.) (data_dict Map.! bit1) (data_dict Map.! bit2)
                |op=="OR" = (.|.) (data_dict Map.! bit1) (data_dict Map.! bit2)
                |op=="XOR" = (data_dict Map.! bit1) `xor` (data_dict Map.! bit2)
            doable = [x|x<-Map.keys inst_dict, (((inst_dict Map.! x)!!0 `Map.member` data_dict))&&(((inst_dict Map.! x)!!1 `Map.member` data_dict))]
            to_add = Map.fromList [(x, f ((inst_dict Map.! x)!!0) ((inst_dict Map.! x)!!1) ((inst_dict Map.! x)!!2))|x<-doable]
            to_remove = Map.fromList [(x, inst_dict Map.! x)|x<-doable]
        in
            (Map.union data_dict to_add, Map.difference inst_dict to_remove)

part_one data_dict inst_dict =
    let
        final_values = head (dropWhile (\(x, y)-> (y/= Map.empty)) (iterate update (data_dict, inst_dict)))
    in
        evaluate (fst final_values)

main = do
    handle <- openFile "day24.txt" ReadMode
    contents <- hGetContents handle
    let
        all_lines = lines contents
        data_part = takeWhile (/="") all_lines
        inst_part =  map (map T.unpack) [T.splitOn (T.pack " ") (T.pack x)|x<-tail(dropWhile (/="") all_lines)]
        data_dict = Map.fromList [(takeWhile (/=':') x, (read::String->Int) (dropWhile (/=' ') x))|x<-data_part]
        inst_dict = Map.fromList [(x!!4, [x!!0, x!!2, x!!1])|x<-inst_part]
    print(part_one data_dict inst_dict)