let example_input_lines = String.split_on_char '\n' "467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598.."

let digit_x_positions s =
  let rec digit_positions_iter s i =
    try
      let pos = Str.search_forward (Str.regexp "\\([0-9]+\\)") s i in
      let str = Str.matched_group 0 s in
      (pos, str)::digit_positions_iter s (pos + (String.length str))
    with Not_found -> [] in
  digit_positions_iter s 0

let parse_input lines =
  List.mapi (fun y line -> List.map (fun (x, s) -> (y,x,s)) @@ digit_x_positions line) lines
  |> List.flatten

let is_symbol c = Str.string_match (Str.regexp ".*\\([^0-9.]+\\)") (String.make 1 c) 0

let is_symbol_connected alines y x len =
  let line_length = String.length alines.(0) in
  let found = ref false in
  for x2 = max (x - 1) 0 to min (x + len) (line_length - 1) do
    for y2 = max (y - 1) 0 to min (y+1) ((Array.length alines) - 1) do
      if String.get alines.(y2) x2|>is_symbol then
        found := true
    done
  done;
  !found

let valid_digits lines =
  let digit_positions = parse_input lines in
  let alines = Array.of_list lines in
  List.filter (fun (y,x,s) -> is_symbol_connected alines y x (String.length s)) digit_positions

let sum_valid lines =
  valid_digits lines |>
    List.fold_left (fun acc (_,_, s) -> acc + (int_of_string s)) 0

let () = let input_lines = match Sys.argv with
           |  [| _; file_name |] -> In_channel.(open_text file_name |> input_lines) (* FIXME: File handle leak *)
           | _ -> example_input_lines in
         sum_valid input_lines |> Format.printf "Part1: %d\n"


(* Local Variables: *)
(* compile-command: "ocamlfind ocamlopt -o day3 -linkpkg -package str day3.ml" *)
(* End: *)
