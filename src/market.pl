
buyItem([tomato_seed, carrot_seed, corn_seed, potato_seed, chicken, sheep, cow, level_2_shovel, level_2_fishing_rod, level_3_shovel, level_3_fishing_rod]).
item([level_2_shovel, level_2_fishing_rod, level_3_shovel, level_3_fishing_rod]).
%  buy
price(tomato_seed, 50).
price(carrot_seed, 50).
price(corn_seed, 50).
price(potato_seed, 50).
price(chicken, 500).
price(sheep, 1000).
price(cow, 1500).
price(level_2_shovel, 300).
price(level_2_fishing_rod, 500).
price(tomato, 50).
price(carrot, 50).
price(corn, 50).
price(potato, 50).
price(egg, 500).
price(milk, 1000).
price(wool, 1500).

% sell
sell([tomato, caroot, corn, potato, egg, milk, wool]).

initItem([]).
initItem([Head|Tail]) :-
    assertz(count(Head,0)),
    initPlant(Tail).

showMenuBuy :-
    nl,
    write(' What do you want to buy?'), nl,nl,
    write(' 1. Carrot seed (50 golds)'), nl,
    write(' 2. Corn seed (50 golds)'), nl,
    write(' 3. Tomato seed (50 golds)'), nl,
    write(' 4. Potato seed (50 golds)'), nl,
    write(' 5. Chicken (500 golds)'), nl,
    write(' 6. Sheep (1000 golds)'), nl,
    write(' 7. Cow (1500 golds)'), nl,!.
    % ganti
    % write(' 8. Level 2 shovel (300 golds)'), nl,
    % write(' 9. Level 2 fishing rod (500 golds)'), nl,!.

% showMenuSell :-

handleMarket :-
    write(' What do you want to do?'), nl,nl,
    write(' 1. buy'),nl,
    write(' 2. sell'),nl,
    read(Option),
    showMenuMarket(Option), !.

showMenuMarket(buy) :-
    showMenuBuy,
    buyItem(BuyItem),
    read(Option),
    getElem(BuyItem, Option, Y),
    price(Y, Price),
    write(' How many do you want to buy?'),nl,
    read(Sum),
    write(Sum), write('harga/satuan: ') ,write(Price),nl,
    Price2 is Sum*Price,
    write(Price2),nl,
    stats(_, _, _, _, G),
    (Price2 > G -> write('Not enough gold'),nl;
    Option = 1 -> increaseSeed(carrot_seed, Sum), reduceGold(Price2);
    Option = 2 -> increaseSeed(corn_seed, Sum), reduceGold(Price2);
    Option = 3 -> increaseSeed(tomato_seed, Sum), reduceGold(Price2);
    Option = 4 -> increaseSeed(potato_seed, Sum), reduceGold(Price2);
    Option = 5 -> increaseAnimal(chicken, Sum), reduceGold(Price2);
    Option = 6 -> increaseAnimal(sheep, Sum), reduceGold(Price2);
    Option = 7 -> increaseAnimal(cow, Sum), reduceGold(Price2);
    count(Y, Sum0),
    Sum1 is Sum + Sum0,
    retract(count(Y, Sum0)),
    asserta(count(Y, Sum1)),
    reduceGold(Price2)), !.
    % G1 is G - Price2, !.

showMenuMarket(sell) :-
    showInventory,
    write('What do you want to sell?'), nl,
    read(Option),
    inventory(Inventory),
    getElem(Inventory, Option, Item),
    ('How many do you want to sell? '),
    read(Sell),
    count(Item, Y),
    (Sell > Y -> write('not enough item, canceling...'),nl; 
    Y1 is Y - Sell,
    retract(count(Item, Y)),
    asserta(count(Item, Y1)),
    price(Item, X),
    Price2 is X*Sell,
    addGold(Price2)), !.

%   startGame. start. 1.