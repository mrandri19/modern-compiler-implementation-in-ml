type token =
  | LPAREN
  | RPAREN
  | PLUS
  | MINUS
  | TIMES
  | DIV
  | EOF
  | NUMBER of (int)

val main :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> int
