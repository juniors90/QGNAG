#############################################################################
##
#W  characters.gd                                QGNAG
##
##  Declarations: characters of the simple modules L(lambda) in the format of
##  the paper (factoring the repeated multiplicities).
##
#############################################################################

#! @Description
#!  Writes <A>filename</A> with the characters of the simple modules L(lambda) in the format of
#!  the paper: one <C>align*</C> per family (tau, rho, chi, eta), one line  \car(lambda) = ... ,
#!  the terms ordered by increasing degree, and the repeated multiplicities factored:
#!  for example  2\cdot(\underline{8}+\underline{34})q^{-3}.
#!  If <A>filtered</A> is true, the weights that are not printed in the paper are skipped:
#!  those with L(lambda) simple as a Verma module (decomposition in all the degrees) and those of dimension 1
#!  (decomposition in a single degree).
#! @Arguments data_record_data_decomp, SimpleNames, filename, filtered
#! @Returns true
DeclareGlobalFunction("QGNAG_WriteCharactersTeX");

#! @Description
#!  The whole text written by QGNAG_WriteCharactersTeX, as a string. <A>permuted_decomps</A> is the list
#!  Permuted(List(data_record_data_decomp, QGNAG_PrepareDecomposition), tau), <A>sNamesL</A> the list of
#!  names such as "(0,\tau_{12})", <A>n_top</A> the number of degrees of the Verma module, <A>maxItems</A> the
#!  maximum number of \underline{} per line and <A>style</A> "q" (q^{d}) or "bracket" ([d]).
#! @Arguments permuted_decomps, sNamesL, n_top, filtered, maxItems, style
DeclareGlobalFunction("QGNAG_CharactersTeXText");

#! @Description
#!  One character  \car(name) &= ...  (without the final punctuation).
#! @Arguments rec_info, LName, maxItems, style
DeclareGlobalFunction("QGNAG_CharacterToTeX");

#! @Description
#!  The term of one degree: the pairs [multiplicity, index] at degree <A>d</A>, with the repeated
#!  multiplicities factored. Returns [ text, number of \underline{} ].
#! @Arguments pairs, d, style
DeclareGlobalFunction("QGNAG_CharacterDegreeTermToTeX");
