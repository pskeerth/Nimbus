program(t_program(P)) --> block(P), [.].

block(t_block(declblock,genblock)) --> ['main'], ['('], [')'], ['{'], decl_block(declblock), general_block(genblock), ['}'].
decl_block(t_declblock(declblock)) --> decl(declblock), [';'].

general_block(t_genblock(genblock)) --> ['{'], command(genblock), ['}'].

decl(t_decl(identifier, integerval, declblock)) -->  ['int'] ,identifier(identifier) ,[':='] ,integer(integer), [';'], decl(declblock).
decl(t_decl(identifier, float_val, declblock) -->  ['float'] ,identifier(identifier) ,[':='] ,float(float), [';'], decl(declblock).
decl(t_decl(identifier, string_val, declblock) -->  ['string'] ,identifier(identifier) ,[':='] ,string(string_val), [';'], decl(declblock).
decl(t_decl(identifier, boolean_val, declblock) -->  ['boolean'] ,identifier(identifier) ,[':='] ,boolean(boolean_val), [';'], decl(declblock).
decl(t_decl(identifier) -->  ['int'], identifier(identifier).
decl(t_decl(identifier) -->  ['float'], identifier(identifier).


%Command
command(t_command(cmd_block, cmd)) --> commandblock(cmd_block), command(cmd).
command(t_command(cmd_block)) --> commandblock(cmd_block).


%Command block(Loops, assignment, print commands)
commandblock(t_command_block(boolean_val, gen_block)) --> ['if'], ['('], boolean(boolean_val),  [')'], general_block(gen_block).
commandblock(t_command_block(boolean_val, gen_block1, gen_block2)) --> ['if'], ['('], boolean(boolean_val),  [')'], general_block(gen_block1), ['else'], general_block(gen_block2).
commandblock(t_command_block(boolean_val, gen_block)) --> ['while'], ['('], boolean(boolean_val),  [')'], general_block(gen_block).
commandblock(t_command_block(identifier, integer_val, boolean_val, unary_expr, gen_block)) --> ['for'], ['('], ['int'] ,identifier(identifier) ,['='] ,integer(integer_val), [';'], boolean(boolean_val), [';'], unaryexpr(unary_expr), [')'], general_block(gen_block).
commandblock(t_command_block(identifier, integer_val1, integer_val2, gen_block)) --> ['for'], identifier(identifier), ['in'], ['range'], ['('], integer(integer_val1), [','], integer(integer_val2), [')'], general_block(gen_block).
commandblock(t_command_block(identifier)) --> ['print'], ['('], identifier(identifier), [')'], [';'].
commandblock(t_command_block(gen_block)) --> general_block(gen_block).

commandblock(t_command_block(boolean_val, gen_block, cmd)) --> ['if'], ['('], boolean(boolean_val),  [')'], general_block(gen_block), command(cmd).
commandblock(t_command_block(boolean_val, gen_block1, gen_block2, cmd)) --> ['if'], ['('], boolean(boolean_val),  [')'], general_block(gen_block1), ['else'], general_block(gen_block2), command(cmd).
commandblock(t_command_block(boolean_val, gen_block, cmd)) --> ['while'], ['('], boolean(boolean_val),  [')'], general_block(gen_block), command(cmd).
commandblock(t_command_block(identifier, integer_val, boolean_val, unary_expr, gen_block, cmd)) --> ['for'], ['('], ['int'] ,identifier(identifier) ,['='] ,integer(integer_val), [';'], boolean(boolean_val), [';'], unaryexpr(unary_expr), [')'], general_block(gen_block), command(cmd).
commandblock(t_command_block(identifier, integer_val1, integer_val2, gen_block, cmd)) --> ['for'], identifier(identifier), ['in'], ['range'], ['('], integer(integer_val1), [','], integer(integer_val2), [')'], general_block(gen_block), command(cmd).
commandblock(t_command_block(identifier, cmd)) --> ['print'], ['('], identifier(identifier), [')'], [';'], command(cmd).
commandblock(t_command_block(gen_block, cmd)) --> general_block(gen_block), command(cmd).

commandblock(t_command_block(identifier, expr)) --> identifier(identifier), [':='], expr(expr), [';'].

%Increment decrement operators
unaryexpr(t_unary_expr(identifier)) --> identifier(identifier), ['+'], ['+'].
unaryexpr(t_unary_expr(identifier)) --> identifier(identifier), ['-'], ['-'].

ternaryexpr(t_ternary_expr(boolean_val, expr1, expr2)) --> ['('], boolean(boolean_val), [')'], ['?'], expr(expr1), [':'], expr(expr2).



% Expressions
expr(t_expr_factor(factor)) --> factor(factor).
expr(t_expr_mini(mini_expr)) --> miniexpr(mini_expr).
expr(t_expr_add(left_mini_expr, right_expr)) --> miniexpr(left_mini_expr), ['+'], expr(right_expr).
expr(t_expr_add(factor, mini_expr)) --> factor(factor), ['+'], miniexpr(mini_expr).
expr(t_expr_sub(left_mini_expr, right_expr)) --> miniexpr(left_mini_expr), ['-'], expr(right_expr).
expr(t_expr_sub(factor, mini_expr)) --> factor(factor), ['-'], miniexpr(mini_expr).
expr(t_expr_ternary(ternary_expr)) --> ternaryexpr(ternary_expr).
#expr(t_expr_ternary(BoolExpr, TrueExpr, FalseExpr)) --> ternaryexpr(BoolExpr, TrueExpr, FalseExpr).

miniexpr(t_miniexpr_factor(factor)) --> factor(Factor).
miniexpr(t_miniexpr_mult(factor, mini_expr)) --> factor(factor), ['*'], miniexpr(mini_expr).
miniexpr(t_miniexpr_div(factor, mini_expr)) --> factor(factor), ['/'], miniexpr(mini_expr).

factor(t_factor_id(identifier)) --> identifier(identifier).
factor(t_factor_num(num)) --> number(num).

% Boolean expressions
boolean(t_boolean_true) --> ['true'].
boolean(t_boolean_false) --> ['false'].
boolean(t_boolean_not(bool_expr)) --> ['not'], boolean(bool_expr).
boolean(t_boolean_and(left_expr, right_expr, bool_expr)) --> expr(left_expr), ['='], expr(right_expr), ['and'], boolean(bool_expr).
boolean(t_boolean_or(left_expr, right_expr, bool_expr)) --> expr(left_expr), ['='], expr(right_expr), ['or'], boolean(bool_expr).
boolean(t_boolean_equal(left_expr, right_expr)) --> expr(left_expr), ['='], expr(right_expr).

% Identifier variables
identifier(t_identifier_lowercase(lowercase, identifier)) --> lowercase_letters(lowercase), identifier(identifier).
identifier(t_identifier_lowercase_uppercase(lowercase, uppercase, identifier)) --> lowercase_letters(lowercase), uppercase_letters(uppercase), identifier(identifier).
identifier(t_identifier_lowercase_(lowercase, identifier)) --> lowercase_letters(lowercase), ['_'], identifier(identifier).
identifier(t_identifier_lowercase(lowercase)) --> lowercase_letters(lowercase).

% Strings
string(t_string_lc(lowercase, string_val)) --> lowercase_letters(lowercase), string(string_val).
string(t_string_uc(uppercase, Rest)) --> uppercase_letters(uppercase), string(string_val).
string(t_string_num(num, Rest)) --> number(Num), string(string_val).
string(t_string_lc(lowercase)) --> lowercase_letters(lowercase).
string(t_string_uc(uppercase)) --> uppercase_letters(uppercase).
string(t_string_num(num)) --> number(num).

% Numbers
integer(t_integer_num(num)) --> number(num).
integer(t_integer_nums(num, integer_val)) --> number(num), integer(integer_val).
float(t_float_int(int_part, frac_part)) --> integer(int_part), ['.'], integer(frac_part).


