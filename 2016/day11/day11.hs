import System.IO
import Data.List

data Generator = Generator {gen_name::String} deriving(Eq, Show)
data Microchip = Microchip {mc_name::String} deriving(Eq, Show)
data Floor = Floor {gens::[Generator],
                    mcs::[Microchip]} deriving(Eq, Show)
data State = State {elev::Int,
                    floors::[Floor]} deriving(Eq, Show)

subsets :: Eq a => Int -> [a] -> [[a]]
subsets size items
    |size == 0 = []
    |size > (length items) = []
    |size == 1 = [[x] | x<-items]
    |otherwise = [[head items]++x | x<-(subsets (size-1) (tail items))]++(subsets size (tail items))

remove :: Eq a => Int -> [a] -> [([a], [a])]
remove n items = [(x, items \\ x) | x<-(subsets n items)] -- \\ is list difference

compare_lists :: Eq a => [a]->[a]->Bool
compare_lists list1 list2 =
    if (list1==[]) && (list2==[]) then True
    else if (length list1) /= (length list2) then False
    else let
        x = head list1
        in
            if x `elem` list2 then (compare_lists (tail list1) (list2 \\ [x]))
            else False

safe_floor :: Floor -> Bool
safe_floor floor = ((gens floor) == []) || (([mc_name x | x<- mcs floor]`intersect` [gen_name x | x<-gens floor])==[mc_name x | x<- mcs floor])

valid :: State -> Bool
valid state =
    let
        valid_elevator = (elev state > 0)&&(elev state < length(floors state))
        valid_floors = all (safe_floor) (floors state)
    in
        valid_elevator && valid_floors

move_up :: State -> [State]
move_up state = 
    let
        all_floors = floors state
        cur_floor_num = elev state
        cur_floor = all_floors !! cur_floor_num
        next_floor = all_floors !! (cur_floor_num+1)
        cur_gens = gens cur_floor
        cur_mcs = mcs cur_floor
        next_gens = gens next_floor
        next_mcs = mcs next_floor
        lower = [all_floors!!x | x<-[0..(cur_floor_num-1)]]
        higher = [all_floors!!x | x<-[(cur_floor_num+2)..(length all_floors)-1]]
        move_one_gen = [[Floor (cur_gens\\x) cur_mcs, Floor (next_gens++x) next_mcs] | x<-(subsets 1 cur_gens)]
        move_one_mc = [[Floor cur_gens (cur_mcs\\x), Floor next_gens (next_mcs++x)] | x<-(subsets 1 cur_mcs)]
        move_two_gens = [[Floor (cur_gens\\x) cur_mcs, Floor (next_gens++x) next_mcs] | x<-(subsets 2 cur_gens)]
        move_two_mcs = [[Floor cur_gens (cur_mcs\\x), Floor next_gens (next_mcs++x)] | x<-(subsets 2 cur_mcs)]
        move_both = [[Floor (cur_gens\\x) (cur_mcs\\y), Floor (next_gens++x) (next_mcs++y)] | x<-(subsets 1 cur_gens), y<-(subsets 1 cur_mcs)]

        two_items = move_two_gens++move_two_mcs++move_both
        valid_double_moves = [x | x<-two_items, (safe_floor (x!!0))&&(safe_floor (x!!1))]
        valid_moves
            |valid_double_moves /= [] = valid_double_moves
            |otherwise = [x | x<-(move_one_gen++move_one_mc), (safe_floor (x!!0))&&(safe_floor (x!!1))]
    in
        [State (cur_floor_num+1) ((lower++x)++higher) | x<-valid_moves]

move_down :: State -> [State]
move_down state = 
    let
        all_floors = floors state
        cur_floor_num = elev state
        cur_floor = all_floors !! cur_floor_num
        next_floor = all_floors !! (cur_floor_num-1)
        cur_gens = gens cur_floor
        cur_mcs = mcs cur_floor
        next_gens = gens next_floor
        next_mcs = mcs next_floor
        lower = [all_floors!!x | x<-[0..(cur_floor_num-2)]]
        higher = [all_floors!!x | x<-[(cur_floor_num+1)..(length all_floors)-1]]
        move_one_gen = [[Floor (next_gens++x) next_mcs, Floor (cur_gens\\x) cur_mcs] | x<-(subsets 1 cur_gens)]
        move_one_mc = [[Floor next_gens (next_mcs++x), Floor cur_gens (cur_mcs\\x)] | x<-(subsets 1 cur_mcs)]
        move_two_gens = [[Floor (next_gens++x) next_mcs, Floor (cur_gens\\x) cur_mcs] | x<-(subsets 2 cur_gens)]
        move_two_mcs = [[Floor next_gens (next_mcs++x), Floor cur_gens (cur_mcs\\x)] | x<-(subsets 2 cur_mcs)]
        move_both = [[Floor (next_gens++x) (next_mcs++y), Floor (cur_gens\\x) (cur_mcs\\y)] | x<-(subsets 1 cur_gens), y<-(subsets 1 cur_mcs)]

        one_item = move_one_gen++move_one_mc
        valid_single_moves = [x | x<-one_item, (safe_floor (x!!0))&&(safe_floor (x!!1))]
        valid_moves
            |valid_single_moves /= [] = valid_single_moves
            |otherwise = [x | x<-(move_two_gens++move_two_mcs++move_both), (safe_floor (x!!0))&&(safe_floor (x!!1))]
    in
        [State (cur_floor_num-1) ((lower++x)++higher) | x<-valid_moves]

pair_up :: State -> Microchip -> (Int, Int)
pair_up state mc = 
    let
        all_floors = floors state
        mc_floor = head [x | x<-[0..(length all_floors)], mc `elem` (mcs (all_floors !! x))]
        gen_floor = head [x | x<-[0..(length all_floors)], (mc_name mc) `elem` (map gen_name (gens (all_floors !! x)))]
    in
        (mc_floor, gen_floor)

compare_states :: State -> State -> Bool
compare_states state1 state2 = 
    let
        mcs1 = concat [mcs x | x<-(floors state1)]
        mcs2 = concat [mcs x | x<-(floors state2)]
        pairs1 = [pair_up state1 x | x<-mcs1]
        pairs2 = [pair_up state2 x | x<-mcs2]
    in
        (compare_lists pairs1 pairs2)&&(elev state1 == elev state2)

next_states :: State -> [State]
next_states state =
    let
        all_floors = floors state
        cur_floor_num = elev state
        cur_floor = all_floors !! cur_floor_num
        temp_next = 
            if (cur_floor_num == 0) ||  (all (\x -> x == True) (map (\x -> (gens x == [])&&(mcs x == [])) (take (cur_floor_num) (floors state)))) then
                move_up state
            else if cur_floor_num == (length all_floors)-1 then
                move_down state
            else
                (move_up state) ++ (move_down state)      
    in
        nubBy compare_states temp_next

is_done :: State -> Bool
is_done state = all (\x -> x == True) (map (\x -> (gens x == [])&&(mcs x == [])) (init (floors state)))

grow_tree :: [[State]]->[[State]]
grow_tree tree =
    let
        latest_gen = last tree
        next_gen = nubBy compare_states (concat (map next_states latest_gen))
        states_visited = concat tree
        to_discard = [x | x<-next_gen, [y | y<-states_visited, compare_states x y ] /= []]
    in
        tree++[(next_gen\\to_discard)]

main = do
    let
        mcPo = Microchip "Polonium"
        mcTm = Microchip "Thulium"
        mcPm = Microchip "Promethium"
        mcRu = Microchip "Ruthenium"
        mcCo = Microchip "Cobalt"
        mcE = Microchip "Elerium"
        mcDl = Microchip "Dilithium"
        
        genPo = Generator "Polonium"
        genTm = Generator "Thulium"
        genPm = Generator "Promethium"
        genRu = Generator "Ruthenium"
        genCo = Generator "Cobalt"
        genE = Generator "Elerium"
        genDl = Generator "Dilithium"

        -- my input part 1
        -- floor1 = Floor [genPo, genTm, genPm, genRu, genCo] [mcTm, mcRu, mcCo]
        -- floor2 = Floor [] [mcPo, mcPm]
        -- floor3 = Floor [] []
        -- floor4 = Floor [] []

        -- my input part 2
        -- floor1 = Floor [genPo, genTm, genPm, genRu, genCo, genE, genDl] [mcTm, mcRu, mcCo, mcE, mcDl]
        -- floor2 = Floor [] [mcPo, mcPm]
        -- floor3 = Floor [] []
        -- floor4 = Floor [] []

        -- test input
        floor1 = Floor [] [mcPo, mcTm]
        floor2 = Floor [genPo] []
        floor3 = Floor [genTm] []
        floor4 = Floor [] []

        -- someone else's input
        -- floor1 = Floor [genPm] [mcPm]
        -- floor2 = Floor [genPo, genTm, genRu, genCo] []
        -- floor3 = Floor [] [mcTm, mcRu, mcCo, mcPo]
        -- floor4 = Floor [] []

        init_state = State 0 [floor1, floor2, floor3, floor4]
        final_tree = takeWhile (\x -> not (True `elem` (map is_done (last x)))) (iterate grow_tree [[init_state]])
        
    print(length final_tree)