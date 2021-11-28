:- dynamic(lastHarvestSeed/2).
:- dynamic(count/2).
:- dynamic(seed/1).
:- dynamic(seedTile/3).
:- dynamic(limitFarm/1).

% Define plant in farm 
plantproduce([corn, tomato, carrot]).
produces(corn_seed, corn).
produces(tomato_seed, tomato).
produces(carrot_seed, carrot).

% Define seed 
seeds([corn_seed,tomato_seed,carrot_seed]).
cornSeed([corn1,corn2,corn3,corn4,corn5,corn6,corn7,corn8,corn9,corn10,corn11,corn12,corn13,corn14,corn15,corn16,corn17]).
carrotSeed([carrot1,carrot2,carrot3,carrot4,carrot5,carrot6,carrot7,carrot8,carrot9,carrot10,carrot11,carrot12,carrot13,carrot14,carrot15,carrot16,carrot17]).
tomatoSeed([tomato1,tomato2,tomato3,tomato4,tomato5,tomato6,tomato7,tomato8,tomato9,tomato10,tomato11,tomato12,tomato13,tomato14,tomato15,tomato16,tomato17]).
seed([corn_seed,tomato_seed, carrot_seed]).

% Initialize fact for all cattle
initPlant([]).
initPlant([Head|Tail]) :-
    produces(Head, Product),
    assertz(count(Head,0)),
    assertz(count(Product,0)),
    initPlant(Tail).

% Initialize fact for seed
initSeed([]).
initSeed([Head1|Tail1]) :-
    assertz(lastHarvestSeed(Head1,0)),
    assertz(seedTile(0,0,Head1)),
    initSeed(Tail1).

% Initialize fact for all farm
initFarm :-
    seeds(ListSeed),
    assertz(limitFarm(0)),
    cornSeed(ListCorn),
    carrotSeed(ListCarrot),
    tomatoSeed(ListTomato),
    initPlant(ListSeed),
    initSeed(ListCarrot),
    initSeed(ListTomato),
    initSeed(ListCorn).

% I.S.
% F.S. Showing Banner Farm
showBannerFarm :-
    write('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'), nl,
    write('~~                                          ~~'), nl,
    write('~~          Welcome to the Farm             ~~'), nl,
    write('~~                                          ~~'), nl,
    write('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'), nl, nl.

% I.S. handleFarm is Calles
% F.S. handle mechanism in farm
handleFarm :-
    showBannerFarm,
    seed(ListSeed),
    (isempty(ListSeed) -> write('You don\'t have any seed. '), nl;
    (\+ isempty(ListSeed)) -> write('You have: '),nl,
    showSeed(ListSeed),
    write('What do you want to plant?'), nl,
    plantproduce(ListPlant),
    write('>>> '),
    read(Plant),
    (isMember(Plant,ListPlant) -> plant(Plant), !;
    write('Oops. You can\'t choose this command.'), nl)), !.

% I.S. showSeed is called
% F.S. Showing all seed
showSeed([]) :- !.
showSeed([Head|Tail]) :-
    count(Head,X),
    (X>0, write('     - '), write(X), write(' '), write(Head), nl; write('')),
    showSeed(Tail).

% I.S. the count seed = 0
% F.S. display error message
plant(Plant) :-
    produces(Y, Plant),
    count(Y, Count),
    Count = 0,
    write('Not enough seeds to plant'),nl, !.

% I.S. the count seed > 0
% F.S. plant the seed
plant(Plant) :-
    produces(Seed, Plant),
    count(Seed, Count),
    Count > 0,
    Counta is Count - 1,
    plantSeed(Seed),
    produces(Seed, Plant),
    removeFromInventory(Seed, 1),
    retract(count(Seed, Count)),
    assertz(count(Seed,Counta)),
    write('You planted a '),write(Plant) ,write(' seed'), nl,
    workFarm, !.

% I.S. the type of seed is corn
% F.S. plant the corn seed to this tile
plantSeed(Seed) :-
    Seed = corn_seed,
    cornSeed(Listcorn),
    handleSeed(Listcorn, Corn),
    day(Day),
    retract(lastHarvestSeed(Corn,_)),
    asserta(lastHarvestSeed(Corn, Day)),
    tile(X, Y, 'P'),
    retractall(seedTile(_,_,Corn)),
    asserta(seedTile(X,Y,Corn)),
    retract(tile(C,D,'P')),
    retract(tile(C,D,'=')),
    asserta(tile(C,D,'c')),
    asserta(tile(C,D,'P')), !.

% I.S. the type of seed is tomato
% F.S. plant the tomato seed to this tile
plantSeed(Seed) :-
    Seed = tomato_seed,
    tomatoSeed(ListTomato),
    handleSeed(ListTomato, Tomato),
    day(Day),
    retract(lastHarvestSeed(Tomato,_)),
    asserta(lastHarvestSeed(Tomato, Day)),
    tile(X, Y, 'P'),
    retractall(seedTile(_,_,Tomato)),
    asserta(seedTile(X,Y,Tomato)),
    retract(tile(C,D,'P')),
    retract(tile(C,D,'=')),
    asserta(tile(C,D,'t')),
    asserta(tile(C,D,'P')), !.

% I.S. the type of seed is carrot
% F.S. plant the carrot seed to this tile
plantSeed(Seed) :-
    Seed = carrot_seed,
    carrotSeed(ListCarrot),
    handleSeed(ListCarrot, Carrot),
    day(Day),
    retract(lastHarvestSeed(Carrot,_)),
    asserta(lastHarvestSeed(Carrot, Day)),
    tile(X, Y, 'P'),
    retractall(seedTile(_,_,Carrot)),
    asserta(seedTile(X,Y,Carrot)),
    retract(tile(C,D,'P')),
    retract(tile(C,D,'=')),
    asserta(tile(C,D,'r')),
    asserta(tile(C,D,'P')), !.

% I.S. 
% F.S. find the seed in list seed depend on type seed that hasn't be used
handleSeed([]) :- !.
handleSeed([Head| Tail], Corn) :-
    lastHarvestSeed(Head, X),
    (X = 0 -> Corn = Head, !;
    handleSeed(Tail, Corn)).


% I.S. 
% F.S. list is Empty
isempty([]).
isempty([Head|Tail]) :-
    count(Head, X),
    (X = 0 -> isempty(Tail), !;
    fail).

% I.S. Farm is ready
% F.S. Call harvest plant depend the seed
handleHarvest(X, Y) :-
    seedTile(X,Y,Plant),
    day(Day),
    lastHarvestSeed(Plant,DayPlant),
    Day > DayPlant + 2, !,
    harvestPlant(Plant),
    retract(lastHarvestSeed(Plant,DayPlant)),
    asserta(lastHarvestSeed(Plant,0)),
    retract(seedTile(X,Y,Seed)),
    asserta(seedTile(0,0,Seed)), !.

% I.S. Farm isn't ready
% F.S. Display error message
handleHarvest(X, Y) :-
    seedTile(X,Y,Plant),
    day(Day),
    lastHarvestSeed(Plant,DayPlant),
    Day =< DayPlant+2,
    write('Your seed is not ready for harvest '),nl,
    write('Please check again later.'), nl,!.

% I.S. Farm is ready to harvest
% F.S. RNG to get random number of product Corn
harvestPlant(Plant) :-
    cornSeed(ListCorn),
    isMember(Plant, ListCorn),
    count(corn, X),
    stats(J,L,_,_,_),
    (J = farmer -> Base is (L//3)+1, Max is Base+4;
    Base is 1, Max is 4),
    random(Base,Max,Num),
    addToInventory(corn, Num),
    X1 is X+Num,
    retract(count(corn,_)),
    asserta(count(corn, X1)),
    tile(XTile,YTile,'P'),
    retract(tile(XTile,YTile,'P')),
    retract(tile(XTile,YTile,'c')),
    asserta(tile(XTile,YTile,'P')),
    addFarmExp(10),
    write('You harvested '), write(X1) ,write(' corn'),nl, !.

% I.S. Farm is ready to harvest
% F.S. RNG to get random number of product Carrot
harvestPlant(Plant) :-
    carrotSeed(ListCarrot),
    isMember(Plant, ListCarrot),
    count(carrot, X),
    stats(J,L,_,_,_),
    (J = farmer -> Base is (L//3)+1, Max is Base+4;
    Base is 1, Max is 4),
    random(Base,Max,Num),
    addToInventory(carrot, Num),
    X1 is X+Num,
    retract(count(carrot,_)),
    asserta(count(carrot, X1)),
    retract(tile(XTile,YTile,'P')),
    retract(tile(XTile,YTile,'r')),
    asserta(tile(XTile,YTile,'P')),
    addFarmExp(10),
    write('You harvested '), write(X1) ,write(' carrot'),nl, !.

% I.S. Farm is ready to harvest
% F.S. RNG to get random number of product Tomato
harvestPlant(Plant) :-
    tomatoSeed(ListTomato),
    count(tomato, X),
    isMember(Plant, ListTomato),
    stats(J,L,_,_,_),
    (J = farmer -> Base is (L//3)+1, Max is Base+4;
    Base is 1, Max is 4),
    random(Base,Max,Num),
    addToInventory(tomato, Num),
    X1 is X+Num,
    retract(count(tomato,_)),
    asserta(count(tomato, X1)),
    retract(tile(XTile,YTile,'P')),
    retract(tile(XTile,YTile,'t')),
    asserta(tile(XTile,YTile,'P')),
    addFarmExp(10),
    write('You harvested '), write(X1) ,write(' tomato'),nl, !.

% I.S -
% F.S add seed to list Seed
increaseSeed(Seed, Add) :-
    count(Seed, Before),
    After is Before+Add,
    seed(ListSeed),
    (\+ isMember(Seed, ListSeed),
    push(ListSeed, Seed, NewList),
    retract(seed(ListSeed)),
    assertz(seed(NewList)); !),
    retract(count(Seed,Before)),
    assertz(count(Seed,After)).

% I.S -
% F.S call work when player farm 3 times
workFarm :-
    limitFarm(Limit),
    retract(limitFarm(_)),
    X1 is Limit +1,
    assertz(limitFarm(X1)),
    (X1 = 3 -> work;
    X1 > 3 -> retract(limitFarm(_)),assertz(limitFarm(0));
    write('')), !.

% Adds Amount to both farm EXP and general EXP.
addFarmExp(Amount) :-
    stats(J, L, S, E, G),
    [Farming, Fishing, Ranching] = S,
    [Specialty, Level, Exp] = Farming,
    NewExp is Exp + Amount,
    NewE is E + Amount,
    NewS = [[Specialty, Level, NewExp], Fishing, Ranching],
    write('> Farming experience added by '), write(Amount), write('!'), nl,
	write('> Current farming level: '), write(Level), nl,
	write('> Current farming EXP: '), write(NewE), nl,
    retract(stats(_,_,_,_,_)),
    assertz(stats(J, L, NewS, NewE, G)),
    checkExp, !.