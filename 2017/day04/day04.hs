import System.IO
import Data.List (nub, sort)

valid :: String -> Bool
valid phrase = (nub $ words phrase) == words phrase

valid2 :: String -> Bool
valid2 phrase = (nub $ (map sort) $ words phrase) == ((map sort) $ words phrase)
main = do
    handle <- openFile "day04.txt" ReadMode
    contents <- hGetContents handle
    let
        to_check = lines contents
    print(length [x | x<-to_check, valid x])
    print(length [x | x<-to_check, valid2 x])