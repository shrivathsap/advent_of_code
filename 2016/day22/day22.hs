import System.IO

draw :: [String]-> IO ()
draw grid = mapM_ putStrLn grid

group :: Int -> [a] -> [[a]]
group n items
    |length(items)<n = [items]
    |otherwise = [take n items]++(group n (drop n items))

make_grid :: [String] -> IO ()
make_grid lines =
    let
        max = 92
        f s = read (init s)::Int
        g x =
            if f((words x)!!2) > max then "#  "
            else if f((words x)!!2) == 0 then "_  "
            else ".  "
        info = [((words x)!!2)++"/"++((words x)!!1)++"   " | x<-lines]
        asd = map g lines
    in
        draw $ map concat (group 29 asd) --my grid is 35x29


main = do
    handle <- openFile "day22.txt" ReadMode
    contents <- hGetContents handle
    let
        info_lines = drop 2 (lines contents)
        f s = read (init s)::Int
        possible_pairs = [((f$(words x)!!2, f$(words x)!!3), (f$(words y)!!2, f$(words y)!!3)) | x<-info_lines, y<-info_lines, x/=y]
        viable_pairs = [x | x<-possible_pairs, (fst$fst x)/=0, ((fst$fst x) <= (snd$snd x))]
    print(length viable_pairs)
    make_grid info_lines