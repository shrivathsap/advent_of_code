import System.IO

parse :: [String] -> [(Int, Int)]
parse stream = [(r (worded x !! 0), r (worded x !! 1)) | x<-stream]
    where
        colon x = if last x == ':' then init x else x
        worded x = map colon $ words x
        r = (read::String->Int)

severity :: Integral a => [(a, a)] -> a
severity scanners = sum [(d*r) | (d, r)<-scanners, d`mod`(2*(r-1)) == 0]

bad_delay :: Integral a => [(a, a)] -> a -> Bool
bad_delay scanners delay = any (==True) [((delay + d)`mod`(2*(r-1)) == 0) | (d, r) <-scanners]

main :: IO ()
main = do
    scanners <- fmap parse $ lines <$> readFile "day13.txt"
    print(severity scanners)
    print(head $ (dropWhile (\x-> bad_delay scanners x)) $ [1..])