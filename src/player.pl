% Dev dependencies
% :- include('time.pl').

% Constants
% define playerWorkingLimit(X) as
% "Player can work for X times before they fainted."
playerWorkingLimit(10).
% define specialties(L) as
% "L is the list of available specialties in the game"
specialties([farming, fishing, ranching]).
% define jobs(L) as
% "L is the list of available jobs in the game"
jobs([farmer, fisherman, rancher]).

% String representation
define(fisherman, 'Fisherman').
define(farmer, 'Farmer').
define(rancher, 'Rancher').

% define correlate(J, S) as
% "S is the specialty of job J"
correlate(farmer, farming).
correlate(fisherman, fishing).
correlate(rancher, ranching).

% define stats(J, L, S, E, G) as
% Player's job is J
% Player's level is L
% Player's specialties are S
% Player's exp is E
% Player's gold is G
:- dynamic(stats/5).

:- dynamic(levelUpExp/1).
:- dynamic(specialtyLevelUpExp/2).

levelUpExp(300).
specialtyLevelUpExp(farming, 300).
specialtyLevelUpExp(fishing, 300).
specialtyLevelUpExp(ranching, 300).

% I.S. stats(J, L, S, E, G) is true for some J, L, S, E, G
% F.S. Displayed player statistics to the console
status :- 
    gameStarted,
    stats(J, L, S, E, G),
    levelUpExp(X),
    write('Your status:\n'),
    define(J, Job),
    write('Job: '),
    write(Job),
    nl,
    write('Level: '),
    write(L),
    nl,
    write('Exp: '),
    write(E),
    write('/'),
    write(X),
    nl,
    displaySpecialtiesStats(S),
    write('Gold: '),
    write(G),
    nl.

% I.S. status called
% F.S. Displayed player specialties statistics
displaySpecialtiesStats([]) :- !.
displaySpecialtiesStats(S) :-
    S = [[Specialty, Level, Exp]|Sub],
    specialtyLevelUpExp(Specialty, E),
    write('Level '),
    write(Specialty),
    write(': '),
    write(Level),
    nl,
    write('Exp '),
    write(Specialty),
    write(': '),
    write(Exp),
    write('/'),
    write(E),
    nl,
    displaySpecialtiesStats(Sub).

% I.S. stats(J, L, S, E, G) is false for any J, L, S, E, G
% F.S. stats(J, 1, S, 0, 0) is true for input J and specific S
initStats(J) :-
    specialties(Specialties),
    newSpecialtiesList(Specialties, S),
    asserta(stats(J, 1, S, 0, 1000)).

% Constructs a new specialties list consisting of triples
% [specialty, level, exp]
newSpecialtiesList([], []) :- !.
newSpecialtiesList([Specialty|Tail], Result) :-
    newSpecialtiesList(Tail, Subresult),
    Result = [[Specialty, 1, 0]|Subresult].

% define limit(X) as
% "player can do X more activities this day before
% they fainted"
:- dynamic(limit/1).

% I.S. limit(X) is false for any X
% F.S. limit(X) is true for playerWorkingLimit(X)
initLimit :-
    playerWorkingLimit(L),
    asserta(limit(L)).

% I.S. limit(X)
% F.S. limit(X - 1) or faint if X = 1
work :-
    limit(Limit),
    NewLimit is Limit - 1,
    (NewLimit is 0 -> faint;
    retract(limit(_)),
    asserta(limit(NewLimit))
    ).

% I.S. limit(1)
% F.S. limit(X) for playerWorkingLimit(X)
faint :-
    retract(limit(_)),
    displayFaintMessage,
    playerWorkingLimit(L),
    asserta(limit(L)).

% I.S. faint called
% F.S. Displayed player faint message
displayFaintMessage :-
    nl, 
    write('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'), 
    nl,
    write('You worked too much for today and passed out.'),
    nl,
    playerWorkingLimit(L),
    write('Try not to do more than '),
    write(L),
    write(' activities daily.'),
    nl,
    write('You wake up and it\'s the next day already.'),
    nl,
    write('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'),
    nl,
    nextDay.

% I.S. stats(J, L, S, E, Gold)
% F.S. stats(J, L, S, E, Gold + Qty)
addGold(Qty) :-
    retract(stats(J, L, S, E, Gold)),
    CurrentGold is Qty + Gold,
    asserta(stats(J, L, S, E, CurrentGold)),
    checkGold.

checkGold :-
    stats(_, _, _, _, Gold),
    (Gold >= 20000 -> win).

% I.S. stats(J, L, S, E, Gold)
% F.S. stats(J, L, S, E, Gold - Qty)
reduceGold(Qty) :-
    Qty_ is Qty * -1,
    addGold(Qty_).

checkExp :-
    stats(_, _, S, E, _),
    checkSpecialtiesExp(S, NewS),
    retract(stats(J, L, S, E, G)),
    asserta(stats(J, L, NewS, E, G)),
    levelUpExp(LU),
    E >= LU,
    levelUp,
    !.
checkExp :- !.

checkSpecialtiesExp([], []) :- !.
checkSpecialtiesExp([[Specialty, Level, Exp]|Sub], S) :-
    checkSpecialtiesExp(Sub, SubList),
    checkSpecialtyExp(Specialty, Exp, Level, NewExp, NewLevel),
    S = [[Specialty, NewLevel, NewExp]|SubList].

checkSpecialtyExp(Specialty, Exp, Level, NewExp, NewLevel) :-
    specialtyLevelUpExp(Specialty, LExp),
    Exp >= LExp,
    NextExp is Exp - LExp,
    retract(specialtyLevelUpExp(Specialty, LExp)),
    NewLExp is LExp + 100,
    NextLevel is Level + 1,
    write('Congratulations, you just leveled up at '),
    write(Specialty),
    write(' !'),
    nl,
    asserta(specialtyLevelUpExp(Specialty, NewLExp)),
    checkSpecialtyExp(Specialty, NextExp, NextLevel, NewExp, NewLevel).
checkSpecialtyExp(_, E, L, E, L) :- !.

levelUp :-
    retract(stats(J, L, S, _, G)),
    L_ is L + 1,
    retract(levelUpExp(X)),
    X_ is X + 100,
    asserta(stats(J, L_, S, 0, G)),
    asserta(levelUpExp(X_)),
    write('Congratulations, you just leveled up !'),
    nl.

% I.S. game started
% F.S. initialize player as fisherman
initFisherman :-
    initStats(fisherman),
    assertz(inv([fishing_rod])),
    assertz(invCount(shovel,0)),
    assertz(invCount(fishing_rod,1)),
    assertz(itemLevel(shovel,0)),
    assertz(itemLevel(fishing_rod,2)),
    write('You choose Fisherman. You have level 2 fishing rod.\n'),
    write('Let\'s start farming!\n').

% I.S. game started
% F.S. initialize player as farmer
initFarmer :-
    initStats(farmer),
    assertz(inv([shovel])),
    assertz(invCount(shovel,1)),
    assertz(invCount(fishing_rod,0)),
    assertz(itemLevel(shovel,1)),
    assertz(itemLevel(fishing_rod,0)),
    retract(count(carrot_seed,0)), 
    retract(count(corn_seed,0)), 
    retract(count(tomato_seed,0)), 
    assertz(count(carrot_seed,1)), 
    assertz(count(corn_seed,1)), 
    assertz(count(tomato_seed,1)),
    addToInventory(carrot_seed, 1),
    addToInventory(corn_seed, 1),
    addToInventory(tomato_seed, 1),
    write('You choose Farmer. You have 3 seeds.\n'),
    write('Let\'s start farming!\n').

% I.S. game started
% F.S. initialize player as rancher
initRancher :-
    initStats(rancher),
    assertz(inv([])),
    assertz(invCount(shovel,0)),
    assertz(invCount(fishing_rod,0)),
    assertz(itemLevel(shovel,0)),
    assertz(itemLevel(fishing_rod,0)),
    retract(ternak(_)),
    retract(count(chicken,0)),
    assertz(ternak([chicken])),
    assertz(count(chicken,2)),
    write('You choose Rancher. You have 2 chickens.\n'),
    write('Let\'s start farming!\n').
