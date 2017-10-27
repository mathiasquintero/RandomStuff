let rec map l f = match l with
    | h::t -> (f h)::(map t f)
    | _ -> [];;

let rec reduce l a f = match l with
    | h::t -> reduce t (f a h) f
    | _ -> a;;

let rec zip x y = match x, y with
    | x::xs, y::ys -> (x, y)::(zip xs ys)
    | _ -> [];;

let reversed l =
    let rec doit l a = match l with
        | h::t -> doit t (h::a)
        | _ -> a
    in doit l [];;

let rec range a b =
    if b < a then
        reversed (range b a)
    else if a = b then
        [a]
    else
        a::(range (a + 1) b);;

let length l = reduce l 0 (fun a _ -> a + 1);;
let width l = match l with
    | h::t -> length h
    | _ -> 0;;

let identityVector i l = map (range 1 l) (fun x -> if x = i then 1.0 else 0.0);;

let identityMatrix l = map (range 1 l) (fun x -> identityVector x l);;

let sumVectors a b = map (zip a b) (fun (a, b) -> a +. b);;
let multiplyScalarAndVector x v = map v (fun y -> x *. y);;
let multiplyVectors a b = reduce (zip a b) 0.0 (fun a (x, y) -> a +. x *. y);;

let rec emptyMatrix l =
    if l = 0 then
        []
    else
        []::(emptyMatrix (l - 1));;

let rec (@) x y = match x with
    | h::t -> h::(t @ y)
    | _ -> y;;

let crossAppend x y = map (zip x y) (fun (a, b) -> a @ [b]);;

let transposed m = reduce m (emptyMatrix (width m)) crossAppend;;

let sumMatrices a b = map (zip a b) (fun (a, b) -> sumVectors a b);;
let multiplyScalarAndMatrix x m = map m (fun v -> multiplyScalarToVector x m);;
let multiplyMatrices a b =
    let transposed = transposed b in
    reduce a [] (fun a b -> a @ [map transposed (fun x -> multiplyVectors x b)]);;

let multiplyMatrixAndVector m v = multiplyMatrices m (transposed [v])

let diagonal m =
    let width = width m in
    let length = length m in
    let range = (range 1 length) in
    map (zip range m) (fun (i, v) -> multiplyVectors (identityVector i width) v);;

let rec powerMatrix m pow =
    if pow = 0 then
        identityMatrix (width m)
    else
        multiplyMatrices m (powerMatrix m (pow - 1));;

let rec goIn i af a bf b =
    let vector = identityVector i (width a) in
    match (a, b) with
    | (x::xs, y::ys) ->
        let factor = (multiplyVectors vector x) /. (multiplyVectors vector af) in
        let newX = sumVectors x (multiplyScalarAndVector (-1.0 *. factor) af) in
        let newY= y -. factor *. bf in
        let (a, b) = goIn i af xs bf ys in
        (newX::a, newY::b)
    | _ -> ([], []);;

let rec doit a b i =
    match (a, b) with
    | (x::xs, y::ys) ->
        let (a, b) = goIn i x xs y ys in
        let (a, b) = doit a b (i + 1) in
        (x::a, y::b)
    | _ -> (a, b);;

let solve a b =
    let (a, b) = doit a b 1 in
    let (a, b) = doit (reversed a) (reversed b) 1 in
    let (a, b) = (reversed a, reversed b) in
    let zipped = zip a b in
    let l = zip (zipped (length zipped)) in
    map l (fun ((a, b), i) -> b /. (multiplyVectors (identityVector i (length a)) a));;


let a = [
    [2.0; 3.0];
    [4.0; 5.0]
];;

let b = [
    [2.0; 3.0];
    [4.0; 5.0]
];;

let c = multiplyMatrices a b;;
