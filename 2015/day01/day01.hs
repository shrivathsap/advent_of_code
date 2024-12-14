import System.IO
convert::Char->Int
convert '(' = 1
convert ')' = -1
main = do
    handle <- openFile "day01.txt" ReadMode
    contents <- hGetContents handle
    let
        string = (lines contents)!!0
        converted = [convert x|x<-string]
        partOne = sum converted
        --plus 1 because that's where the first time -1 appears...
        partTwo = length (takeWhile (>=0) [sum (take n converted)|n<-[1..length converted-1]])+1
    print(partOne)
    print(partTwo)