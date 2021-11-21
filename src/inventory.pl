% Dev dependencies
:- include('time.pl').
:- include('player.pl').

% Inventory list
:- dynamic(inventory/1).
% invCount(X, Y) means there are Y X's.
:- dynamic(invCount/2).

% Specify names for item variables (to show when printing)
itemName(corn_seed, 'corn seed').
itemName(shovel, 'shovel').
itemName(watering_can, 'watering can').

% At first, the inventory is an empty list.
inventory([]).

% addToInventory(Item) adds an item to the inventory.
addToInventory(Item) :-
  inventory(Inv),
  member(Item, Inv),
  invCount(Item, InvCount),
  NewInvCount is InvCount + 1,
  retract(invCount(Item, _)),
  assertz(invCount(Item, NewInvCount)),
  itemName(Item, ItemName),
  write('*** Added '), write(ItemName), write(' to the inventory!'), nl, !.
addToInventory(Item) :-
  inventory(Inv),
  append(Inv, [Item], NewInv),
  assertz(invCount(Item, 1)),
  retract(inventory(_)),
  assertz(inventory(NewInv)),
  itemName(Item, ItemName),
  write('*** Added '), write(ItemName), write(' to the inventory!'), nl, !.

% showInventory shows the player's inventory.
showInventory :-
  inventory(Inv),
  write('=============================================='), nl,
	write('These are the contents of your inventory: '), nl,
	showInvHelper(Inv, 1), 
	write('=============================================='), nl, !.

showInvHelper([], 1) :-
	write('You don\'t have any items!'), nl.
showInvHelper([], _) :- !.
showInvHelper(List, X) :-
	[H|T] = List,
	invCount(H, InvCount),
  itemName(H, ItemName),
	write(X), write('. '), write(InvCount), write(' '), write(ItemName), write('(s).'), nl,
	Y is X + 1,
	showInvHelper(T, Y).

% === TO DO ===
% Add functionality to remove items from the list.