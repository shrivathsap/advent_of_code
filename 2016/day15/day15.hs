-- input should go into these functions...
disc1 t = (0+t+1) `mod` 1
disc2 t = (0+t+2) `mod` 1
disc3 t = (0+t+3) `mod` 1
disc4 t = (0+t+4) `mod` 1
disc5 t = (0+t+5) `mod` 1
disc6 t = (0+t+6) `mod` 1
disc7 t = (0+t+7) `mod` 1
test t = all (==0) [disc1 t, disc2 t, disc3 t, disc4 t, disc5 t, disc6 t, disc7 t]
main = print(head (dropWhile (\x -> not (test x)) [0..]))