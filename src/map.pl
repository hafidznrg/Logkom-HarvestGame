:- dynamic(tile/3).
:- dynamic(map_size/2).

% I.S. Initialize MAP
% F.S. Map has created, initialize player position at House
createMap :- 
    write('Map has created.'), nl,
    asserta(map_size(15,20)),
    assertz(tile(0,_,'#')),
    assertz(tile(_,0,'#')),
    assertz(tile(16,_,'#')),
    assertz(tile(_,21,'#')),
    assertz(tile(2,6,'R')),
    asserta(tile(4,4,'P')),
    assertz(tile(4,4,'H')),
    assertz(tile(4,9,'F')),
    assertz(tile(8,8,'Q')),
    assertz(tile(8,13,'M')).

% I.S. Tile at last row and last column
% F.S. Print border.
printTile(X,Y) :-
    map_size(Height,Width),
    X is Height+1,
    Y is Width+1, !,
    write('#'), nl.

% I.S. Tile at last row
% F.S. Print border, print next tile
printTile(X,Y) :-
    map_size(Height,Width),
    X is Height+1,
    Y =< Width,
    write('#'),
    Y1 is Y+1,
    printTile(X,Y1).

% I.S. Tile at last column for each row
% F.S. Print border, print the first tile for the next row
printTile(X,Y) :-
    map_size(Height,Width),
    X =< Height,
    Y is Width+1,
    write('#'), nl,
    X1 is X+1,
    print('            '),
    printTile(X1,0).

% I.S. -
% F.S. printTile at position (X,Y)
printTile(X,Y) :-
    map_size(Height, Width),
    X =< Height,
    Y =< Width,
    (tile(X,Y,C), write(C), Y1 is Y+1, printTile(X,Y1);
    \+ tile(X,Y,_), write('-'), Y1 is Y+1, printTile(X,Y1)).

% I.S. displayMap is called
% F.S. Displayed Map
displayMap :-
    write('[]==========================================[]'), nl,
    write('||                                          ||'), nl,
    write('||             Here\'s your Map              ||'), nl,
    write('||                                          ||'), nl,
    write('[]==========================================[]'), nl, nl,
    print('            '),
    printTile(0,0), !.

/* MOVEMENT */
% I.S. handleMove is called
% F.S. Player postion is updated
handleMove(X,Y) :-
    (\+ tile(X,Y,_)),
    retract(tile(_,_,'P')),
    asserta(tile(X,Y,'P')).

% I.S. handleMove is called
% F.S. Player position is updated if they want to go to
% Ranch, Farm, Marketplace, Quest, or Home; else call cantMove
handleMove(X,Y) :-
    tile(X,Y,C),
    ((C = 'R'; C = 'F'; C = 'M'; C = 'Q'; C = 'H'),
    retract(tile(_,_,'P')),
    asserta(tile(X,Y,'P'));
    cantMove).
    
% I.S. Player position at (X,Y)
% F.S. handleMove to East
e :-
    tile(X,Y,'P'),
    Y1 is Y+1,
    handleMove(X,Y1), !.

% I.S. Player position at (X,Y)
% F.S. handleMove to West
w :-
    tile(X,Y,'P'),
    Y1 is Y-1,
    handleMove(X,Y1), !.

% I.S. Player position at (X,Y)
% F.S. handleMove to North
n :-
    tile(X,Y,'P'),
    X1 is X-1,
    handleMove(X1,Y), !.

% I.S. Player position at (X,Y)
% F.S. handleMove to South
s :-
    tile(X,Y,'P'),
    X1 is X+1,
    handleMove(X1,Y), !.

% I.S. cantMove called
% F.S. Displayed error message can't move
cantMove :- 
    write('You can\'t move to this location'), nl, !.