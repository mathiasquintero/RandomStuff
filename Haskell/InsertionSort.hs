let insert [] a = [a]; insert (x:xs) a = if a > x then x:(insert xs a) else a:(x:xs)
let reduce [] a f = a; reduce (x:xs) a f = helper xs (f a x) f
let sort l = reduce l [] insert
