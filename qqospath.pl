:- module(qqospath, [ospath/4,command/2]).
:- use_module(library(quasi_quotations)).
:- quasi_quotation_syntax(ospath).

:- dynamic dict_result_cached/4.


command(QQ,Res):-
    atomic_list_concat(QQ,Res).

%if nothing has changed take the Result from cache
ospath(Content,SyntaxArgs,VariableNames,Result):-
    with_mutex(qqospath,(clear_cache(5.0),
    must_be(list, VariableNames),
    include(qq_var(SyntaxArgs), VariableNames, QQDict),

    (   \+current_prolog_flag(xref,true),
        %asserta(no_xref),
        dict_result_cached(Content,QQDict,TmpRes,_),TmpRes=Result,!,
        true %garbage_collect
    ;
        %asserta(xref),
    phrase_from_quasi_quotation(path(SyntaxArgs,QQDict,Result), Content),
        retractall(dict_result_cached(Content,_,_,_)),
        get_time(Now),
        asserta(dict_result_cached(Content,QQDict,Result,Now)),
         true %garbage_collect
    ))).

%clears items that are too old
clear_cache(TimeSeconds):-
    get_time(Now),
    MinTime is Now - TimeSeconds,
    forall((dict_result_cached(K,L,M,WhenAsserted),
    WhenAsserted < MinTime),
    retractall(dict_result_cached(K,L,M,WhenAsserted))),!,
    garbage_collect.


clear_cache(_).

%filter out variables that are not in between brackets
qq_var(Vars, _=Var) :- member(V, Vars), V == Var, !.



path(_SA,_VN,[]) --> \+ [_],!.

path(SA,VN,[H|T]) -->
    variable(SA,VN,Var),!,{H=Var},
    path(SA,VN,T).

path(SA,VN,[H|T] ) -->
    [HCode], {atom_codes(H,[HCode])},!,
    path(SA,VN,T).


variable(SA,VN,A)  -->
    {member(VarName=B,VN),atom_codes(VarName,VNCodes)},
    VNCodes,!,
    {member(A,SA),A==B}.






























