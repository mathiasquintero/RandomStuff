let rec reduce l f a = match l with x::xs -> reduce xs f (f a x) | [] -> a;;
let rec map l f = match l with x::xs -> (f x)::(map xs f) | [] -> [];;

let ($) a b = match a with Some(a) -> a | None -> b;;
let (=>) i f = match i with Some(i) -> Some(f i) | None -> None;;
let (^?) a b = let m = (a => (fun x -> x ^ b)) in m $ b;;

let rec (%) a b = if a < b then a else (a - b) % b;;

let helper a n (f, s) = if (f n) then Some(a ^? s) else a;;
let fizzbuzz n l = (reduce l (fun a x -> helper a n x) None) $ (string_of_int n);; 

let rec range a b = if a < b then a::(range (a + 1) b) else [b];;
let rules = map [3, "Fizz"; 5, "Buzz"] (fun (a, b) -> (fun n -> n % a = 0), b);;

let game = map (range 0 100) (fun x -> fizzbuzz x rules);;
