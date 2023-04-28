program --> block, ['.'].
block --> ['main'], ['('], [')'], ['{'], decl_block, command, ['}'].

decl_block --> decl, decl_block.
decl_block --> decl.

% Predicate to parse the block.
general_block --> ['{'], command, ['}'].

% Declarations (initialization).
decl -->  ['int'] ,identifier(Identifier) ,[':='] ,integer(Integer_val), [';'].
decl -->  ['float'] ,identifier(Identifier) ,[':='] ,float(Float_val), [';'].
decl -->  ['string'] ,identifier(Identifier) ,[':='] ,string(String_val), [';'].
decl -->  ['boolean'] ,identifier(Identifier) ,[':='] ,boolean(Boolean_val), [';'].

decl -->  ['int'], identifier(Identifier), [';'].
decl -->  ['float'], identifier(Identifier), [';'].

% Commands.
command --> commandblock, command.
command --> commandblock.

% Command block (loops, assignment, print commands).
if_statement --> ['if'], ['('], boolean,  [')'], general_block.
if_else_statement --> ['if'], ['('], boolean,  [')'], general_block, ['else'], general_block.
while_statement --> ['while'], ['('], boolean,  [')'], general_block.
for_loop -- > ['for'], ['('], ['int'] ,identifier ,['='] ,integer, [';'], boolean, [';'], unaryexpr, [')'], general_block.
for_in_range_loop --> ['for'], identifier, ['in'], ['range'], ['('], integer, [','], integer, [')'], general_block.
print_statement --> ['print'], ['('], identifier, [')'], [';'].
declare_in_block --> identifier, [':='], expr, [';'].

commandblock --> if_statement | if_else_statement | while_statement | for_loop |
                 for_in_range_loop | print_statement | declare_in_block | general_block.
commandblock --> if_statement, command | if_else_statement, command | while_statement, command |
                 for_loop, command | for_in_range_loop, command | print_statement, command |
                 declare_in_block, command | general_block, command.

% Increment decrement operators.
unaryexpr --> identifier, ['+'], ['+'].
unaryexpr --> identifier, ['-'], ['-'].

ternaryexpr --> ['('], boolean, [')'], ['?'], expr, [':'], expr.

% Expression for arithmetic computations.
expr --> factor.
expr --> miniexpr.
expr --> miniexpr, ['+'], expr.
expr --> factor, ['+'], miniexpr.
expr --> miniexpr, ['-'], expr.
expr --> factor, ['-'], miniexpr.
expr --> ternaryexpr.

% To incorporate precedence rules.
miniexpr --> factor.
miniexpr --> factor, ['*'], miniexpr.
miniexpr --> factor, ['/'], miniexpr.

% Lowest factor in th expressions.
factor --> identifier.
factor --> number.

% Boolean expressions.
boolean --> ['true'] | ['false'] | ['not'], boolean.
boolean --> expr, ['='], expr , ['and'], boolean | expr, ['='], expr, ['or'], boolean.
boolean --> expr, ['='], expr |  expr, ['>'], expr | expr ['<'], expr |
            expr, ['>='], expr | expr, ['=<'], expr |  expr, ['!='], expr.

% identifier variables.
identifier --> lowercase_letters, identifier_tail.
identifier_tail --> uppercase_letters, identifier_tail.
identifier_tail --> ['_'], identifier_tail.
identifier_tail --> [].

% String part.
lowercase_letters --> ['a'] | ['b'] | ['c'] | ['d'] | ['e'] | ['f'] |
    ['g'] | ['h'] | ['i'] | ['j'] | ['k'] | ['l'] | ['m'] | ['n'] | ['o'] |
    ['p'] | ['q'] | ['r'] | ['s'] | ['t'] | ['u'] | ['v'] | ['w'] | ['x'] |
    ['x'] | ['y'] | ['z'].
uppercase_letters --> ['A'] | ['B'] | ['C'] | ['D'] | ['E'] | ['F'] |
    ['G'] | ['H'] | ['I'] | ['J'] | ['K'] | ['L'] | ['M'] | ['N'] | ['O'] |
    ['P'] | ['Q'] | ['R'] | ['S'] | ['T'] | ['U'] | ['V'] | ['W'] | ['X'] |
    ['X'] | ['Y'] | ['Z'].

% String part.
string --> lowercase_letters, string.
string --> uppercase_letters, string.
string --> number, string.
string --> lowercase_letters.
string --> uppercase_letters.
string --> number.

% Numbers part.
integer --> number, integer.
integer --> number.
float --> integer, ['.'], integer.

number --> ['0'] | ['1'] | ['2'] | ['3'] | ['4'] | ['5'] | ['6'] | ['7'] | ['8'] | ['9'].