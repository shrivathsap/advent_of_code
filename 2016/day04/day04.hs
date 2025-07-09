import System.IO
import Data.Char
import Data.List
import Data.Ord

shift_cipher num char --expecting only lower case letters or hyphen
    |char=='-' = '-'
    |otherwise = chr (ord 'a' + ((ord char + num - ord 'a') `mod` 26))

check :: [Char] -> Bool
check str =
    let
        letters = takeWhile (not.isDigit) str
        checksum = reverse (drop 1 (take 6 (reverse str)))
        sorted_letters = dropWhile (not.isLetter) (sort (letters))--remove hyphens
        ordered_by_freq = reverse (sortBy (comparing length) (group (sorted_letters)))--most to least frequent
        sorted_ordered_by_freq = concat (map sort (groupBy (\x y -> (length x == length y)) (ordered_by_freq)))
    in
        take 5 (nub (concat sorted_ordered_by_freq)) == checksum

sectorID :: [Char] -> Int
sectorID str = read(takeWhile (isDigit) (dropWhile (not.isDigit) str))::Int

decrypt :: [Char] -> [Char]
decrypt str =
    let
        shift = (sectorID str) `mod` 26
        encrypted = takeWhile (not.isDigit) str
    in
        (map (shift_cipher shift) encrypted)++(show (sectorID str))

main = do
    handle <- openFile "day04.txt" ReadMode
    contents <- hGetContents handle
    let
        codes = lines contents
        correct = [x|x<-codes, check x]
        sectorIDs = map sectorID correct
        decrypted = map decrypt correct
        north_pole = [x|x<-decrypted, isInfixOf "north" x]
    print (sum sectorIDs)
    print (north_pole)