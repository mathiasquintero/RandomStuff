let rec bubble l = match l with
  | [] -> []
  | x::[] -> l
  | x::(y::xs) -> if (x > y) then y::(bubble (x::xs)) else x::(bubble (y::xs))

let rec length l = match l with
| [] -> 0
| x::xs -> 1 + length xs

let sort l =
  let rec loop l n =
    if n == 0 then
      l
    else
      loop (bubble l) (n-1)
  in loop l (length l)
