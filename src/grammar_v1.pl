:- table identifier/2, expr/2, boolean/2.

program --> block.
block --> ['main'], ['('], [')'], ['{'], decl_block, command, ['}'].

decl_block --> decl.
decl_block --> decl, decl_block.


% Predicate to parse the block.
general_block --> ['{'], command, ['}'].

% Declarations (initialization).
decl -->  ['int'], identifier, [':='], integer, [';'].
decl -->  ['float'], identifier, [':='], float, [';'].
decl -->  ['string'], identifier, [':='], string, [';'].
decl -->  ['boolean'], identifier, [':='], boolean, [';'].

decl -->  ['int'], identifier, [';'].
decl -->  ['float'], identifier, [';'].

% Commands.
command --> commandblock, command.
command --> commandblock.

% Command block (loops, assignment, print commands).
if_statement --> ['if'], ['('], boolean,  [')'], general_block.
if_else_statement --> ['if'], ['('], boolean,  [')'], general_block, ['else'], general_block.
while_statement --> ['while'], ['('], boolean,  [')'], general_block.
for_loop --> ['for'], ['('], ['int'] ,identifier ,[':='] ,integer, [';'], boolean, [';'], unaryexpr, [')'], general_block.
for_in_range_loop --> ['for'], identifier, ['in'], ['range'], ['('], integer, [','], integer, [')'], general_block.
print_statement --> ['print'], ['('], identifier, [')'], [';'].
declare_in_block --> identifier, [':='], expr, [';'].

commandblock --> if_statement | if_else_statement | while_statement | for_loop |
                 for_in_range_loop | print_statement | declare_in_block | general_block.
commandblock --> if_statement, command | if_else_statement, command | while_statement, command |
                 for_loop, command | for_in_range_loop, command | print_statement, command |
                 declare_in_block, command | general_block, command.

% Increment decrement operators.
unaryexpr --> identifier, ['++'].
unaryexpr --> identifier, ['--'].

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

factor --> ['('], expr, [')'].
factor --> identifier.
factor --> integer.

% Boolean expressions.

boolean --> ['true'], !.
boolean --> ['false'], !.
boolean --> ['not'], boolean, !.
boolean --> boolean, ['and'], boolean, !.
boolean --> boolean, ['or'], boolean, !.
boolean --> ['('], boolean, [')'], ['and'], ['('], boolean, [')'], !.
boolean --> ['('], boolean, [')'], ['or'], ['('], boolean, [')'], !.


boolean --> expr, ['='], expr.
boolean --> expr, ['!='], expr.
boolean --> expr, ['<'], expr.
boolean --> expr, ['>'], expr.
boolean --> expr, ['<='], expr.
boolean --> expr, ['>='], expr.


% identifier variables.
identifier --> string.

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
string --> lowercase_letters.
string --> uppercase_letters.

% Numbers part.
integer --> number, integer.
integer --> number.
float --> integer, ['.'] , integer.

number --> digit.
number --> digit, number.

digit --> [0] | [1] | [2] | [3] | [4] | [5] | [6] | [7] | [8] | [9].