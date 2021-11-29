% Dev dependencies
% :- include('time.pl').
% :- include('player.pl').

% List of fishes
% :- dynamic(fishes/1).
% count(X, Y) means there are Y X's.
% :- dynamic(count/2).

% A predicate to check whether the player is near a pond or not.
isNearPond :-
	tile(X, Y, 'P'),
	X1 is X + 1,
	tile(X1, Y, 'o'), !.
isNearPond :-
	tile(X, Y, 'P'),
	X1 is X - 1,
	tile(X1, Y, 'o'), !.
isNearPond :-
	tile(X, Y, 'P'),
	Y1 is Y + 1,
	tile(X, Y1, 'o'), !.
isNearPond :-
	tile(X, Y, 'P'),
	Y1 is Y - 1,
	tile(X, Y1, 'o'), !.
isNearPond :-
	tile(X, Y, 'P'),
	X1 is X + 1,
	Y1 is Y + 1,
	tile(X1, Y1, 'o'), !.
isNearPond :-
	tile(X, Y, 'P'),
	X1 is X - 1,
	Y1 is Y + 1,
	tile(X1, Y1, 'o'), !.
isNearPond :-
	tile(X, Y, 'P'),
	X1 is X - 1,
	Y1 is Y - 1,
	tile(X1, Y1, 'o'), !.
isNearPond :-
	tile(X, Y, 'P'),
	X1 is X + 1,
	Y1 is Y - 1,
	tile(X1, Y1, 'o'), !.

% Define what the valid fishes are.
fish([akame, goldfish, tuna, carp]).

% At the start of the game, the player doesn't have a fish yet.
% fishes([]).
% count(akame, 0).
% count(goldfish, 0).
% count(tuna, 0).
% count(carp, 0).

% A predicate to get the players fishing level.
getFishingLevel(X) :-
	stats(_, _, S, _, _),
	[_, F, _] = S,				% F berupa sebuah list untuk specialty Fisherman
	[_, X, _] = F, !.			% Urutannya adalah [Specialty, Level, Exp]

% Adds Amount to both fishing EXP and general EXP.
addFishingExp(Amount) :-
  stats(J, L, S, E, G),
  [Farming, Fishing, Ranching] = S,
  [Specialty, Level, Exp] = Fishing,
  NewExp is Exp + Amount,
  NewE is E + Amount,
  NewS = [Farming, [Specialty, Level, NewExp], Ranching],
  retract(stats(_,_,_,_,_)),
  assertz(stats(J, L, NewS, NewE, G)),
	checkExp,
	stats(_, _, S_, _, _),
	[_, Fishing_, _] = S_,
	[_, Level_, Exp_] = Fishing_,
  write('> Fishing experience added by '), write(Amount), write('!'), nl,
	write('> Current fishing level: '), write(Level_), nl,
	write('> Current fishing EXP: '), write(Exp_), nl, !.

% Handle fish!
% I.S. The player has a list of fishes
% F.S. The list of fishes will be updated based on what the character fished.
handleFish :-
	getFishingLevel(FishLevel),
	RNGBound is 20 - FishLevel,
	random(1, RNGBound, X),
	getFish(X),
	inv(Inventory),
	write('=============================================='), nl,
	write('These are the fishes that you currently have: '), nl,
	showFishes(Inventory, 1), 
	write('=============================================='), nl,
  work, !.

% getFish(X) will add different values to the list of fishes based on X.
% X = 1 -> akame
% X = 2 -> goldfish
% X = 3 -> tuna
% X = 4 -> carp
% Other than that, the player catches nothing.
getFish(1) :-
	addFish(akame), !.

getFish(2) :-
	addFish(goldfish), !.

getFish(3) :-
	addFish(tuna), !.

getFish(4) :-
	addFish(carp), !.

getFish(Num) :-
	(Num @< 1 ; Num @> 4),
	write('You failed to catch anything!'), nl, !.
getFish(_) :- !.

% addFish(X) is a helper function for getFish(X).
% Basically, it appends the fish to fishes if it isn't there yet,
% else, it just decreases the fish count.
addFish(X) :-
	totalItem(TotalItem),
	InvCheck is TotalItem + 1,
	( InvCheck @> 100 -> (
		write('You caught a fish, but your inventory is full!'), nl,
		write('You are forced to let it out back to the water.'), nl,
		addFishingExp(50), !
	) ; (
		addToInventory(X, 1),
		write('*** You caught a(n) '), write(X), write('!'),  nl,
  	addFishingExp(50), 
		handleFishQuest(1), !
	)).

% showFishes(List, Count) shows the list of fishes that the player have.
showFishes([], 1) :-
	write('You don\'t have any fishes!'), nl.
showFishes([], _) :- !.
showFishes(List, X) :-
	[H|T] = List,
	category(H, Category),
	Category == 'fish',
	invCount(H, FishCount),
	write(X), write('. '), write(FishCount), write(' '), write(H), write('(s).'), nl,
	Y is X + 1,
	showFishes(T, Y).
showFishes(List, X) :-
	[H|T] = List,
	category(H, Category),
	Category \== 'fish',
	showFishes(T, X).
