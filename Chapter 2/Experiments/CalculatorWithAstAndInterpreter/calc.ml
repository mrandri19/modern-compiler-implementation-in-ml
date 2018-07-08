#use "parser.ml";;
#use "lexer.ml";;

let rec interp_ast ast:int =
    match ast with
    | Number n -> n
    | Block ast1 -> interp_ast ast1
    | Operation (ast1, op, ast2) ->
        let ast1 = interp_ast ast1 in
        let ast2 = interp_ast ast2 in
        match op with
        | Plus -> ast1 + ast2
        | Minus -> ast1 - ast2
        | Times -> ast1 * ast2
        | Div -> ast1 / ast2

let () =
    let lexbuf = Lexing.from_channel stdin in
    let ast = main testlang lexbuf in
    print_endline @@ string_of_int @@ interp_ast ast;
