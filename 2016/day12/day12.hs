import System.IO
import Data.Char

data Comp = Comp {prog::[String], inst_ptr::Int, regs::[Int]} deriving (Show)--although allows variable size, regs has length 4

ltn :: Num a => String -> a
ltn x
    |x=="a" = 0
    |x=="b" = 1
    |x=="c" = 2
    |x=="d" = 3
    |otherwise = -1

cpy :: String -> String -> Comp -> Comp
cpy x y c
    |(isLetter (x!!0)) = Comp (prog c) ((inst_ptr c) + 1) ((take (ltn y) (regs c)) ++[(regs c)!!(ltn x)]++(drop (ltn y+1) (regs c)))
    |otherwise = Comp (prog c) ((inst_ptr c) + 1) ((take (ltn y) (regs c)) ++[read x::Int]++(drop (ltn y+1) (regs c)))

inc :: String -> Comp -> Comp
inc x c = Comp (prog c) ((inst_ptr c) + 1) ((take (ltn x) (regs c)) ++[(regs c)!!(ltn x)+1]++(drop (ltn x+1) (regs c)))

dec :: String -> Comp -> Comp
dec x c = Comp (prog c) ((inst_ptr c) + 1) ((take (ltn x) (regs c)) ++[(regs c)!!(ltn x)-1]++(drop (ltn x+1) (regs c)))

jnz :: String -> String -> Comp -> Comp
jnz x y c
    |(isLetter (x!!0)) =
        if (regs c)!!(ltn x) == 0 then Comp (prog c) (inst_ptr c +1) (regs c)
        else Comp (prog c) (inst_ptr c + (read y::Int)) (regs c)
    |otherwise =
        if (read x::Int) == 0 then Comp (prog c) (inst_ptr c +1) (regs c)
        else Comp (prog c) (inst_ptr c + (read y::Int)) (regs c)

process :: Comp -> Comp
process c
    |(inst_ptr c >= (length (prog c))) = c
    |inst == "cpy" = cpy (parts!!1) (parts!!2) c
    |inst == "inc" = inc (parts!!1) c
    |inst == "dec" = dec (parts!!1) c
    |otherwise = jnz (parts!!1) (parts!!2) c
    where
        parts = words (prog c !! inst_ptr c)
        inst = parts!!0
        

main = do
    handle <- openFile "day12.txt" ReadMode
    contents <- hGetContents handle
    let
        c = Comp (lines contents) 0 [0, 0, 0, 0]
        d = Comp (lines contents) 0 [0, 0, 1, 0]
        future = iterate process c
        future2 = iterate process d
        final = head(dropWhile (\x -> (inst_ptr x)<(length (prog x))) future)
        final2 = head(dropWhile (\x -> (inst_ptr x)<(length (prog x))) future2)
    print(final)
    print(final2)