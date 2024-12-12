import System.IO
import Data.Set as Data
import Data.List

one_step:: (Int, Int)->Int->Int->[(Int, Int)]
one_step (x, y) rows cols = [n|n<-[(x-1, y), (x, y+1), (x+1, y), (x, y-1)], 0<= fst n, fst n<rows, 0<= snd n, snd n<cols]

fixed_point :: (Eq a)=>(a->a)->a->a
fixed_point f x =
    if ((f x) == x) then x
    else fixed_point f (f x)

update :: [[Char]]->Int->Int->[(Int, Int)]->[(Int, Int)]
update grid rows cols region =
    if region == [] then []
    else
        let
            label = (grid!!(fst rnd)!!(snd rnd)) where rnd = head region
            to_add = concat [[n|n<-(one_step x rows cols), ((grid!!fst n)!!snd n) == label]|x<-region]
        in
            nub (region++to_add)

cost :: [(Int, Int)]->Int
cost region=
    let
        area = length region
        perimeter = sum [length [n|n<-[(x-1, y), (x, y+1), (x+1, y), (x, y-1)], not (n `elem` region)]|(x, y)<-region]
    in
        area*perimeter

is_corner :: [(Int, Int)]->(Int, Int)->Int->Int->(Bool, Int)
is_corner region place rows cols =
    let
        neighbours = [(x, y)|(x, y)<-(one_step place rows cols), ((x, y)`elem` region)]
        x = fst place
        y = snd place
    in
        if (length neighbours == 4)||(length neighbours == 3) then (False, 0)
        else if (length neighbours == 2) then
            let
                n1 = neighbours!!0
                n2 = neighbours!!1
            in
                if (fst n1 == fst n2)||(snd n1 == snd n2) then (False, 0)
                else let
                    ver = head [n|n<-neighbours, snd n == y]
                    hor = head [n|n<-neighbours, fst n == x]
                    diag = if ((x- fst ver)*(y-snd hor) == 1) then [n|n<-[(x-1, y+1), (x+1, y-1)], n`elem`region, 0<= fst n, fst n<rows, 0<= snd n, snd n<cols] else [n|n<-[(x+1, y+1), (x-1, y-1)], n`elem`region, 0<= fst n, fst n<rows, 0<= snd n, snd n<cols]
                in
                    if (length diag == 0) then (True, -2)
                    else if (length diag == 1) then (True, 0)
                    else (True, 2)
        else if (length neighbours == 1) then
            let
                parent = head neighbours
                corners = if (fst parent == x) then [n|n<-[(fst parent-1, snd parent), (fst parent+1, snd parent)], n`elem`region, 0<= fst n, fst n<rows, 0<= snd n, snd n<cols] else [n|n<-[(fst parent, snd parent-1), (fst parent, snd parent+1)], n`elem`region, 0<= fst n, fst n<rows, 0<= snd n, snd n<cols]
            in
                if (length corners == 0) then (True, 0)
                else if (length corners == 1) then (True, 2)
                else (True, 4)
        else (True, 4)

sides :: [(Int, Int)] -> Int -> Int -> Int
sides region rows cols =
    if region == [] then 0
    else
        if length region == 1 then 4
        else
            let
                to_remove = head (dropWhile (\x-> not(fst (is_corner region x rows cols))) region)
                change = snd (is_corner region to_remove rows cols)
            in
                change+(sides (Data.List.filter (/=to_remove) region) rows cols)


all_regions :: [[Char]] -> [(Int, Int)] -> [(Int, Int)] -> [[(Int, Int)]] -> Int -> Int -> [[(Int, Int)]]
all_regions grid positions_seen positions_unseen regions rows cols =
    if (length positions_unseen == 0) then regions
    else
        let
            new_region = fixed_point (update grid rows cols) [head positions_unseen]
        in
            all_regions grid (positions_seen++new_region) [x|x<-positions_unseen, not (x `elem` new_region)] (regions++[new_region]) rows cols

main = do
    handle <- openFile "day12.txt" ReadMode
    contents <- hGetContents handle
    let 
        grid = lines contents
        rnum = length grid
        cnum = length (grid!!0)
        a = all_regions grid [] [(x, y)|x<-[0..rnum-1], y<-[0..cnum-1]] [] rnum cnum
    print(length a)
    print(sum [cost x|x<-a])
    print(sum [length x*(sides x rnum cnum)|x<-a])
