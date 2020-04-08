%not out of dim
not_out(A,B):-
    dim(X,Y),
    A < X , A >= 0,
    B < Y , B >=0.

%move_right:-
move([A,B],[A,NB],right):-
    NB is B+1,
    not_out(A,NB),
    \+ bomb([A,NB]).

%move_left:-
move([A,B],[A,NB],left):-
    NB is B-1,
    not_out(A,NB),
    \+ bomb([A,NB]).

%move_down:-
move([A,B],[NA,B],down):-
    NA is A+1,
    not_out(NA,B),
    \+ bomb([NA,B]).

%move_up:-
move([A,B],[NA,B],up):-
    NA is A-1,
    not_out(NA,B),
    \+ bomb([NA,B]).

is_star(X,Y,N,NewN):-
    star([X,Y]),
    NewN is N+1,!.
is_star(_,_,N,NewN):-
    NewN is N.

%path
path([E1,E2],_,M,M,N,N):-
    end([E1,E2]).
path([X,Y],Visited,MS,Moves,N,Stars):-
    move([X,Y],NextState,M),
    \+ member(NextState, Visited),
    %(  star([X,Y]) -> NewN is N+1 ; NewN is N ),
    is_star(X,Y,N,NewN),
    path(NextState,[NextState|Visited],[M|MS],Moves,NewN,Stars).

%member
member(X,[X|_]).
member(X,[_|R]) :- member(X,R).

%reverse
reverse([],Z,Z).
reverse([H|T],Z,Acc) :- reverse(T,Z,[H|Acc]).

%play
play(Moves,Stars):-
    start(Start),
    path(Start,[Start],[],RevMoves,0,Stars),
    reverse(RevMoves, Moves).
