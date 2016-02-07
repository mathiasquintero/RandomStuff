let rec insert i l = match l with
  | [] -> [i]
  | h::t -> if h > i then i::l else h::(insert i t)

let sort l =
  let rec doit a l = (match l with
  | [] -> a
  | x::xs -> doit (insert x a) xs) in doit [] l
