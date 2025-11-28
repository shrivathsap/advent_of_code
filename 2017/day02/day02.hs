import System.IO

find_diff::String->Int
find_diff row =
    let
        entries = map (read::String->Int) $ words row
    in
        maximum entries - minimum entries

find_quot::String->Int
find_quot row =
    let
        entries = map (read::String->Int) $ words row
        multiples_of n = [x | x<-entries, x/=n, x`mod`n==0]
        wanted_pair = [(n, multiples_of n) | n<-entries, (multiples_of n)/=[]]
    in
        (snd(wanted_pair!!0)!!0)`div` fst(wanted_pair!!0)

main = do
    handle <- openFile "day02.txt" ReadMode
    contents <- hGetContents handle
    let
        rows = lines contents
    print(sum(map find_diff rows))
    print(sum(map find_quot rows))