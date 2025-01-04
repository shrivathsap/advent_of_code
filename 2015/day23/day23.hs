import Data.List

convert :: [Char] -> Int
convert num_string =
    if "+" `isPrefixOf` num_string then (read::String->Int) (drop 1 num_string)
    else (read::String->Int) num_string

advance :: (Integral a1, Integral a2) => [String] -> (a1, a2, Int) -> (a1, a2, Int)
advance instructions (a,b, inst_pointer)
    |inst=="hlf a" = (a`div`2, b, inst_pointer+1)
    |inst=="hlf b" = (a, b`div`2, inst_pointer+1)
    |inst=="tpl a" = (3*a, b, inst_pointer+1)
    |inst=="tpl b" = (a, 3*b, inst_pointer+1)
    |inst=="inc a" = (a+1, b, inst_pointer+1)
    |inst=="inc b" = (a, b+1, inst_pointer+1)
    |"jmp"`isPrefixOf`inst = (a, b, inst_pointer + convert(last $ words inst))
    |"jio a,"`isPrefixOf` inst = if a==1 then (a, b, inst_pointer + convert(last $ words inst)) else (a, b, inst_pointer+1)
    |"jio b,"`isPrefixOf` inst = if b==1 then (a, b, inst_pointer + convert(last $ words inst)) else (a, b, inst_pointer+1)
    |"jie a,"`isPrefixOf` inst = if a`mod`2==0 then (a, b, inst_pointer + convert(last $ words inst)) else (a, b, inst_pointer+1)
    |"jie b,"`isPrefixOf` inst = if b`mod`2==0 then (a, b, inst_pointer + convert(last $ words inst)) else (a, b, inst_pointer+1)
    where
        inst = instructions !! inst_pointer
        
main :: IO ()
main = do
    instructions <- lines <$> readFile "day23.txt"
    let
        part_one = (takeWhile (\(_,_,x)-> (0<=x)&&(x<length instructions))) $ iterate (advance instructions) (0,0,0)
        part_two = (takeWhile (\(_,_,x)-> (0<=x)&&(x<length instructions))) $ iterate (advance instructions) (1,0,0)
    print(last part_one)
    print(last part_two)