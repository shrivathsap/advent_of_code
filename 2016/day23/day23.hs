import System.IO
import Data.Char

import Debug.Trace

data Comp = Comp {prog::[String],
                  inst_ptr::Int,
                  regs::[Int]} deriving (Show)--although allows variable size, regs has length 4

ltn :: Num a => String -> a
ltn x
    |x=="a" = 0
    |x=="b" = 1
    |x=="c" = 2
    |x=="d" = 3
    |otherwise = -1

cpy :: String -> String -> Comp -> Comp
cpy x y c
    |not(isLetter (y!!0)) = Comp (prog c) ((inst_ptr c) + 1) (regs c) --move on
    |(isLetter (x!!0)) = Comp (prog c) ((inst_ptr c) + 1) ((take (ltn y) (regs c)) ++[(regs c)!!(ltn x)]++(drop (ltn y+1) (regs c)))
    |otherwise = Comp (prog c) ((inst_ptr c) + 1) ((take (ltn y) (regs c)) ++[read x::Int]++(drop (ltn y+1) (regs c)))

inc :: String -> Comp -> Comp
inc x c = Comp (prog c) ((inst_ptr c) + 1) ((take (ltn x) (regs c)) ++[(regs c)!!(ltn x)+1]++(drop (ltn x+1) (regs c)))

dec :: String -> Comp -> Comp
dec x c = Comp (prog c) ((inst_ptr c) + 1) ((take (ltn x) (regs c)) ++[(regs c)!!(ltn x)-1]++(drop (ltn x+1) (regs c)))

jnz :: String -> String -> Comp -> Comp
jnz x y c --this time y could be a letter
    |(isLetter (x!!0)) =
        if (regs c)!!(ltn x) == 0 then Comp (prog c) (inst_ptr c +1) (regs c)
        else Comp (prog c) (inst_ptr c + jump_amount) (regs c)
    |otherwise =
        if (read x::Int) == 0 then Comp (prog c) (inst_ptr c +1) (regs c)
        else Comp (prog c) (inst_ptr c + jump_amount) (regs c)
    where
        jump_amount =
            if (isLetter (y!!0)) then (regs c)!!(ltn y)
            else (read y::Int)

modify :: [String] -> Int -> [Char] -> [String]
modify insts ptr new_cmd =
    let
        previous = take ptr insts
        to_modify = insts!!ptr
        next = drop (ptr+1) insts
        new = new_cmd++(drop 3 to_modify)
    in
        previous++[new]++next

tgl :: [Char] -> Comp -> Comp
tgl x c =
    let
        jmp_amt = (regs c)!!(ltn x) --expects x to be a letter
        next_ptr = (inst_ptr c)+jmp_amt
        cmd_to_edit =
            if next_ptr<(length $ prog c) then (words $ (prog c)!!next_ptr)!!0
            else "skp" --skip
        new_cmd
            |cmd_to_edit=="inc" = "dec"
            |cmd_to_edit=="dec" = "inc"
            |cmd_to_edit=="tgl" = "inc"
            |cmd_to_edit=="cpy" = "jnz"
            |cmd_to_edit=="jnz" = "cpy"
            |cmd_to_edit=="skp" = "skp"
    in
        if new_cmd=="skp" then (Comp (prog c) (inst_ptr c + 1) (regs c))
        else (Comp (modify (prog c) next_ptr new_cmd) (inst_ptr c + 1) (regs c))


process :: Comp -> Comp
process c
    |(inst_ptr c >= (length (prog c))) = c
    |inst == "cpy" = cpy (parts!!1) (parts!!2) c
    |inst == "inc" = inc (parts!!1) c
    |inst == "dec" = dec (parts!!1) c
    |inst == "jnz" = jnz (parts!!1) (parts!!2) c
    |otherwise = tgl (parts!!1) c
    where
        parts = words (prog c !! inst_ptr c)
        inst = parts!!0

fact n
    |n==0 = 1
    |otherwise = n*(fact (n-1))

main = do
    handle <- openFile "day23.txt" ReadMode
    --day23_mod is obtained by changing the tgl to inc, and toggling all future instructions an even space away from tgl
    contents <- hGetContents handle
    let
        c = Comp (lines contents) 0 [7, 0, 0, 0] --part one
        -- c = Comp (lines contents) 17 [fact 12, 0, 0, 0] --part two
        future = iterate process c
        final = head(dropWhile (\x -> (inst_ptr x)<(length (prog x))) future)
    print(final)