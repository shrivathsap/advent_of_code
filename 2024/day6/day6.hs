import System.IO
import Data.List
import qualified Data.Set as Set

--rotate a direction clockwise by pi
rotate::[Int]->[Int]
rotate [x, y] = [y, -x]

init_orientation :: Char->[Int]
init_orientation '^' = [-1, 0]
init_orientation '>' = [0, 1]
init_orientation 'V' = [1, 0]
init_orientation '<' = [0, -1]

add_vects :: (Integral n)=>[n]->[n]->[n]
add_vects [] [] = []
add_vects (x:xs) (y:ys)
    |(length (x:xs) /= length (y:ys)) = []
    |otherwise = (x+y:add_vects xs ys)

within_bounds :: Foldable t => Int->Int->[t a]->Bool
within_bounds x y array = (x `elem` [0..length array - 1]) && (y `elem` [0..length (array!!0) - 1])

--run through the grid and find the place where the character is one of ^>V< and figure out the orientation
find_initial :: [[Char]] ->  [[Int]]
find_initial grid = [[[i, j], init_orientation ((grid!!i)!!j)]|i<-[0..length grid-1], j<-[0..length (grid!!0)-1], not((grid!!i)!!j `elem` ['#', '.'])]!!0

possible :: [[Char]] -> [Int] -> [Int] -> Int -> Int -> Bool
possible grid start_pos start_dir x y = 
    if (grid!!x)!!y `elem` ['#', '^', '>', 'v', '<'] then False
    else
        let
            num_r = length grid
            num_c = length (grid!!0)
            -- obstacles_visited = Set.empty
            (end_pos, end_dir, visited) = until repeat_or_outside add_next (start_pos, start_dir, Set.empty)
                where
                    repeat_or_outside (position, direction, list) =
                         ([position, direction] `Set.member` list)||(position!!0)<0||(position!!0)>=num_r||(position!!1)<0||(position!!1)>=num_c
                    add_next (position, direction, list) = 
                        let [a, b] = [(position!!0)+(direction!!0), (position!!1)+(direction!!1)]--(add_vects position direction)
                        in
                            if ((a<0)||(a>=num_r)||(b<0)||(b>=num_c)) then ([a, b], direction, list)
                            else
                                if (((grid!!a)!!b) == '#')||((a==x)&&(y==b)) then (position, rotate direction, Set.insert [position, direction] list)
                                else
                                    ([a, b], direction, list)
        in
            within_bounds (end_pos!!0) (end_pos!!1) grid

--move one step, if it isn't in the grid, that's the result, else check whether there's an obstacle
next_pos :: [[Char]]->[Int]->[Int]->[[Int]]
next_pos grid current direction = 
    let
        potential_next = add_vects current direction
    in
        if not(within_bounds (potential_next!!0) (potential_next!!1) grid) then [potential_next, direction]
        else
            if (grid!!(potential_next!!0))!!(potential_next!!1) == '#' then next_pos grid current (rotate direction)
            else [potential_next, direction]

main = do
    handle <- openFile "day6.txt" ReadMode
    contents <- hGetContents handle
    let
        grid = lines contents
        start = find_initial grid
        --magic! two lambda functions: one to check within bounds, another to get the next position
        --iterate from start gives an "infinite" list, but then we takeWhile the element is within bounds
        --nub is from Data.List and removes duplicates
        visited = takeWhile (\x-> within_bounds ((x!!0)!!0) ((x!!0)!!1) grid ) $ iterate (\x -> next_pos grid (x!!0) (x!!1)) start
        distinct_places = nub [x!!0|x<-visited]
        possible_obstacles = [x|x<-distinct_places, possible grid (start!!0) (start!!1) (x!!0) (x!!1)]
        -- possible_obstacles = [x|x<-distinct_places, has_loops grid start x]
    print(length possible_obstacles)
    print(length distinct_places)