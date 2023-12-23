type range =
  {
    dest_start: int;
    source_start: int;
    length: int;
  }

let ints_of_line s =
  let number_r = Str.regexp "\\([0-9]+\\)" in
  let rec get_numbers start =
    print_newline ();
    try
      let pos = Str.search_forward number_r s start in
      let m = Str.matched_string s in
      (int_of_string m)::(get_numbers (pos + (String.length m)))
    with Not_found -> [] in
  get_numbers 0

let parse_input s =
  let sections = Str.split (Str.regexp "\n^$\n") s in
  let seeds = List.hd sections |> ints_of_line in
  let maps_s = List.tl sections in
  let mappings = List.map (fun s -> List.nth (String.split_on_char ':' s) 1
                            |> Str.split (Str.regexp "\n")
                            |> List.map (fun line -> let xs = ints_of_line line in
                                                     { dest_start = List.nth xs 0;
                                                       source_start = List.nth xs 1;
                                                       length = List.nth xs 2;
                                                     })
                   ) maps_s in
  mappings, seeds


let move_categories mappings seed =
  let move_category n ranges =
    match List.filter (fun range -> n >= range.source_start && n < range.source_start + range.length ) ranges with
    | range::_ -> n + range.dest_start - range.source_start
    | _ -> n in                 (* FIXME: Multiple ranges? *)
  List.fold_left (fun n ranges -> move_category n ranges) seed mappings


let example_input ="seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4
"


let min_seed mappings seeds =
  let xs = List.map (move_categories mappings) seeds in
  List.fold_left min (List.hd xs) (List.tl xs)

let () =
  let s = match Sys.argv with
    |  [| _; file_name |] -> In_channel.(open_text file_name |> input_all) (* FIXME: File handle leak *)
    | _ -> example_input in
  let (mappings, seeds) = parse_input s in
  Printf.printf "Part 1: %d\n" (min_seed mappings seeds)

(* Local Variables: *)
(* compile-command: "ocamlfind ocamlopt -o day5 -linkpkg -package str day5.ml" *)
(* End: *)
