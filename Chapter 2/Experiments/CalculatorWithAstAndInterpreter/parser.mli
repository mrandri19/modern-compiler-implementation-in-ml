
(* The type of tokens. *)

type token = 
  | TIMES
  | RPAREN
  | PLUS
  | NUMBER of (int)
  | MINUS
  | LPAREN
  | EOF
  | DIV

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val main: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (ast)
