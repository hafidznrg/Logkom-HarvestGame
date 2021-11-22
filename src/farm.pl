:- dynamic(lastFarm/2).
:- dynamic(counts/2).
:- dynamic(seed/1).

seeds([corn_seed,tomatoo_seed,carrot_seed]).

% Define counts for each plant and seed
counts(corn,0).
counts(tomato,0).
counts(carrot,0).

counts(corn_seed,2).
counts(tomatoo_seed,0).
counts(carrot_seed,0).


produces(corn_seed, corn).
produces(tomatoo_seed, tomato).
produces(carrot_seed, carrot).

lastFarm(corn,0).
lastFarm(tomato,0).
lastFaem(carrot,0).

seed([corn_seed,tomatoo_seed]).


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
    % keknya dari main nya
    write('What do you want to plant?'), nl, 
    % ini ngeloop
    % loop nya dimana
    read(Plant),
    plant(Plant)), !.

showSeed([]) :- !.

showSeed([Head|Tail]) :-
    counts(Head,X),
    (X>0, write('     - '), write(X), write('  '), write(Head), nl; nl),
    showSeed(Tail).

harvestPlant(Plant) :-
    produces(Y, Plant),
    counts(Y, Count),
    Count = 0, 
    write('not enough seeds to plant'),nl, !.


plant(Plant) :-
    produces(Seed, Plant),
    counts(Seed, Count),
    Count > 0,
    Counta is Count - 1,
    retract(counts(Seed, Count)),
    assertz(counts(Seed,Counta)),
    write('you planted a '),write(Plant) ,write(' seed'), nl,
    retract(tile(X,Y,'P')),
    asserta(tile(X,Y,'F')),
    asserta(tile(X,Y,'P')),    
    !.

