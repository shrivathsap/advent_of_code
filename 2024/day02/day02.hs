import Data.List
import System.IO
import Control.Monad

is_decreasing :: (Ord n)=>[n]->Bool
is_decreasing [] = True --not needed, but here for completeness
is_decreasing [x] = True
is_decreasing (x:y:xs)
    |x<=y = False
    |otherwise = is_decreasing (y:xs)

is_increasing :: (Ord n)=>[n]->Bool
is_increasing [] = True --not needed, but here for completeness
is_increasing [x] = True
is_increasing (x:y:xs)
    |x>=y = False
    |otherwise = is_increasing (y:xs)

gradual_change :: (Integral n)=>[n]->Bool
gradual_change [] = True --not needed, but here for completeness
gradual_change [x] = True
gradual_change (x:y:xs)
    |abs(x-y)< 1 || abs(x-y)>3 = False
    |otherwise = gradual_change (y:xs)

--function to get all subsets obtained by removing one element, expects non empty list
one_short :: (Integral n)=>[n]->[[n]]
one_short [x, y] = [[x], [y]] --base case
--in [1, 2, 3], remove 1 to get [2, 3], and take subsets of [2, 3] and add 1 to those using a lambda function
one_short (x:xs) = [xs]++map(\y->[x]++y) (one_short xs)

positive :: (Integral n)=>[n]->Bool
positive num_list = gradual_change(num_list) && (is_decreasing(num_list)||is_increasing(num_list))

positive_lenient :: (Integral n)=>[n]->Bool
--if a list is already safe, then removing head should keep it safe
--if there's at least one element whose removal gives safe, then the list is safe
--this is not optimized...
positive_lenient num_list
    |length positives >= 1 = True
    |otherwise = False
    where
        positives = [1|x<-one_short num_list, positive x]
    
main = do
    let list = []
    handle <- openFile "day2.txt" ReadMode
    contents <- hGetContents handle
    let singlelines = lines contents
        --singlelines gives a list of lines
        --first apply words to each line using "map words singlelines"
        --this is a list of lists that looks like [["1", "2"], ["2", "4"], ["2", "3"]]
        --then apply read::String->Int, but the application has to be on the second layer, thus map.map
        list = (map.map)(read::String->Int)(map words singlelines)
        score = length [1|x<-list, positive x]
        score_lenient = length [1|x<-list, positive_lenient x]
    print score
    print score_lenient
    hClose handle