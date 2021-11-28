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
    write('- write [diary]\n'),
    write('- read [diary]\n'),
    write('- exit\n\n'),
    repeat,
    write('>>> '),
    readLine(Cmd),
    nl,
    (
        (Cmd = 'sleep', sleepHandler, !);
        (Cmd = 'read', readDiaryHandler, !);
        (Cmd = 'read diary', readDiaryHandler, !);
        (Cmd = 'write', writeDiaryHandler, !);
        (Cmd = 'write diary', writeDiaryHandler, !);
        (Cmd = 'exit', !);
        write('Invalid choice !')
    )
    .
house :-
    gameStarted,
    write('You are not currently in your house!'),
    !.

% I.S. day(D)
% F.S. day(D + 1)
sleepHandler :-
    write('You went to sleep.\n\n'),
    nextDay,
    retract(limit(_)),
    playerWorkingLimit(L),
    asserta(limit(L)),
    nl.

% I.S. Diary entries may be empty
% F.S. Added an entry to diary entries
writeDiaryHandler :-
    day(Day),
    diaryEntries(Entries),
    hasWriteDiary(Entries, Day),
    write('You have written your diary for today!'),
    !.
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
    save,
    !.

% I.S. Any
% F.S. Displayed diary entry at some day
readDiaryHandler :-
    diaryEntries(Entries),
    (
        empty(Entries) -> write('You haven\'t written any diary yet.');
        write('Which diary entry do you wish to read ?'),
        nl,
        displayDiaryEntries(Entries),
        write('>>> '),
        read_integer(Day),
        (
            validDiaryDay(Entries, Day)
                -> showDiaryEntry(Entries, Day),
                    nl,
                    loadData(Day), !;
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
            -> (write(Writing), nl, !);
        showDiaryEntry(SubEntries, Day)
    ).

% I.S. Diary entries may contain some entries
% F.S. Diary entries is appended by 1 entry
pushDiaryEntry(Entry) :-
    diaryEntries(Entries),
    push(Entries, Entry, NewEntries),
    retract(diaryEntries(_)),
    asserta(diaryEntries(NewEntries)).

% define hasWriteDiary(E, D) as
% "Player has write a diary entry for day D in
% diary entries E"
hasWriteDiary([], _) :- !, fail.
hasWriteDiary([Entry|SubEntries], Day) :-
    (
        Entry = [Day, _]
            -> !;
        hasWriteDiary(SubEntries, Day)
    ).

% I.S. writeDiaryHandler called
% F.S. Saved current state
save :-
    day(DayInt),
    toString(DayInt, Day),
    atom_concat('save_data/', Day, Base),
    atom_concat(Base, '.pl', Filename),
    open(Filename, write, Stream),
    write(Stream, ':- dynamic(loadAll/0).\n'),
    write(Stream, 'loadAll :-\n'),

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

    write(Stream, '  !.\n'),

    close(Stream).

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
    write(Stream, '  assertz('),
    write_term(Stream, Term, [quoted(true)]),
    write(Stream, '),\n'),
    fail.

writeSaveData(Stream, Term) :-
    write(Stream, '  assertz('),
    write_term(Stream, Term, [quoted(true)]),
    write(Stream, '),\n').

% I.S. readDiaryHandler called
% F.S. Loaded saved state
loadData(Day) :-
    retractall(diaryEntries(_)),
    (
        current_predicate(lastHarvestSeed/2) ->
        retractall(lastHarvestSeed(_, _))
    ),
    (
        current_predicate(count/2) ->
        retractall(count(_, _))
    ),
    (
        current_predicate(seed/1) ->
        retractall(seed(_))
    ),
    (
        current_predicate(seedTile/3) ->
        retractall(seedTile(_, _, _))
    ),
    (
        current_predicate(invCount/2) ->
        retractall(invCount(_, _))
    ),
    (
        current_predicate(tile/3) ->
        retractall(tile(_, _, _))
    ),
    retractall(fishes(_)),
    retractall(inventory(_)),
    retractall(map_size(_)),
    retractall(stats(_, _, _, _, _)),
    retractall(limit(_)),
    retractall(onQuest(_)),
    (
        current_predicate(quest/3) ->
        retractall(quest(_, _, _))
    ),
    (
        current_predicate(lastHarvest/2) ->
        retractall(lastHarvest(_, _))
    ),
    retractall(ternak(_)),
    retractall(day(_)),
    toString(Day, DayStr),
    atom_concat('save_data/', DayStr, Base),
    atom_concat(Base, '.pl', Filename),
    write('--------------------------\n'),
    consult(Filename),
    write('--------------------------\n'),
    loadAll,
    abolish(loadAll/0),
    nl,
    displayLoadMessage,
    displayDayMessage,
    !.

displayLoadMessage :-
    typewrite('Suddenly you feel strange', 0.05),
    sleep(1.5),
    typewrite('...', 0.8),
    sleep(1.5),
    nl,
    typewrite('You started to reflect on your life.', 0.05),
    sleep(1.5),
    nl,
    typewrite('You walked through the window,', 0.05),
    sleep(0.75),
    typewrite(' looking at the outside world.', 0.05),
    sleep(1.5),
    nl,
    typewrite('You began to think', 0.05),
    sleep(0.75),
    typewrite('...', 0.8),
    sleep(1.5),
    nl,
    nl,
    typewrite('Is it a new day already ?', 0.05),
    sleep(1.5),
    nl,
    nl,
    typewrite('Deja Vu.', 0.02),
    sleep(0.75),
    typewrite(' I know i\'ve been here before.', 0.02),
    sleep(0.75),
    nl,
    nl.