:- include('map.pl').
:- include('ranch.pl').

start :- 
    initStats(rancher),
    initLimit,
    createMap.
    
ranch :- 
    tile(X,Y,'P'),
    (tile(X,Y,'R') -> handleRanch;
    write('You need to go to the Ranch first.')), !.