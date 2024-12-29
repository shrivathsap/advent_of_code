import System.IO
import Data.List

parsed :: [Char] -> [Char]
parsed [] = []
parsed ('\\':'"':xs) = ('"':parsed xs)
parsed ('\\':'x':x:y:xs) = ('!':parsed xs)
parsed ('\\':'\\':xs) = ('\\':parsed xs)
parsed (x:xs) = (x:parsed xs)

unparsed ::[Char]->[Char]
unparsed [] = []
unparsed ('"':xs) = ('\\':'"':unparsed xs)
unparsed ('\\':xs) = ('\\':'\\':unparsed xs)
unparsed (x:xs) = (x:unparsed xs)

main :: IO ()
main = do
    handle <- openFile "day08.txt" ReadMode
    contents <- hGetContents handle
    let
        all_lines = lines contents
    print(sum [length x|x<-all_lines])
    print(sum [length (parsed x)-2|x<-all_lines])--minus 2 for the slashes in \" for escaping the end quotes
    print(sum [length (unparsed x)+2|x<-all_lines])--plus 2 for the added " in the end, i.e., the quotes around "\\x23"