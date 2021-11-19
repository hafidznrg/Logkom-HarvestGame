% Dev dependencies
% :- include('time.pl').

% Constants
% define playerWorkingLimit(X) as
% "Player can work for X times before they fainted."
playerWorkingLimit(5).
% define specialites(L) as
% "L is the list of available specialites in the game"
specialties([farming, fishing, ranching]).
% define jobs(L) as
% "L is the list of available jobs in the game"
jobs([fisherman, farmer, rancher]).

% define stats(J, L, S, E, G) as
% Player's job is J
% Player's level is L
% Player's specialties are S
% Player's exp is E
% Player's gold is G
:- dynamic(stats/5).

% I.S. stats(J, L, S, E, G) is false for any J, L, S, E, G
% F.S. stats(J, 1, S, 0, 0) is true for input J and specific S
initStats(J) :-
    jobs(JobList),
    newSpecialtiesList(JobList, S),
    asserta(stats(J, 1, S, 0, 0)).

% Constructs a new specialties list consisting of triples
% [specialty, level, exp]
newSpecialtiesList([], []) :- !.
newSpecialtiesList([Job|Tail], Result) :-
    newSpecialtiesList(Tail, Subresult),
    Result = [[Job, 1, 0]|Subresult].

% define limit(X) as
% "player can do X more activities this day before
% they fainted"
:- dynamic(limit/1).

% I.S. limit(X) is false for any X
% F.S. limit(X) is true for playerWorkingLimit(X)
initLimit :-
    playerWorkingLimit(L),
    asserta(limit(L)).

% I.S. limit(X)
% F.S. limit(X - 1) or faint if X = 1
work :-
    limit(Limit),
    NewLimit is Limit - 1,
    (NewLimit is 0 -> faint;
    retract(limit(_)),
    asserta(limit(NewLimit))
    ).

% I.S. limit(1)
% F.S. limit(X) for playerWorkingLimit(X)
faint :-
    retract(limit(_)),
    displayFaintMessage,
    playerWorkingLimit(L),
    asserta(limit(L)).

% I.S. faint called
% F.S. Displayed player faint message
displayFaintMessage :-
    write('You worked too much for today and passed out.'),
    nl,
    playerWorkingLimit(L),
    write('Try not to do more than '),
    write(L),
    write(' activities daily.'),
    nl,
    write('You wake up and it\'s the next day already.'),
    nextDay.

    