import System.IO
import qualified Data.Text as T
import qualified Data.Map as Map
import Data.Bits
import Data.Char

isInt :: String->Bool
isInt s = not(any (\x->not (isDigit x)) s)

update :: (Map.Map String Int, Map.Map String [String]) -> (Map.Map String Int, Map.Map String [String])
update (data_dict, inst_dict) =
    if inst_dict == Map.empty then (data_dict, inst_dict)
    else
        let
            check x pos = (isInt(((Map.!) inst_dict x)!!pos))||((((Map.!) inst_dict x)!!pos)`Map.member` data_dict)
            shift x
                |((Map.!) inst_dict x)!!1=="RSHIFT" = shiftR num_to_shift ((read::String->Int) (((Map.!) inst_dict x)!!2))
                |((Map.!) inst_dict x)!!1=="LSHIFT" = shiftL num_to_shift ((read::String->Int) (((Map.!) inst_dict x)!!2))
                where
                    num_to_shift = if isInt(((Map.!) inst_dict x)!!0) then ((read::String->Int)(((Map.!) inst_dict x)!!0)) else ((Map.!) data_dict (((Map.!) inst_dict x)!!0))
            f x = 
                let
                    op = ((Map.!) inst_dict x)!!1
                    left = if isInt(((Map.!) inst_dict x)!!0) then ((read::String->Int)(((Map.!) inst_dict x)!!0)) else ((Map.!) data_dict (((Map.!) inst_dict x)!!0))
                    right = if isInt(((Map.!) inst_dict x)!!2) then ((read::String->Int)(((Map.!) inst_dict x)!!2)) else ((Map.!) data_dict (((Map.!) inst_dict x)!!2))
                in
                    if op=="AND" then (.&.) left right
                    else  (.|.) left right
            bit_comp x = complement ((Map.!) data_dict (((Map.!) inst_dict x)!!1))
            done_nums = [x|x<-Map.keys inst_dict, length((Map.!) inst_dict x)==1,
                    isInt(((Map.!) inst_dict x)!!0)]
            done_vars = [x|x<-Map.keys inst_dict, length((Map.!) inst_dict x)==1,
                    ((((Map.!) inst_dict x)!!0)`Map.member` data_dict)]
            to_not = [x|x<-Map.keys inst_dict, length ((Map.!) inst_dict x) == 2, check x 1]
            to_shift = [x|x<-Map.keys inst_dict, length((Map.!) inst_dict x) == 3,
                     ((Map.!) inst_dict x)!!1 `elem` ["RSHIFT", "LSHIFT"], check x 0]
            to_compute = [x|x<-Map.keys inst_dict, length((Map.!) inst_dict x) == 3,
                     ((Map.!) inst_dict x)!!1 `elem` ["AND", "OR"], (check x 0)&&(check x 2)]
            to_add_nums = Map.fromList [(x, (read::String->Int) (((Map.!) inst_dict x)!!0) )|x<-done_nums]
            to_add_vars=  Map.fromList [(x, (Map.!) data_dict (((Map.!) inst_dict x)!!0))|x<-done_vars]
            notted = Map.fromList [(x, bit_comp x)|x<-to_not]
            shifted = Map.fromList [(x, shift x)|x<-to_shift]
            computed = Map.fromList [(x, f x)|x<-to_compute]
            updated = Map.union (Map.union (Map.union (Map.union (Map.union data_dict to_add_nums) to_add_vars) notted) shifted) computed
            removed = foldr (Map.delete) (foldr (Map.delete) (foldr (Map.delete) inst_dict to_not) to_shift) to_compute
        in
            (updated, removed)

            
main = do
    handle <- openFile "day07.txt" ReadMode
    contents <- hGetContents handle
    let
        inst_part =  map (map T.unpack) [T.splitOn (T.pack " ") (T.pack x)|x<-lines contents]
        inst_dict = Map.fromList [(last x, takeWhile (/="->") x)|x<-inst_part]
        data_dict = Map.empty
        (complete_dict, complete_inst) = head ((drop 350) (iterate update (data_dict, inst_dict)))
    print(length inst_part)
    print(complete_dict)