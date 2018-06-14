# qqospath
Windows file path to prolog conversion that uses quasi quotations

A learning project where I took a deep dive to quasi quoting. 

First I had an idea to just use it for getting a prolog-path nicely from OS-path. Then I thought, ok, 
I'll try something more difficult, a variables in the path. After that I noticed, that these
are like a macro. 


EXAMPLE1:

?- A={|ospath||c:\program files (x86)\swipl|}.

A = ['c:/program files (x86)/swipl'].


EXAMPLE2:

?- Var=swipl,A={|ospath||c:\program files (x86)\Var|}.

Var = swipl,

A = ['c:/program files (x86)/', swipl].

The Example2 gives now a term that can be fed to atomic_list_concat/2 to get a proper prolog-path. Possibly I 
will try to do a version that gives out a atom as in Example1.


EXAMPLE3:

 ?- Testvariable=xxx, AnotherVariable=yyy,A={|ospath||Testvariable_sometext_here_AnotherVariable|}.
 
Testvariable = xxx,

AnotherVariable = yyy,

A = [xxx, '_sometext_here_', yyy].

All the variables that are used with the ospath/4 are "seen" while the parsing of the the ospath/4 is done, I 
believe it is possible to do a code, where the variables can be explicitly shown.


DEVELOPER NOTES:

While developing, I noticed that trace/1 will not work, writeln/1 can cause a huge number of errors and even the debug/3 messages don't work. I used the throw/1 to get information what is going on inside qqospath.

At the command prompt, I developed the DCG-clauses initially with the phrase/2-3. The phrase/2 and phrase_from_quasi_quotation/2 they are very much alike, but with a big difference: phrase_from_quasi_quotation/2 does some external processing after it finishes, predicates from apply_macros.pl are being used, as seen with the debugger.

First I thought that quasi-quoting is just some techical term, but actually quasi-quoting is some linguistics thing  https://en.wikipedia.org/wiki/Quasi-quotation

DEVELOPER NOTES2:
While developing with phrase/3 this is possible. First arguments is SyntaxArgs, Second argument is VariableNames.

?- phrase(qqospath:path(_SA,['X'=aaa,'Y'=bbb],Res),`XYXY`,R).

Res = [aaa, bbb, aaa, bbb],

R = [].

But phrase_from_quasi_quotation/2 doesn't "see" the members of VariableNames (like 'X'=aaa), it "sees" only variables, because the variables are unified outside the phrase_from_quasi_quotation/2. That is to say phrase_from_quasi_quotation/2 handles 
only variables and those variables are unified after exit from the phrase_from_quasiquotation/2. I thought this was a bug, I spent a few hours to "debug" this "bug", but then I found out that it is by design.


While really calling phrase_from_quasi_quotation/2 the only way I could get data about a phrase_from_quasi_quotation/2 was throw/1

This example shows a throw/1 inside a DCG rule:
...

path(SA,VN,[H|T]) -->
    pathsegment(SA,VN,Seg),!,{    throw((SA,VN)),          atomic_list_concat(Seg,SegA),H=SegA},
    path(SA,VN,T).
    
...

And then I get:
?- SomeVar=xxx,OtherVar=yyy,A= {|ospath||---SomeVar|},atomic_list_concat(A,'/',At).

ERROR: Unknown message: [],['SomeVar'=_9766,'OtherVar'=_9778,'A'=_9790,'At'=_9802]

So the _9766 and _9778  are unified with real values *after* the phrase_from_quasi_quotes/2 exits. The 
debugger shows predicates from the apply_macros.pl 
