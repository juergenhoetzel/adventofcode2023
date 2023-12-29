let parse s = String.split_on_char '\n' s |> List.map (fun line -> Array.init (String.length line) (String.get line)) |> Array.of_list

let n_empty_rows image y_start y_end =
  Array.sub image y_start (y_end - y_start)
  |> Array.to_list
  |> List.filter (fun row -> Array.mem '#' row|>not)
  |> List.length

let n_empty_cols image x_start x_end =
  Array.init (x_end - x_start) (fun x -> Array.init (Array.length image) (fun y -> image.(y).(x + x_start)))
  |> Array.to_list
  |> List.filter (fun row -> Array.mem '#' row|>not)
  |> List.length

let galaxy_positions image =
  Array.mapi (fun y row -> (Array.to_list row) |> List.mapi (fun x c -> if c = '#' then Some (y,x) else None)
                           |> List.filter_map Fun.id) image
  |> Array.to_list |> List.concat


let galaxy_combinations image =
  let positions = galaxy_positions image in
  let rec iter = function
    | [] -> []
    | pos::xs -> (List.map (fun pos2 -> (pos, pos2)) xs) @ iter xs in
  iter positions


let galaxy_difference image ((y1, x1),(y2, x2)) =
  let empty_x = n_empty_cols image (min x1 x2) (max x1 x2) in
  let empty_y = n_empty_rows image (min y1 y2) (max y1 y2) in
  (abs (x1-x2)) + (abs (y2 - y1))  + empty_x + empty_y

let part1 image =
  galaxy_combinations image
  |> List.map (fun comb -> galaxy_difference image comb) |> List.fold_left (+) 0

let example_input = "...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#....."

let () =
  let image = match Sys.argv with
    | [|_; file_name |] -> In_channel.(with_open_text file_name  input_all|> String.trim) |> parse
    | [|_|] -> parse example_input
    | _ -> failwith "Too many args" in
  Printf.printf "Part1: %d\n" (part1 image);

(* Local Variables: *)
(* compile-command: "ocamlfind ocamlopt -o day11 day11.ml" *)
(* End: *)
