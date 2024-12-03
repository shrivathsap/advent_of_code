import Data.List
import System.IO
import Control.Monad

evenList :: (Integral n) => n->[n]
evenList n = [x|x<-[0..n], even x]

oddList :: (Integral n) => n->[n]
oddList n = [x|x<-[0..n], odd x]

score :: (Integral n) => n->[n]->Int
score n xs = length [i|i<-xs, i==n]

quicksort :: (Ord a)=>[a]->[a]
quicksort [] = []
quicksort (x:xs) = 
    let smallerSorted = quicksort [a|a<-xs, a<x]
        biggerSorted = quicksort [a|a<-xs, a>x]
    in smallerSorted ++ [x] ++ [i|i<-xs, i==x] ++ biggerSorted

main = do
    let list = []
    handle <- openFile "day1.txt" ReadMode
    contents <- hGetContents handle
    let singlewords = words contents
        list = singlewords
        l = length list-1
        list1 = quicksort (map (read::String->Int) [list!!i|i<-evenList l])
        list2 = quicksort (map (read::String->Int) [list!!i|i<-oddList l])
        score_list = [score (list1!!i) list2 | i<-[0..(((l+1)`div` 2)-1)]]
        total_dist = sum [abs(list1!!i-list2!!i)|i<-[0..(l+1)`div`2-1]]
        similarity_score = sum [(list1!!i)*(score_list!!i)|i<-[0..(l+1)`div`2-1] ]
    print total_dist
    print similarity_score        
    hClose handle
    