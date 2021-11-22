% :- include('player.pl').

:- dynamic(onQuest/1).
:- dynamic(quest/3).

onQuest(false).

handleQuest :-
    onQuest(true),
    write('You have an on-going Quest!'), nl, !.
%                                               ^^ tadi ada underscore
% heh maap
handleQuest :-
    onQuest(false),
    stats(_,L,_,_,_),
    Base is L+3,
    Max is Base+6,
    random(Base,Max,Num1),
    random(Base,Max,Num2),
    random(Base,Max,Num3),
    assertz(quest(Num1,Num2,Num3)),
    write('You got a new Quest!'), nl, nl,
    write('You need to collect:'), nl,
    write(' - '), write(Num1), write(' harvest item'), nl,
    write(' - '), write(Num2), write(' fish'), nl,
    write(' - '), write(Num3), write(' ranch item'), nl, !.


checkQuest :-
    quest(X,Y,Z),
    (X < 0, Y < 0, Z < 0,
    write('Congratulations you have finished your quest'), nl,
    retract(quest(X,Y,Z)); nl). 


%  quest.pl:10:48: syntax error: . or operator expected after expression
% harusnya udah bener ini ^^^
% coba lagi ok aman tapi karena nginclude player jadi nginclude double
% kalo mo jalanin dari file lain dev dependenciesnya dijadiin komen dulu