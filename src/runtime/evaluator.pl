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