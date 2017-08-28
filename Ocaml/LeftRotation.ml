open List;;
open Str;;
open String;;
let (@) l i = List.append l [i];;
let rec shift l n = 
    if n = 0 then 
        l 
    else
        match l with 
        | x::xs -> shift (xs @ x) (n - 1)
        | [] -> [];;

let numbers string = List.map int_of_string (Str.split (Str.regexp " ") string);;
let string numbers = String.concat " " (List.map string_of_int numbers);;
let rec input numbers = match numbers with
    | x::xs -> let (a, _) = input xs in (x, a)
    | [] -> (0, 0);;

let (_, d) = input (numbers (read_line ()));;
let shifted = shift (numbers (read_line ())) d;;
print_string (string shifted);;

