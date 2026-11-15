#############################################################################
##
#W  dgchecks.gd                                  QGNAG
##
##  Declarations: checks of the simple D(G)-modules (are they D(G)-modules? simple?
##  pairwise non-isomorphic? are they all?) and comparison with the paper.
##
#############################################################################

#! @Description
#!  Checks the group of the paper: the generators <A>gens</A> = [t, x, y, z] satisfy x = t^2, y = t z t^-1 and the
#!  relations of the presentation, the presentation defines a group of order |G|, G = A4 x C2, and the conjugacy classes
#!  and centralizers of A4 are those quoted in the text. Prints one line per check and returns true if all hold.
#! @Arguments G, gens
#! @Returns true or false
DeclareGlobalFunction("QGNAG_CheckGroupFacts");

#! @Description
#!  Checks, from the data stored in each module (s.simple, s.DeltaStructureMatrices, s.group, s.generatorsofgroup):
#!  (1) every module is a D(G)-module: rho is a homomorphism, the delta_h are orthogonal idempotents adding up to 1 and
#!  rho(g) delta_h rho(g)^-1 = delta_{g h g^-1};  (2) every module is simple (its commutant has dimension 1);
#!  (3) the modules are pairwise non-isomorphic (their D(G)-characters tr(rho(g) delta_h) are different);
#!  (4) they are all the simple D(G)-modules: the support of each module is one conjugacy class C of G, and for every class
#!  C the modules supported on C have dimensions |C| * (degrees of the irreducible characters of the centralizer of C);
#!  in particular their number is the sum, over the classes, of the number of conjugacy classes of the centralizer, and
#!  the sum of the squares of the dimensions is |G|^2.
#!  Prints a report and returns a record with the fields ok, allDGModules, allSimple, pairwiseNonIsomorphic, complete.
#! @Arguments simples
#! @Returns a record
DeclareGlobalFunction("QGNAG_CheckSimplesDG");

#! @Description
#!  The 56 simple D(G)-modules of the paper (Sections 2.3.1-2.3.4 of the new text), built from the formulas of the text
#!  for the group G and the generators <A>gens</A> = [t, x, y, z]. Same record shape as the elements of SimplesMn
#!  (simple, group, generatorsofgroup, DeltaStructureMatrices), plus the fields label and name.
#! @Arguments G, gens
#! @Returns a list of 56 records
DeclareGlobalFunction("QGNAG_PaperSimples");

#! @Description
#!  The list SimpleNames of the new text (enumeration of Section 2.4), generated, not typed.
#! @Returns a list of 56 strings
DeclareGlobalFunction("QGNAG_NewSimpleNames");

#! @Description
#!  Writes the enumeration of the simple modules as LaTeX, in the format of the text (an align* environment with four
#!  columns, "1. & M(0,\tau_{00}) & 2. & ..."), ready for \input. Unlike QGNAG_SaveSimpleModulesNotationToLaTeX, the file contains no
#!  Markdown (no "##" and no "$$"), so it compiles inside any document.
#! @Arguments filename, names
#! @Returns true
DeclareGlobalFunction("QGNAG_WriteSimpleNamesTeX");

#! @Description
#!  Compares each module of <A>simples</A> with the module of the same position in <A>paper</A> (QGNAG_PaperSimples):
#!  isomorphic as D(G)-modules? If so, it computes the change of basis X (rho_paper = X rho X^-1) and classifies it:
#!  identity, diagonal, permutation, signed permutation, monomial or general.
#! @Arguments simples, paper
#! @Returns a record
DeclareGlobalFunction("QGNAG_CompareSimplesWithPaper");

#! @Description
#!  A copy of <A>simples</A> where simple, DeltaStructureMatrices and base are replaced by those of <A>paper</A>, so that
#!  QGNAG_SimplesSummaryToLaTeX prints exactly the matrices of the text. SimplesMn itself is not modified.
#! @Arguments simples, paper
#! @Returns a list of records
DeclareGlobalFunction("QGNAG_SimplesInPaperBasis");

#! @Description
#!  Compares data_fusion_rules_parallel (records first, second, vector) with the fusion rules of the Proposition of the new text.
#! @Arguments data_fusion_rules_parallel
#! @Returns a record
DeclareGlobalFunction("QGNAG_CheckFusionRulesOfPaper");

# Internal helpers.
DeclareGlobalFunction("QGNAG_DGCHECKS_Line");
DeclareGlobalFunction("QGNAG_ModuleDelta");
DeclareGlobalFunction("QGNAG_ModuleDeltas");
DeclareGlobalFunction("QGNAG_ElementIndex");
DeclareGlobalFunction("QGNAG_GroupElementKey");
DeclareGlobalFunction("QGNAG_DeltaElementKey");
DeclareGlobalFunction("QGNAG_IntertwinerSpace");
DeclareGlobalFunction("QGNAG_CheckModuleDG");
DeclareGlobalFunction("QGNAG_SimpleLabels");
DeclareGlobalFunction("QGNAG_LabelPosition");
DeclareGlobalFunction("QGNAG_PaperFusionVector");
DeclareGlobalFunction("QGNAG_ChangeOfBasisKind");
