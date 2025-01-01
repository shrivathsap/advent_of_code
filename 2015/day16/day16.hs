import System.IO
import Data.List

filter_out sues property =
    let
        name = (words property)!!0
    in
        [x|x<-sues, not(name `isInfixOf` x)||(property `isInfixOf` x)]

main = do
    handle <- openFile "day16.txt" ReadMode
    contents <- hGetContents handle
    let
        sues = lines contents
        wanted = ["children: 3", "cats: 7", "samoyeds: 2", "pomeranians: 3", "akitas: 0", "vizslas: 0", "goldfish: 5", "trees: 3", "cars: 2", "perfumes: 1"]
        certain = ["children: 3", "samoyeds: 2", "akitas: 0", "vizslas: 0", "cars: 2", "perfumes: 1"]
        part_one = foldl' filter_out sues wanted
        part_two = foldl' filter_out sues certain
    print(part_one)
    print(part_two)