#
# QGNAG: Computations with quantum groups at a non-abelian group, including Drinfeld doubles, simple modules, characters, and Hilbert series.
#
# This file is a script which compiles the package manual.
#

SetGapDocHTMLStyle("MathJax");

#AutoDoc( rec( scaffold := true, autodoc := true ) );
AutoDoc(
    rec(
        scaffold := true,
        autodoc  := true,
        dir      := "doc/"
    )
);

Exec("cp doc/chap0.html doc/index.html");
