module Posset = Set.Make(struct type t = (int*int)*(int*int) let compare (p1,_) (p2,_) = compare p1 p2 end)

let start_direction = (0,0)

let parse_input lines =
  List.map (fun s -> Array.init( String.length s) (String.get s)) lines
  |> Array.of_list

let is_valid_pos contraption  (y, x) =
  0 <= y && y < Array.length contraption && 0 <= x && x < Array.length contraption.(y)


let flow contraption start_pos direction =
  let visited = ref [] in
  let rec flow_iter (y, x) (dy, dx) =
    if is_valid_pos contraption (y, x) && not (List.mem ((y, x), (dy, dx)) !visited) then
      begin
        visited :=  ((y, x), (dy, dx))::!visited;
        let new_dirs = match contraption.(y).(x) with
          | '/' ->  [(-dx, -dy)]
          | '\\' -> [(dx, dy)]
          | '|' -> [(1, 0); (-1, 0)]
          | '-' -> [(0, 1); (0, -1)]
          | '.' -> [(dy, dx)]
          | c -> invalid_arg  (String.make 1 c) in
        List.iter (fun new_d -> let (dy,dx) = new_d in flow_iter ((y+dy),(x+dx)) new_d)  new_dirs;
      end
    else ()
  in flow_iter start_pos direction;
  !visited


let example_input = ".|...\\....
|.-.\\.....
.....|-...
........|.
..........
.........\\
..../.\\\\..
.-.-/..|..
.|....-|.\\
..//.|...." |> String.split_on_char '\n'


let part_1 contraption =
  flow contraption (0, 0) (0, 1) |> Posset.of_list |>Posset.cardinal

let part_2 contraption =
  let y_size = Array.length contraption in
  let x_size = Array.length contraption.(0) in
  let startpos_directions = [List.init y_size (fun y -> (y,x_size-1),(0, -1));List.init y_size (fun y -> (y,0),(0, 1));
                             List.init x_size (fun x -> (y_size-1,x),(-1, 0));List.init x_size (fun x -> (0,x),(1, 0))] in
  let xs = List.concat_map (List.map (fun (pos,dir) -> flow contraption pos dir |> Posset.of_list|> Posset.cardinal)) startpos_directions in
  List.fold_left max (List.hd xs) (List.tl xs)

let () =
  let input_str = match Sys.argv with
    |  [| _; file_name |] -> In_channel.(with_open_text  file_name input_lines)
    | _ -> example_input in
  let contraption = parse_input input_str in
  part_1 contraption |> Printf.printf "Part 1: %d\n";
  part_2 contraption |> Printf.printf "Part 2: %d\n";


  (* List.iter (fun startpos_directions ) startpos_directions *)



(* Local Variables: *)
(* compile-command: "ocamlfind ocamlopt -o day16 day16.ml" *)
(* End: *)
