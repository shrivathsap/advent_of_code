import System.IO
isTriangle :: (Ord a1, Num a1, Num a2) => [a1] -> a2
isTriangle [a, b, c]
    |(a+b>c)&&(b+c>a)&&(c+a>b) = 1
    |otherwise = 0

groupIntoThrees :: [a] -> [[a]]
groupIntoThrees nums
    |length nums == 0 = []
    |length nums < 3 = [nums]
    |otherwise = [take 3 nums]++(groupIntoThrees (drop 3 nums))

main = do
    handle <- openFile "day03.txt" ReadMode
    contents <- hGetContents handle
    let
        triples = lines contents
        f x = read x::Int
        sides = [map f (words x) | x<-triples]
        part_two_list = [x!!0|x<-sides]++[x!!1|x<-sides]++[x!!2|x<-sides]
        new_sides = groupIntoThrees part_two_list
        triangles = map isTriangle sides
        new_triangles = map isTriangle new_sides
    print(sum triangles)
    print(sum new_triangles)