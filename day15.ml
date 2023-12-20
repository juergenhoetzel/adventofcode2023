let clist_of_string s = List.init (String.length s) (String.get s)

let hash s = List.fold_left (fun acc c -> (Char.code c + acc) * 17 mod 256) 0 (clist_of_string s)

let part1 s = String.split_on_char ',' s |> List.map hash |> List.fold_left ( + ) 0

let example_input = "rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7"


let () = let input_str = match Sys.argv with
           |  [| _; file_name |] -> open_in "input.txt" |> input_line (* FIXME:leak *)
           | _ -> example_input in
         part1 input_str |> Format.printf "Part1: %d\n"



