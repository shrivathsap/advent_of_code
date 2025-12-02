import System.IO

parse :: (Ord d, Eq c, Num d, Num c, Num e) => ([Char], d, c, d, e) -> ([Char], d, c, d, e)
parse (to_parse, group_layer, garbage_layer, total, garbage_count) =
    let
        cur_char = head to_parse
        new_to_parse =
            if cur_char == '!' then tail$tail to_parse
            else tail to_parse
        new_group_layer =
            if (cur_char == '{')&&(garbage_layer==0) then group_layer+1 --enter an inner group
            else if (cur_char == '}')&&(garbage_layer==0) then group_layer-1 --exit an inner group
            else group_layer
        new_garbage_layer =
            if (cur_char == '<')&&(garbage_layer==0) then 1 --enter an inner garbage
            else if (cur_char == '>')&&(garbage_layer==1) then 0 --exit outermost garbage
            else garbage_layer
        new_total =
            if new_group_layer<group_layer then total+group_layer
            else total
        new_garbage_count =
            if (cur_char=='<')&&(garbage_layer==0) then garbage_count
            else if (cur_char=='>')&&(garbage_layer==1) then garbage_count
            else if (cur_char=='!') then garbage_count
            else if (garbage_layer==1) then garbage_count+1
            else garbage_count
    in
        if to_parse == [] then (to_parse, group_layer, garbage_layer, total, garbage_count)
        else parse(new_to_parse, new_group_layer, new_garbage_layer, new_total, new_garbage_count)

parse2 :: (Ord d, Eq c, Num d, Num c, Num e) => ([Char], d, c, d, e) -> ([Char], d, c, d, e)
parse2 ([], a, b, c, d) = ([], a, b, c, d)
parse2 (c:cs, gl, ggl, tot, gc) --gl=group_layer, ggl=garbage_layer, tot=total, gc=garbage_count
    |c=='{'&&ggl==1 = parse2 (cs, gl, ggl, tot, gc+1)
    |c=='{'&&ggl==0 = parse2 (cs, gl+1, ggl, tot, gc)
    |c=='}'&&ggl==1 = parse2 (cs, gl, ggl, tot, gc+1)
    |c=='}'&&ggl==0 = parse2 (cs, gl-1, ggl, tot+gl, gc)
    |c=='<'&&ggl==1 = parse2 (cs, gl, ggl, tot, gc+1)
    |c=='<'&&ggl==0 = parse2 (cs, gl, ggl+1, tot, gc)
    |c=='>'&&ggl==1 = parse2 (cs, gl, ggl-1, tot, gc)
    |c=='>'&&ggl==0 = parse2 (cs, gl, ggl, tot, gc)
    |c=='!'         = parse2 (tail cs, gl, ggl, tot, gc)
    |        ggl==1 = parse2 (cs, gl, ggl, tot, gc+1)
    |otherwise      = parse2 (cs, gl, ggl, tot, gc)

main :: IO ()
main = do
    handle <- openFile "day09.txt" ReadMode
    contents <- hGetContents handle
    let
        stream = lines contents
    print([parse(x, 0, 0, 0, 0) | x<-stream])
    print([parse2(x, 0, 0, 0, 0) | x<-stream])