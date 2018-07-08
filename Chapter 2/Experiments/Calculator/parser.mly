%token LPAREN RPAREN
%token PLUS MINUS TIMES DIV
%token EOF
%token <int> NUMBER

%start main
%type <int> main
%%
main:
    expr EOF { $1 }
;

expr:
    NUMBER               { $1 }
    | LPAREN expr RPAREN { $2 }
    | expr PLUS expr     { $1 + $3 }
    | expr MINUS expr    { $1 - $3 }
    | expr TIMES expr    { $1 * $3 }
    | expr DIV expr      { $1 / $3 }
