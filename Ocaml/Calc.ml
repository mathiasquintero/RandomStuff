(**
  Just some functions I implement often ;)
**)

(**
  All of these functions are tail recursive.
  So they should be save to use with any input
**)

type number = N of int | R of float | Inf | NaN

let pow a b =
  let rec helper a b r =
    if b = 0 then
      r
    else
      helper a (b-1) (r*a)
  in helper a b 1

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

let reverse l =
  let rec helper l r = (match l with
    | h::t -> helper t (h::r)
    | _ -> r) in helper l []

let rec reduce l f a = match l with
  | x::xs -> reduce xs f (f a x)
  | _ -> a

let map l f =
  let rec helper l a = match l with
    | x::xs -> helper xs (f x:: a)
    | _ -> a
  in reverse (helper l [])

let foldLeft l f = match l with
  | x::xs -> reduce xs f x
  | _ -> failwith "Error"

let filter l f =
  let rec helper l r = (match l with
    | h::t -> if f h then helper t (h::r) else helper t r
    | _ -> r) in reverse (helper l [])

let rec looper f n =
  if n < 0 then
    looper f (-n)
  else if n == 0 then
    f ()
  else
    let res = f () in looper f (n-1)

let rec range a b =
  if b < a then
    reverse (range b a)
  else if a = b then
    [a]
  else
    a::(range (a+1) b)

let sum l = reduce l (+) 0

let sumMap a b f = sum (map (range a b) f)

let sumToPow a b n = sumMap a b (fun x -> pow x n)
