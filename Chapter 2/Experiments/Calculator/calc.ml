#use "parser.ml";;
#use "lexer.ml";;
let () =
    let lexbuf = Lexing.from_channel stdin in
    let result = main testlang lexbuf in
    print_endline @@ string_of_int result;
