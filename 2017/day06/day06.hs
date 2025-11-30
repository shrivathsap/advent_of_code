import System.IO
import qualified Data.IntMap.Lazy as IntMap
import Data.List (elemIndex)
import Data.Maybe (fromJust)

get_max_pos :: IntMap.IntMap IntMap.Key -> IntMap.Key
get_max_pos nums = 
    let
        values = IntMap.elems nums
        keys = IntMap.keys nums
        m = maximum values
    in
        head [i | i<-keys, nums IntMap.! i == m] --using ! is bad in general, but it works out here

increase :: (Num a, Num c) => (IntMap.IntMap a, IntMap.Key, c) -> (IntMap.IntMap a, IntMap.Key, c)
increase (nums, pos, count) = (IntMap.adjust (\x->x+1) pos nums, (pos+1)`mod` length nums, count-1)

redistribute :: IntMap.IntMap IntMap.Key -> IntMap.IntMap IntMap.Key
redistribute nums =
    let
        n = length nums
        start = get_max_pos nums
        to_distribute = nums IntMap.! start
        removed = IntMap.adjust (\x->0) start nums
        first (a, b, c) = a
    in
        first $ until (\(a, b, c)->(c==0)) increase (removed, (start+1)`mod`n, to_distribute)

part_one :: [IntMap.IntMap IntMap.Key] -> Int
part_one memory_states =
    let
        last_state = last memory_states
        next_state = redistribute last_state
        n = length memory_states
    in
        if (elem next_state memory_states) then n else part_one (memory_states++[next_state])

part_two :: [IntMap.IntMap IntMap.Key] -> Int
part_two memory_states =
    let
        last_state = last memory_states
        next_state = redistribute last_state
        n = length memory_states
    in
        if (elem next_state memory_states) then n - fromJust(elemIndex next_state memory_states)
        else part_two (memory_states++[next_state])

main = do
    handle <- openFile "day06.txt" ReadMode
    contents <- hGetContents handle
    let
        blocks = map (read::String->Int)$ words $ (lines contents !! 0)
        nums = IntMap.fromList [(n, blocks!!n) | n<-[0..length blocks-1]]
    print(part_one [nums])
    print(part_two [nums])