import System.IO
import qualified Data.Map as Map

--modify :: Map.Map String Int -> [[String]] -> Map.Map String Int
modify (registers, insts, current_max) =
    let
        current_inst = head insts --will be [reg, operation, number, "if", reg, compare, number]
        reg_to_modify = current_inst !! 0
        operation = current_inst !! 1
        change = (read::String->Int) $ current_inst !! 2
        reg_to_check = current_inst !! 4
        value_to_check = registers Map.! reg_to_check --register is already in map, so shouldn't break
        compare = current_inst !! 5
        compare_against = (read::String->Int) $ current_inst !! 6
        to_change
            |compare==">" = value_to_check>compare_against
            |compare=="<" = value_to_check<compare_against
            |compare==">=" = value_to_check>=compare_against
            |compare=="<=" = value_to_check<=compare_against
            |compare=="==" = value_to_check==compare_against
            |compare=="!=" = value_to_check/=compare_against
        new_change = if to_change then change else 0
        new_registers
            |operation=="dec" = Map.adjust (\x->x-new_change) reg_to_modify registers
            |otherwise = Map.adjust (\x->x+new_change) reg_to_modify registers
        new_max = if (maximum $ Map.elems new_registers) > current_max then (maximum $ Map.elems new_registers)
                  else current_max
    in
        if insts == [] then (registers, [], current_max)
        else modify (new_registers, (tail insts), new_max)

main = do
    handle <- openFile "day08.txt" ReadMode
    contents <- hGetContents handle
    let
        instructions = map words $ lines contents
        registers = Map.fromList [(x!!0, 0) | x<-instructions]
        first (a, b, c) = a
        third (a, b, c) = c
        final_state = modify (registers, instructions, 0)
    print(maximum $ Map.elems $ first final_state, third final_state)