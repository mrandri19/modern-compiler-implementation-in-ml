#use "lexer.ml";;

let string_of_token = function
| NUMBER n -> "number"

| LPAREN -> "lparen"
| RPAREN -> "rparen"

| TIMES -> "times"
| MINUS -> "minus"
| PLUS -> "plus"
| DIV -> "div"

| EOF -> "eof";;

let lexbuf = Lexing.from_channel stdin;;
let rec dump_lexbuf () =
    let tok = testlang lexbuf in
    let () = print_endline @@ string_of_token tok in
    if tok != EOF then
        dump_lexbuf ()
    else ()
;;

let () = dump_lexbuf ();;