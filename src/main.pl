:- include('map.pl').
:- include('ranch.pl').

start :- 
    assertz(day(0)),
    createMap.
    
ranch :- 
    tile(X,Y,'P'),
    (tile(X,Y,'R') -> incActivities, handleRanch;
    write('You need to go to the Ranch first.')), !.