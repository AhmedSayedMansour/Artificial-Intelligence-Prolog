:- abolish(available_resources/1).
:- abolish(done/1).
:- dynamic available_resources/1.
:- dynamic done/1.

/*Input*/

process(p2).
process(p3).
process(p1).
process(p4).
process(p5).

allocated(p1, r2).
allocated(p2, r1).
allocated(p3, r1).
allocated(p4, r1).

requested(p1, r1).
requested(p3, r2).
requested(p5, r2).

/*Dynamic Knowledge*/
available_resources([[r1 , 0],[r2 , 0],[r3 , 0]]).
done(o).

/*Allocated only*/
allocated(X):-
    \+ done(X),
    allocated(X , _),
    \+ requested(X ,_),
    release(X),
    assert(done(X)).

/*Allocated and requested*/
allocated_requested(X):-
    \+ done(X),
    requested(X , R),
    allocated(X,_),
    check_resource(R),
    release(X),
    assert(done(X)).

/*Requested only*/
requested(X):-
    \+ done(X),
    requested(X , R),
    check_resource(R),
    assert(done(X)).

/*Check if the resource has available instance*/
check_resource(R):-
    index(R , I),
    available_resources(L),
    nth1(I , L , E),
    get_ava(E , N),
    N > 0.

/*Global release*/
release(X):-
    allocated(X , Z),
    index(Z,N),
    available_resources(L),
    retract(available_resources(L)),
    nth1(N, L, E),
    get_ava(E,Y),
    NewY is Y+1,
    select(E,L,[Z,NewY],NewL),
    assert(available_resources(NewL)).

/*get index of resource from the available_resources*/
index(V,N):-
    available_resources(L),
    search(L,N,1,V).

/*Used in index rule*/
search(Matrix, Row, Col, Value):-
    nth1(Row, Matrix, MatrixRow),
    nth1(Col, MatrixRow, Value).

/*Get the number of instances*/
get_ava([_|Y],Y).

/*Run all processes*/
run(X):-
    process(X),
   (allocated(X) ; allocated_requested(X) ; requested(X)).

/*Loop to run two times*/
run_loop(X):-
    (run(X);
    run(X)).

/*remove duplicates*/
remove_duplicates([],[]).
remove_duplicates([H | T], List) :-    
     member(H, T),
     remove_duplicates( T, List),!.
remove_duplicates([H | T], [H|T1]) :- 
      \+member(H, T),
      remove_duplicates( T, T1).

/*Check the safe state and out the graph of processes*/
safe_state(Final):-
    findall(X,run_loop(X),L),
    remove_duplicates(L,Final).
