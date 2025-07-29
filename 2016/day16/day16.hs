import System.IO

dragon :: [Char] -> [Char]
dragon s = s++"0"++(map f (reverse s))
    where
        f '1' = '0'
        f '0' = '1'

power_of_two :: Int->Int
power_of_two n
    |n`mod`2==1 = 0
    |otherwise = 1+(power_of_two (n `div` 2))

group :: Int -> [a] -> [[a]]
group n items
    |length(items)==0 = []
    |length(items)<n = [items]
    |otherwise = [(take n items)] ++ (group n (drop n items))

checksum :: [Char]-> [Char]
checksum s =
    let
        chunks = group 2 s
        f pair
            |(pair!!0==pair!!1) = "1"
            |otherwise = "0"
    in
        concat(map f chunks)

checksum2 :: [Char] -> [Char]
checksum2 s =
    let
        p = power_of_two (length s)
        chunks = group (2^p) s
        f chunk
            |(length [x | x<-chunk, x=='0']) `mod` 2==1 = "0"
            |otherwise = "1"
    in
        concat(map f chunks)

main = do
    handle <- openFile "day16.txt" ReadMode
    input <- hGetContents handle
    let
        disc_size = 35651584::Int
        random_data = take disc_size (head (dropWhile (\x -> (length x)<disc_size) (iterate dragon input)))
        part_one = head (dropWhile (\x -> (length x)`mod`2==0) (iterate checksum2 random_data))
    print(part_one)