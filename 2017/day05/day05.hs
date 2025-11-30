import System.IO
import qualified Data.Map as Map
import Data.Maybe (fromJust)

modify_list (current_list, current_pos, step) =
    let
        jump = current_list !! current_pos
        new_list = (take (current_pos) current_list)++[jump+1]++(drop (current_pos+1) current_list)
    in
        (new_list, current_pos+jump, step+1)

modify_list2::(Map.Map Int Int, Int, Int)->(Map.Map Int Int, Int, Int)
modify_list2 (current_list, current_pos, step) =
    let
        jump = fromJust (Map.lookup current_pos current_list)
        new_jump = if jump>=3 then jump-1 else jump+1
        new_list = Map.adjust (\x->new_jump) current_pos current_list
    in
        (new_list, current_pos+jump, step+1)

main = do
    handle <- openFile "day05.txt" ReadMode
    contents <- hGetContents handle
    let
        jumps = map (read::String->Int) $ lines contents
        mapped_jumps = Map.fromList [(n, jumps!!n) | n<-[0..length jumps-1]]
        last_step = until (\(a, b, c)-> (b<0||b>(length a-1))) modify_list (jumps, 0, 0)
        last_step2 = until (\(a, b, c)-> (b<0||b>(length a-1))) modify_list2 (mapped_jumps, 0, 0)
        third (a, b, c) = c
    print(third last_step)
    print(third last_step2)
