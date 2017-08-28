open List;;
open Str;;

(** Actual calulation **)
let rec (%) a b = if a < b then a else (a - b) % b;;
let rec pow a b acc = if b = 0 then acc else pow a (b - 1) (a * acc);;
let (^) a b = (pow a b 1);;
let rec doubleArrow a b r = if b = 0 then r else doubleArrow a (b - 1) (a ^ r)
let ($) a b = doubleArrow a b 1;;
let output a b c = (a $ b) % c;;

(** Parsing stuff. Because reasons... **)
let numbers string = List.map int_of_string (Str.split (Str.regexp " ") string);;
let rec input numbers = match numbers with
    | x::xs -> let (a, b, _) = input xs in (x, a, b)
    | [] -> (0, 0, 0);;

let rec perform string = let a, b, c = input (numbers string) in output a b c;;
let rec doit n f = if n = 0 then () else f (); doit (n - 1) f;;

let times = read_int ();;
doit times (fun () ->
    let line = read_line () in
    let result = string_of_int (perform line) in
    print_string result
);;
