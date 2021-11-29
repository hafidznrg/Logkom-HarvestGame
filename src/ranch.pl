% Dev dependencies
% :- include('time.pl').
% :- include('player.pl').
% :- include('utils.pl').

:- dynamic(lastHarvest/2).
:- dynamic(count/2).
:- dynamic(ternak/1).
:- dynamic(increaseAnimal/1).

% Define animals in ranch 
animals([cow,sheep,chicken]).
produce(cow, milk).
produce(sheep, wool).
produce(chicken, egg).

% Define count for each animals and its product
% Initialize fact about Ranch
initRanch :-
    animals(ListCattle),
    initCattle(ListCattle).

% Initialize fact for all cattle
initCattle([]).
initCattle([Head|Tail]) :-
    produce(Head,Product),
    assertz(count(Head,0)),
    assertz(count(Product,0)),
    assertz(lastHarvest(Head,0)),
    initCattle(Tail).

% Initialize empty ternak
ternak([]).

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
    (empty(ListTernak) -> write('You don\'t have any cattle.'), nl;
    (\+ empty(ListTernak)) -> write('   You have:'), nl,
    showTernak(ListTernak),
    write('What do you want to do?'), nl,
    write(' > '),
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
ranchLevel(X) :-
    stats(_, _, S, _, _),
    [_, _, Ranching] = S,
    [_, X, _] = Ranching, !.

harvestRanch(Hewan) :-
    ranchLevel(RanchingLevel),
    ternak(ListTernak),
    isMember(Hewan, ListTernak),
    lastHarvest(Hewan, Day0),
    day(Day),
    AdditionalDay is 5 - RanchingLevel,
    (AdditionalDay @=< 0 -> (
        DayCheck is 1 + Day0
    ) ; (
        DayCheck is Day0 + AdditionalDay
    )),
    Day > DayCheck, !,
    harvestThis(Hewan), !.

% I.S. Cattle isn't ready
% F.S. Display error message
harvestRanch(Hewan) :-
    ranchLevel(RanchingLevel),
    ternak(ListTernak),
    isMember(Hewan, ListTernak),
    lastHarvest(Hewan, Day0),
    day(Day),
    AdditionalDay is 5 - RanchingLevel,
    (AdditionalDay @=< 0 -> (
        DayCheck is 1 + Day0
    ) ; (
        DayCheck is Day0 + AdditionalDay
    )),
    Day =< DayCheck,
    produce(Hewan,Result),
    write('Your '), write(Hewan), write(' hasn\'t produced any '), write(Result), nl,
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
    stats(J,_,S,_,_),
    (J = rancher -> getRanchLevel(S,J,L), Base is (L//3)+1, Max is Base+4;
    Base is 1, Max is 4),
    random(Base,Max,Num),
    totalItem(TotalItem),
    InvCheck is TotalItem + Num,
    ( InvCheck @> 100 -> (
        nl, write('Clear out some space from your inventory first before harvesting!'), nl
    ) ; (
        showResult(Num,Product),
        addToInventory(Product, Num),
        count(Product,Before),
        After is Before+Num,
        retract(count(Product,Before)),
        assertz(count(Product,After)),
        work,
        addRanchExp(50),
        lastHarvest(Hewan, Day0),
        day(Day),
        retract(lastHarvest(Hewan,Day0)),
        assertz(lastHarvest(Hewan, Day)),
        handleRanchQuest(Num), !
    )), !.

getRanchLevel([],_,0) :- !.
getRanchLevel([[Specialty, Level, _] | Tail], Job, X) :-
    (
        correlate(Job, Specialty) -> X is Level;
        getRanchLevel(Tail,Job,X)
    ).
    

% I.S. -
% F.S. Displayed message
showResult(Num,Product) :-
    write('You got '), write(Num), write(' '), write(Product), (Num>1, write('s'), nl; nl).

% I.S -
% F.S add animal to list ternak
increaseAnimal(Hewan, Add) :-
    count(Hewan, Before),
    After is Before+Add,
    ternak(ListTernak),
    (\+ isMember(Hewan, ListTernak), push(ListTernak,Hewan,NewList),
    retract(ternak(ListTernak)),
    assertz(ternak(NewList)); !),
    retract(count(Hewan,Before)),
    assertz(count(Hewan,After)).

% Adds Amount to both ranch EXP and general EXP.
addRanchExp(Amount) :-
    stats(J, L, S, E, G),
    [Farming, Fishing, Ranching] = S,
    [Specialty, Level, Exp] = Ranching,
    NewExp is Exp + Amount,
    NewE is E + Amount,
    NewS = [Farming, Fishing, [Specialty, Level, NewExp]],
    retract(stats(_,_,_,_,_)),
    assertz(stats(J, L, NewS, NewE, G)),
    checkExp,
    stats(_,_,[_,_,[_,LevelNow,ExpNow]],_,_),
    write('> Ranching experience added by '), write(Amount), write('!'), nl,
	write('> Current ranching level: '), write(LevelNow), nl,
	write('> Current ranching EXP: '), write(ExpNow), nl, !.