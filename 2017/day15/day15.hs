import System.IO
import Data.Bits ( Bits((.&.)) )

mulA = 16807
mulB = 48271
num = 2147483647
threshold = 2^16
total = 40000000
total2 = 5000000

part_one::Int->Int->Int->Int
part_one startA startB rounds =
    length [(a, b) | (a, b)<- (take rounds) $ iterate f (startA, startB), (a`mod`threshold==b`mod`threshold)]
    where
        f(a, b) = ((mulA*a) `mod` num, (mulB*b) `mod` num)

part_two :: Int -> Int -> Int -> Int
part_two startA startB rounds = 
    length [(a, b) | (a, b)<-(zip numsA numsB), (a`mod`threshold==b`mod`threshold)]
    where
        fA a = (mulA*a)`mod`num
        fB b = (mulB*b)`mod`num
        --should start with one application of f, not with startA, startB
        numsA = take rounds $ filter (\x->x`mod`4==0) $ iterate fA (fA startA)
        numsB = take rounds $ filter (\x->x`mod`8==0) $ iterate fB (fB startB)

main = do
    print(part_one 0 0 total)
    print(part_two 0 0 total2)