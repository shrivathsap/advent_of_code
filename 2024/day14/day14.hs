import Text.Regex.TDFA
import System.IO
import Data.List

movie :: Integral b => [[b]] -> b -> b -> b -> [(b, b)]
movie positions cols rows seconds = [(((c!!0)+seconds*(c!!2))`mod`cols, ((c!!1)+seconds*(c!!3))`mod`rows)|c<-positions]

partOne parsed_input cols rows =
    let
        final_config = movie parsed_input cols rows 100
        first = [p|p<-final_config, 2*(fst p)<(cols-1) && 2*(snd p)<(rows-1)]
        second = [p|p<-final_config, 2*(fst p)>(cols-1) && 2*(snd p)<(rows-1)]
        third = [p|p<-final_config, 2*(fst p)<(cols-1) && 2*(snd p)>(rows-1)]
        fourth = [p|p<-final_config, 2*(fst p)>(cols-1) && 2*(snd p)>(rows-1)]
    in
        (length first)*(length second)*(length third)*(length fourth)

partTwo parsed_input cols rows = [i|i<-[0..10000], length(nub(movie parsed_input cols rows i))== length(movie parsed_input cols rows i) ]

main = do
    handle <- openFile "day14.txt" ReadMode
    contents <- hGetContents handle
    let
        length = 101
        height = 103
        all = lines contents
        f string = (map (read::String->Int))(getAllTextMatches(string =~ "[0-9]+|-[0-9]+")::[String])
        pos_vel = [f l|l<-all]
    print(partOne pos_vel length height)
    print(partTwo pos_vel length height)