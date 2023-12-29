let parse_str s =
  Str.split_delim (Str.regexp  "\n\n") s
  |> List.map (fun s -> String.trim s |> String.split_on_char '\n'|> Array.of_list)

let rotate puzzle =
  let x_positions = Array.init (String.length puzzle.(0)) Fun.id in
  Array.map (fun x -> String.init (Array.length puzzle) (fun y -> String.get puzzle.(y) x)) x_positions

let flip_equal_smug puzzle flip_pos =
  let rec iter i =
    try
      let chars1 = let s = puzzle.(flip_pos-i-1) in List.init (String.length s) (String.get s) in
      let chars2 = let s = puzzle.(flip_pos+i) in List.init (String.length s) (String.get s) in
      let abs_diff = List.fold_left2 (fun acc x y -> acc + if x<>y then 1 else 0) 0 chars1 chars2 in
      abs_diff + iter (i+1)
  with Invalid_argument _ -> 0 in
  iter 0

let flip_equal puzzle flip_pos =
  let rec flip_equal_iter i =
    try puzzle.(flip_pos-i-1) = puzzle.(flip_pos+i) && flip_equal_iter (i+1)
    with Invalid_argument _ -> true in
  flip_equal_iter 0

let flip_pos puzzle =
  let flip_positions = List.init ((Array.length puzzle) - 1) succ in
  List.find_opt (flip_equal puzzle) flip_positions

let smug_pos puzzle =
  let flip_positions = List.init ((Array.length puzzle) - 1) succ in
  List.find_opt (fun pos -> flip_equal_smug puzzle pos == 1) flip_positions


let rec score puzzle opt_fun = match opt_fun puzzle with
  | Some n -> 100 * n
  | None -> match opt_fun (rotate puzzle) with
            | Some n -> n
            | None -> failwith "Puzzle Input"

let part1 puzzles =
  List.fold_left (+) 0 (List.map (fun puzzle -> score puzzle flip_pos) puzzles)

let part2 puzzles =
  List.fold_left (+) 0 (List.map (fun puzzle -> score puzzle smug_pos) puzzles)

let example_input = "#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.

#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#"

let () =
  let puzzles = match Sys.argv with
    | [|_; file_name |] -> In_channel.(with_open_text file_name  input_all) |> parse_str
    | [|_|] -> parse_str example_input
    | _ -> failwith "Too many args" in
  Printf.printf "Part1: %d\n" (part1 puzzles);
  Printf.printf "Part2: %d\n" (part2 puzzles)


(* Local Variables: *)
(* compile-command: "ocamlfind ocamlopt -o day13 day13.ml -linkpkg -package str" *)
(* End: *)
