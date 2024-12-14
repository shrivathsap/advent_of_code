import Text.Regex.TDFA
import System.IO

area :: Int->Int->Int->Int
area x y z = 2*(x*y+y*z+z*x)+foldr1 min [x*y, y*z, z*x]

ribbon :: Int->Int->Int->Int
ribbon x y z = foldr1 min [2*(x+y), 2*(y+z), 2*(z+x)] + (x*y*z)
main = do
    handle <- openFile "day02.txt" ReadMode
    contents <- hGetContents handle
    let
        all = [map (read::String->Int) (getAllTextMatches(x =~ "[0-9]+"))|x<-(lines contents)]
    print(sum [area (box!!0) (box!!1) (box!!2)|box<-all])
    print(sum [ribbon (box!!0) (box!!1) (box!!2)|box<-all])