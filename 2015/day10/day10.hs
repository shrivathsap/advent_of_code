get_next :: [Char] -> [Char]
get_next string =
    if string == "" then ""
    else
        let
            first = head string
            initial = takeWhile (==first) string
            n = length initial
        in
            (show n)++[first]++(get_next(drop n string))