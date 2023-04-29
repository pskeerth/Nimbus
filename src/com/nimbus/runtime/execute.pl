:- use_module(parser).
:- use_module(evaluator).

read_file(FileName, ConvertedData) :-
    open(FileName, read, Stream),
    read_stream(Stream, FileData),
    convert(FileData, ConvertedData), !,
    close(Stream).

read_stream(Stream, []) :- at_end_of_stream(Stream).
read_stream(S, [Characters | Remaining]) :-
    \+ at_end_of_stream(S),
    read_line_to_codes(S, Codes),
    atom_codes(Characters, Codes),
    read_stream(S, Remaining), !.

convert([C|Cs], [I|T]) :- atom_number(C, I), convert(Cs, T).
convert([H|Hs], [H|T]) :- atom(H), convert(Hs, T).
convert([], []).

main(Filename, E) :- nl,
    read_file(Filename, FileData),
    write(FileData), nl,
    program(ParseTree, FileData, []),
    write("Generating Parse Tree: "), nl,
    write(ParseTree), nl,
    write("Solution:"), nl,
    program_eval(ParseTree, E), nl,
    write("Environment state:"), nl,
    write(E), nl.
