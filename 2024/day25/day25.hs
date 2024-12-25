import System.IO
import Data.List

fits lock key rows cols = if ([(lock!!i)+(key!!i)|i<-[0..cols-1], (lock!!i)+(key!!i)>rows]==[]) then True else False

locks_and_keys items rows cols =
    let
        locks = [x|x<-items, x/=[""], (x!!0)!!0=='#']
        keys = [x|x<-items, x/=[""], (x!!0)!!0=='.']
        lock_heights = [[length[(x!!r)!!c|r<-[0..rows-1], (x!!r)!!c=='#']|c<-[0..cols-1]]|x<-locks]
        key_heights = [[length[(x!!r)!!c|r<-[0..rows-1], (x!!r)!!c=='#']|c<-[0..cols-1]]|x<-keys]
    in
        (lock_heights, key_heights)

part_one locks keys rows cols = [(x, y)|x<-locks, y<-keys, (fits x y rows cols)]

main = do
    handle <- openFile "day25.txt" ReadMode
    contents <- hGetContents handle
    let
        all_lines = lines contents
        items = groupBy (\x y->(x/="")&&(y/="")) all_lines
        rnum = 7
        cnum = 5
        (locks, keys) = locks_and_keys items rnum cnum
    print(length (part_one locks keys rnum cnum))
