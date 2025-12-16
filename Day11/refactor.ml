let read_file filename = In_channel.with_open_text filename In_channel.input_all

let contents = read_file "input"

let lines =
  contents
  |> String.split_on_char '\n'
  |> List.filter (fun s -> s <> "")


let parse_line line =
  match String.split_on_char ':' line with
  | [node; rest] ->
    let node = String.trim node in
    let neighbors =
      rest
      |> String.trim
      |> String.split_on_char ' '
      |> List.filter ((<>) "")
    in
    (node, neighbors)
  | _ ->
    failwith ("invalid line: " ^ line)

let parse_lines lines = List.map parse_line lines

let servers = parse_lines lines

let get_neighbors node =
  match List.find_opt (fun (n, _) -> n = node) servers with
  | Some (_, neighbors) -> neighbors
  | None -> []

let rec dfs visited node =
  if node = "out" then 1
  else if List.mem node visited then 0
  else
    let visited = node :: visited in
    get_neighbors node
    |> List.map (dfs visited)
    |> List.fold_left (+) 0

let count = dfs [] "you"

let () = Printf.printf "Unique paths from you to out: %d\n" count
