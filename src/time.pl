% define day(D) as
% "This day is the D'th day of the game."
:- dynamic(day/1).

% Day initialization
day(1).
% ? Uncomment these lines if needed
% initDay :-
%     asserta(day(1)).

% I.S. day(D) for some D
% F.S. day(D + 1)
nextDay :-
    retract(day(Day)),
    NextDay is Day + 1,
    asserta(day(NextDay)),
    (Day is 366 -> lose; !).

% I.S. day(366)
% F.S. Player loses the game.
lose :-
    write('You have worked hard, but in the end result is all that matters'),
    nl,
    write('May God bless you in the future with kind people!').