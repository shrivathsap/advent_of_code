import System.IO
import Text.Regex.TDFA
import Data.List

group_into_threes :: [a] -> ([a], [a], [a])
group_into_threes nine_ints = (take 3 nine_ints, take 3 (drop 3 nine_ints), drop 6 nine_ints)

-- find_fixed :: Eq a => (a -> a) -> a -> a
-- find_fixed f seed = values!!fixed
--     where
--         values = iterate f seed --[seed, f seed, f^2 seed, ...]
--         check n = (values!!n == values!!(n+1))
--         fixed = length $ takeWhile (==False) $ map check [0..]

parse :: RegexContext Regex source1 (AllTextMatches [] String) => source1 -> ([Int], [Int], [Int])
parse line = group_into_threes $ (map (read::String->Int))(getAllTextMatches(line=~"-?[0-9]+")::[String])

find_max_oneD :: (Int, Int, Int)->Int
find_max_oneD (x, v, a) = max root1 root2 --completely ignores the question of complex roots; got lucky with the input
    where
        b = a+2*v
        root1 = (-1*b+(ceiling $ sqrt (fromIntegral (b*b-8*a*x))))`div`2
        root2 = (-1*b-(ceiling $ sqrt (fromIntegral (b*b-8*a*x))))`div`2

find_max :: ([Int], [Int], [Int]) -> Int
find_max (p, v, a) =
    let
        xcoord = (p!!0, v!!0, a!!0)
        ycoord = (p!!1, v!!1, a!!1)
        zcoord = (p!!2, v!!2, a!!2)
    in
        maximum $ map find_max_oneD [xcoord, ycoord, zcoord]

dist :: Integral a => a -> ([a], [a], [a]) -> a
dist t (p, v, a) =
    let
        xcoord = (p!!0, v!!0, a!!0)
        ycoord = (p!!1, v!!1, a!!1)
        zcoord = (p!!2, v!!2, a!!2)
        f (x0, v0, a0) = x0+(v0*t)+((a0*t*(t+1))`div`2)
    in
        sum $ map abs $ map f [xcoord, ycoord, zcoord]

closest :: [([Int], [Int], [Int])] -> [Int]
closest stats = findIndices (==minimum distances) distances
    where
        last_time = maximum $ map find_max stats
        distances = map (dist last_time) stats

will_collide_oneD :: (Eq a, Num a) => a -> (a, a, a) -> (a, a, a) -> Bool
will_collide_oneD t (x0, v0, a0) (x1, v1, a1) = (a*t*t+b*t+c==0)
    where
        a = (a1-a0)
        b = (a1-a0)+2*(v1-v0)
        c = 2*(x1-x0)

will_collide :: (Eq a, Num a) => a -> ([a], [a], [a]) -> ([a], [a], [a]) -> Bool
will_collide t (p0, v0, a0) (p1, v1, a1) = (will_collide_oneD t xcoord0 xcoord1)&&(will_collide_oneD t ycoord0 ycoord1)&&(will_collide_oneD t zcoord0 zcoord1)
    where
        xcoord0 = (p0!!0, v0!!0, a0!!0)
        ycoord0 = (p0!!1, v0!!1, a0!!1)
        zcoord0 = (p0!!2, v0!!2, a0!!2)
        xcoord1 = (p1!!0, v1!!0, a1!!0)
        ycoord1 = (p1!!1, v1!!1, a1!!1)
        zcoord1 = (p1!!2, v1!!2, a1!!2)

collision_time_oneD :: Integral c => (c, c, c) -> (c, c, c) -> c
collision_time_oneD (x0, v0, a0) (x1, v1, a1)
    |(a == 0)&&(b == 0)&&(c == 0) = -2 --the two particles are the same
    |(a == 0)&&(b == 0)&&(c /= 0) = -1 --same acc, vel, but different starting positions
    |(a == 0) = if (c`mod`b==0 && c*b<0) then -1*(c`div`b) else -1 --no relative acc, linear equation
    |otherwise = if flag then r else -1 --check if collision time is integer or not
    where
        a = (a1-a0)
        b = (a1-a0)+2*(v1-v0)
        c = 2*(x1-x0)
        d = b*b-4*a*c
        e = floor $ sqrt $ (fromIntegral d::Double)
        r = if ((-b+e)`mod`(2*a)==0 && (-b+e)*a>=0) then (-b+e)`div` (2*a) else (-b-e)`div`(2*a)
        flag = (e*e==d) && (((-b+e)`mod`(2*a)==0 && (-b+e)*a>0)||((-b-e)`mod`(2*a)==0 && (-b-e)*a>0))

collision_time :: Integral a => ([a], [a], [a]) -> ([a], [a], [a]) -> a
collision_time (p0, v0, a0) (p1, v1, a1)
    |(xtime == -1)||(ytime == -1)||(ztime == -1) = -1 --no collision in positive time
    |(xtime == -2)&&(ytime == -2) = ztime
    |(ytime == -2)&&(ztime == -2) = xtime
    |(ztime == -2)&&(xtime == -2) = ytime
    |(xtime == -2)                = if (ytime==ztime) then ytime else -1
    |(ytime == -2)                = if (xtime==ztime) then ztime else -1
    |(ztime == -2)                = if (xtime==ytime) then xtime else -1
    |otherwise                    = if (xtime==ytime)&&(ytime==ztime) then xtime else -1
    where
        xcoord0 = (p0!!0, v0!!0, a0!!0)
        ycoord0 = (p0!!1, v0!!1, a0!!1)
        zcoord0 = (p0!!2, v0!!2, a0!!2)
        xcoord1 = (p1!!0, v1!!0, a1!!0)
        ycoord1 = (p1!!1, v1!!1, a1!!1)
        zcoord1 = (p1!!2, v1!!2, a1!!2)
        xtime = collision_time_oneD xcoord0 xcoord1
        ytime = collision_time_oneD ycoord0 ycoord1
        ztime = collision_time_oneD zcoord0 zcoord1

tick_particle :: Integral a => ([a], [a], [a]) -> a -> ([a], [a], [a])
tick_particle (p, v, a) t = ([p!!0+(v!!0)*t+(a!!0)*(t*(t+1)`div`2), p!!1+(v!!1)*t+(a!!1)*(t*(t+1)`div`2), p!!2+(v!!2)*t+(a!!2)*(t*(t+1)`div`2)],
                             [v!!0+(a!!0)*t, v!!1+(a!!1)*t, v!!2+(a!!2)*t], a)

to_delete :: (Eq a, Num a) => ([a], [a], [a]) -> [([a], [a], [a])] -> a -> Bool
to_delete (p, v, a) stats t = (length $ filter (==True) $ map (will_collide t (p, v, a)) stats)>=2

tick :: Integral a => ([([a], [a], [a])], [a]) -> ([([a], [a], [a])], [a])
tick (stats, col_times)
    |(filter (>0) col_times == []) = (stats, col_times)
    |otherwise = ([tick_particle x first_col | x<-stats, not(to_delete x stats first_col)], new_col_times)
    where
        first_col = minimum $ filter (>0) col_times
        new_col_times = filter (>0) [g x | x<-col_times]
        g x = if x<0 then x else x-first_col
        
main = do
    input <- lines <$> readFile "day20.txt"
    let
        stats = map parse (input)
        col_times = filter (>0) [collision_time x y | x<-stats, y<-stats]
        last_collision = maximum col_times
        leftover = (iterate tick (stats, col_times)) !! last_collision
    print(last_collision)
    print(minimum $ filter (>0) col_times)
    print("part one:", closest stats)
    print("part two:", length (fst leftover))