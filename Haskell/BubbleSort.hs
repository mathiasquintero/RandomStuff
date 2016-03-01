let bubble [] = []; bubble [x] = [x]; bubble (x:y:xs) = if x > y then y:(bubble (x:xs)) else x:(bubble (y:xs))
let length [] = 0; length (x:xs) = 1 + (length xs)
let helper 0 a = a; helper n a = helper (n-1) (bubble a)
let sort l = helper (length l) l
