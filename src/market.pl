
buy([tomatoo_seed, carrot_seed, corn_seed, tomatoo_seed, potato_seed, chicken, shepp, cow, level_2_shovel, level_2_fishing_rod]).

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
sell([tomatoo, caroot, corn, potato, egg, milk, wool]).

showMenuMarket :-
    write(' what do you wan\'t to buy?'), nl,nl,
    write('   1. Carrot seed (50 golds)'), nl,
    write('   2. Corn seed (50 golds)'), nl,
    write('   3. Tomato seed (50 golds)'), nl,
    write('   4. Potato seed (50 golds)'), nl,
    write('   5. Chicken (500 golds)'), nl,
    write('   6. Sheep (1000 golds)'), nl,
    write('   7. Cow (1500 golds)'), nl,
    write('   8. Level 2 shovel (300 golds)'), nl,
    write('   9. Level 2 fishing rod (500 golds)'), nl,!.
