import Data.Bits (Xor(Xor), Bits (xor))
import Data.Char (digitToInt)
import Data.List (foldl')

data Comp = Comp {prog::[Int], inst_ptr::Int, regA::Int, regB::Int, regC::Int, output::String} deriving Show

bin 0 = "000"
bin 1 = "001"
bin 2 = "010"
bin 3 = "011"
bin 4 = "100"
bin 5 = "101"
bin 6 = "110"
bin 7 = "111"

inv_bin "000" = 0
inv_bin "001" = 1
inv_bin "010" = 2
inv_bin "011" = 3
inv_bin "100" = 4
inv_bin "101" = 5
inv_bin "110" = 6
inv_bin "111" = 7

toDec :: String -> Int
toDec = foldl' (\acc x -> acc * 2 + digitToInt x) 0

operand ::Comp->Int
operand c = (prog c)!!(inst_ptr c+1)

combo :: Comp -> Int
combo c
    |bit`elem`[0, 1, 2, 3] = bit
    |bit==4 = regA c
    |bit==5 = regB c
    |bit==6 = regC c
    |otherwise = error "7"
    where
        bit = operand c

adv :: Comp -> Comp
adv c = Comp (prog c) (inst_ptr c+2)  (regA c `div` 2^(combo c)) (regB c) (regC c) (output c)

bxl :: Comp->Comp
bxl c = Comp (prog c) (inst_ptr c+2)  (regA c) ((regB c) `xor` (operand c)) (regC c) (output c)

bst :: Comp -> Comp
bst c = Comp (prog c) (inst_ptr c+2)  (regA c) ((combo c)`mod`8) (regC c) (output c)

jnz :: Comp -> Comp
jnz c = Comp (prog c) (if regA c == 0 then inst_ptr c+2 else operand c) (regA c) (regB c) (regC c) (output c)

bxc :: Comp -> Comp
bxc c = Comp (prog c) (inst_ptr c+2)  (regA c) (regB c `xor` regC c) (regC c) (output c)

out :: Comp -> Comp
out c = Comp (prog c) (inst_ptr c+2)  (regA c) (regB c) (regC c) (output c++","++(show ((combo c)`mod`8)))

bdv :: Comp -> Comp
bdv c =  Comp (prog c) (inst_ptr c+2)  (regA c) (regA c `div` 2^(combo c)) (regC c) (output c)

cdv :: Comp -> Comp
cdv c = Comp (prog c) (inst_ptr c+2)  (regA c) (regB c) (regA c `div` 2^(combo c)) (output c)

read_inst :: Int -> Comp -> Comp
read_inst 0 = adv
read_inst 1 = bxl
read_inst 2 = bst
read_inst 3 = jnz
read_inst 4 = bxc
read_inst 5 = out
read_inst 6 = bdv
read_inst 7 = cdv

step :: (Comp, Bool)->(Comp, Bool)
step (c, b) =
    let
        len = length (prog c)
        i = inst_ptr c
    in
        if (i>len-1||b==False) then (c, False)
        else
            let current_inst = (prog c)!!i
            in
                ((read_inst current_inst) c, b)

--string is reverse of what is to be matched, so taking from front and reversing
to_xor :: [Char] -> Int -> [Char]
to_xor string num = 
    let
        xnum = num `xor` 1
    in
        if xnum>3 then (concat (replicate (3-(length (take 3(drop (xnum-3) string)))) "0"))++reverse(take 3(drop (xnum-3) string))
        else if xnum==3 then (concat (replicate (3-(length (take 3 string))) "0"))++reverse(take 3 string)
        else if xnum==2 then (concat (replicate (2-(length (take 2 string))) "0"))++reverse(take 2 string)++(take 1 (bin num))
        else if xnum==1 then (concat (replicate (1-(length (take 1 string))) "0"))++(take 1 string)++(take 2 (bin num))
        else bin num

--target_string is the output to be matched, but in reverse
rev_engine::([String], String)->([String], String)
rev_engine (sol_list, target_string) =
    if target_string == "" then (sol_list, "")
    else
        let
            target = (read::String->Int)(take 1 target_string)
            f sol = [b|b<-[0..7], (((b`xor`4)`xor` (inv_bin(to_xor sol b)))==target)]
        in
            --drop 2 for the leading number in 0..7 and for the comma after
            ([(reverse(bin b))++sol|sol<-sol_list, b<-(f sol), (f sol/=[])], drop 2 target_string)

main = do
    let
        initial = Comp [] 0  0 0 0 ""
        len = length []
        run = takeWhile (\x-> snd x) (iterate step (initial, True))
        partOne = tail(output (fst (last run)))
        target_string = ""
        all_solutions = [reverse x|x<-fst(rev_engine(last(takeWhile (\x->(snd x/="")) (iterate rev_engine ([""], reverse target_string)))))]
        partTwo = minimum [toDec x|x<-all_solutions]
    print(partOne)
    print(partTwo)