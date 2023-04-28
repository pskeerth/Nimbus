program(t_program(P)) --> block(P), [.].

block(t_block(decl_block,gen_block)) --> ['main'], ['('], [')'], ['{'], decl_block(decl_block), general_block(gen_block), ['}'].
decl_block(t_decl_block(decl_block)) --> decl(decl_block), [';'].

general_block(t_gen_block(gen_block)) --> ['{'], command(gen_block), ['}'].

% Predicate to parse the block.
general_block --> ['{'], command, ['}'].

% Declarations (initialization).
decl(t_decl('int', identifier, integer_val, decl_block)) -->  ['int'] ,identifier(identifier) ,[':='] ,integer(integer_val), [';'], decl(decl_block).
decl(t_decl('float', identifier, float_val, decl_block) -->  ['float'] ,identifier(identifier) ,[':='] ,float(float_val), [';'], decl(decl_block).
decl(t_decl('string', identifier, string_val, decl_block) -->  ['string'] ,identifier(identifier) ,[':='] ,string(string_val), [';'], decl(decl_block).
decl(t_decl('boolean', identifier, boolean_val, decl_block) -->  ['boolean'] ,identifier(identifier) ,[':='] ,boolean(boolean_val), [';'], decl(decl_block).
decl(t_decl('int', identifier) -->  ['int'], identifier(identifier).
decl(t_decl('float', identifier) -->  ['float'], identifier(identifier).

%Command
command(t_command(cmd_block, cmd)) --> commandblock(cmd_block), command(cmd).
command(t_command(cmd_block)) --> commandblock(cmd_block).

% Command block (loops, assignment, print commands).
if_statement(t_if_statement(bool_expr, gen_block)) --> ['if'], ['('], boolean(bool_expr),  [')'], general_block(gen_block).
if_else_statement(t_if_else_statement(bool_expr, gen_block1, gen_block2)) --> ['if'], ['('], boolean,  [')'], general_block, ['else'], general_block.
while_statement(t_while_statement(bool_expr, gen_block)) --> ['while'], ['('], boolean(bool_expr),  [')'], general_block(gen_block).
for_loop(t_for_loop(identifier, integer_val, bool_expr, unary_expr, gen_block)) -- > ['for'], ['('], ['int'] ,identifier(identifier) ,['='] ,integer(integer_val), [';'], boolean(bool_expr), [';'], unaryexpr(unary_expr), [')'], general_block(gen_block).
for_in_range_loop(t_for_in_range_loop) --> ['for'], identifier(identifier), ['in'], ['range'], ['('], integer(integer_val), [','], integer(integer_val), [')'], general_block(gen_block).
print_statement(t_print_statement(identifier)) --> ['print'], ['('], identifier(identifier), [')'], [';'].
declare_in_block(t_decl_in_block(identifier, expr)) --> identifier(identifier), [':='], expr(expr), [';'].

commandblock(t_command_block(statement)) --> if_statement(statement) | if_else_statement(statement) | while_statement(statement) | for_loop(statement) |
                 for_in_range_loop(statement) | print_statement(statement) | declare_in_block(statement) | general_block(statement).
commandblock((t_command_block(statement, cmd)) --> if_statement(statement), command(cmd) | if_else_statement(statement), command(cmd) | while_statement(statement), command(cmd) |
                 for_loop(statement), command(cmd) | for_in_range_loop(statement), command(cmd) | print_statement(statement), command(cmd) |
                 declare_in_block(statement), command(cmd) | general_block(statement), command(cmd).

%Increment decrement operators
unaryexpr(t_unary_expr(identifier, '+', '+')) --> identifier(identifier), ['+'], ['+'].
unaryexpr(t_unary_expr(identifier, '-', '-')) --> identifier(identifier), ['-'], ['-'].

ternaryexpr(t_ternary_expr(bool_expr, expr1, expr2)) --> ['('], boolean(bool_expr), [')'], ['?'], expr(expr1), [':'], expr(expr2).

% Expressions
expr(t_expr(factor)) --> factor(factor).
expr(t_expr(mini_expr)) --> miniexpr(mini_expr).
expr(t_expr(left_mini_expr, '+', right_expr)) --> miniexpr(left_mini_expr), ['+'], expr(right_expr).
expr(t_expr(factor, '+', mini_expr)) --> factor(factor), ['+'], miniexpr(mini_expr).
expr(t_expr(left_mini_expr, '-', right_expr)) --> miniexpr(left_mini_expr), ['-'], expr(right_expr).
expr(t_expr(factor, '-', mini_expr)) --> factor(factor), ['-'], miniexpr(mini_expr).
expr(t_expr(ternary_expr)) --> ternaryexpr(ternary_expr).

% To incorporate precedence rules.
miniexpr(t_miniexpr(factor)) --> factor(Factor).
miniexpr(t_miniexpr(factor, '*', mini_expr)) --> factor(factor), ['*'], miniexpr(mini_expr).
miniexpr(t_miniexpr(factor, '/', mini_expr)) --> factor(factor), ['/'], miniexpr(mini_expr).

% Lowest factor in th expressions.
factor(t_factor(identifier)) --> identifier(identifier).
factor(t_factor(num)) --> number(num).

% Boolean expressions.
boolean(t_boolean(bool_expr)) --> ['true'] | ['false'] | ['not'], boolean(bool_expr).
boolean(t_boolean(expr1, expr2, bool_expr)) --> expr(expr1), ['='], expr(expr2) , ['and'], boolean(bool_expr) | expr(expr1), ['='], expr(expr2), ['or'], boolean(bool_expr).
boolean(t_boolean(expr1, expr2)) --> expr(expr1), ['='], expr(expr2).

% identifier variables.
identifier(t_identifier(lowercase_let, identifier_tail)) --> lowercase_letters(lowercase_let), identifier_tail(identifier_tail).
identifier_tail(t_identifier(uppercase_let, identifier_tail) --> uppercase_letters(uppercase_let), identifier_tail(identifier_tail) | ['_'], identifier_tail(identifier_tail) | ''.


% Strings
string(t_string(lowercase, string_val)) --> lowercase_letters(lowercase), string(string_val).
string(t_string(uppercase, string_val)) --> uppercase_letters(uppercase), string(string_val).
string(t_string(num, string_val)) --> number(num), string(string_val).
string(t_string(lowercase)) --> lowercase_letters(lowercase).
string(t_string(uppercase)) --> uppercase_letters(uppercase).
string(t_string(num)) --> number(num).

% Numbers
integer(t_integer(num)) --> number(num).
integer(t_integer(num, integer_val)) --> number(num), integer(integer_val).
float(t_float(int_part, frac_part)) --> integer(int_part), ['.'], integer(frac_part).

