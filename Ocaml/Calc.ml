(** Just some functions I implement often ;) **)

let fak n =
  let rec helper n a =
    if n < 0 then
      failwith "Dafuq, dude?"
    else if n = 0 then
      a
    else
      helper (n-1) (a*n)
  in helper n 1

let fibonacci n =
  let rec helper n a b =
    if n = 0 then
      b
    else
      helper (n-1) (a+b) a
  in helper n 1 0

let choose a b =
  if a < b then
    failwith "Seriously?"
  else
    (fak a) / ((fak b)*(fak (a-b)))

let rec reduce l f a = match l with
  | x::xs -> reduce xs f (f a x)
  | _ -> a

let rec map l f = match l with
| [] -> []
| x::xs -> (f x)::(map xs f)

let foldLeft l f = match l with
  | x::xs -> reduce xs f x
  | _ -> failwith "Error"

let rec looper f n =
  if n < 0 then
    looper f (-n)
  else
    let res = f () in looper f (n-1)

let rec range a b =
  if b < a then
    range b a
  else if a = b then
    [a]
  else
    a::(range (a+1) b)

let sum l = reduce l (+) 0

let sumMap a b f = sum (map (range a b) f)
