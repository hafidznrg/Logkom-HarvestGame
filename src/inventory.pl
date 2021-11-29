% Dev dependencies
% :- include('time.pl').
% :- include('player.pl').

% Inventory list
:- dynamic(inv/1).
% invCount(X, Y) means there are Y X's.
% invCount(_, _)
:- dynamic(invCount/2).
% itemLevel(X, Y) means that X is at level Y.
:- dynamic(itemLevel/2).

% At first, the inventory has a level 1 fishing rod and a level 1 shovel.
% inv([shovel, fishing_rod]).
% itemLevel(shovel, 1).
% itemLevel(fishing_rod, 1).
% invCount(shovel, 1).
% invCount(fishing_rod, 1).

upgradeItemLevel(Item) :-
  itemLevel(Item, ItemLevel),
  NewItemLevel is ItemLevel + 1,
  retract(itemLevel(Item, _)),
  assertz(itemLevel(Item, NewItemLevel)),
  itemName(Item, ItemName),
  write('*** Upgraded '), write(ItemName), write(' to level '), write(NewItemLevel), write('!'), nl, !.

% Specify names for item variables (to show when printing)
itemName(carrot_seed, 'carrot seed').
itemName(corn_seed, 'corn seed').
itemName(tomato_seed, 'tomato seed').
itemName(shovel, 'shovel').
itemName(fishing_rod, 'fishing rod').
itemName(corn, 'corn').
itemName(carrot, 'carrot').
itemName(tomato, 'tomato').
itemName(egg, 'egg').
itemName(milk, 'milk').
itemName(wool, 'wool').
itemName(akame, 'akame').
itemName(goldfish, 'goldfish').
itemName(tuna, 'tuna').
itemName(carp, 'carp').

% Seed adalah yang berhubungan dengan farming
category(carrot_seed, 'seed').
category(corn_seed, 'seed').
category(tomato_seed, 'seed').
% Animal adalah yang berhubungan dengan ranch
category(chicken, 'animal').
category(sheep, 'animal').
category(cow, 'animal').
% Tool adalah peralatan yang bisa diupgrade
category(shovel, 'tool').
category(fishing_rod, 'tool').
% Loot adalah item yang bisa dijual
category(corn, 'loot').
category(carrot, 'loot').
category(tomato, 'loot').
category(egg, 'loot').
category(milk, 'loot').
category(wool, 'loot').
% Fish adalah item hasil pancingan, bisa dijual juga
category(akame, 'fish').
category(goldfish, 'fish').
category(tuna, 'fish').
category(carp, 'fish').

% addToInventory(Item, Count) adds 'Count' item(s) to the inventory.
addToInventory(Item, Count) :-
  inv(Inv),
  member(Item, Inv),
  invCount(Item, InvCount),
  NewInvCount is InvCount + Count,
  retract(invCount(Item, _)),
  assertz(invCount(Item, NewInvCount)),
  itemName(Item, ItemName),
  write('*** Added '), write(Count), write(' '), write(ItemName), write('(s) to the inventory!'), nl, !.
addToInventory(Item, Count) :-
  inv(Inv),
  append(Inv, [Item], NewInv),
  assertz(invCount(Item, Count)),
  retract(inv(_)),
  assertz(inv(NewInv)),
  itemName(Item, ItemName),
  write('*** Added '), write(Count), write(' '), write(ItemName), write('(s) to the inventory!'), nl, !.

% showInventory shows the player's inventory.
showInventory :-
  inv(Inv),
  write('=============================================='), nl,
	write('These are the contents of your inventory: '), nl,
	showInvHelper(Inv, 1), 
	write('=============================================='), nl, !.

showInvHelper([], 1) :-
	write('You don\'t have any items!'), nl.
showInvHelper([], _) :- !.
showInvHelper(List, X) :-
	[H|T] = List,
  itemLevel(H, ItemLevel),
	invCount(H, InvCount),
  itemName(H, ItemName),
	write(X), write('. '), write(InvCount), write(' level '), write(ItemLevel), write(' '), write(ItemName), write('.'), nl,
	Y is X + 1,
	showInvHelper(T, Y).
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
  inv(Inv),
  invCount(Item, Count),
  retract(invCount(Item, _)),
  removeX(Inv, Item, NewInv),
  itemName(Item, ItemName),
  retract(inv(_)),
  assertz(inv(NewInv)),
  write('*** You have removed '), write(Count), write(' '), write(ItemName), write('(s) from your inventory!'), nl, !.
% If Count < item's count, it will only decrease the count.
removeFromInventory(Item, Count) :-
  invCount(Item, ItemCount),
  Count < ItemCount,
  NewCount is ItemCount - Count,
  itemName(Item, ItemName),
  retract(invCount(Item, _)),
  assertz(invCount(Item, NewCount)),
  write('*** You have removed '), write(Count), write(' '), write(ItemName), write('(s) from your inventory!'), nl, !.
% If both condition does not match, then the operation is valid.
removeFromInventory(Item, _) :-
  itemName(Item, ItemName),
  write('You don\'t have enough '), write(ItemName), write('s.'), nl, !.

throwItem :-
  gameStarted,
  showInventory, nl, nl,
  write('What do you want to throw?'), nl,
  write('> '),
  read(ItemObject),
  handleThrow(ItemObject).
handleThrow(ItemObject) :-
  category(ItemObject, ItemCategory),
  (ItemCategory == 'tool' ; ItemCategory == 'animal'),
  nl, write('You can\'t throw away this item! Cancelling ...'), nl, !.
handleThrow(ItemObject) :-
  invCount(ItemObject, ItemCount),
  ItemCount @> 0,
  category(ItemObject, ItemCategory),
  ItemCategory \== 'seed',
  itemName(ItemObject, ItemName),
  nl, write('You have '), write(ItemCount), write(' '), write(ItemName), write('. How many do you want to throw?'), nl,
  write('> '),
  read(Amount),
  nl, removeFromInventory(ItemObject, Amount), !.
handleThrow(ItemObject) :-
  invCount(ItemObject, ItemCount),
  ItemCount @> 0,
  category(ItemObject, ItemCategory),
  ItemCategory == 'seed',
  itemName(ItemObject, ItemName),
  nl, write('You have '), write(ItemCount), write(' '), write(ItemName), write('. How many do you want to throw?'), nl,
  write('> '),
  read(Amount),
  nl, removeFromInventory(ItemObject, Amount), 
  count(ItemObject, Count),
  Counta is Count - 1,
  retract(count(ItemObject, Count)),
  assertz(count(ItemObject, Counta)), 
  !.
