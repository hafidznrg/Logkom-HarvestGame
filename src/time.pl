% Dev dependencies
% :- include('utils.pl').

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
    displayDayMessage,
    (NextDay is 366 -> lose; !).

% I.S. nextDay called
% F.S. Displayed day message to the console.
displayDayMessage :-
    typewrite('~~~~~~~~~~~~~~~~~~~~~~~~~', 0.025),
    nl,
    day(D),
    toString(D, Day),
    atom_concat('Day ', Day, Msg),
    typewrite(Msg, 0.5),
    nl,
    typewrite('~~~~~~~~~~~~~~~~~~~~~~~~~', 0.025),
    nl
    .

% I.S. stats(_, _, _, _, G) for G >= 20000.
% F.S. Player win the game.
win :-
    typewrite('It was a long,', 0.025),
    sleep(0.8),
    write(' '),
    typewrite('long', 0.4),
    sleep(0.6),
    typewrite(' journey.', 0.025),
    sleep(1.2),
    nl,
    typewrite('Nonetheless,', 0.04),
    sleep(0.6),
    typewrite(' you managed to find your way through.', 0.025),
    sleep(1.2),
    nl,
    nl,
    stats(J, _, _, _, G),
    day(D),
    toString(D, Day),
    toString(G, Gold),
    typewrite('Congratulations, ', 0.03),
    sleep(0.5),
    typewrite(J, 0.025),
    typewrite('. ', 0.025),
    sleep(0.5),
    typewrite('You have successfully accumulated ', 0.025),
    typewrite(Gold, 0.025),
    typewrite(' gold in ', 0.025),
    typewrite(Day, 0.025),
    typewrite(' days.', 0.025),
    sleep(1.2),
    nl,
    typewrite('It is the end', 0.03),
    sleep(0.6),
    typewrite(' for now.', 0.03),
    sleep(1),
    write(' '),
    typewrite('However', 0.4),
    sleep(0.6),
    typewrite('...', 0.8),
    nl,
    sleep(1.2),
    typewrite('More journey awaits you out there.', 0.025),
    sleep(1.2),
    nl,
    nl,
    typewrite('Sadly, ', 0.3),
    sleep(0.6),
    typewrite('this is the last of our meeting.', 0.025),
    sleep(0.6),
    typewrite(' Take care.', 0.04),
    sleep(1.2),
    nl,
    nl,
    typewrite('Until then, ', 0.3),
    typewrite(J, 0.025),
    typewrite('.', 0.5),
    sleep(1.2),
    nl,
    nl,
    typewrite('Goodbye :)', 0.025),
    sleep(3),
    halt.

% I.S. day(366)
% F.S. Player loses the game.
lose :-
    write('You have worked hard, but in the end result is all that matters'),
    nl,
    write('May God bless you in the future with kind people!'),
    nl.