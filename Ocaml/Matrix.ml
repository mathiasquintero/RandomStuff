let rec map l f = match l with
    | h::t -> (f h)::(map t f)
    | _ -> []

let rec reduce l a f = match l with
    | h::t -> reduce t (f a h) f
    | _ -> a

let rec zip x y = match x, y with
    | x::xs, y::ys -> (x, y)::(zip xs ys)
    | _ -> []

let length l = reduce l 0 (fun a _ -> a + 1)
let width l = match l with
    | h::t -> length h
    | _ -> 0

let multiplyVectors a b = reduce (zip a b) 0.0 (fun a (x, y) -> a +. x *. y)

let rec emptyMatrix l =
    if l = 0 then
        []
    else
        []::(emptyMatrix (l - 1))

let rec (@) x y = match x with
    | h::t -> h::(t @ y)
    | _ -> y

let crossAppend x y = map (zip x y) (fun (a, b) -> a @ [b])

let transposed m = reduce m (emptyMatrix (width m)) crossAppend

let multiplyMatrices a b =
    let transposed = transposed b in
    reduce a [] (fun a b -> a @ [map transposed (fun x -> multiplyVectors x b)])