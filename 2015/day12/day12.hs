import Text.Regex.TDFA
import System.IO
import Data.List

f::Char->Int
f c = if c=='{' then 1 else if c=='}' then -1 else 0

get_objects ::[Char]->[[Char]]
get_objects long_line =
    if long_line=="" then []
    else
        let
            opens = [n|n<-[0..length(long_line)-1], long_line!!n=='{']
            closes = [n|n<-[0..length(long_line)-1], long_line!!n=='}']
            pairs = [(n, m)|n<-opens, m<-closes, n<m, sum(map f (drop (n) (take (m+1) long_line)))==0]
            
        in
            if pairs == [] then []
            else
                let
                    (x, y) = head pairs
                in
                    (get_objects (take (x-1) long_line))++[(drop x (take (y+1) long_line))]++(get_objects (drop (y+1) long_line))++(get_objects (drop (x+1) (take (y+1) long_line)))

double_counted string list_of_strings = ([y|y<-list_of_strings, y/=string, isInfixOf string y]/=[])

indices :: Eq a => [a] -> [a] -> [Int]
indices substring string =
    let
        n = length substring
        m = length string
    in
        [i|i<-[0..m-1], (drop i (take (i+n) string))==substring]

has_red :: [Char] -> Bool
has_red string =
    let
        f::Char->Int
        f c = if c=='{' then 1 else if c=='}' then -1 else 0
    in
        if not(isInfixOf ":\"red\"" string) then False
        else
            let
                to_check = indices ":\"red\"" (drop 1 string)
                modified = map f (drop 1 string)
                positive = [i|i<-to_check, sum(take i modified)==0]
            in
                if positive == [] then False
                else True

main :: IO ()
main = do
    handle <- openFile "day12.txt" ReadMode
    contents <- hGetContents handle
    let
        long_line = (lines contents)!!0
        red_objects = [x|x<-(get_objects long_line), has_red x]
        filtered_red = [x|x<-red_objects, not (double_counted x red_objects)]
        red_sum = sum[sum(map (read::String->Int) (getAllTextMatches (x=~"[0-9]+|-[0-9]+")::[String]))|x<-filtered_red]
    print("Part One:", sum(map (read::String->Int) (getAllTextMatches (long_line=~"[0-9]+|-[0-9]+")::[String])))
    print(length filtered_red)
    print("subtract", red_sum)