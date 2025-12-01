import System.IO

rot::(Int, [String], Int, Int) -> (Int, [String], Int, Int)
rot (pointer, insts, count, count2) =
    let
        current_inst = head insts --looks like "L44"
        dir = head current_inst
        amt = (read::String->Int) $ tail current_inst
        new_pointer
            |dir=='L' = (pointer-amt)
            |otherwise = (pointer+amt)
        new_count = if (new_pointer`mod`100) == 0 then count+1 else count
        new_count2 = if new_pointer>99 then count2+(new_pointer`div`100)
                     else if new_pointer<=0&&pointer>0 then count2+1+((-1*new_pointer)`div`100)
                     else if new_pointer<=0 then count2+((-1*new_pointer)`div`100)
                     else count2
    in
        if insts == [] then (pointer, [], count, count2)
        else rot (new_pointer`mod`100, tail insts, new_count, new_count2)

main = do
    handle <- openFile "day01.txt" ReadMode
    contents <- hGetContents handle
    let
        insts = lines contents
    print(rot (50, insts, 0, 0))