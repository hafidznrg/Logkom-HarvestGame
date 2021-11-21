:- include('map.pl').
:- include('ranch.pl').
:- include('farm.pl').

start :- 
    initStats(rancher),
    initLimit,
    createMap.
    
ranch :- 
    tile(X,Y,'P'),
    (tile(X,Y,'R') -> handleRanch;
    write('You need to go to the Ranch first.')), !.

dig :-
    tile(X,Y,'P'),
    (tile(X,Y,C), (C = 'R'; C = 'F'; C = 'M'; C = 'Q'; C = 'H')) -> write('you can\'t dig this tile. '),nl;
    tile(X,Y,C),
    assertz(tile(X,Y,'=')), !.
% entah kenapa P nya ketutupan sama =   

plant :-
    tile(X,Y,'P'),
    (tile(X,Y,'=') -> handleFarm;
    write('You need to go to the farm field or dig the tile first')), !.