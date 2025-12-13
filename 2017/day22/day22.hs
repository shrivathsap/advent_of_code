import System.IO
import qualified Data.Map as Map
import Debug.Trace

fourth (a,b,c,d) = d

update1 (infected, (x,y), (dx,dy), infections) = (new_infected, (x+dx1, y+dy1), (dx1,dy1), new_infections)
    where
        is_infected = (x,y) `elem` infected
        (dx1,dy1) = if is_infected then (dy, -dx) else (-dy,dx)
        new_infected = if is_infected then filter (/= (x,y)) infected else infected++[(x,y)]
        new_infections = if is_infected then infections else infections+1

update2 (states, (x,y), (dx,dy),infections) = (new_states, (x+dx1,y+dy1), (dx1,dy1), new_infections)
    where
        --0:clean, 1:weak, 2:inf, 3:flag; 0->1->2->3->0
        --0->left, 1->no turn, 2->right, 3->reverse
        cur_state = Map.findWithDefault 0 (x,y) states
        (!new_states, !(dx1,dy1), !new_infections) = case cur_state of
            0 -> (Map.insert (x,y) 1 states, (-dy,dx), infections)
            1 -> (Map.insert (x,y) 2 states, (dx,dy), infections+1)
            2 -> (Map.insert (x,y) 3 states, (dy,-dx), infections)
            3 -> (Map.delete (x,y) states, (-dx,-dy), infections)

evolve init_state rounds
    |rounds==0 = init_state
    |otherwise = evolve one_update (rounds-1) where !one_update = (update2 init_state)
main = do
    input <- lines <$> readFile "day22.txt"
    let
        rows = length input
        cols = length (input!!0)
        xshift = rows`div`2
        yshift = cols`div`2 --both are 25 in the input
        infected = [(x-xshift, y-yshift) | x<-[0..rows-1], y<-[0..cols-1], (input!!x)!!y=='#']
        init_state = Map.fromList [(x, 2) | x<-infected]
        (x, y) = (0,0)
        (dx,dy) = (-1,0)
        infections = 0
        generations = 100000
        final_state = (iterate update1 (infected, (x,y), (dx,dy), infections))!!10000
        final2 = evolve (init_state, (x,y), (dx,dy), infections) generations
    print(fourth final_state)
    print(fourth final2)