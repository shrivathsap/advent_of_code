import System.IO
import qualified Data.Map as Map

nine_chunks :: Eq a => [a] -> [[a]]
nine_chunks nums
    |(length nums `mod` 9)/=0 = error "Something has gone horribly wrong"
    |nums == [] = []
    |(length nums == 9) = [nums]
    |otherwise = [(take 9 nums)]++(nine_chunks $ drop 9 nums)

--chunk looks like [cur_state, if 0, to_write, dir, next_state, if 1, to_write, dir, next_state]
parse_chunk :: Num b => [String] -> (String, [(Int, b, String)])
parse_chunk chunk = (chunk!!0, [(r (chunk!!2), d (chunk!!3), chunk!!4), (r (chunk!!6), d (chunk!!7), chunk!!8)])
    where
        r = (read::String->Int)
        d "right" = 1
        d "left" = -1

turing :: (Ord b1, Ord c, Num c) => Map.Map b1 [(Int, c, b2)] -> (Map.Map c Int, b1, c) -> (Map.Map c Int, b2, c)
turing rules (tape, state, pos) = (new_tape, new_state, new_pos)
    where
        to_do = (Map.!) rules state
        current_val = Map.findWithDefault 0 pos tape
        (new_val, dir, new_state) = to_do!!current_val
        !new_tape = Map.insert pos new_val tape
        !new_pos = pos+dir

main = do
    input <- lines <$> readFile "day25.txt"
    let
        init_state = (init.last.words) (input!!0)
        steps = ((read::String->Int).head.(drop 1).reverse.words) (input!!1)
        rules = map (init.last.words) $ filter (/="") (drop 2 input)
        parsed_rules = Map.fromList (map parse_chunk $ nine_chunks rules)
        part_one = (\(a,_,_)->sum $ Map.elems a) $ (iterate (turing parsed_rules) (Map.fromList [], init_state, 0))!!(steps)
    print(part_one)