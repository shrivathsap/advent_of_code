import System.IO
char_to_int :: [String]->[Int]
char_to_int xs = [read x|x<-xs]

--Haskell doesn't have built-in split function
split :: Eq a => a -> [a] -> [[a]]
split d [] = []
split d s = x : split d (drop 1 y) where (x,y) = span (/= d) s

middle_of :: [Int]->Int
middle_of xs
    |length xs `mod` 2 == 1 = xs!!((length xs - 1) `div` 2)
    |otherwise = 0

--given a list and number, it gives all the things that should be above the given number
list_to_dict :: [[Int]]->Int->[Int]
list_to_dict rule_list number = [x!!1|x<-rule_list, (x!!0)==number]

intersect xs ys = if (length [x|x<-xs, x`elem` ys]) == 0 then False else True

--for the ith element, take the first i-1 and see if it intersects with the rule set
is_safe :: [Int]->[[Int]]->Bool
is_safe list_of_nums rule_list =
    let
        flags = [intersect (take i list_of_nums) (list_to_dict rule_list (list_of_nums !! i)) | i<-[0..length list_of_nums-1]]
    in
        not (True `elem` flags)

--quick sort type sorting but with given rule set. there is a built in way to go about this apparently
new_sort list_of_nums rule_list = 
    let
        len = length list_of_nums
    in
        if len == 0 then []
        else
            let
                end = list_of_nums !! (len-1)
                all_but_last = take (len-1) list_of_nums
                move_up = [x|x<-all_but_last, x `elem` (list_to_dict rule_list end)]
                rest = [x|x<-all_but_last, not (x`elem` move_up)]
            in
                if (move_up == []) then (new_sort all_but_last rule_list)++[end]
                else (new_sort rest rule_list)++[end]++(new_sort move_up rule_list)

main = do
    handle <- openFile "day5.txt" ReadMode
    contents <- hGetContents handle
    let
        rules = takeWhile (/= "") (lines contents)
        numbers = (map char_to_int) [split ',' x | x<- (tail (dropWhile (/= "") (lines contents)))]
        --distinction between ' and " is somewhat annoying
        rule_set = (map char_to_int) [[takeWhile (/= '|') x]++[tail (dropWhile (/='|') x)]| x<-rules]
        safe_pages = [x|x<-numbers, is_safe x rule_set]
        unsafe_pages = [x|x<-numbers, not (is_safe x rule_set)]
        sorted_unsafe = [new_sort x rule_set| x<-unsafe_pages]
        middles = [middle_of x|x<-safe_pages]
        unsafe_middles = [middle_of x|x<-sorted_unsafe]
    print(sum middles)
    print(sum unsafe_middles)