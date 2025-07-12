import System.IO

mtail :: [a] -> [a] --modified tail to take the tail of a potentially empty list
mtail xs
  | null xs   = []
  | otherwise = tail xs

clear_hypernet :: [Char] -> [[Char]]
clear_hypernet ip
    |ip=="" = []
    |otherwise = [takeWhile (/='[') ip]++clear_hypernet(mtail (dropWhile (/=']') ip))

only_hypernet ip
    |ip=="" = []
    |otherwise = [takeWhile (/= ']') (mtail (dropWhile (/='[') ip))]++only_hypernet(mtail (dropWhile (/=']') ip))

has_tls :: Eq a => [a] -> Int
has_tls ip = length [x | x<-[0..(length ip-5)], (ip!!x == ip!!(x+3))&&(ip!!(x+1) == ip!!(x+2))&&(ip!!x /= ip!!(x+1))]

has_ssl :: Eq a => ([a], [a]) -> Int
has_ssl (p1, p2) =
    let
        l1 = length p1 - 3
        l2 = length p2 - 3
    in
        length [(x, y) | x<-[0..l1], y<-[0..l2], (p1!!x==p1!!(x+2))&&(p1!!x /= p1!!(x+1))&&(p2!!y==p2!!(y+2))&&(p2!!y==p1!!(x+1))&&(p2!!(y+1)==p1!!x)]

supports_tls :: [Char] -> Bool
supports_tls ip = (sum (map has_tls (clear_hypernet ip))>0)&&(has_tls (only_hypernet ip) == 0)

supports_ssl :: [Char] -> Bool
supports_ssl ip =
    let
        supernets = clear_hypernet ip
        hypernets = only_hypernet ip
    in
        (sum (map has_ssl [(x, y) | x<-supernets, y<-hypernets])>0)

main = do
    handle <- openFile "day07.txt" ReadMode
    contents <- hGetContents handle
    let
        ips = lines contents
    print(length [x|x<-ips, supports_tls x])
    print(length [x|x<-ips, supports_ssl x])