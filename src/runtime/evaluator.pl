program_eval(t_program(K), NewEnv) :- block_eval(K, [], NewEnv).
block_eval(t_block(D, C), Env, NewEnv) :-
    declblock_eval(D, Env, Env1), command_eval(C, Env1, NewEnv).

declblock_eval(D, Env, NewEnv) :- decl_eval(D, Env, NewEnv).
declblock_eval(t_decl_block(D, R), Env, NewEnv) :-
    decl_eval(D, Env, Env1), declblock_eval(R, Env1, NewEnv).

generalblock_eval(Cmd_block, Env, NewEnv) :-
    command_eval(Cmd_block, Env, NewEnv).

decl_eval(t_decl('int', ID, Val), Env, NewEnv) :- update('int', ID, Val, Env, NewEnv).
decl_eval(t_decl('float', ID, Val), Env, NewEnv) :- update('float', ID, Val, Env, NewEnv).
decl_eval(t_decl('string', ID, Val), Env, NewEnv) :- update('string', ID, Val, Env, NewEnv).
decl_eval(t_decl('boolean', ID, Val), Env, NewEnv) :- update('boolean', ID, Val, Env, NewEnv).
decl_eval(t_decl('int', ID), Env, NewEnv) :- update('int', ID, 0, Env, NewEnv).
decl_eval(t_decl('float', ID), Env, NewEnv) :-  update('float', ID, 0.0, Env, NewEnv).

command_eval(Cmd_block, Env, NewEnv) :-
    commandblock_eval(Cmd_block, Env, NewEnv).
command_eval(t_command(Cmd_block, Cmd), Env, NewEnv) :-
    commandblock_eval(Cmd_block, Env, Env1), command_eval(Cmd, Env1, NewEnv).

if_statement_eval(t_if_statement(B_exp, Block), Env, NewEnv) :-
    boolean_eval(B_exp, Env, Env1, true), generalblock_eval(Block, Env1, NewEnv).
if_statement_eval(t_if_statement(B_exp, _), Env, NewEnv) :-
    boolean_eval(B_exp, Env, NewEnv, false).

if_else_statement_eval(t_if_else_statement(B_exp, Gen_block1, _), Env, NewEnv) :-
    boolean_eval(B_exp, Env, Env1, true), generalblock_eval(Gen_block1, Env1, NewEnv).
if_else_statement_eval(t_if_else_statement(B_exp, _, Gen_block2), Env, NewEnv) :-
    boolean_eval(B_exp, Env, Env1, false), generalblock_eval(Gen_block2, Env1, NewEnv).

while_statement_eval(t_while_statement(B_exp, Block), Env, NewEnv) :-
    boolean_eval(B_exp, Env, Env1, true), generalblock_eval(Block, Env1, Env2),
    while_statement_eval(t_while_statement(B_exp, Block), Env2, NewEnv).
while_statement_eval(t_while_statement(B_exp, _), Env, NewEnv) :-
    boolean_eval(B_exp, Env, NewEnv, false).

for_loop_eval(t_for_loop(ID, Int, B_exp, Unary_expr, Block), Env, NewEnv) :-
    update(ID, Int, Env, Env1), boolean_eval(B_exp, Env1, Env2, true),
    generalblock_eval(Block, Env2, Env3), unaryexpr_eval(Unary_expr, Env3, Env4),
    lookup(ID, Env4, NewVal),
    for_loop_eval(t_for_loop(ID, NewVal, B_exp, Unary_expr, Block), Env4, NewEnv).

for_loop_eval(t_for_loop(ID, Int, B_exp, Unary_expr, Block), Env, NewEnv) :-
    not(lookup(ID, Env, _)), update('int', ID, Int, Env, Env1),
    for_loop_eval(t_for_loop(ID, Int, B_exp, Unary_expr, Block), Env1, NewEnv).

for_loop_eval(t_for_loop(ID, Int, B_exp, _, _), Env, Env2) :-
   update(ID, Int, Env, Env1), boolean_eval(B_exp, Env1, Env2, false).

for_in_range_loop_eval(t_for_in_range_loop(ID, Int1, Int2, Block), Env, NewEnv) :-
    not(lookup(ID, Env, _)), update('int', ID, Int1, Env, Env1),
    for_in_range_loop_eval(t_for_in_range_loop(ID, Int1, Int2, Block),Env1, NewEnv).

for_in_range_loop_eval(t_for_in_range_loop(ID, Int1, Int2, Block), Env, NewEnv) :-
    update(ID, Int1, Env, Env1), Int1 =< Int2,
    generalblock_eval(Block, Env1, Env2), NewVal is Int1+1,
    for_in_range_loop_eval(t_for_in_range_loop(ID, NewVal, Int2, Block),Env2, NewEnv).

for_in_range_loop_eval(t_for_in_range_loop(_, Int1, Int2, _), Env, Env) :-
    Int1 > Int2.

print_statement_eval(t_print_statement(ID), Env, Env) :-
    lookup(ID, Env, Value), write(Value), nl.

declare_in_block_eval(t_decl_in_block(ID, Expr), Env, NewEnv) :-
    expr_eval(Expr, Env, Env1, V), update(ID, V, Env1, NewEnv).

commandblock_eval(t_command_block(S), Env, NewEnv) :-
    if_statement_eval(S, Env, NewEnv).
commandblock_eval(t_command_block(S), Env, NewEnv) :-
    if_else_statement_eval(S, Env, NewEnv).
commandblock_eval(t_command_block(S), Env, NewEnv) :-
    while_statement_eval(S, Env, NewEnv).
commandblock_eval(t_command_block(S), Env, NewEnv) :-
    for_loop_eval(S, Env, NewEnv).
commandblock_eval(t_command_block(S), Env, NewEnv) :-
    for_in_range_loop_eval(S, Env, NewEnv).
commandblock_eval(t_command_block(S), Env, Env) :-
   	print_statement_eval(S, Env, Env).
commandblock_eval(t_command_block(S), Env, NewEnv) :-
    declare_in_block_eval(S, Env, NewEnv).
commandblock_eval(t_command_block(S), Env, NewEnv) :-
    generalblock_eval(S, Env, NewEnv).

commandblock_eval(t_command_block(S, Cmd), Env, NewEnv) :-
    if_statement_eval(S, Env, Env1), command_eval(Cmd, Env1, NewEnv);
    if_else_statement_eval(S, Env, Env1), command_eval(Cmd, Env1, NewEnv);
    while_statement_eval(S, Env, Env1), command_eval(Cmd, Env1, NewEnv);
    for_loop_eval(S, Env, Env1), command_eval(Cmd, Env1, NewEnv);
    for_in_range_loop_eval(S, Env, Env1), command_eval(Cmd, Env1, NewEnv);
    print_statement_eval(S, Env, Env1), command_eval(Cmd, Env1, NewEnv);
    declare_in_block_eval(S, Env, Env1), command_eval(Cmd, Env1, NewEnv);
    generalblock_eval(S, Env, Env1), command_eval(Cmd, Env1, NewEnv).

%Increment decrement operators
unaryexpr_eval(t_unary_expr(ID, '++'), Env, NewEnv) :-
    lookup(ID, Env, Val), NewVal is Val+1, update(ID, NewVal, Env, NewEnv).
unaryexpr_eval(t_unary_expr(ID, '--'), Env, NewEnv) :-
    lookup(ID, Env, Val), NewVal is Val-1, update(ID, NewVal, Env, NewEnv).

%Ternary operators
ternaryexpr_eval(t_ternary_expr(B_exp, Expr1, _), Env, NewEnv, V) :-
    boolean_eval(B_exp, Env, Env2, true), expr_eval(Expr1, Env2, NewEnv, V).
ternaryexpr_eval(t_ternary_expr(B_exp, _, Expr2), Env, NewEnv, V) :-
    boolean_eval(B_exp, Env, Env2, false), expr_eval(Expr2, Env2, NewEnv, V).

%Evaluator for boolean expressions
boolean_eval(t_boolean(true), _, _, true).
boolean_eval(t_boolean(false), _, _, false).

boolean_eval(t_boolean(not, X), Env, NewEnv, false) :- boolean_eval(X, Env, NewEnv, true).
boolean_eval(t_boolean(not, X), Env, NewEnv, true) :- boolean_eval(X, Env, NewEnv, false).

boolean_eval(t_boolean(Expr1, '=',  Expr2), Env, NewEnv, true) :-
    expr_eval(Expr1, Env, Env2, V1), expr_eval(Expr2, Env2, NewEnv, V2), V1 = V2.
boolean_eval(t_boolean(Expr1, '=',  Expr2), Env, NewEnv, false) :-
    expr_eval(Expr1, Env, Env2, V1), expr_eval(Expr2, Env2, NewEnv, V2), V1 \= V2.
boolean_eval(t_boolean(Expr1, '!=', Expr2), Env, NewEnv, true) :-
    expr_eval(Expr1, Env, Env2, V1), expr_eval(Expr2, Env2, NewEnv, V2), V1 \= V2.
boolean_eval(t_boolean(Expr1, '!=', Expr2), Env, NewEnv, false) :-
    expr_eval(Expr1, Env, Env2, V1), expr_eval(Expr2, Env2, NewEnv, V2), V1 = V2.
boolean_eval(t_boolean(Expr1, '<',  Expr2), Env, NewEnv, true) :-
    expr_eval(Expr1, Env, Env2, V1), expr_eval(Expr2, Env2, NewEnv, V2), V1 < V2.
boolean_eval(t_boolean(Expr1, '<',  Expr2), Env, NewEnv, false) :-
    expr_eval(Expr1, Env, Env2, V1), expr_eval(Expr2, Env2, NewEnv, V2), V1 >= V2.
boolean_eval(t_boolean(Expr1, '>',  Expr2), Env, NewEnv, true) :-
    expr_eval(Expr1, Env, Env2, V1), expr_eval(Expr2, Env2, NewEnv, V2), V1 > V2.
boolean_eval(t_boolean(Expr1, '>',  Expr2), Env, NewEnv, false) :-
    expr_eval(Expr1, Env, Env2, V1), expr_eval(Expr2, Env2, NewEnv, V2), V1 =< V2.
boolean_eval(t_boolean(Expr1, '<=', Expr2), Env, NewEnv, true) :-
    expr_eval(Expr1, Env, Env2, V1), expr_eval(Expr2, Env2, NewEnv, V2), V1 =< V2.
boolean_eval(t_boolean(Expr1, '<=', Expr2), Env, NewEnv, false) :-
    expr_eval(Expr1, Env, Env2, V1), expr_eval(Expr2, Env2, NewEnv, V2), V1 > V2.
boolean_eval(t_boolean(Expr1, '>=', Expr2), Env, NewEnv, true) :-
    expr_eval(Expr1, Env, Env2, V1), expr_eval(Expr2, Env2, NewEnv, V2), V1 >= V2.
boolean_eval(t_boolean(Expr1, '>=', Expr2), Env, NewEnv, false) :-
    expr_eval(Expr1, Env, Env2, V1), expr_eval(Expr2, Env2, NewEnv, V2), V1 < V2.

boolean_eval(t_boolean(Bool_expr1, 'and', Bool_expr2), Env, NewEnv, V) :- boolean_eval(Bool_expr1, Env, Env1, V1), boolean_eval(Bool_expr2, Env1, NewEnv, V2), boolean_check(V1, 'and', V2, V).
boolean_eval(t_boolean(Bool_expr1, 'or', Bool_expr2), Env, NewEnv, V) :- boolean_eval(Bool_expr1, Env, Env1, V1), boolean_eval(Bool_expr2, Env1, NewEnv, V2), boolean_check(V1, 'or', V2, V).

boolean_check(true, 'and', true, true).
boolean_check(true, 'and', false, false).
boolean_check(false, 'and', true, false).
boolean_check(false, 'and', false, false).

boolean_check(true, 'or', true, true).
boolean_check(true, 'or', false, true).
boolean_check(false, 'or', true, true).
boolean_check(false, 'or', false, false).


%Evaluator for expressions
expr_eval(t_add(Left_mini_expr, Right_expr), Env, NewEnv, V) :-
    expr_eval(Left_mini_expr, Env, Env1, V1), expr_eval(Right_expr, Env1, NewEnv, V2), V is V1+V2.
expr_eval(t_minus(Left_mini_expr, Right_expr), Env, NewEnv, V) :-
    expr_eval(Left_mini_expr, Env, Env1, V1), expr_eval(Right_expr,Env1, NewEnv, V2), V is V1-V2.
expr_eval(t_multi(X, Y), Env, NewEnv, V) :-
    expr_eval(X, Env, Env1, V1), expr_eval(Y, Env1, NewEnv, V2), V is V1*V2.
expr_eval(t_divide(X, Y), Env, NewEnv, V) :-
    expr_eval(X, Env, Env1, V1), expr_eval(Y, Env1, NewEnv, V2), Y\=0, V is V1/V2.
expr_eval(t_bracket(X), Env, NewEnv, V) :-
    expr_eval(X, Env, NewEnv, V).
expr_eval(t_assign(X, :=, Y), Env, NewEnv, V) :-
    expr_eval(Y, Env, Env1, V), update(X, V, Env1, NewEnv).
expr_eval(X, Env, Env, V) :- lookup(X, Env, V).
expr_eval(X, Env, NewEnv, V) :- ternaryexpr_eval(X, Env, NewEnv, V).
expr_eval(X, Env, Env, X) :- integer(X).
expr_eval(X, Env, Env, X) :- float(X).

%Declaring the identifiers with values
update_data(int, ID, Value, [], [(int, ID, Value)]) :- integer(Value).
update_data(int, _, Value, [], []) :- not(integer(Value)), illegal_type(Value, int).
update_data(float, ID, Value, [], [(float, ID, Value)]) :- float(Value).
update_data(float, _, Value, [], []) :- not(float(Value)), illegal_type(Value, float).
update_data(string, ID, Value, [], [(string, ID, Value)]) :- string(Value).
update_data(string, _, Value, [], []) :- not(string(Value)), illegal_type(Value, string).
update_data(boolean, ID, Value, [], [(boolean, ID, Value)]) :- Value==true;Value==false.
update_data(boolean, _, Value, [], []) :- Value \= true, Value \= false, illegal_type(Value, boolean).

update(Datatype, ID, Value, [], NewEnv) :- update_data(Datatype, ID, Value, [], NewEnv).
update(Datatype, ID, Value, [Head|Tail], [Head|NewEnv]) :-
    Head \= (_,ID,_), update(Datatype, ID, Value, Tail, NewEnv).
update(_, Name, _, [Head| _], _NewEnv) :- Head=(_,Name,_), error_typecheck(Name).

%Updating the identifiers with values
update(ID, Value, [H|T], [H|NewEnv]) :- H \= (_, ID, _), update(ID, Value, T, NewEnv).

update(ID, Value, [(int, ID, _)|T], [(int, ID, Value)|T]) :- integer(Value).
update(ID, Value, [(int, ID, _)|_], [_]) :- not(integer(Value)), illegal_type(Value, int).

update(ID, Value, [(float, ID, _)|T], [(float, ID, Value)|T]) :- float(Value).
update(ID, Value, [(float, ID, _)|_], [_]) :- not(float(Value)), illegal_type(Value, float).

update(ID, Value, [(string, ID, _)|T], [(string, ID, Value)|T]) :- string(Value).
update(ID, Value, [(string, ID, _)|_], [_]) :- not(string(Value)), illegal_type(Value, string).

update(ID, Value, [(boolean, ID, _)|T], [(boolean, ID, Value)|T]) :- Value==true;Value==false.
update(ID, Value, [(boolean, ID, _)|_], [_]) :-
    Value \= true, Value \= false, illegal_type(Value, boolean).

%type check errors
illegal_type(Value, Datatype) :-
    format('Illegal type conversion. ~w is not an ~w type', [Value, Datatype]).
error_typecheck(ID) :-
    format('Variable already initialised in different datatype. ~w', [ID]).

%Lookup for the variable names in the environment
lookup(Varname, [(_, Varname, Value)|_], Value).
lookup(Varname, [_|T], Value) :- lookup(Varname, T, Value).