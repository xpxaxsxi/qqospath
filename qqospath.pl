:- module(qqpospath, [ospath/4]).
:- use_module(library(quasi_quotations)).
:- quasi_quotation_syntax(ospath).

ospath(Content,SyntaxArgs,VariableNames,Result):-
    phrase_from_quasi_quotation(path(SyntaxArgs,VariableNames,Result), Content).



path(_SA,_VN,[]) --> \+ [_],!.

path(SA,VN,[H|T]) -->
    variable(SA,VN,Var),!,{H=Var},
    path(SA,VN,T).

path(SA,VN,[H|T]) -->
    pathsegment(SA,VN,Seg),!,{atomic_list_concat(Seg,SegA),H=SegA},
    path(SA,VN,T).




variable(SA,VN,A)  -->
    {member(A,SA),member(VarName=B,VN),A==B,atom_codes(VarName,VNCodes)},

    VNCodes,!.

slash(_,_,A) -->
    [0'\\],{A='\\'}.

pathatom(_,_,A) --> slash(_,_,A),!.
pathatom(_,_,A) -->
     [H2],{atom_codes(A,[H2])}.


pathsegment(SA,VN,[H|T]) -->
    \+variable(SA,VN,_),
    pathatom(_,_,H),!,
    pathsegment(SA,VN,T).
pathsegment(_SA,_VN,[],A,A).




