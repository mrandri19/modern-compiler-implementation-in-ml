type id = string
type binop = Plus | Minus | Times | Div
type stm =
  | CompoundStm of stm * stm
  | AssignStm of id * exp
  | PrintStm of exp list
and exp = IdExp of id
        | NumExp of int
        | OpExp of exp * binop * exp
        | EseqExp of stm * exp

(* The program represented as AST in `prog`
    a := 5+3;
    b := (print(a, a-1), 10*a);
    print(b)
*)
let prog =
    CompoundStm(
        AssignStm("a",OpExp(NumExp 5, Plus, NumExp 3)),
        CompoundStm(
            AssignStm(
                "b",
                EseqExp(
                    PrintStm[
                        IdExp"a";
                        OpExp(IdExp"a", Minus,NumExp 1)
                    ],
                    OpExp(NumExp 10, Times, IdExp"a"))
            ),
            PrintStm[IdExp "b"]
        )
    )

(* The program environment, which contains the variables, represented as a list
   of tuples. This could (and should) be an HashMap or something if we cared about
   performance *)
type env = (string*int) list

let rec lookup (needle:string) (haystack:env): int =
    match haystack with
    | [] -> failwith @@ "Variable " ^ needle ^ " not found"
    | (name, value)::tl -> if name = needle then value else lookup needle tl

(* Interpret a statement, accepting a statement and a table representing the variables *)
let rec interp_stm (prog:stm) (table:env): env =
    match prog with
    (* A compound statement: we exec the fist statement and then the second,
       passing the updated local environment *)
    | CompoundStm (stm1, stm2) ->
      let new_table = interp_stm stm1 table in
      interp_stm stm2 new_table

    (* An assignment statement: we get the expression value and the new
       environment, and we update the new env with the assigned variable *)
    | AssignStm (ident, expr)->
      let (exp_val, new_table) = interpExpr expr table in

      (* Updating simply means appending to the beginning, this works since
         `lookup` only looks at the first match *)
      (ident, exp_val)::new_table

    (* A print statement: we evaluate all of the expressions and then print
       them. After that we return the same env since print doesn't touch it*)
    | PrintStm expr_list ->
      let expr_res = List.map (fun expr -> interpExpr expr table) expr_list in

      let () = List.map (fun (value, new_table) ->
          print_int value;
          print_char ' '
      ) expr_res |> ignore in
      print_newline ();

      table


(* Interpret a statement, accepting a statement and a table representing the variables,
   outputting the expression's value and the updated env (expressions can have side effects). *)
and interpExpr (expr:exp) (table:env): (int*env) =
    match expr with
    (* Convert a variable to its numeric value by looking it up in the env *)
    | IdExp ident -> (lookup ident table, table)
    (* Simply return the numeric value *)
    | NumExp num -> (num, table)
    (* Perform the algebric operation, merging the possible side effects of the operation *)
    | OpExp (expr1, binaryop, expr2) ->
      let (expr1_val, table1) = interpExpr expr1 table in
      let (expr2_val, table2) = interpExpr expr2 table in
      let expr_res = match binaryop with
          | Plus ->  expr1_val+ expr2_val
          | Minus ->  expr1_val- expr2_val
          | Times ->  expr1_val* expr2_val
          | Div ->  expr1_val/ expr2_val
      in
      (expr_res, table1 @ table2)
    (* Exec a sequence of a statement and an expression, returning the last expression
       result*)
    | EseqExp (stm1, exp) ->
      let new_table = interp_stm stm1 table in
      interpExpr exp new_table

(* Should print 8 7 80 *)
let () = interp_stm prog [] |> ignore