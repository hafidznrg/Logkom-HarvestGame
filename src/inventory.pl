% Dev dependencies
% :- include('time.pl').
% :- include('player.pl').

% Inventory list
:- dynamic(inventory/1).
% invCount(X, Y) means there are Y X's.
% invCount(_, _)
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

% Helper function for removeFromInventory
% removeX(List, X, Res)
removeX([], _, []).
removeX([X|T], X, T). 
removeX([H|T], X, [H|Y]) :-
  H \== X,
  removeX(T, X, Y).

% removeFromInventory(Item, Count) removes Item by Count.
% If the item's count is exactly like Count, it will be removed from the list.
removeFromInventory(Item, Count) :-
  inventory(Inv),
  invCount(Item, Count),
  retract(invCount(Item, _)),
  removeX(Inv, Item, NewInv),
  itemName(Item, ItemName),
  retract(inventory(_)),
  assertz(inventory(NewInv)),
  write('You have removed '), write(Count), write(' '), write(ItemName), write('(s) from your inventory!'), nl, !.
% If Count < item's count, it will only decrease the count.
removeFromInventory(Item, Count) :-
  invCount(Item, ItemCount),
  Count < ItemCount,
  NewCount is ItemCount - Count,
  itemName(Item, ItemName),
  retract(invCount(Item, _)),
  assertz(invCount(Item, NewCount)),
  write('You have removed '), write(Count), write(' '), write(ItemName), write('(s) from your inventory!'), nl, !.
% If both condition does not match, then the operation is valid.
removeFromInventory(Item, _) :-
  itemName(Item, ItemName),
  write('You don\'t have enough '), write(ItemName), write('s.'), nl, !.