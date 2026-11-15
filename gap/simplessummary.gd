#############################################################################
##
#W  simplessummary.gd                       QGNAG
##
##  Declarations for the LaTeX summary of the simple D(G)-modules.
##
#############################################################################

#! @Description
#!  Writes the LaTeX fragment <A>filename</A> with the complete description of the simple
#!  D(G)-modules in <A>simples</A> (the list SimplesMn): name, dimension, element g they are
#!  attached to, basis, matrices of all the generators of G (s.simple(g) for g in
#!  s.generatorsofgroup) and the nonzero matrices delta_h. It only reads <A>simples</A>.
#! @Arguments filename, simples, names, genNames, relationsOK
#! @Returns true
#!  <A>names</A> is the list SimpleNames (or fail), <A>genNames</A> a list of LaTeX names of the
#!  generators (or fail) and <A>relationsOK</A> the value returned by
#!  QGNAG_TestRelationsForDGModSimples.
DeclareGlobalFunction("QGNAG_SimplesSummaryToLaTeX");

# Internal helpers.
DeclareGlobalFunction("QGNAG_SimplesSummary_ObjToString");
DeclareGlobalFunction("QGNAG_SimplesSummary_EscapeLaTeX");
DeclareGlobalFunction("QGNAG_SimplesSummary_CycloToLaTeX");
DeclareGlobalFunction("QGNAG_SimplesSummary_MatrixToLaTeX");
DeclareGlobalFunction("QGNAG_SimplesSummary_ElementToPair");
DeclareGlobalFunction("QGNAG_SimplesSummary_ElementToLaTeX");
DeclareGlobalFunction("QGNAG_SimplesSummary_BaseElementToLaTeX");
DeclareGlobalFunction("QGNAG_SimplesSummary_DeltaToLaTeX");
