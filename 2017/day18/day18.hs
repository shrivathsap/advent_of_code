import System.IO
import qualified Data.Map as Map

data Prog = Prog {ptr::Int, registers::Map.Map String Int, out::[Int], inbox::[Int]}deriving(Show)

process :: ([String], Int, Map.Map String Int, [Int], [Int]) -> ([String], Int, Map.Map String Int, [Int], [Int])
process (insts, pointer, regs, sounds, recovered)
    |pointer<0 || pointer>length insts = (insts, pointer, regs, sounds, recovered)
    |cmd=="snd" = (insts, pointer+1, regs, sounds++[f reg], recovered)
    |cmd=="set" = (insts, pointer+1, Map.insert reg (f (inst!!2)) regs, sounds, recovered)
    |cmd=="add" = (insts, pointer+1, Map.insertWith (+) reg (f (inst!!2)) regs, sounds, recovered)
    |cmd=="mul" = (insts, pointer+1, Map.insertWith (*) reg (f (inst!!2)) regs, sounds, recovered)
    |cmd=="mod" = (insts, pointer+1, Map.insertWith (\x y->y`mod`x) reg (f (inst!!2)) regs, sounds, recovered)
    |cmd=="jgz" = 
        if (f reg > 0) then (insts, pointer+f(inst!!2), regs, sounds, recovered)
        else (insts, pointer+1, regs, sounds, recovered)
    |cmd=="rcv" =
        if (f reg > 0) then (insts, pointer+1, regs, sounds, recovered++[last sounds])
        else (insts, pointer+1, regs, sounds, recovered)                 
    where
        inst = words $ (insts !! pointer)
        cmd = inst!!0
        reg = inst!!1
        f x = if elem x (Map.keys regs) then ((Map.!) regs x)
              else (read::String->Int) x

halt :: [String] -> Prog -> Bool
halt insts prog= (ptr prog < 0)||(ptr prog > length insts)||((words $ (insts !! ptr prog))!!0=="rcv"&&(inbox prog ==[]))

process2 :: ([String], Prog) -> Prog
process2 (insts, prog)
    |pointer<0 || pointer>length insts = prog
    |cmd=="snd" = Prog (pointer+1) regs ((out prog)++[f reg]) (inbox prog)
    |cmd=="set" = Prog (pointer+1) (Map.insert reg (f (inst!!2)) regs) (out prog) (inbox prog)
    |cmd=="add" = Prog (pointer+1) (Map.insertWith (+) reg (f (inst!!2)) regs) (out prog) (inbox prog)
    |cmd=="mul" = Prog (pointer+1) (Map.insertWith (*) reg (f (inst!!2)) regs) (out prog) (inbox prog)
    |cmd=="mod" = Prog (pointer+1) (Map.insertWith (\x y->y`mod`x) reg (f (inst!!2)) regs) (out prog) (inbox prog)
    |cmd=="jgz" = 
        if (f reg > 0) then Prog (pointer+f(inst!!2)) regs (out prog) (inbox prog)
        else Prog (pointer+1) regs (out prog) (inbox prog)
    |cmd=="rcv" =
        if (inbox prog/=[]) then Prog (pointer+1) (Map.insert reg (head $ inbox prog) regs) (out prog) (tail (inbox prog))
        else prog
    where
        pointer = ptr prog
        regs = registers prog
        inst = words $ insts !! pointer
        cmd = inst!!0
        reg = inst!!1
        f x = if elem x (Map.keys regs) then ((Map.!) regs x) else (read::String->Int) x

duet :: ([String], Prog, Prog) -> ([String], Prog, Prog)
duet (insts, progA, progB) = (insts, Prog new_ptrA new_regsA new_outA new_inA, Prog new_ptrB new_regsB new_outB new_inB)
    where
        (ptrA, regsA, outA, inA) = (ptr progA, registers progA, out progA, inbox progA)
        (ptrB, regsB, outB, inB) = (ptr progB, registers progB, out progB, inbox progB)
        instA = words $ insts !! ptrA
        instB = words $ insts !! ptrB
        (cmdA, regA) = (instA !! 0, instA !! 1)
        (cmdB, regB) = (instB !! 0, instB !! 1)
        fA x = if elem x (Map.keys regsA) then ((Map.!) regsA x) else (read::String->Int) x
        fB x = if elem x (Map.keys regsB) then ((Map.!) regsB x) else (read::String->Int) x
        --process a step for both programs
        newA = process2(insts, progA)
        newB = process2(insts, progB)
        (new_ptrA, new_regsA, new_outA) = (ptr newA, registers newA, out newA)
        (new_ptrB, new_regsB, new_outB) = (ptr newB, registers newB, out newB)
        new_inA = if cmdB=="snd" then (inbox newA)++[fB regB] else (inbox newA)
        new_inB = if cmdA=="snd" then (inbox newB)++[fA regA] else (inbox newB)

main = do
    input <- lines <$> readFile "day18.txt"
    let
        fifth (a, b, c, d, e) = e
        statesA = Map.fromList [("a", 0), ("b", 0), ("f", 0), ("i", 0), ("p", 0)]
        statesB = Map.fromList [("a", 0), ("b", 0), ("f", 0), ("i", 0), ("p", 1)]
        init_state = (input, 0, statesA, [], [])
        pA = Prog 0 statesA [] []
        pB = Prog 0 statesB [] []
        part_one = fifth $ head $ dropWhile (\x->(fifth x==[])) $ iterate process init_state
        part_two = head $ dropWhile (\(_, a, b)->not(halt input a && halt input b)) $ iterate duet (input, pA, pB)
    print(part_one)
    print(length $ out $ (\(x, y, z)->z) part_two)