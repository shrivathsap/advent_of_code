import System.IO
import Text.Regex.TDFA
best_comb :: [Int] -> [Int] -> [Int] -> (Int, Int)
best_comb [x1, y1] [x2, y2] target = 
    let
        x3 = target!!0+10000000000000
        y3 = target!!1+10000000000000
        det = x1*y2-x2*y1
        scaled_a = y2*x3-x2*y3
        scaled_b = -y1*x3+x1*y3
    in
        if (det == 0) then (0, 0) --this never happens in the input file, so I'm not going to fix this branch
        else if (det*scaled_a<0)||(det*scaled_b<0)||(scaled_a`mod`det /= 0)||(scaled_b`mod`det /= 0) then (0, 0)
        else (scaled_a`div`det, scaled_b`div`det)

main = do
    handle <- openFile "day13.txt" ReadMode
    contents <- hGetContents handle
    let 
        all = lines contents
        machines = [take 3 (drop (4*i) all)|i<-[0..(length all - 1)`div`4]]
        f string = (map (read::String->Int))(getAllTextMatches(string =~ "[0-9]+")::[String])
        linear_equations = [(map f) x|x<-machines]
        solutions = [best_comb (x!!0) (x!!1) (x!!2)|x<-linear_equations]
    print(sum [3*(fst x)+(snd x)|x<-solutions])