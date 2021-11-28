% Prices
price(carrot_seed, 50).
price(corn_seed, 50).
price(tomato_seed, 50).
price(potato_seed, 50).
price(chicken, 500).
price(sheep, 1000).
price(cow, 1500).
price(shovel, 300).       % This is not the real price, instead it's a multiplier.
price(fishing_rod, 500).  % This is not the real price, instead it's a multiplier.

% Seed adalah yang berhubungan dengan farming
category(carrot_seed, 'seed').
category(corn_seed, 'seed').
category(tomato_seed, 'seed').
category(potato_seed, 'seed').
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
category(potato, 'loot').
category(egg, 'loot').
category(milk, 'loot').
category(wool, 'loot').

getItemObject(Index, ItemObject) :-
  (Index = 1 -> ItemObject = carrot_seed ;
  Index = 2 -> ItemObject = corn_seed ;
  Index = 3 -> ItemObject = tomato_seed ;
  Index = 4 -> ItemObject = potato_seed ;
  Index = 5 -> ItemObject = chicken ;
  Index = 6 -> ItemObject = sheep ;
  Index = 7 -> ItemObject = cow ;
  Index = 8 -> ItemObject = shovel ;
  Index = 9 -> ItemObject = fishing_rod ), !.

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
  write('4. Potato seed (50 golds)'), nl,
  write('5. Chicken (500 golds)'), nl,
  write('6. Sheep (1000 golds)'), nl,
  write('7. Cow (1500 golds)'), nl, 
  write('8. Level '), write(SoldShovelLevel), write(' shovel ('), write(ActualShovelPrice), write(' golds)'), nl,
  write('9. Level '), write(SoldRodLevel), write(' fishing rod ('), write(ActualRodPrice), write(' golds)'), nl, !.

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

showMenuMarket(buy) :-
  showMenuBuy, nl,
  write('> '),
  read(Option),
  getItemObject(Option, ItemObject),
  category(ItemObject, Category),
  (Category == 'seed' -> handleBuySeed(ItemObject) ;
  Category == 'animal' ->  handleBuyAnimal(ItemObject) ;
  Category == 'tool' -> handleBuyTool(ItemObject)), !.

showMenuMarket(sell) :-
  write('> TO-DO!'), nl, !.

handleBuySeed(ItemObject) :-
  price(ItemObject, ItemPrice),
  nl, write('How many do you want to buy?'), nl,
  write('> '),
  read(ItemCount),
  AccPrice is ItemPrice * ItemCount,
  stats(_, _, _, _, G),
  (AccPrice > G -> (
    write('You don\'t have enough gold!'), nl
  ) ; (
    addToInventory(ItemObject, ItemCount),
    increaseSeed(ItemObject, ItemCount),
    showCharged(AccPrice),
    reduceGold(AccPrice)
  )), !.

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

handleBuyTool(ItemObject) :-
  price(ItemObject, ItemPrice),
  itemLevel(ItemObject, ItemLevel),
  ActualPrice is ItemPrice * ItemLevel,
  stats(_, _, _, _, G),
  (ActualPrice > G -> (
    write('You don\'t have enough gold!'), nl
  ) ; (
    upgradeItemLevel(ItemObject),
    showCharged(ActualPrice),
    reduceGold(ActualPrice)
  )), !.