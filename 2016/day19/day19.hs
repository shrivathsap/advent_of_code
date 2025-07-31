delete_elf :: [Int] -> [Int]
delete_elf elves
    |(length elves) `mod` 2 == 0 = [elves!!x | x<-[0..(length elves-1)], x`mod`2==0]
    |otherwise = [last elves]++[elves!!x | x<-[0..(length elves-2)], x`mod`2==0]

power_of_three :: Int -> Int
power_of_three num
    |num<3 = 0
    |otherwise = 1+power_of_three(num `div` 3)

part_one :: Int -> [Int]
-- if n = 2^m+l, then part_one n = 2*l+1
part_one n = head $ dropWhile (\x->length x/=1) $ iterate delete_elf [x+1 | x<-[0..n-1]]

part_two :: Int -> Int
part_two n =
    let
        m = 3^(power_of_three n)
    in
        if n==m then m
        else if n<=2*m then n-m
        else (2*m)+2*(n-2*m)