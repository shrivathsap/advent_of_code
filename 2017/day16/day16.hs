import System.IO

letters = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p"]

comma_split :: [Char] -> [[Char]]
comma_split [] = []
comma_split (c:cs)
    |cs==[] = if c==',' then [] else [[c]]
    |c==',' = comma_split cs
    |otherwise = [takeWhile (/= ',') (c:cs)]++(comma_split (dropWhile (/=',') (c:cs)))       

rot :: Int -> [a] -> [a]
rot x string
    |x>=0 = (drop x string)++(take x string)
    |x<0 = (drop (length string + x) string)++(take (length string+x) string)

exchange :: Int -> Int -> [a] -> [a]
exchange p1 p2 string = [string !! (g i) | i<-[0..length string-1]]
    where
        g i
            |i==p1 = p2
            |i==p2 = p1
            |otherwise = i

partner :: Eq a => a -> a -> [a] -> [a]
partner p1 p2 string = [g x | x<-string]
    where
        g x
            |x==p1 = p2
            |x==p2 = p1
            |otherwise = x

dance :: [[Char]] -> [Char] -> [[Char]]
dance dancers (c:cs)
    |c=='s' = rot (-1*(read::String->Int) cs) dancers
    |c=='x' = exchange (r p1) (r p2) dancers
    |c=='p' = partner p1 p2 dancers
    where
        p1 = takeWhile (/='/') cs
        p2 = tail $ (dropWhile (/='/') cs)
        r = read::String->Int

dance2 :: ([a], [[Char]]) -> [Char] -> ([a], [[Char]])
dance2 (positions, names) (c:cs)
    |c=='s' = (rot (-1*(read::String->Int) cs) positions, names)
    |c=='x' = (exchange (r p1) (r p2) positions, names)
    |c=='p' = (positions, partner p1 p2 names)
    where
        p1 = takeWhile (/='/') cs
        p2 = tail $ (dropWhile (/='/') cs)
        r = read::String->Int

main :: IO ()
main = do
    input <- lines <$> readFile "day16.txt"
    let
        moves = comma_split (input!!0)
        final x = foldl dance x moves
        final2 = foldl dance2 ([0..15], letters) moves
        perms = [letters]++(takeWhile (/= letters) $ iterate final (final letters)) --ignore the 0th power
        --pairs = zip [0..140] (take 141 $ map concat $ iterate final letters)
        order = length perms
        power = 1000000000 `mod` order
        part_one = concat $ final letters
        part_two = concat $ perms!!power
    print(final2)
    print(part_one)
    print(part_two)