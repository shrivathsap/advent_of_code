import System.IO

data Reindeer = Reindeer {speed::Int,
                          duration::Int,
                          rest::Int,
                          time_flown::Int,
                          time_rested::Int,
                          dist::Int,
                          is_flying::Bool,
                          score::Int}deriving (Show)

distance :: Int->Int->Int->Int->Int
distance speed duration rest time =
    if time<=0 then 0
    else if time<=duration then speed*time
    else
        speed*duration+(distance speed duration rest (time-duration-rest))

update_one :: Reindeer -> Reindeer
update_one reindeer =
    if is_flying reindeer then
        let
            new_time = if (time_flown reindeer)==(duration reindeer) then 0 else (time_flown reindeer)+1
            new_state = if (new_time==0) then False else True
            new_rested = if (new_time==0) then 1 else (rest reindeer)
            new_dist = if (new_time==0) then (dist reindeer) else (dist reindeer+speed reindeer)
        in
            Reindeer (speed reindeer) (duration reindeer) (rest reindeer) (new_time) (new_rested) (new_dist) (new_state) (score reindeer)
    else
        let
            new_rested = if (time_rested reindeer)==(rest reindeer-1) then 0 else (time_rested reindeer)+1
            new_state = if (new_rested==0) then True else False
            new_time = if (new_rested==0) then 0 else (time_flown reindeer)
        in
            Reindeer (speed reindeer) (duration reindeer) (rest reindeer) (new_time) (new_rested) (dist reindeer) (new_state) (score reindeer)

update_scores :: [Reindeer]->[Reindeer]
update_scores reindeers =
    let
        buff = [update_one x|x<-reindeers]
        max = maximum [dist x|x<-buff]
        f r = if (dist r==max) then (Reindeer (speed r) (duration r) (rest r) (time_flown r) (time_rested r) (dist r) (is_flying r) (score r + 1)) else r
    in
        [f x|x<-buff]

main = do
    let
        stats = []--input goes here as a list of three numbers
        dists = [distance (x!!0) (x!!1) (x!!2) 2503|x<-stats]
        reindeers = [Reindeer (x!!0) (x!!1) (x!!2) 0 0 0 True 0|x<-stats]
        end1 = (!!2503) $ iterate (map update_one) reindeers
        end = (!!2503) $ iterate update_scores reindeers
    print(maximum dists)
    print(maximum [score x|x<-end])