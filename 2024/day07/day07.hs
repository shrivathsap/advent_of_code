import System.IO

parse :: String->(Int, [Int])
parse string = (head aux, tail aux)
    where
        aux = map (read::String->Int) ([takeWhile (\x-> (x/= ':')) string] ++ tail (words (dropWhile (\x->(x/=':')) string)))

deconcat :: Int->Int->String
deconcat num1 num2 = 
    let
        str1 = show num1
        str2 = show num2
        l1 = length str1
        l2 = length str2
    in
        if l1<l2 then "-1"
        else
            if (drop (l1-l2) str1)==str2 then take (l1-l2) str1
            else "-1"

computes :: (Int, [Int]) -> Bool
computes (num, list_of_nums) = 
    if (num<0) then False
    else if ((length list_of_nums) == 1) then (num == (list_of_nums!!0))
    else
        let
            l = length list_of_nums
            last = list_of_nums !! (l-1)
            all_but_last = take (l-1) list_of_nums
            removed = deconcat num last
            quotient = if (num`mod`last == 0) then (num`div`last) else -1
        in
            if removed == "" then True
            else
                let new_num = (read::String->Int) removed
                in
                    (computes (quotient, all_but_last))||(computes ((num-last), all_but_last))||(computes (new_num, all_but_last))

main = do
    handle <- openFile "day7.txt" ReadMode
    contents <- hGetContents handle
    let
        all_lines = sum [fst (parse x)|x<-(lines contents), computes (parse x)]
    print all_lines
