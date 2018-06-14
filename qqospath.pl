:- module(qqospath, [ospath/4]).
:- use_module(library(quasi_quotations)).
:- quasi_quotation_syntax(ospath).

ospath(Content,SyntaxArgs,VariableNames,Result):-
    phrase_from_quasi_quotation(path1000(SyntaxArgs,VariableNames,Result), Content).

list_to_path_segments(_S,[H],R):-
    !,R=H.
list_to_path_segments(S,[H|T],R):-
    S==H,
    !,
    list_to_path_segments(S,T,R).
list_to_path_segments(S,[H|T],R) :-
    list_to_path_segments(S,T,Rdeep),R=Rdeep/H.


path1000(SA,VN,R)--> {VN2=['\\'=Slash|VN]}, path(SA,VN2,Q),
{ reverse(Q,RQ),list_to_path_segments(Slash,RQ,R)}.

path(_SA,_VN,[]) --> \+ [_],!.

path(SA,VN,[H|T]) -->
    variable(SA,VN,Var),!,{H=Var},
    path(SA,VN,T).

path(SA,VN,[H|T]) -->
    pathsegment(SA,VN,Seg),!,{ atomic_list_concat(Seg,SegA),H=SegA},
    path(SA,VN,T).



variable(_SA,VN,A)  -->
    {member(VarName=A ,VN),atom_codes(VarName,VNCodes)},
    VNCodes,!.

slash(_,_,A) -->
    [0'\\],{A='/'}.

pathatom(_,_,A) --> slash(_,_,A),!.
pathatom(_,_,A) -->
     [H2],{atom_codes(A,[H2])}.


pathsegment(SA,VN,[H|T]) -->
    \+variable(SA,VN,_),
    pathatom(_,_,H),!,
    pathsegment(SA,VN,T).
pathsegment(_SA,_VN,[],A,A).




