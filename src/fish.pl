% Dev dependencies
:- include('time.pl').
:- include('player.pl').

% List of fishes
:- dynamic(fishes/1).
% count(X, Y) means there are Y X's.
:- dynamic(count/2).

% Define what the valid fishes are.
fish([akame, goldfish, tuna, carp]).

% At the start of the game, the player doesn't have a fish yet.
fishes([]).
count(akame, 0).
count(goldfish, 0).
count(tuna, 0).
count(carp, 0).

% Handle fish!
% I.S. The player has a list of fishes
% F.S. The list of fishes will be updated based on what the character fished.
handleFish :-
	random(1, 20, X),
	getFish(X),
	fishes(FishList),
	write('=============================================='), nl,
	write('These are the fishes that you currently have: '), nl,
	showFishes(FishList, 1), 
	write('=============================================='), nl, !.

% getFish(X) will add different values to the list of fishes based on X.
% X = 1 -> akame
% X = 2 -> goldfish
% X = 3 -> tuna
% X = 4 -> carp
% Other than that, the player catches nothing.
getFish(1) :-
	addFish(akame).

getFish(2) :-
	addFish(goldfish).

getFish(3) :-
	addFish(tuna).

getFish(4) :-
	addFish(carp).

getFish(_) :-
		write('You failed to catch anything!'), nl, !.

% addFish(X) is a helper function for getFish(X).
% Basically, it appends the fish to fishes if it isn't there yet,
% else, it just decreases the fish count.
addFish(X) :-
	fishes(FishList),
	member(X, FishList),
	count(X, FishCount),
	NewFishCount is FishCount + 1,
	retract(count(X, _)),
	assertz(count(X, NewFishCount)),
	write('*** You caught a(n) '), write(X), write('!'), nl.
addFish(X) :-
	fishes(FishList),
	append(FishList, [X], NewFishList),
	retract(count(X, _)),
	assertz(count(X, 1)),
	retract(fishes(_)),
	assertz(fishes(NewFishList)),
	write('*** You caught a(n) '), write(X), write('!'), nl.

% showFishes(List, Count) shows the list of fishes that the player have.
showFishes([], 1) :-
	write('You don\'t have any fishes!'), nl.
showFishes([], _) :- !.
showFishes(List, X) :-
	[H|T] = List,
	count(H, FishCount),
	write(X), write('. '), write(FishCount), write(' '), write(H), write('(s).'), nl,
	Y is X + 1,
	showFishes(T, Y).

% === TO DO ===
% Integrate it with player, i.e. add bonuses if the player is a fisher, XP stuffs, and more.