find_subsets nums target =
    if target <= 0 then []
    else if (length nums==1)&&((nums!!0)==target) then [nums]
    else if (length nums==1)&&((nums!!0)/=target) then []
    else
        let
            first = head nums
        in
            if first==target then [[first]]++(find_subsets (tail nums) target)
            else if first > target then find_subsets (tail nums) target
            else [[first]++x | x<-find_subsets (tail nums) (target-first)] ++ (find_subsets (tail nums) target)

main = do
    nums <- lines <$> readFile "day24.txt"
    let
        weights = reverse $ map (read::String->Int) nums
        target = sum(weights)`div`4
        all_possible = find_subsets weights target
        m = minimum [length x | x<-all_possible]
        best = [x | x<-all_possible, length x == m]
    print(weights)
    print(length all_possible)
    print(m)
    print(length best)
    print(minimum [product x | x<-best])