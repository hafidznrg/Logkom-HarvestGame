% Dev dependencies
:- include('time.pl').
:- include('player.pl').

:- dynamic(lastHarvest/2).
:- dynamic(count/2).
:- dynamic(ternak/1).

% Define animals in ranch 
animals([cow,sheep,chicken]).

% Define count for each animals and its product
count(cow,0).
count(sheep,0).
count(chicken,0).
count(milk,0).
count(wool,0).
count(egg,0).

produce(cow, milk).
produce(sheep, wool).
produce(chicken, egg).

lastHarvest(cow,0).
lastHarvest(sheep,0).
lastHarvest(chicken,0).

% Testing
% PLayer have cow and chicken
% Edit count
ternak([cow,chicken]).

% I.S. showBannerRanch is called
% F.S. Displayed banner
showBannerRanch :-
    write('[]==========================================[]'), nl,
    write('||                                          ||'), nl,
    write('||           Welcome to the Ranch           ||'), nl,
    write('||                                          ||'), nl,
    write('[]==========================================[]'), nl, nl.

% I.S. Player at the Ranch
% F.S. Show Ranch Menu and handle it
handleRanch :- 
    showBannerRanch,
    ternak(ListTernak),
    (isEmpty(ListTernak) -> write('You don\'t have any cattle.'), nl;
    (\+ isEmpty(ListTernak)) -> write('   You have:'), nl,
    showTernak(ListTernak),
    write('What do you want to do?'), nl,
    read(Hewan), !,
    harvestRanch(Hewan)).

% I.S. showTernak is called
% F.S. Showing all cattle
showTernak([]) :- !.
showTernak([Head|Tail]) :-
    count(Head,X),
    (X>0, write('     - '), write(X), write('  '), write(Head), nl; nl),
    showTernak(Tail).

% I.S. Cattle is ready
% F.S. Harvest
harvestRanch(Hewan) :-
    ternak(ListTernak),
    isMember(Hewan, ListTernak),
    lastHarvest(Hewan, Day0),
    day(Day),
    Day > Day0+5, !,
    work,
    harvestThis(Hewan),
    retract(lastHarvest(Hewan,Day0)),
    assertz(lastHarvest(Hewan, Day)).

% I.S. Cattle isn't ready
% F.S. Display error message
harvestRanch(Hewan) :-
    ternak(ListTernak),
    isMember(Hewan, ListTernak),
    lastHarvest(Hewan, Day0),
    day(Day),
    Day =< Day0+5,
    produce(Hewan,Result),
    write('Your '), write(Hewan), write(' hasn\'t produce any '), write(Result), nl,
    write('Please check again later.'), nl.

% I.S. Command isn't match
% F.S. Display error message
harvestRanch(Hewan) :-
    ternak(ListTernak),
    \+ isMember(Hewan, ListTernak),
    write('Oops. You can\'t choose this command.'), nl.

% I.S. Cattle is ready
% F.S. RNG to get random number of product
harvestThis(Hewan) :-
    produce(Hewan,Product),
    stats(J,L,_,_,_),
    (J = rancher -> Base is (L//3)+1, Max is Base+3;
    Base is 1, Max is 3),
    random(Base,Max,Num),
    showResult(Num,Product),
    count(Product,Before),
    After is Before+Num,
    retract(count(Product,Before)),
    assertz(count(Product,After)).

% I.S. -
% F.S. Displayed message
showResult(Num,Product) :-
    write('You got '), write(Num), write(' '), write(Product), (Num>1, write('s'), nl; nl).






% list comprehension

% isEmpty
isEmpty(List) :- \+ (isMember(_,List)).

% isMember
isMember(E,[E|_]) :- !.
isMember(E,[_|Tail]) :- isMember(E,Tail).