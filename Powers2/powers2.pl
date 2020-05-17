read_input(File, N, C) :-
    open(File, read, Stream),
    read_line(Stream, [N]),
    read_lines(Stream,N,C).

read_line(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).

read_lines(Stream,N,L):-
    (N =:= 1 ->
        read_line(Stream, C),
        append([],C,L)
    ;N > 1 ->
        NewN is N - 1,
        read_lines(Stream,NewN,Ln),
        read_line(Stream, C),
        append(C,Ln,L)
        ).

sum2(Target,Result) :-
    (Target =:= 0, Result is 1
    ;Target > 0,
     NewTarget is Target - 1,
     sum2(NewTarget,Nf),
     Result is Nf*2).

count([],_,0).
count([X|T],Xi,N) :- X =:= Xi, count(T,Xi,N1), N is N1 + 1.
count([X|T],Xi,N) :- X \= Xi, count(T,Xi,N).

first(_,_,_,0,Result) :-
     Result is -1.
first(Ninput,Kinput,Xexponent,Scounter,Result) :-
    (Kinput =:= Ninput ->
      append([],[Xexponent],Result)
    ;Kinput < Ninput ->
        sum2(Xexponent,Aux),
        NewK is Aux + Kinput,
        NewX is Xexponent + 1,
        first(Ninput,NewK,NewX,Scounter,Result)
    ;Kinput > Ninput -> 
        Aux12 is Xexponent - 1,
        sum2(Aux12,Aux1),
        NewK1 is Kinput - Aux1,
        NewS is Scounter - 1,
        first(Ninput,NewK1,0,NewS,Res),
        append([Aux12],Res,Result)
    ).

afterCreate(List,K,Result) :-
    length(List,Aux),
    Result is K - Aux.

create(Lista,Current,Result) :-
    (Current =:= 1 ->
        count(Lista,Current,Res),
        append([],[Res],Result)
    ;Current > 1 ->
        NewCur is Current - 1,
        create(Lista,NewCur,Res1),
        count(Lista,Current,Res),
        append([Res],Res1,Result)
        ).

final(Ninput,Kinput,Xexponent,Scounter,Result) :-
    first(Ninput,Kinput,Xexponent,Scounter,Re),
    nth0(0,Re,X),
    create(Re,X,Rel),
    reverse(Rel,Res),
    afterCreate(Re,Kinput,R),
    append([R],Res,Result).

final1(Ninput,Kinput,Xexponent,Scounter,Result) :-
    (final(Ninput,Kinput,Xexponent,Scounter,Res),
     nth0(0,Res,X),
     (X < 0 ->
         Result = [[]]
     ;X >= 0->
        Result = [Res]
        )
    ).

final2(N,In,Result):-
    (N =:= 1 ->
        nth0(0,In,A),
        nth0(1,In,B),
        final1(A,B,0,B,Res),
        append([],Res,Result)
    ;N > 0 ->
        NewN is N - 1,
        Temp is N*2 - 2,
        Temp1 is N*2 - 1,
        nth0(Temp,In,A),
        nth0(Temp1,In,B),
        final2(NewN,In,Re),
        final1(A,B,0,B,Res),
        append(Re,Res,Result)).
    
powers2(File,Result) :-
    read_input(File, N, C),
    final2(N,C,Res),
    reverse(Res,Result).

  




