import System.IO
import qualified Data.Map as Map
import Debug.Trace

is_prime num = all (/= 0) [num`mod`x | x<-[2..(num-1)]] --input is small enough

process (insts, pointer, regs, count)
    --Map.insertWith f k a m will make m at k be f new_value old_value, so f=subtraction replaces it with new-old
    |pointer<0 || pointer>=length insts = (insts, pointer, regs, count)
    |cmd=="set" = (insts, pointer+1, Map.insert reg (f (inst!!2)) regs, count)
    |cmd=="sub" = (insts, pointer+1, Map.insertWith (+) reg (-1*(f (inst!!2))) regs, count)
    |cmd=="mul" = (insts, pointer+1, Map.insertWith (*) reg (f (inst!!2)) regs, count+1)
    |cmd=="jnz" = 
        if (f reg /= 0) then (insts, pointer+f(inst!!2), regs, count)
        else (insts, pointer+1, regs, count)                
    where
        inst = words $ (insts !! pointer)
        cmd = inst!!0
        reg = inst!!1
        f x = if elem x (Map.keys regs) then ((Map.!) regs x)
              else (read::String->Int) x

part_two = length [x | x<-[b..c], ((x-b)`mod`17==0)&&(not $ is_prime x)]
    where
        b = (84*100)+100000
        c = (84*100)+100000+17000

main = do
    input <- lines <$> readFile "day23.txt"
    let
        fourth (a, b, c, d) = d
        second (a, b, c, d) = b
        inst_max = length input
        init_regs = Map.fromList [("a", 0), ("b", 0), ("c", 0), ("d", 0), ("e", 0), ("f", 0), ("g", 0), ("h", 0)]
        init_state = (input, 0, init_regs, 0)
        -- part_one = (iterate process init_state)!!60000
        part_one = fourth $ head $ dropWhile (\x->((second x)>=0&&(second x)<inst_max)) $ iterate process init_state
    print(part_one)
    print(part_two)