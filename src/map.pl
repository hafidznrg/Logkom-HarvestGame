:- dynamic(tile/3).
:- dynamic(map_size/2).

/* MAP border */
% tile(0,_,'#').
% tile(_,0,'#').
% tile(16,_,'#').
% tile(_,21,'#').

randomPlayerPos :-
    random(1, 15, X),
    random(1, 20, Y),
    asserta(tile(X,Y,'P')), !.

createMap :- 
    write('Map has created.'), nl,
    asserta(map_size(15,20)),
    assertz(tile(0,_,'#')),
    assertz(tile(_,0,'#')),
    assertz(tile(16,_,'#')),
    assertz(tile(_,21,'#')),
    assertz(tile(2,6,'R')),
    asserta(tile(4,4,'P')),         /* Posisi Player */
    assertz(tile(4,4,'H')),
    assertz(tile(4,9,'F')),
    assertz(tile(8,8,'Q')),
    assertz(tile(8,13,'M')).
    % randomPlayerPos.

% Border kanan bawah
printTile(X,Y) :-
    map_size(Height,Width),
    X is Height+1,
    Y is Width+1, !,
    write('#'), nl.

% Border bawah
printTile(X,Y) :-
    map_size(Height,Width),
    X is Height+1,
    Y =< Width,
    write('#'),
    Y1 is Y+1,
    printTile(X,Y1).

% Border kanan
printTile(X,Y) :-
    map_size(Height,Width),
    X =< Height,
    Y is Width+1,
    write('#'), nl,
    X1 is X+1,
    print('            '),
    printTile(X1,0).

% Isi di dalam MAP
printTile(X,Y) :-
    map_size(Height, Width),
    X =< Height,
    Y =< Width,
    (tile(X,Y,C), write(C), Y1 is Y+1, printTile(X,Y1);
    \+ tile(X,Y,_), write('-'), Y1 is Y+1, printTile(X,Y1)).

displayMap :-
    write('[]==========================================[]'), nl,
    write('||                                          ||'), nl,
    write('||             Here\'s your Map              ||'), nl,
    write('||                                          ||'), nl,
    write('[]==========================================[]'), nl, nl,
    print('            '),
    printTile(0,0), !.

