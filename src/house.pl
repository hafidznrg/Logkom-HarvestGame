% Dev dependencies
% :- include('time.pl').
% :- include('list_utils.pl').

:- dynamic(diaryEntries/1).

% I.S. diaryEntries(X) is false for any X
% F.S. diaryEntries(X) is true for some X, i.e.
%      the diaryEntries is initialized
initDiaryEntries :-
    asserta(diaryEntries([])).

% All house activities
house :-
    gameStarted,
    tile(X, Y, 'P'),
    tile(X, Y, 'H'),
    write('What do you want to do ?\n'),
    write('- sleep\n'),
    write('- writeDiary\n'),
    write('- readDiary\n'),
    write('- exit\n\n'),
    write('>>> '),
    readLine(Cmd),
    nl,
    (
        (Cmd = 'sleep', sleepHandler, !);
        (Cmd = 'readDiary', readDiaryHandler, !);
        (Cmd = 'writeDiary', writeDiaryHandler, !);
        (Cmd = 'exit', !);
        house
    ).
house :-
    gameStarted,
    write('You are not currently in your house!'),
    !.

% I.S. day(D)
% F.S. day(D + 1)
sleepHandler :-
    write('You went to sleep.\n\n'),
    nextDay,
    day(D),
    write('Day '),
    write(D),
    nl.
% TODO: Display weather mechanism message

% I.S. Diary entries may be empty
% F.S. Added an entry to diary entries 
writeDiaryHandler :-
    day(Day),
    write('Write your diary for Day '),
    write(Day),
    nl,
    write('>>> '),
    readLine(Writing),
    Entry = [Day, Writing],
    pushDiaryEntry(Entry),
    write('Day '),
    write(Day),
    write(' entry saved.'),
    save.
% readLine func dari gprolog?
% I.S. Any
% F.S. Displayed diary entry at some day
readDiaryHandler :-
    diaryEntries(Entries),
    (
        empty(Entries) -> write('You haven\'t written any diary yet.');
        displayDiaryEntries(Entries),
        read_integer(Day),
        (
            validDiaryDay(Entries, Day)
                -> showDiaryEntry(Entries, Day);
            write('Invalid day !')
        )
    ).

% I.S. readDiaryHandler called
% F.S. Displayed all available entry days
displayDiaryEntries([]) :- !.
displayDiaryEntries([Entry|SubEntries]) :-
    [Day, _] = Entry,
    write('- Day '),
    write(Day),
    nl,
    displayDiaryEntries(SubEntries).

% define validDiaryDay(Entries, Day) as
% "An entry at day Day exists in diary entries Entries."
validDiaryDay(Entries, Day) :-
    Entries = [] -> (!, fail);
    Entries = [Head|Tail],
    (
        Head = [Day, _];
        validDiaryDay(Tail, Day)
    ).
    
% I.S. readDiaryHandler called
% F.S. Displayed diary entry at day Day
showDiaryEntry(Entries, Day) :-
    Entries = [Entry|SubEntries],
    (
        Entry = [Day, Writing]
            -> write(Writing);
        showDiaryEntry(SubEntries, Day)
    ).

% I.S. Diary entries may contain some entries
% F.S. Diary entries is appended by 1 entry
pushDiaryEntry(Entry) :-
    diaryEntries(Entries),
    push(Entries, Entry, NewEntries),
    retract(diaryEntries(_)),
    asserta(diaryEntries(NewEntries)).

% I.S. writeDiaryHandler called
% F.S. Saved current state
save :-
    day(DayInt),
    toString(DayInt, Day),
    atom_concat('save_data/', Day, Base),
    atom_concat(Base, '.pl', Filename),
    open(Filename, write, Stream),

    diaryEntries(Entries),
    writeSaveData(Stream, diaryEntries(Entries)),
    
    saveLastHarvestSeed(Stream),

    saveCount(Stream),

    saveSeed(Stream),
    
    saveSeedTile(Stream),

    saveInvCount(Stream),
    
    saveTile(Stream),

    fishes(I),
    writeSaveData(Stream, fishes(I)),

    inventory(J),
    writeSaveData(Stream, inventory(J)),

    map_size(Width, Height),
    writeSaveData(Stream, map_size(Width, Height)),

    stats(Job, Level, Exp, Specialties, Gold),
    writeSaveData(Stream, stats(Job, Level, Exp, Specialties, Gold)),

    limit(Limit),
    writeSaveData(Stream, limit(Limit)),

    onQuest(T),
    writeSaveData(Stream, onQuest(T)),

    saveQuest(Stream),

    saveLastHarvest(Stream),

    ternak(R),
    writeSaveData(Stream, ternak(R)),

    writeSaveData(Stream, day(DayInt)),

    close(Stream), !.
save :- !.

saveCount(Stream) :-
    current_predicate(count/2),
    count(C, D),
    writeSaveDataLoop(Stream, count(C, D)).
saveCount(_) :- !.

saveSeed(Stream) :-
    current_predicate(seed/1),
    seed(E),
    writeSaveDataLoop(Stream, seed(E)).
saveSeed(_) :- !.

saveSeedTile(Stream) :-
    current_predicate(seedTile/3),
    seedTile(F, G, H),
    writeSaveDataLoop(Stream, seedTile(F, G, H)).
saveSeedTile(_) :- !.

saveInvCount(Stream) :-
    current_predicate(invCount/2),
    invCount(K, L),
    writeSaveDataLoop(Stream, invCount(K, L)).
saveInvCount(_) :- !.

saveTile(Stream) :-
    current_predicate(tile/3),
    tile(X, Y, Z),
    writeSaveDataLoop(Stream, tile(X, Y, Z)).
saveTile(_) :- !.

saveLastHarvest(Stream) :-
    current_predicate(lastHarvest/2),
    lastHarvest(P, Q),
    writeSaveDataLoop(Stream, lastHarvest(P, Q)).
saveLastHarvest(_) :- !.

saveLastHarvestSeed(Stream) :-
    current_predicate(lastHarvestSeed/2),
    lastHarvestSeed(A, B),
    writeSaveDataLoop(Stream, lastHarvestSeed(A, B)).
saveLastHarvestSeed(_) :- !.

saveQuest(Stream) :-
    current_predicate(quest/3),
    quest(M, N, O),
    writeSaveData(Stream, quest(M, N, O)).
saveQuest(_) :- !.

writeSaveDataLoop(Stream, Term) :-
    write_term(Stream, Term, [quoted(true)]),
    write(Stream, '.\n'),
    fail.

    

writeSaveData(Stream, Term) :-
    write_term(Stream, Term, [quoted(true)]),
    write(Stream, '.\n').

load :-
    consult('save_data/1.pl').


% :- dynamic(count/2).
% :- dynamic(seed/1).
% :- dynamic(seedTile/3).
% :- dynamic(fishes/1).
% :- dynamic(diaryEntries/1).
% :- dynamic(inventory/1).
% :- dynamic(invCount/2).
% :- dynamic(gameStarted/0).
% :- dynamic(gameLoaded/0).
% :- dynamic(tile/3).
% :- dynamic(map_size/2).
% :- dynamic(stats/5).
% :- dynamic(limit/1).
% :- dynamic(onQuest/1).
% :- dynamic(quest/3).
% :- dynamic(lastHarvest/2).
% :- dynamic(ternak/1).
% :- dynamic(day/1).
