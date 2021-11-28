:- include('map.pl').
:- include('ranch.pl').
:- include('farm.pl').
:- include('market.pl').
:- include('utils.pl').
:- include('quest.pl').
:- include('time.pl').
:- include('player.pl').
:- include('house.pl').
:- include('fish.pl').
:- include('inventory.pl').

:- dynamic(gameStarted/0).
:- dynamic(gameLoaded/0).

startGame :- 
    asserta(gameLoaded),
    showMenu.

start :- 
    gameLoaded,
    retract(gameLoaded),
    asserta(gameStarted),
    initLimit,
    initDiaryEntries,
    initRanch,
    initFarm,
    assertz(onQuest(false)),
    createMap,
    showChoice,
    repeat,
    write('> '),
    read(Num),
    (Num is 1 -> initFisherman;
    Num is 2 -> initFarmer;
    Num is 3 -> initRancher;
    write('Invalid choice!'), nl, fail)
    , !. 

ranch :- 
    gameStarted,
    tile(X,Y,'P'),
    (tile(X,Y,'R') -> handleRanch;
    write('You need to go to the Ranch first.'), nl), !.

dig :-
    gameStarted,
    tile(X,Y,'P'),
    (
        tile(X,Y,C),
        (C = 'R'; C = 'F'; C = 'M'; C = 'Q'; C = 'H'; C = 'c'; C = 't'; C = 'r'; C = ('='))
    )
        -> 
        (
            write('You can\'t dig this tile. '),
            nl
        );
        (
            tile(X,Y,C),
            retract(tile(X, Y, 'P')),
            asserta(tile(X,Y,'=')), 
            asserta(tile(X, Y, 'P'))
        ),
    !. 
    
plant :-
    gameStarted,
    tile(X,Y,'P'),
    (tile(X,Y,'=') -> handleFarm; 
    write('You need to go to the farm field or dig the tile first'), nl), !.

market :-
    gameStarted,
    tile(X,Y,'P'),
    (tile(X,Y,'M') -> handleMarket;
    write('You need to go to the Market first.'), nl), !.

quest :-
    gameStarted,
    tile(X,Y,'P'),
    (tile(X,Y,'Q') -> handleQuest;
    write('You need to go to the ?? first.'), nl), !.

harvest :-
    gameStarted,
    tile(X, Y, 'P'),
    (tile(X,Y,C),
    (C = 'c'; C = 't'; C = 'r') -> handleHarvest(X, Y);
    write('You can\'t harvest this tile'), nl), !.

fish :-
    gameStarted,
    (isNearPond -> handleFish ; write('You can\'t fish here!'), nl), !.

inventory :-
    gameStarted,
    showInventory, !.

showMenu :-
    write('  _   _                           _   '), nl,
    write(' | | | | __ _ _ ____   _____  ___| |_ '), nl,
    write(' | |_| |/ _` | \'__\\ \\ / / _ \\/ __| __|'), nl,
    write(' |  _  | (_| | |   \\ V /  __/\\__ \\ |_ '), nl,
    write(' |_| |_|\\__,_|_|    \\_/ \\___||___/\\__|'), nl,
    nl,
    write('Harvest Star!!!'), nl,
    nl,
    write('Let\'s play and pay our debts together!'), nl,
    nl,
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'), nl,
    write('%                              ~Harvest Star~                                  %'), nl,
    write('% 1. start  : untuk memulai petualanganmu                                      %'), nl,
    write('% 2. map    : menampilkan peta                                                 %'), nl,
    write('% 3. status : menampilkan kondisimu terkini                                    %'), nl,
    write('% 4. w      : gerak ke utara 1 langkah                                         %'), nl,
    write('% 5. s      : gerak ke selatan 1 langkah                                       %'), nl,
    write('% 6. d      : gerak ke ke timur 1 langkah                                      %'), nl,
    write('% 7. a      : gerak ke barat 1 langkah                                         %'), nl,
    write('% 8. help   : menampilkan segala bantuan                                       %'), nl,
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'), nl, !.

showChoice :-
    write('Welcome to Harvest Star. Choose your job'), nl,
    write('1. Fisherman'), nl,
    write('2. Farmer'), nl,
    write('3. Rancher'), nl.

load :-
    consult('save_data/1.pl').