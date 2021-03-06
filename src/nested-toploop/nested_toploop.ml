open Batteries;;

open A_translator;;
open Ast_pp;;
open Ast_wellformedness;;
open Interpreter;;
open Toploop_options;;

let toploop_operate () e =
  print_string "\n";
  begin
    try
      let e' = a_translate_nested_expr e in
      check_wellformed_expr e';
      let v,env = eval e' in
      print_string (pp_var v ^ " where "  ^ pp_env env ^ "\n");
    with
    | Illformedness_found(ills) ->
      print_string "Provided expression is ill-formed:\n";
      List.iter
        (fun ill ->
           print_string @@ "   " ^ pp_illformedness ill ^ "\n")
        ills
  end;
  print_string "\n";
  print_string "Please enter an expression to evaluate followed by \";;\".\n";
  print_string "\n";
  flush stdout
;;

let command_line_parsing () = 
  let parser = BatOptParse.OptParser.make ~version:"version 0.3" () in
  BatOptParse.OptParser.add parser ~long_name:"log" logging_option;
  let spare_args = BatOptParse.OptParser.parse_argv parser in
  match spare_args with
  | [] -> ()
  | _ -> failwith "Unexpected command-line arguments."
;;

let () =
  let toploop_options = command_line_parsing () in

  print_string "Toy Nested Toploop\n";
  print_string "-----------\n";
  print_string "\n";
  print_string "Please enter an expression to evaluate followed by \";;\".\n";
  print_string "\n";
  flush stdout;
  Nested_parser.parse_expressions IO.stdin
  |> LazyList.iter (toploop_operate toploop_options)
;;