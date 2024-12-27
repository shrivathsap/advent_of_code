import System.IO
has_three_vowels string = (length [x|x<-string, x`elem`['a','e','i','o','u']]>=3)

has_double_letter string = (length [i|i<-[0..length string-2],(string!!i)==(string!!(i+1))]>0)

has_bad_string string = (length [i|i<-[0..length string-2],[string!!i,string!!(i+1)]`elem` ["ab","cd","pq","xy"]]>0)

has_double_pair string = (length [(i, j)|i<-[0..length string-2], j<-[0..length string-2], abs(i-j)>1, (string!!i)==(string!!j), (string!!(i+1)==string!!(j+1))]>0)

has_sandwich string = (length [i|i<-[0..length string-3], string!!i==string!!(i+2)]>0)
nice_part_one string = (has_three_vowels string)&&(has_double_letter string)&&(not (has_bad_string string))

nice_part_two string = (has_double_pair string)&&(has_sandwich string)

main = do
    handle <- openFile "day05.txt" ReadMode
    contents <- hGetContents handle
    let
        input_lines = lines contents
    print(length [x|x<-input_lines, nice_part_one x])
    print(length [x|x<-input_lines, nice_part_two x])