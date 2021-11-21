:- dynamic(tile/3).
:- dynamic(map_size/2).

% Initialize tile water for map version 1
listWater1([(5,20),(6,19),(6,20),(7,18),(7,19),(7,20),(8,18),(8,19),(8,20),(9,19),(9,20),(10,20),(11,8), (11,9),(11,10),(11,11),(12,7),(12,8),(12,9),(12,10),(12,11),(12,12),(13,7),(13,8),(13,9),(13,10),(13,11),(13,12),(14,8),(14,9),(14,10),(14,11)]).

% Initialize tile water for map version 2
listWater2([(1,13),(1,14),(1,15),(1,16),(1,17),(1,18),(1,19),(1,20),(2,14),(2,15),(2,16),(2,17),(2,18),(2,19),(2,20),(3,15),(3,16),(3,17),(3,18),(3,19),(3,20),(4,15),(4,16),(4,17),(4,18),(4,19),(4,20),(5,17),(5,18),(5,19),(5,20),(6,19),(6,20),(7,20)]).

% Asserting tile water
assertWater([]) :- !.
assertWater([(X,Y)|Tail]) :-
    assertz(tile(X,Y,'o')),
    assertWater(Tail).

% I.S. RNG get 1
% F.S. Create Map version 1
createMap1 :-
    asserta(map_size(15,20)),
    assertz(tile(0,_,'#')), assertz(tile(_,0,'#')), assertz(tile(16,_,'#')), assertz(tile(_,21,'#')),
    assertz(tile(2,6,'R')), asserta(tile(5,4,'P')), assertz(tile(4,4,'H')), assertz(tile(4,9,'F')), assertz(tile(8,8,'Q')), assertz(tile(8,13,'M')),
    listWater1(ListWater), assertWater(ListWater).

% I.S. RNG get 2
% F.S. Create Map version 2
createMap2 :-
    asserta(map_size(15,20)),
    assertz(tile(0,_,'#')), assertz(tile(_,0,'#')), assertz(tile(16,_,'#')), assertz(tile(_,21,'#')),
    assertz(tile(10,5,'R')), asserta(tile(12,16,'P')), assertz(tile(12,16,'H')), assertz(tile(13,11,'F')), assertz(tile(4,9,'Q')), assertz(tile(7,15,'M')),
    listWater2(ListWater), assertWater(ListWater).

% I.S. Initialize MAP
% F.S. Map has created, initialize player position at House
createMap :- 
    write('Map has created.'), nl,
    asserta(map_size(15,20)),
    random(1,3,Num),
    write(Num),
    (Num = 1 -> createMap1;
    Num = 2 -> createMap2).

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
    ((C = 'R'; C = 'F'; C = 'M'; C = 'Q'; C = 'H'; C = ('=')),
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