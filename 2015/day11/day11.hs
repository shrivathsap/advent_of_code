import Data.Char (ord, chr)
import Debug.Trace

convert_to :: Integral a => a -> [a]
convert_to num
    |num==0 = []
    |otherwise = convert_to(num`div`26)++[num`mod`26]

increment :: [Char] -> [Char]
increment pwd =
    let
        to_int = [ord x-ord 'a'|x<-pwd]
        num = sum [(26^i)*((reverse to_int)!!i)|i<-[0..length(to_int)-1]]--need to reverse because units place is at the end
        len = length (convert_to(num+1))
        padded = (take (8-len) $ repeat 0)++(drop (len-8) (convert_to(num+1)))
    in
        [chr (x+ord 'a')|x<-padded]

has_doubles :: Eq a => [a] -> Bool
has_doubles pwd =
    let
        all_repeats = [i|i<-[0..(length pwd-2)], (pwd!!i)==(pwd!!(i+1))]
        consecs_removed = [i|i<-all_repeats, not ((i+1)`elem` all_repeats)]
    in
        length consecs_removed >= 2

has_ascending pwd = length [i|i<-[0..(length pwd)-3], (ord $ pwd!!i)==((ord $ pwd!!(i+1))-1), (ord $ pwd!!i)==((ord $ pwd!!(i+2))-2)]>=1

check pwd = (has_doubles pwd)&&(has_ascending pwd)&&(not ('i' `elem` pwd))&&(not ('o' `elem` pwd))&&(not('l'`elem`pwd))

main = do
    let
        init = increment "hxbxxyzz"
    print(head (dropWhile (\x->not $ check x) (iterate increment init)))