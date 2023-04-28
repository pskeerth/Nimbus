:- module(program, [program/3]).
:- table identifier/3.

program(t_program(P)) --> block(P).
block(t_block(Decl_block, Cmd_block)) --> ['main'], ['('], [')'], ['{'], decl_block(Decl_block), command(Cmd_block), ['}'].

decl_block(Decl_block) --> decl(Decl_block).
decl_block(t_decl_block(Decl_block, Rem_block)) --> decl(Decl_block), decl_block(Rem_block).

general_block(t_gen_block(Cmd_block)) --> ['{'], command(Cmd_block), ['}'].

% Declarations (initialization).
decl(t_decl('int', Identifier, Integer_val)) -->  ['int'] ,identifier(Identifier) ,[':='] ,integer(Integer_val), [';'].
decl(t_decl('float', Identifier, Float_val)) -->  ['float'] ,identifier(Identifier) ,[':='] ,float(Float_val), [';'].
decl(t_decl('string', Identifier, String_val)) -->  ['string'] ,identifier(Identifier) ,[':='] ,string(String_val), [';'].
decl(t_decl('boolean', Identifier, Boolean_val)) -->  ['boolean'] ,identifier(Identifier) ,[':='] ,boolean(Boolean_val), [';'].

decl(t_decl('int', Identifier)) -->  ['int'], identifier(Identifier), [';'].
decl(t_decl('float', Identifier)) -->  ['float'], identifier(Identifier), [';'].


%Command
command(t_command(Cmd_block)) --> commandblock(Cmd_block).
command(t_command(Cmd_block, Cmd)) --> commandblock(Cmd_block), command(Cmd).

% Command block (loops, assignment, print commands).
if_statement(t_if_statement(Bool_expr, Gen_block)) --> ['if'], ['('], boolean(Bool_expr),  [')'], general_block(Gen_block).
if_else_statement(t_if_else_statement(Bool_expr, Gen_block1, Gen_block2)) --> ['if'], ['('], boolean(Bool_expr),  [')'], general_block(Gen_block1), ['else'], general_block(Gen_block2).
while_statement(t_while_statement(Bool_expr, Gen_block)) --> ['while'], ['('], boolean(Bool_expr),  [')'], general_block(Gen_block).
for_loop(t_for_loop(Identifier, Integer_val, Bool_expr, Unary_expr, Gen_block)) --> ['for'], ['('], ['int'] ,identifier(Identifier) ,[':='] ,integer(Integer_val), [';'], boolean(Bool_expr), [';'], unaryexpr(Unary_expr), [')'], general_block(Gen_block).
for_in_range_loop(t_for_in_range_loop(Identifier, Integer_val1, Integer_val2, Gen_block)) --> ['for'], identifier(Identifier), ['in'], ['range'], ['('], integer(Integer_val1), [','], integer(Integer_val2), [')'], general_block(Gen_block).
print_statement(t_print_statement(Identifier)) --> ['print'], ['('], identifier(Identifier), [')'], [';'].
declare_in_block(t_decl_in_block(Identifier, Expr)) --> identifier(Identifier), [':='], expr(Expr), [';'].

commandblock(t_command_block(Statement)) --> if_statement(Statement) | if_else_statement(Statement) | while_statement(Statement) | for_loop(Statement) |
                 for_in_range_loop(Statement) | print_statement(Statement) | declare_in_block(Statement) | general_block(Statement).
commandblock(t_command_block(Statement, Cmd)) --> if_statement(Statement), command(Cmd) | if_else_statement(Statement), command(Cmd) | while_statement(Statement), command(Cmd) |
                 for_loop(Statement), command(Cmd) | for_in_range_loop(Statement), command(Cmd) | print_statement(Statement), command(Cmd) |
                 declare_in_block(Statement), command(Cmd) | general_block(Statement), command(Cmd).

%Increment decrement operators
unaryexpr(t_unary_expr(Identifier, '+', '+')) --> identifier(Identifier), ['+'], ['+'].
unaryexpr(t_unary_expr(Identifier, '-', '-')) --> identifier(Identifier), ['-'], ['-'].

ternaryexpr(t_ternary_expr(Bool_expr, Expr1, Expr2)) --> ['('], boolean(Bool_expr), [')'], ['?'], expr(Expr1), [':'], expr(Expr2).

% Expressions
expr(t_expr(Factor)) --> factor(Factor).
expr(t_expr(Mini_expr)) --> miniexpr(Mini_expr).
expr(t_expr(Left_mini_expr, '+', Right_expr)) --> miniexpr(Left_mini_expr), ['+'], expr(Right_expr).
expr(t_expr(Factor, '+', Mini_expr)) --> factor(Factor), ['+'], miniexpr(Mini_expr).
expr(t_expr(Left_mini_expr, '-', Right_expr)) --> miniexpr(Left_mini_expr), ['-'], expr(Right_expr).
expr(t_expr(Factor, '-', Mini_expr)) --> factor(Factor), ['-'], miniexpr(Mini_expr).
expr(t_expr(Ternary_expr)) --> ternaryexpr(Ternary_expr).

% To incorporate precedence rules.
miniexpr(t_miniexpr(Factor)) --> factor(Factor).
miniexpr(t_miniexpr(Factor, '', Mini_expr)) --> factor(Factor), [''], miniexpr(Mini_expr).
miniexpr(t_miniexpr(Factor, '/', Mini_expr)) --> factor(Factor), ['/'], miniexpr(Mini_expr).

% Lowest factor in th expressions.
factor(t_factor(Identifier)) --> identifier(Identifier).
factor(t_factor(Num)) --> number(Num).

% Boolean expressions.
boolean(t_boolean(Bool_expr)) --> ['true'] | ['false'] | ['not'], boolean(Bool_expr).
boolean(t_boolean(Expr1, Expr2, bool_expr)) --> expr(Expr1), ['='], expr(Expr2) , ['and'], boolean(bool_expr) | expr(Expr1), ['='], expr(Expr2), ['or'], boolean(bool_expr).
boolean(t_boolean(Expr1, Expr2)) --> expr(Expr1), ['='], expr(Expr2) |  expr(Expr1), ['>'], expr(Expr2) |
    								 expr(Expr1), ['<'], expr(Expr2) |  expr(Expr1), ['>='], expr(Expr2) |
    								 expr(Expr1), ['=<'], expr(Expr2) |  expr(Expr1), ['!='], expr(Expr2).

% identifier variables.
identifier(t_identifier(Identifier)) --> identifier_val(Identifier).
identifier_val(Identifier, [Identifier | Tail], Tail) :- atom(Identifier), not(integer(Identifier)),
                                                         not(float(Identifier)), check_keyword(Identifier).
check_keyword(Identifier) :- not(member(Identifier, [int, float, string, boolean, true, false,
    						 if, else, for, while, in, range, or, and, not,  :=, '!=', =,
                             <, >, <=, >=, ++, --, +, -, *, /])).

% Strings
string(t_string(String)) --> string_val(String).
% Numbers
integer(t_integer(Num)) --> integer_val(Num).
float(t_float(Float)) --> float_val(Float).

integer_val(V, [V | T], T) :- integer(V).
float_val(V, [V | T], T) :- float(V).
string_val(V, [V | T], T) :- string(V).

% Nums
number(t_number) --> ['0'] | ['1'] | ['2'] | ['3'] | ['4'] | ['5'] | ['6'] | ['7'] | ['8'] | ['9'].