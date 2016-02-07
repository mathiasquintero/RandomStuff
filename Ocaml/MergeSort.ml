let rec merge x y = match x,y with
  | [],_ -> y
  | _,[] -> x
  | h::t,m::n -> if m > h then h::(merge t y) else m::(merge x n)

let rec divide x = match x with
  | [] -> ([],[])
  | x::xs -> let (a,b) = divide xs in (x::b,a)

let rec sort x = match x with
  | [] -> []
  | x::[] -> [x]
  | _ -> let (a,b) = divide x in merge (sort a) (sort b)
