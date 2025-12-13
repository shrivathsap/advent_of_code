import System.IO

next_char :: Num f => ([[Char]], (Int, Int), (Int, Int), [Char], Bool, f) -> ([[Char]], (Int, Int), (Int, Int), [Char], Bool, f)
next_char (grid, (x, y), (dx, dy), visited, end, count)
    |(grid!!x)!!y==' ' = (grid, (x, y), (dx, dy), visited, True, count)
    |(grid!!x)!!y=='|' = (grid, (x+dx, y+dy), (dx, dy), visited, end, count+1)
    |(grid!!x)!!y=='-' = (grid, (x+dx, y+dy), (dx, dy), visited, end, count+1)
    |(grid!!x)!!y=='+' = (grid, (x+ndx, y+ndy), (ndx, ndy), visited, end, count+1)
    |otherwise = (grid, (x+dx, y+dy), (dx, dy), visited++[(grid!!x)!!y], end, count+1)
    where
        (ndx, ndy) = if (grid!!(x-dy))!!(y+dx)==' ' then (dy, -1*dx) else (-1*dy, dx)

main = do
    grid <- lines <$> readFile "day19.txt"
    let
        fourth (a, b, c, d, e, f) = d
        fifth (a, b, c, d, e, f) = e
        sixth (a, b, c, d, e, f) = f
        (x, y) = (0, head [i | i<-[0..length (grid!!0)-1], (grid!!0)!!i/=' '])
        final = head $ (dropWhile (\x->not(fifth x))) $ iterate next_char (grid, (x, y), (1, 0), [], False, 0)
    print(fourth final, sixth final)