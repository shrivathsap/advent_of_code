import System.IO
import Text.Regex.TDFA

pattern1 = "mul\\([0-9]{1,3},[0-9]{1,3}\\)"
pattern2 = "mul\\([0-9]{1,3},[0-9]{1,3}\\)|do\\(\\)|don\'t\\(\\)"

dropLast = reverse.tail.reverse

--Haskell doesn't have a built in split function :(
split :: Eq a => a -> [a] -> [[a]]
split d [] = []
split d s = x : split d (drop 1 y) where (x,y) = span (/= d) s

--returns product of a list of numbers
mul :: [Int]->Int
mul [x] = x
mul (x:y) = x*mul(y)

--expects "mul(2, 3)" type strings, drops the first 4 to get "2, 3)"
--then dropLast gets rid of the last ")"
--then use a Lambda function to split at the comma
--then map read to it; defaults to Int output, so we get [2, 3], then mul
mul1 :: String->Int
mul1 string = (mul . map read . (\x->split ',' x) . dropLast) (drop 4 string)

--works as described; is a binary function on a (flag, num) pair and a string
conditional_sum :: (Bool, Int)->String->(Bool, Int)
conditional_sum (_, sum) "do()" = (True, sum)
conditional_sum (_, sum) "don't()" = (False, sum)
conditional_sum (False, sum) _ = (False, sum)
conditional_sum (True, sum) xs = (True, sum+mul1 xs)

--first applies the conditional_sum thing from the left and then returns the second element, i.e., the sum
sum2 :: [String]->Int
sum2 = snd . foldl conditional_sum (True, 0)

main = do
    handle <- openFile "day3.txt" ReadMode
    contents <- hGetContents handle
    print((sum . map mul1) (getAllTextMatches(contents =~ pattern1)::[String]))
    print(sum2 (getAllTextMatches(contents =~ pattern2)::[String]))
    hClose handle