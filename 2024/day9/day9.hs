import System.IO
data Block = Block{size :: Int
                   ,start :: Int
                   ,label :: String
                   ,is_num :: Bool
                   } deriving (Show)

block_sum :: Block->Int
block_sum x = if (is_num x) then sum [i*((read::String->Int) (label x))|i<-[start x .. (start x)+(size x)-1]] else 0

generate_blocks :: String -> Int -> Int -> Bool -> [Block]
generate_blocks [x] offset start_index switch =
    if switch then [Block ((read::String->Int) [x]) offset (show start_index) True]
    else [Block ((read::String->Int) [x]) offset "." False]
generate_blocks (x:xs) offset start_index switch =
    let 
        size = (read::String->Int) [x]
    in
        if switch then [Block size offset (show start_index) True]++(generate_blocks xs (offset+size) (start_index+1) False)
        else [Block size offset "." False]++(generate_blocks xs (offset+size) start_index True)

draw::[Block]->String
draw [b] = concat [label b|x<-[0..size b-1]]
draw (b:bs) = concat [label b|x<-[0..size b-1]]++(draw bs)

move_bits :: [Block]->[Block]
move_bits [b] = [b]--if (size b == 0) then [] else [b]
move_bits (b:bs) =
    if (is_num b) then (b:move_bits bs)
    else if (size b == 0) then move_bits bs
    else
        let (x, y) = break (\z-> (is_num z)) (reverse bs)
        in
            if ((length y)==0) then (b:bs) --means bs is only dots
            else
                let
                    c = head y
                in
                    if (size c)<=(size b) then let
                            new_head = [Block (size b-size c) (start b+size c) (label b) (is_num b)]
                            new_middle = reverse (tail y)
                            new_c = [Block (size c) (start c) (".") False]
                            new_tail = reverse x
                        in
                            [Block (size c) (start b) (label c) True]++(move_bits (new_head++new_middle++new_c++new_tail))
                    else let --b is filled up, so no new_head
                        new_middle = reverse (tail y)
                        new_c = [Block (size c-size b) (start c) (label c) True]--skipping adding a few dots
                        new_tail = reverse x
                        in 
                            [Block (size b) (start b) (label c) True]++(move_bits (new_middle++new_c++new_tail))


move_files :: [Block]->[Block]
move_files [b] = [b]
move_files (b:bs) =
    if (is_num b) then (b:move_files bs)
    else
        let (x, y) = break (\z-> (is_num z)&&(size z<= size b)) (reverse bs)
        in
            if ((length y)==0) then (b:move_files bs)
            else
                let
                    c = head y
                    new_head = [Block (size b-size c) (start b+size c) (label b) (is_num b)]
                    new_middle = reverse (tail y)
                    new_c = [Block (size c) (start c) (".") False]
                    new_tail = reverse x
                in
                    [Block (size c) (start b) (label c) True]++(move_files (new_head++new_middle++new_c++new_tail))

main = do
    handle <- openFile "day9.txt" ReadMode
    contents <- hGetContents handle
    let
        line = (lines contents)!!0
        a = generate_blocks line 0 0 True
        b = move_files a
    -- print(draw(a))
    -- print(draw(b))
    print (sum [block_sum x | x<- b])
