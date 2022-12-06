:- use_module(library(dcg/basics)).

main_file(Stacks, Commands) -->
    stacks(Stacks),
    "\n",
    commands(Commands).

stacks(Stacks) -->
    crate_line(Crates),
    (stacks(Remaining) | empty_stacks(Remaining)),
    {maplist(append, Crates, Remaining, Stacks)}.
crate_line([X|Crates]) -->
    crate(X), (" ", crate_line(Crates) | "\n", {Crates = []}).
crate([X]) --> "[", [CharCode], "]", {name(X, [CharCode])}.
crate([]) --> "   ".

empty_stacks([[]|EmptyStacks]) -->
    " ", [_], " ", (" ", empty_stacks(EmptyStacks) | "\n", {EmptyStacks = []}).

commands([command(Amount, From, To)|XS]) -->
    "move ", integer(Amount), " from ", integer(From), " to ", integer(To), "\n",
    (commands(XS) | {XS = []}).

move_ej1(command(Amount, From, To), Stacks, NewStacks) :-
    nth1(From, Stacks, FromStack),
    nth1(To, Stacks, ToStack),
    split_at(Amount, FromStack, Extracted, NewFromStack),
    reverse(Extracted, WillAddToStack),
    append(WillAddToStack, ToStack, NewToStack),
    select(FromStack, Stacks, NewFromStack, ReplacedFromStack),
    select(ToStack, ReplacedFromStack, NewToStack, NewStacks).

move_ej2(command(Amount, From, To), Stacks, NewStacks) :-
    nth1(From, Stacks, FromStack),
    nth1(To, Stacks, ToStack),
    split_at(Amount, FromStack, WillAddToStack, NewFromStack),
    append(WillAddToStack, ToStack, NewToStack),
    select(FromStack, Stacks, NewFromStack, ReplacedFromStack),
    select(ToStack, ReplacedFromStack, NewToStack, NewStacks).

% From: https://www.swi-prolog.org/pldoc/doc/_SWI_/library/dialect/hprolog.pl?show=src#split_at/4
split_at(0,L,[],L) :- !.
split_at(N,[H|T],[H|L1],L2) :-
    M is N -1,
    split_at(M,T,L1,L2).

head([X|_], X).

run_ej(Move, ResultsFormatted) :-
    phrase_from_file(main_file(Stacks, Commands), "ej5.input"),
    foldl(Move, Commands, Stacks, NewStacks),
    maplist(head, NewStacks, Results),
    concat_atom(Results, ResultsFormatted).

:- run_ej(move_ej1, Result), write(Result), nl.
:- run_ej(move_ej2, Result), write(Result), nl.
