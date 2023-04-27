lexer grammar NimbusLexer;

// Keywords
MAIN: 'main';
IF: 'if';
ELSE: 'else';
WHILE: 'while';
FOR: 'for';
IN: 'in';
RANGE: 'range';
PRINT: 'print';

// Types
INT: 'int';
FLOAT: 'float';
STRING: 'string';
BOOLEAN: 'boolean';

// Boolean literals
TRUE: 'true';
FALSE: 'false';

// Operators
PLUS: '+';
MINUS: '-';
MULTIPLY: '*';
DIVIDE: '/';
MODULUS: '%';
EQUALS: '=';
NOT_EQUALS: '!=';
GREATER_THAN: '>';
LESS_THAN: '<';
GREATER_THAN_OR_EQUAL_TO: '>=';
LESS_THAN_OR_EQUAL_TO: '<=';
AND: 'and';
OR: 'or';
NOT: 'not';
QUESTION_MARK: '?';
ASSIGNMENT: ':=';
INCREMENT: '++';
DECREMENT: '--';

// Symbols
LPAREN: '(';
RPAREN: ')';
LBRACE: '{';
RBRACE: '}';
SEMICOLON: ';';
COMMA: ',';
DOT: '.';

// Identifiers and literals
IDENTIFIER: [a-zA-Z_][a-zA-Z0-9_]*;
INTEGER: [0-9]+;
FLOATVAL: INTEGER '.' INTEGER;
STRINGVAL: '"' (~["\\\r\n] | '\\' ["\\/bfnrt])* '"';
WS: [ \t\r\n]+ -> skip;
