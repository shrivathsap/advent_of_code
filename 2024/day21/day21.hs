import Data.Map (Map)
import qualified Data.Map as Map
import Data.List

dirs '<' = (-1, 0)
dirs '^' = (0, 1)
dirs '>' = (1, 0)
dirs 'v' = (0, -1)

board1 :: Map.Map (Int, Int) String
board1 = Map.fromList[((-2, 3),"7"), ((-1, 3),"8"), ((0, 3),"9"),
          ((-2, 2),"4"), ((-1, 2),"5"), ((0, 2),"6"),
          ((-2, 1),"1"), ((-1, 1),"2"), ((0, 1),"3"),
          ((-2, 0),"x"), ((-1, 0),"0"), ((0, 0),"A")]
board2 :: Map.Map (Int, Int) String
board2 = Map.fromList[((-2, 0),"x"), ((-1, 0),"^"), ((0, 0),"A"),
          ((-2, -1),"<"), ((-1, -1),"v"), ((0, -1),">")]
invb1 = Map.fromList [(y, x)|(x, y)<-Map.toList board1]
invb2 = Map.fromList [(y, x)|(x, y)<-Map.toList board2]
repeat' n c = concat(replicate n c)

break_at_A :: String -> [String]
break_at_A string =
    if string == "A" then ["A"]
    else if string == "" then []
    else
        let
            head = (takeWhile (/='A') string)++"A"
            tail = (drop 1 (dropWhile (/='A') string))
        in
            [head]++(break_at_A tail)

generate n0 c0 n1 c1 =
    if n0==0 && n1==0 then []
    else nub [(repeat' n0 c0)++(repeat' n1 c1), (repeat' n1 c1)++(repeat' n0 c0)]

validate sequence start board =
    let
        positions = foldl (\x y-> x++[(fst(last x)+fst(dirs y), snd(last x)+snd(dirs y))]) [start] sequence
    in
        if ("x" `elem` [board Map.! pos| pos<-positions]) then False
        else True

valid_moves :: (Int, Int) -> (Int, Int) -> Map (Int, Int) String -> [String]
valid_moves (x0, y0) (x1, y1) board = 
    let 
        sequences =
            if x0>x1 && y0>y1 then (generate (x0-x1) "<" (y0-y1) "v")
            else if x0<=x1 && y0>y1 then (generate (x1-x0) ">" (y0-y1) "v")
            else if x0>x1 && y0<=y1 then (generate (x0-x1) "<" (y1-y0) "^")
            else (generate (x1-x0) ">" (y1-y0) "^")
        temp = [x|x<-sequences, (validate x (x0, y0) board)]
    in
        if ((temp == ["<v", "v<"])||(temp == ["v<", "<v"]))&&(board==board2) then ["<v"]
        else if ((temp == ["^<", "<^"])||(temp == ["<^", "^<"]))&&(board==board2) then ["<^"]
        else if ((temp == ["v>", ">v"])||(temp == [">v", "v>"]))&&(board==board2) then ["v>"]
        else if ((temp == [">^", "^>"])||(temp == ["^>", ">^"]))&&(board==board2) then ["^>"]
        else if temp == [] then [""]
        else temp

extend_path board (current_paths, current_pos) char =
    let
        next_pos = if (board==board1) then (invb1 Map.! [char]) else (invb2 Map.! [char])
        path = valid_moves current_pos next_pos board
        to_return = 
            if (current_pos == next_pos) then ([x++"A"|x<-current_paths], next_pos)
            else if (current_pos /= next_pos)&&(current_paths == []) then ([x++"A"|x<-path], next_pos)
            else ([x++y++"A"|x<-current_paths, y<-path], next_pos)
    in
        if to_return == ([], next_pos) then (["A"], next_pos)
        else to_return

key_sequence string board = fst(foldl (extend_path board) ([], (0, 0)) string)

convert_to_dict string = 
    let
        pieces = break_at_A string
        dict = Map.empty
    in
        foldl (\y x-> Map.insertWith (+) x 1 y) dict pieces

update_dict :: Map String Int -> Map String Int
update_dict string_dict =
    let
        best_moves = [(s, (convert_to_dict ((key_sequence s board2)!!0)))|s<-Map.keys string_dict]
        f d (x, y) = foldl (\c (a, b)->(Map.insertWith (+) a (b*(string_dict Map.! x)) c)) d (Map.toList y)
    in
        foldl f Map.empty best_moves

part_one string = 
    let
        first_bot = key_sequence string board1
        second_bot = concat [key_sequence x board2|x<-first_bot]
        third_bot = concat [key_sequence x board2|x<-second_bot]
    in
        ((read::String->Int) (take 3 string))*(minimum [length x|x<-third_bot])

part_two :: String -> Int -> Int
part_two string layers =
    let
        first_bot = key_sequence string board1
        f x = (iterate(update_dict) (convert_to_dict x))!!layers
        g dict = sum [(length x)*(dict Map.! x)|x<-Map.keys dict]
    in
        ((read::String->Int) (take 3 string))*(minimum [g (f x)|x<-first_bot])

main = do
    let input_ = []
    print(sum([part_one i | i<- input_]))
    print(sum([part_two i 25| i <- input_]))
