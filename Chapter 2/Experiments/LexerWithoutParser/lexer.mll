{
type token =
| NUMBER of int

| LPAREN
| RPAREN

| TIMES
| MINUS
| PLUS
| DIV

| EOF
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
