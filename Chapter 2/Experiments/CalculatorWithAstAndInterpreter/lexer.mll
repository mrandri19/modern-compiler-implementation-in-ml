{
module L = Lexing
module B = Buffer
let get      = L.lexeme
let sprintf  = Printf.sprintf

let position lexbuf =
    let p = lexbuf.L.lex_curr_p in
        sprintf "%s:%d:%d"
        p.L.pos_fname p.L.pos_lnum (p.L.pos_cnum - p.L.pos_bol)

let set_filename (fname:string) (lexbuf:L.lexbuf)  =
    ( lexbuf.L.lex_curr_p <-
        { lexbuf.L.lex_curr_p with L.pos_fname = fname }
    ; lexbuf
    )

exception Error of string
let error lexbuf fmt =
    Printf.kprintf (fun msg ->
        raise (Error ((position lexbuf)^" "^msg))) fmt
}
let digit = ['0'-'9']

rule testlang = parse
    | '\n'|'\r'|'\t'|' ' { testlang lexbuf }
    | '('   { LPAREN }
    | ')'   { RPAREN }
    | '+'   { PLUS }
    | '-'   { MINUS }
    | '*'   { TIMES }
    | '/'   { DIV }
    | digit as d {
        NUMBER (
            match d with
            | '0' -> 0
            | '1' -> 1
            | '2' -> 2
            | '3' -> 3
            | '4' -> 4
            | '5' -> 5
            | '6' -> 6
            | '7' -> 7
            | '8' -> 8
            | '9' -> 9
            | _ -> failwith "BUG"
            )
    }
    | eof   { EOF }
    | _         { error lexbuf
               "found '%s' - don't know how to handle" @@ get lexbuf }