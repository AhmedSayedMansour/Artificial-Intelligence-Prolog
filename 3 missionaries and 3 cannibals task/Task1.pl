%move from right to left:-
%move 2 missionaries
move(s(M,C,1),s(NewM,C,0)):-
    M > 1,
    NewM is M-2.
%move 2 cannibals
move(s(M,C,1),s(M,NewC,0)):-
    C > 1,
    NewC is C-2.
%move 1 cannibals & 1 missionaries
move(s(M,C,1),s(NewM,NewC,0)):-
    M > 0,
    NewM is M-1,
    C > 0,
    NewC is C-1.
%move from left to right:-
%move 1 missionaries
move(s(M,C,0),s(NewM,C,1)):-
    M < 3,
    NewM is M+1.
%move 1 cannibals
move(s(M,C,0),s(M,NewC,1)):-
    C < 3,
    NewC is C+1.
%move 1 cannibals & 1 missionaries
move(s(M,C,0),s(NewM,NewC,1)):-
    M < 3,
    NewM is M+1,
    C <3 ,
    NewC is C+1.
%unsafe
unsafe(s(M,C,_)):-
    M < C,
    M > 0.
unsafe(s(M,C,_)):-
    M > C,
    M =\= 0 ,
    M =\= 3 ,
    M =\= C.
%path
path(s(0,0,0),R,R).
path(State,Visited,R):-
    \+ unsafe(State),
    move(State,NextState),
    \+ member(NextState, Visited),
    path(NextState,[NextState|Visited],R).
%game
game(S):-
    path(S,[S],R),
    reverse(R,NR),
    print(NR).
%print
print([]).
print([A|B]) :-
  write_ln(A),
  print(B).