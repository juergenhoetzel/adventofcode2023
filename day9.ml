let parse_input lines = List.map (fun line -> Str.split (Str.regexp "[ \t]+") line |> List.map int_of_string) lines

let is_zerolist xs = List.filter ((<>) 0) xs |> List.length = 0

let last xs = List.nth xs (List.length xs - 1)

let sum xs =  List.fold_left (+) (List.hd xs) (List.tl xs)

let rec diff_elements = function
  | [] | [_] -> []
  | x1::x2::xs -> (x2 - x1)::(diff_elements (x2::xs))

let diff_list xs =
  let rec diff_list_iter acc =
    let diffs = diff_elements (List.hd acc) in
    if is_zerolist diffs then diffs::acc else diff_list_iter (diffs::acc)
  in
  diff_list_iter [xs]

let continue_line xs =
  let x = diff_list xs |> List.map last |> sum in
  xs @ [x]

let prepend_line xs =
  let x = diff_list xs
          |> List.map List.hd
          |> List.fold_left (fun acc x -> (x-acc)) 0 in
  x::xs



let part_1 input_str =
  List.map continue_line (parse_input input_str) |> List.map last |> sum

let part_2 input_str =
  List.map prepend_line (parse_input input_str) |> List.map List.hd |> sum


let example_input = String.split_on_char '\n' "0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45"

let () =
  let input_str = match Sys.argv with
    |  [| _; file_name |] -> In_channel.(open_text file_name |> input_lines) (* FIXME: File handle leak *)
    | _ -> example_input in
  Printf.printf "Part 1: %d\n" (part_1 input_str);
  Printf.printf "Part 2: %d\n" (part_2 input_str)

(* Local Variables: *)
(* compile-command: "ocamlfind ocamlopt -o day9 -linkpkg -package str day9.ml" *)
(* End: *)


