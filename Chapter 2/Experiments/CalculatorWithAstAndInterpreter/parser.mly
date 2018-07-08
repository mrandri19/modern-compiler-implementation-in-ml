%{
type operator =
    | Plus
    | Minus
    | Times
    | Div
type ast =
    | Number of int
    | Operation of ast * operator * ast
    | Block of ast
%}

%token LPAREN RPAREN
%token PLUS MINUS TIMES DIV
%token EOF
%token <int> NUMBER

%start main
%type <ast> main
%%
main:
    | expr EOF { $1 }
;

expr:
    NUMBER               { Number $1 }
    | LPAREN expr RPAREN { Block $2 }
    | expr PLUS expr     { Operation ($1 ,Plus ,$3) }
    | expr MINUS expr    { Operation ($1 ,Minus ,$3) }
    | expr TIMES expr    { Operation ($1 ,Times ,$3) }
    | expr DIV expr      { Operation ($1 ,Div ,$3) }
