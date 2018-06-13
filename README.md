# qqospath
Windows file path to prolog conversion that uses quasi quotations

A learning project where I took a deep dive to quasi quoting. 

First I had an idea to just use it for getting a prolog-path nicely from OS-path. Then I thought, ok, 
I'll try something more difficult, a variables in the path. After that I noticed, that these
are like a macro. 


Example1:

?- A={|ospath||c:\program files (x86)\swipl|}.

A = ['c:/program files (x86)/swipl'].


Example2:

?- Var=swipl,A={|ospath||c:\program files (x86)\Var|}.

Var = swipl,

A = ['c:/program files (x86)/', swipl].

The Example2 gives now a term that can be fed to atomic_list_concat/2 to get a proper prolog-path. Possibly I 
will try to do a version that gives out a atom as in Example1.


Example 3:

?- Testvariable='xxx', AnotherVariable='yyy',A={|ospath||Testvariable\'some text here'\AnotherVariable|}.

Testvariable = xxx,

AnotherVariable = yyy,

A = [xxx, '/\'some text here\'/', yyy].

All the variables that are used with the ospath/4 are "seen" while the parsing of the the ospath/4 is done, I 
believe it is possible to do a code, where the variables can be explicitly shown.
