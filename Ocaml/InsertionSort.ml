let rec reduce l a f = match l with
  | h::t -> reduce t (f a h) f
  | [] -> a

let rec insert i l = match l with
  | [] -> [i]
  | h::t -> if h > i then i::l else h::(insert i t)

let sort l = reduce l [] insert
