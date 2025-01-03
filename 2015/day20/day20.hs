import Debug.Trace
import Data.Map (Map)
import qualified Data.Map as Map
import Data.List

update_divisors current next =
    let
        first = head $ dropWhile (\x->(next`mod`x/=0)) [2..(floor $ sqrt $ fromIntegral next)]++[next]
    in
        if first == next then Map.insert next (1+next) current
        else
            let
                exps = [i | i<-[0..ceiling $ logBase 2 (fromIntegral next)+1], next`mod`(first^i)==0]
                power_sum = sum [first^i | i<-exps]
                divided = next `div` (first^(last exps))
            in
                Map.insert next (((Map.!) current divided)*power_sum) current
        
small_sum n = sum [n`div`x | x<-[1..50], n`mod`x == 0]

input = 6000--input goes here
target_one = input `div` 10
target_two = input `div` 11

damn_son = foldl' update_divisors (Map.fromList [(1,1)]) [2..target_one]
part_one = head $ dropWhile (\x-> ((Map.!) damn_son x < target_one)) [1..target_one]
part_two = head $ dropWhile (\x-> (small_sum x < target_two)) [1..target_two]