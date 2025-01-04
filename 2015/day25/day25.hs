cantor (x,y) = (d*(d+1)`div`2)+y-1 where d=x+y-2--x+y-1 is the diagonal that (x,y) lives on
fast_power n e d =
    if e==1 then n`mod`d
    else if e`mod`2==0 then fast_power (n^2`mod`d) (e`div`2) d
    else n*(fast_power (n^2`mod`d) (e`div`2) d)`mod` d
apply n f x = foldr (\a b -> f b) x [1..n]
seed = 20151125
a = 252533
b = 33554393
f num = (a*num)`mod`b
input = (0,0)--input goes here
part_one = (seed*(fast_power a (cantor input) b))`mod` b