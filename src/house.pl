% Dev dependencies
:- include('time.pl').
:- include('list_utils.pl').

dynamic(diaryEntries/1).

% I.S. diaryEntries(X) is false for any X
% F.S. diaryEntries(X) is true for some X, i.e.
%      the diaryEntries is initialized
initDiaryEntries :-
    asserta(diaryEntries([])).

% All house activities
house :-
% TODO : Check house tile
    write('What do you want to do ?\n'),
    write('- sleep\n'),
    write('- writeDiary\n'),
    write('- readDiary\n'),
    write('- exit\n\n'),
    write('>>> '),
    read(Cmd),
    nl,
    (
        (Cmd = 'sleep', sleepHandler, !);
        (Cmd = 'readDiary', readDiaryHandler, !);
        (Cmd = 'writeDiary', writeDiaryHandler, !);
        (Cmd = 'exit', !);
        house
    ).

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
    readLine(Writing),
    Entry = [Day, Writing],
    pushDiaryEntry(Entry),
    write('Day '),
    write(Day),
    write(' entry saved.').

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
