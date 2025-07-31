import System.IO
import qualified Data.Sequence as Seq

my_move :: Seq.Seq a -> Int -> Int -> Seq.Seq a
my_move seq a b
    |a<b = Seq.deleteAt a (Seq.insertAt (b+1) letter seq)
    |otherwise = Seq.deleteAt (a+1) (Seq.insertAt (b) letter seq)
    where
        letter = seq `Seq.index` a --kind of unsafe; expects a to be within range

my_reverse :: Seq.Seq a -> Int -> Int -> Seq.Seq a
my_reverse seq a b = (Seq.take a seq) Seq.>< (Seq.reverse $ Seq.take (b-a+1) (Seq.drop a seq)) Seq.>< (Seq.drop (b+1) seq)

swap_pos :: Seq.Seq a -> Int -> Int -> Seq.Seq a
swap_pos seq a b =
    let
        let1 = seq `Seq.index` a
        let2 = seq `Seq.index` b
    in
        Seq.update b let1 (Seq.update a let2 seq)

swap_letter :: Eq b => Seq.Seq b -> b -> b -> Seq.Seq b
swap_letter seq a b =
    let
        f index x
            |x==a = b
            |x==b = a
            |otherwise = x
    in
        Seq.mapWithIndex f seq --mapWithIndex takes a function that depends on the index, but I want to swap all

rotate :: (Num t, Ord t) => Seq.Seq a -> t -> Seq.Seq a
rotate seq num --rotate right
    |num==0 = seq
    |num==1 = (Seq.drop (Seq.length seq - 1) seq) Seq.>< (Seq.take (Seq.length seq - 1) seq)
    |num==(-1) = (Seq.drop 1 seq) Seq.>< (Seq.take 1 seq)
    |num>0 =  rotate ((Seq.drop (Seq.length seq - 1) seq) Seq.>< (Seq.take (Seq.length seq - 1) seq)) (num-1)
    |otherwise = rotate ((Seq.drop 1 seq) Seq.>< (Seq.take 1 seq)) (num+1)

rotate_pos :: Eq a => Seq.Seq a -> a -> Seq.Seq a
rotate_pos seq letter =
    let
        num = head(Seq.findIndicesL (==letter) seq) --find all indices - there's only one. don't want to deal with Maybe
    in
        if (num < 4) then rotate seq (num+1)
        else rotate seq (num+2)

rotate_pos_opp :: Eq a => Seq.Seq a -> a -> Seq.Seq a
rotate_pos_opp seq letter =
    let
        num = head(Seq.findIndicesL (==letter) seq) --find all indices - there's only one. don't want to deal with Maybe
        rot 1 = 0
        rot 3 = 1
        rot 5 = 2
        rot 7 = 3
        rot 2 = 4
        rot 4 = 5
        rot 6 = 6
        rot 0 = 7
    in
        if ((rot num) < 4) then rotate seq (-1*((rot num)+1))
        else rotate seq (-1*((rot num)+2))

scramble :: Seq.Seq Char -> [Char] -> Seq.Seq Char
scramble seq inst =
    let
        parts = words inst
    in
        if parts!!0=="move" then
            my_move seq (read (parts!!2)::Int) (read(parts!!5)::Int)
        else if (parts!!0=="swap") && (parts!!1=="position") then
            swap_pos seq (read (parts!!2)::Int) (read(parts!!5)::Int)
        else if (parts!!0=="swap" ) && (parts!!1=="letter") then
            swap_letter seq ((parts!!2)!!0) ((parts!!5)!!0)
        else if (parts!!0=="rotate") && (parts!!1=="left") then
            rotate seq (-1 * (read (parts!!2)::Int))
        else if (parts!!0=="rotate") && (parts!!1=="right") then
            rotate seq (read (parts!!2)::Int)
        else if (parts!!0=="rotate") && (parts!!1=="based") then
            rotate_pos seq ((last parts)!!0)
        else if (parts!!0=="reverse") then
             my_reverse seq (read (parts!!2)::Int) (read(parts!!4)::Int)
        else
            seq

unscramble :: Seq.Seq Char -> [Char] -> Seq.Seq Char
unscramble seq inst =
    let
        parts = words inst
    in
        if parts!!0=="move" then
            my_move seq (read(parts!!5)::Int) (read (parts!!2)::Int)
        else if (parts!!0=="swap") && (parts!!1=="position") then
            swap_pos seq (read(parts!!5)::Int) (read (parts!!2)::Int)
        else if (parts!!0=="swap" ) && (parts!!1=="letter") then
            swap_letter seq ((parts!!5)!!0) ((parts!!2)!!0)
        else if (parts!!0=="rotate") && (parts!!1=="left") then
            rotate seq ((read (parts!!2)::Int))
        else if (parts!!0=="rotate") && (parts!!1=="right") then
            rotate seq (-1 * read (parts!!2)::Int)
        else if (parts!!0=="rotate") && (parts!!1=="based") then
            rotate_pos_opp seq ((last parts)!!0)
        else if (parts!!0=="reverse") then
             my_reverse seq (read (parts!!2)::Int) (read(parts!!4)::Int)
        else
            seq


main = do
    handle <- openFile "day21.txt" ReadMode
    contents <- hGetContents handle
    let
        insts = lines contents
        pwd = Seq.fromList "abcdefgh"
        pwd2 = Seq.fromList "fbgdceah"
        scrambled = foldl scramble pwd insts
        unscrambled = foldl unscramble pwd2 (reverse insts)
    -- print(map (\n -> foldl scramble pwd (take n (insts))) [0..100])
    -- print(map (\n -> foldl unscramble pwd2 (take n (reverse insts))) [0..100])
    print(scrambled)
    print(unscrambled)