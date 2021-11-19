% Dev dependencies
% :- include('time.pl').

:- dynamic(lastHarvest/2).
:- dynamic(count/2).
:- dynamic(ternak/1).

ternak([cow,sheep]).

produce(cow, milk).
produce(sheep, wool).
produce(chicken, egg).

count(cow,5).
count(sheep,3).

count(milk,0).
count(wool,0).

lastHarvest(cow,0).
lastHarvest(sheep,0).

showMenuRanch :-
    write('[]==========================================[]'), nl,
    write('||                                          ||'), nl,
    write('||           Welcome to the Ranch           ||'), nl,
    write('||                                          ||'), nl,
    write('[]==========================================[]'), nl, nl.


handleRanch :- 
    showMenuRanch,
    ternak(ListTernak),
    (isEmpty(ListTernak) -> write('You don\'t have any cattle.'), nl;
    (\+ isEmpty(ListTernak)) -> write('   You have:'), nl,
    showTernak(ListTernak),
    write('What do you want to do?'), nl,
    read(Hewan), !,
    harvestRanch(Hewan)).

showResult(Num,Result) :-
    write('You got '), write(Num), write(' '), write(Result), (Num>1, write('s'), nl; nl).

harvestRanch(Hewan) :-
    ternak(ListTernak),
    isMember(Hewan, ListTernak),
    lastHarvest(Hewan, Day0),
    day(Day),
    Day > Day0+5, !,
    random(1,5,Num),
    produce(Hewan,Result),
    showResult(Num,Result),
    count(Result,X),
    NewX is X+Num,
    retract(count(Result,X)),
    retract(lastHarvest(Hewan,Day0)),
    assertz(count(Result,NewX)),
    assertz(lastHarvest(Hewan, Day)).

harvestRanch(Hewan) :-
    ternak(ListTernak),
    isMember(Hewan, ListTernak),
    lastHarvest(Hewan, Day0),
    day(Day),
    Day < Day0+5,
    produce(Hewan,Result),
    write('Your '), write(Hewan), write(' isn\'t ready to produce '), write(Result), nl.

harvestRanch(Hewan) :-
    ternak(ListTernak),
    \+ isMember(Hewan, ListTernak),
    write('Oops. You can\'t choose this command.'), nl.

showTernak([]) :- !.

showTernak([Head|Tail]) :-
    count(Head,X),
    write('     - '), write(X), write('  '), write(Head), nl,
    showTernak(Tail).







% list comprehension

% isEmpty
isEmpty(List) :- \+ (isMember(_,List)).

% isMember
isMember(E,[E|_]) :- !.
isMember(E,[_|Tail]) :- isMember(E,Tail).