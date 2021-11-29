% Prices
price(carrot_seed, 50).
price(corn_seed, 50).
price(tomato_seed, 50).
price(chicken, 500).
price(sheep, 1000).
price(cow, 1500).
price(shovel, 300).       % This is not the real price, instead it's a multiplier.
price(fishing_rod, 500).  % This is not the real price, instead it's a multiplier.
% Selling price
price(carrot, 200).
price(corn, 200).
price(tomato, 200).
price(egg, 200).
price(milk, 400).
price(wool, 300).
price(akame, 200).
price(goldfish, 200).
price(tuna, 250).
price(carp, 300).

% I.S -
% F.S get Elemen in list buy depend on Index
getItemObject(Index, ItemObject) :-
  (Index = 1 -> ItemObject = carrot_seed ;
  Index = 2 -> ItemObject = corn_seed ;
  Index = 3 -> ItemObject = tomato_seed ;
  Index = 4 -> ItemObject = chicken ;
  Index = 5 -> ItemObject = sheep ;
  Index = 6 -> ItemObject = cow ;
  Index = 7 -> ItemObject = shovel ;
  Index = 8 -> ItemObject = fishing_rod ), !.

% I.S -
% F.S show menu buy 
showMenuBuy  :-
  itemLevel(shovel, ShovelLevel),
  itemLevel(fishing_rod, RodLevel),
  price(shovel, ShovelPrice),
  price(fishing_rod, RodPrice),
  ActualShovelPrice is ShovelPrice * ShovelLevel,
  ActualRodPrice is RodPrice * RodLevel,
  SoldShovelLevel is ShovelLevel + 1,
  SoldRodLevel is RodLevel + 1,
  nl,
  write('What do you want to buy?'), nl,
  write('1. Carrot seed (50 golds)'), nl,
  write('2. Corn seed (50 golds)'), nl,
  write('3. Tomato seed (50 golds)'), nl,
  write('4. Chicken (500 golds)'), nl,
  write('5. Sheep (1000 golds)'), nl,
  write('6. Cow (1500 golds)'), nl, 
  write('7. Level '), write(SoldShovelLevel), write(' shovel ('), (ShovelLevel = 0 -> write(150); write(ActualShovelPrice)), write(' golds)'), nl,
  write('8. Level '), write(SoldRodLevel), write(' fishing rod ('), (RodLevel = 0 -> write(150); write(ActualRodPrice)), write(' golds)'), nl, !.

% I.S don't have sellable item
% F.S display eror message 
showSellableItemsHelper([], 1) :-
  write('You don\'t have any sellable goods!'), nl.

% I.S -
% F.S show sellable item
showSellableItemsHelper([], _) :- !.
showSellableItemsHelper(List, X) :-
  [H|T] = List,
  category(H, Category),
  (Category == 'loot'; Category == 'fish'),
  invCount(H, ItemCount),
  itemName(H, ItemName),
  write('-'), write('  '), write(ItemCount), write(' '), write(ItemName), write('(s)'), nl,
  Y is X + 1,
  showSellableItemsHelper(T, Y).
showSellableItemsHelper(List, X) :-
  [_|T] = List,
  showSellableItemsHelper(T, X).

showSellableItems :-
  write('Here are the sellable items in your inventory: '), nl,
  inv(Inventory),
  showSellableItemsHelper(Inventory, 1), !.

%  I.S -
%  F.S handle mechanism market
handleMarket :-
  repeat,
  nl, write('What do you want to do?'), nl,
  write('1. Buy'), nl,
  write('2. Sell'), nl, nl,
  write('> '),
  read(Option),
  ((Option == 'buy'; Option == 'sell') -> !, showMenuMarket(Option) ;
  write('Invalid choice'), nl, fail), !.

showCharged(Price) :-
  write('You have been charged '), write(Price), write(' golds.'), nl, !.

% I.S option buy
% F.S show menu market buy
showMenuMarket(buy) :-
  showMenuBuy, nl,
  write('> '),
  read(Option),
  getItemObject(Option, ItemObject),
  category(ItemObject, Category),
  (Category == 'seed' -> handleBuySeed(ItemObject) ;
  Category == 'animal' ->  handleBuyAnimal(ItemObject) ;
  Category == 'tool' -> handleBuyTool(ItemObject)), !.

% I.S option sell
% F.S show menu market sell
showMenuMarket(sell) :-
  showSellableItems,
  write('What do you want to sell?'), nl,
  nl,
  write('> '),
  read(Option),
  invCount(Option, ItemCount),
  category(Option, ItemCategory),
  (ItemCategory == 'fish' ; ItemCategory == 'loot'),
  ItemCount > 0,
  nl,
  write('How many do you want to sell?'), nl,
  nl,
  write('> '),
  read(Amount),
  handleSell(Option, Amount), !.

% -
% handle item sell
handleSell(ItemObject, Amount) :-
  itemName(ItemObject, ItemName),
  invCount(ItemObject, ItemCount),
  price(ItemObject, ItemPrice),
  (Amount @=< ItemCount -> (
    GoldIncrement is ItemPrice * Amount,
    removeFromInventory(ItemObject, Amount),
    write('You sold '), write(Amount), write(' '), write(ItemName), write('(s).'), nl,
    write('You received '), write(GoldIncrement), write(' golds.'), nl,
    addGold(GoldIncrement)
  ) ; (
    write('You don\'t have that much! Cancelling ...'), nl
  )), !.

% I.S -
% F.S handle buy seed
handleBuySeed(ItemObject) :-
  price(ItemObject, ItemPrice),
  totalItem(TotalItem),
  nl, write('How many do you want to buy?'), nl,
  write('> '),
  read(ItemCount),
  InvCheck is TotalItem + ItemCount,
  ( InvCheck @> 100 -> (
    write('Not enough capacity at your inventory!'), nl, !
  ) ; (
    AccPrice is ItemPrice * ItemCount,
    stats(_, _, _, _, G),
    (AccPrice > G -> (
      write('You don\'t have enough gold!'), nl
    ) ; (
      addToInventory(ItemObject, ItemCount),
      increaseSeed(ItemObject, ItemCount),
      showCharged(AccPrice),
      reduceGold(AccPrice)
    )), !
  )).
  

% I.S -
% F.S handle buy animal
handleBuyAnimal(ItemObject) :-
  price(ItemObject, ItemPrice),
  nl, write('How many do you want to buy?'), nl,
  write('> '),
  read(ItemCount),
  AccPrice is ItemPrice * ItemCount,
  stats(_, _, _, _, G),
  (AccPrice > G -> (
    write('You don\'t have enough gold!'), nl
  ) ; (
    increaseAnimal(ItemObject, ItemCount),
    write('*** You have bought '), write(ItemCount), write(' '), write(ItemObject), (ItemCount > 1, write('s.'); write('.')), nl,
    showCharged(AccPrice),
    reduceGold(AccPrice)
  )), !.

% I.S -
% I.S handle buy tool like shovel and fishing rod
handleBuyTool(ItemObject) :-
  price(ItemObject, ItemPrice),
  itemLevel(ItemObject, ItemLevel),
  (ItemLevel == 0 -> ActualPrice is 150 ; ActualPrice is ItemPrice * ItemLevel),
  stats(_, _, _, _, G),
  (ActualPrice > G -> (
    write('You don\'t have enough gold!'), nl
  ) ; (
    upgradeItemLevel(ItemObject),
    showCharged(ActualPrice),
    reduceGold(ActualPrice)
  )), !.