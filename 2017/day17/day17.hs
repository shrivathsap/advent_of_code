import System.IO

update :: Num b => Int -> ([b], b, Int) -> ([b], b, Int)
update shift (nums, to_insert, pos) = ((take (new_pos+1) nums)++[to_insert]++(drop (new_pos+1) nums), to_insert+1, new_pos+1)
    where new_pos = (pos+shift)`mod`(length nums)

part_two :: Integral p => p -> [(p, p)]
part_two shift =
    let
        f (length, pos) = (length+1, (pos+shift+1)`mod`length) --length+1 is the length after insertion
        rounds = 50*(10^6)
        inserted = filter (\x->snd x==0) $ take rounds $ iterate f (1, 0)
    in
        inserted
        
main = do
    input <- lines <$> readFile "day17.txt"
    let
        nums = [0]
        shift = (read::String->Int) (input!!0)
        (a, b, c) = last $ take 2017 $ iterate (update shift) (nums, 1, 0)
        part_one = a!!((c+1+shift)`mod`(length a))
    print(part_one)
    print(part_two shift)