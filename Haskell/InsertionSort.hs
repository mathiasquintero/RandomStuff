let insert [] a = [a]; insert (x:xs) a = if a > x then x:(insert xs a) else a:(x:xs)
let helper [] a = a; helper (x:xs) a = helper xs (insert a x)
let sort l = helper l []
