:- dynamic(lastFarm/2).
:- dynamic(seed/1).


% Define counts for each plant and seed
counts(corn,0).
counts(tomato,0).
counts(wheat,0).

counts(corn_seed,0).
counts(tomatoo_seed,0).
counts(carrot_seed,0).

produces(corn_seed, corn).
produces(tomatoo_seed, tomato).
produces(wheat_seed, wheat).

lastFarm(corn,0).
lastFarm(tomato,0).
lastFaem(carrot,0).

seed([corn_seed,tomatoo_seed,carrot_seed]).

showMenuFarm :-
    write('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'), nl,
    write('~~                                          ~~'), nl,
    write('~~          Welcome to the Farm             ~~'), nl,
    write('~~                                          ~~'), nl,
    write('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'), nl, nl.

handleFarm :-
    showMenuFarm,
    seed(ListSeed),
    (isEmpty(ListSeed) -> write('You don\'t have any seed. '), nl;
    (\+ isEmpty(ListSeed)) -> write('You have: '),nl,
    showSeed(ListSeed),
    write('What do you want to plant?'), nl,
    read(Seed), !,
    harvestFarm(Seed)).

showSeed([]) :- !.

showSeed([Head|Tail]) :-
    counts(Head,X),
    (X>0, write('     - '), write(X), write('  '), write(Head), nl),
    showSeed(Tail).

