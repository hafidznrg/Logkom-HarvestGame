% ----------------- LIST UTILS -----------------

% define empty(X) as "X is empty"
empty([]).

% define getElem(X, I, Y) as
% "X's I-th element is Y"
getElem([], _, undefined).
getElem([Head|_], 0, Head) :- !.
getElem([_|Tail], I, Elem) :-
    I_ is I - 1,
    getElem(Tail, I_, Elem).

% define push(L, E, R) as
% "R is the result of inserting E as the last
% element of L"
push([], E, [E]).
push([Head|Tail], E, Result) :-
    push(Tail, E, Subresult),
    Result = [Head|Subresult].


% define isMember(E,L)
% return true if E is in L
isMember(E,[E|_]) :- !.
isMember(E,[_|Tail]) :- isMember(E,Tail).

% ------------------ IO UTILS ------------------

% I.S. Any
% F.S. String is string representation of user input
readLine(String) :-
    write(''),
    current_input(IStream),
    stringify('', IStream, String).

% I.S. Str may be empty
% F.S. Str is Char appended by Stream's buffer
stringify('\n', _, Str) :-
    Str = '',
    !.
stringify(Char, Stream, Str) :-
    get_char(Stream, NextChar),
    stringify(NextChar, Stream, SubStr),
    atom_concat(Char, SubStr, Str).

% rewrite :-
%     readLine(Str),
%     write(Str).
