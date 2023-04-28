program_eval(t_program(K), NewEnv) :- block_eval(K, [], NewEnv).
block_eval(t_block(D, C), Env, NewEnv) :- declblock_eval(D, Env, Env1), command_eval(C, Env1, NewEnv).

declblock_eval(t_decl_block(D), Env, NewEnv) :- decl_eval(D, Env, NewEnv).
declblock_eval(t_decl_block(D, R), Env, NewEnv) :- decl_eval(D, Env, Env1), declblock_eval(R, Env1, NewEnv).

generalblock_eval(t_gen_block(Cmd_block), Env, NewEnv) :- command_eval(Cmd_block, Env, NewEnv).

decl_eval(t_decl('int', ID, Val), Env, NewEnv) :- update('int', ID, Val, Env, NewEnv).
decl_eval(t_decl('float', ID, Val), Env, NewEnv) :- update('float', ID, Val, Env, NewEnv).
decl_eval(t_decl('string', ID, Val), Env, NewEnv) :- update('string', ID, Val, Env, NewEnv).
decl_eval(t_decl('boolean', ID, Val), Env, NewEnv) :- update('boolean', ID, Val, Env, NewEnv).
decl_eval(t_decl('int', ID), Env, NewEnv) :- update('int', ID, 0, Env, NewEnv).
decl_eval(t_decl('float', ID), Env, NewEnv) :-  update('float', ID, 0.0, Env, NewEnv).

command_eval(t_command(Cmd_block), Env, NewEnv) :- commandblock_eval(Cmd_block, Env, NewEnv).
command_eval(t_command(Cmd_block, Cmd), Env, NewEnv) :- commandblock_eval(Cmd_block, Env, Env1), command_eval(Cmd, Env1, NewEnv).

if_statement_eval(t_if_statement(Bool_expr, Gen_block), Env, NewEnv) :- boolean_eval(Bool_expr, Env, Env1, true), generalblock_eval(Gen_block, Env1, NewEnv).
if_statement_eval(t_if_statement(Bool_expr, _), Env, NewEnv) :- boolean_eval(Bool_expr, Env, NewEnv, false).

if_else_statement_eval(t_if_else_statement(Bool_expr, Gen_block1, _), Env, NewEnv) :- boolean_eval(Bool_expr, Env, Env1, true), generalblock_eval(Gen_block1, Env1, NewEnv).
if_else_statement_eval(t_if_else_statement(Bool_expr, _, Gen_block2), Env, NewEnv) :- boolean_eval(Bool_expr, Env, Env1, false), generalblock_eval(Gen_block2, Env1, NewEnv).

while_statement_eval(t_while_statement(Bool_expr, Gen_block), Env, NewEnv) :- boolean_eval(Bool_expr, Env, Env1, true), generalblock_eval(Gen_block, Env1, Env2),
    																		  while_statement_eval(t_while_statement(Bool_expr, Gen_block), Env2, NewEnv).
while_statement_eval(t_while_statement(Bool_expr, _), Env, NewEnv) :- boolean_eval(Bool_expr, Env, NewEnv, false).

for_loop_eval(t_for_loop(Identifier, Integer_val, Bool_expr, Unary_expr, Gen_block), Env, NewEnv) :- update('int', Identifier, Integer_val, Env, Env1), boolean_eval(Bool_expr, Env1, Env2, true),
    												unaryexpr_eval(Unary_expr, Env2, Env3), general_block(Gen_block, Env3, Env4), lookup(Identifier, NewVal),
    												for_loop_eval(t_for_loop(Identifier, NewVal, Bool_expr, Unary_expr, Gen_block), Env4, NewEnv).

for_in_range_loop_eval(t_for_in_range_loop(Identifier, Integer_val1, Integer_val2, Gen_block), Env, NewEnv) :- Integer_val1 =< Integer_val2, update('int', Identifier, Integer_val1, Env, Env1), general_block(Gen_block, Env1, Env2),
    																									NewVal is Integer_val1+1, for_in_range_loop_eval(t_for_in_range_loop(Identifier, NewVal, Integer_val2, Gen_block),Env2, NewEnv).
for_in_range_loop_eval(t_for_in_range_loop(_, Integer_val1, Integer_val2, _), Env, Env) :- Integer_val1 > Integer_val2.

print_statement_eval(t_print_statement(Identifier), Env, Env) :- lookup(Identifier, Value), write(Value), nl.

declare_in_block_eval(t_decl_in_block(Identifier, Expr), Env, NewEnv) :- update(Identifier, Expr, Env, NewEnv).


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
update(Datatype, ID, Value, [Head|Tail], [Head|NewEnv]) :- Head \= (,ID,), update(Datatype, ID, Value, Tail, NewEnv).
update(, Name, _, [Head| _], _NewEnv) :- Head=(,Name,_), error_typecheck(Name).

%Updating the identifiers with values
update(ID, Value, [H|T], [H|NewEnv]) :- H \= (_, ID, _), update(ID, Value, T, NewEnv).

update(ID, Value, [(int, ID, _)|T], [(int, ID, Value)|T]) :- integer(Value).
update(ID, Value, [(int, ID, )|], [_]) :- not(integer(Value)), illegal_type(Value, int).

update(ID, Value, [(float, ID, _)|T], [(float, ID, Value)|T]) :- float(Value).
update(ID, Value, [(float, ID, )|], [_]) :- not(float(Value)), illegal_type(Value, float).

update(ID, Value, [(string, ID, _)|T], [(string, ID, Value)|T]) :- string(Value).
update(ID, Value, [(string, ID, )|], [_]) :- not(string(Value)), illegal_type(Value, string).

update(ID, Value, [(boolean, ID, _)|T], [(boolean, ID, Value)|T]) :- Value==true;Value==false.
update(ID, Value, [(boolean, ID, )|], [_]) :- Value \= true, Value \= false, illegal_type(Value, boolean).

%type check errors
illegal_type(Value, Datatype) :- format('Illegal type conversion. ~w is not an ~w type', [Value, Datatype]).
error_typecheck(ID) :- format('Variable already initialised in different datatype. ~w', [ID]).

%illegal_type(Value, Datatype) :- write('Illegal type conversion. ~w is not an ~w type', [Value, Datatype]), halt.
%error_typecheck(ID) :- write('Variable already initialised in different datatype. ~w', [ID]), halt.

%Lookup for the variable names in the environment
lookup(Varname, [(, Varname, Value)|], Value).
lookup(Varname, [_|T], Value) :- lookup(Varname, T, Value).