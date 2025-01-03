import qualified Data.Map as Map

draw :: [String]-> IO ()
draw grid = mapM_ putStrLn grid

draw_from :: Map.Map (Int, Int) Bool -> Int -> Int -> IO ()
draw_from dict rows cols= 
    let
        h bool = if bool then '#' else '.'
    in
        draw [[h $ (Map.!) dict (x, y)|y<-[0..cols-1]]|x<-[0..rows-1]]

neighbours :: (Int, Int) -> Int -> Int -> [(Int, Int)]
neighbours (x, y) rows cols = [(a, b)|(a, b)<-nbd, 0<=a, a<rows, 0<=b, b<cols] where
    nbd = [(x-1, y-1), (x-1, y), (x-1, y+1),
           (x, y-1),             (x, y+1),
           (x+1, y-1), (x+1, y), (x+1, y+1)]


update_state :: Int -> Int -> Map.Map (Int, Int) Bool -> Map.Map (Int, Int) Bool
update_state rows cols state_dict =
    let 
        alive_nbs (x, y) = length [z|z<-neighbours (x, y) rows cols, (Map.!) state_dict z == True]
        next_state (x, y) =
            if (x, y) `elem` [(0,0),(0, cols-1),(rows-1,0),(rows-1,cols-1)] then True--remove this for part one
            else if (Map.!) state_dict (x, y) then (alive_nbs (x, y) == 2)||(alive_nbs (x, y) == 3)
            else (alive_nbs (x, y) == 3)
    in
        Map.fromList [((x, y), next_state (x, y))|(x, y)<-Map.keys state_dict]
    
main :: IO ()
main = do
    grid <- lines <$> readFile "day18.txt"
    let
        rnum = length grid
        cnum = length (grid!!0)
        g (x, y) =
            if (x, y) `elem` [(0,0), (0,cnum-1),(rnum-1,0),(rnum-1,cnum-1)] then True
            else (((grid)!!x)!!y)=='#'
        initial = Map.fromList [((x, y), (((grid)!!x)!!y)=='#')|x<-[0..rnum-1], y<-[0..cnum-1]]
        part_two_initial = Map.fromList [((x, y), g (x, y))|x<-[0..rnum-1], y<-[0..cnum-1]]
        final = (!! 100) $ iterate (update_state rnum cnum) part_two_initial
    print(length [z|z<- Map.elems final, z==True])