subsets :: [a] -> [[a]]
subsets [] = [[]]
subsets (x:xs) = [[x]++y|y<-subsets xs]++subsets xs
main = do
    input <- (map (read::String->Int)) <$> lines <$> readFile "day17.txt"
    let
        part_one = [x|x<-(subsets input), sum x == 150]
        minimal = minimum [length x|x<-part_one]
        part_two = [x|x<-part_one, length x == minimal]
    print(length part_one)
    print(length part_two)