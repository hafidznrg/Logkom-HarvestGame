:- include('map.pl').
:- include('ranch.pl').
:- include('farm.pl').
:- include('market.pl').
:- include('utils.pl').
:- include('quest.pl').

start :- 
    initStats(rancher),
    initLimit,
    initDiaryEntries,
    assertz(onQuest(false)),
    createMap.
    
ranch :- 
    tile(X,Y,'P'),
    (tile(X,Y,'R') -> handleRanch;
    write('You need to go to the Ranch first.')), !.

dig :-
    tile(X,Y,'P'),
    (
        tile(X,Y,C),
        (C = 'R'; C = 'F'; C = 'M'; C = 'Q'; C = 'H')
    )
        -> 
        (
            write('you can\'t dig this tile. '),
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
    tile(X,Y,'P'),
    (tile(X,Y,'=') -> handleFarm; 
    write('You need to go to the farm field or dig the tile first')), !.

market :-
    tile(X,Y,'P'),
    (tile(X,Y,'M') -> handleMarket;
    write('You need to go to the Market first.')), !.

quest :-
    tile(X,Y,'P'),
    (tile(X,Y,'Q') -> handleQuest;
    write('You need to go to the ?? first.')), !.
