:- set_prolog_flag(double_quotes, codes).
:- use_module(library(dcg/basics)).

main_file(Stacks, Commands) -->
    stacks(Stacks),
    "\n",
   commands(Commands).

stacks(Stacks) -->
    crate_line(Crates),
    (stacks(Remaining) | stack_names(Remaining)),
    {maplist(append, Crates, Remaining, Stacks)}.
crate_line([X|Crates]) -->
    crate(X), (" ", crate_line(Crates) | "\n", {Crates = []}).
crate([X]) --> "[", [CharCode], "]", {name(X, [CharCode])}.
crate([]) --> "   ".

stack_names([[]|EmptyStacks]) -->
    stack_name, (" ", stack_names(EmptyStacks) | "\n", {EmptyStacks = []}).
stack_name --> " ", [_], " ".

commands([command(Amount, From, To)|XS]) -->
    "move ", integer(Amount), " from ", integer(From), " to ", integer(To), "\n",
    commands(XS).
commands([]) --> [].

move(Stacks, command(Amount, From, To), NewStacks) :-
    nth1(From, Stacks, FromStack),
    nth1(To, Stacks, ToStack),
    split_at(Amount, FromStack, Extracted, NewFromStack),
    reverse(Extracted, WillAddToStack),
    append(WillAddToStack, ToStack, NewToStack),
    select(FromStack, Stacks, NewFromStack, ReplacedFromStack),
    select(ToStack, ReplacedFromStack, NewToStack, NewStacks).

run_commands(Stacks, [Command|Commands], FinalStacks) :-
    move(Stacks, Command, NextStacks),
    run_commands(NextStacks, Commands, FinalStacks).
run_commands(Stacks, [], Stacks).

% From: https://www.swi-prolog.org/pldoc/doc/_SWI_/library/dialect/hprolog.pl?show=src#split_at/4
split_at(0,L,[],L) :- !.
split_at(N,[H|T],[H|L1],L2) :-
    M is N -1,
    split_at(M,T,L1,L2).

head([X|_], X).


?- phrase_from_file(main_file(Stacks, Commands), "ej5.input"),
   run_commands(Stacks, Commands, NewStacks),
   maplist(head, NewStacks, Results),
   concat_atom(Results, ResultsFormatted).
