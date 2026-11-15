#############################################################################
##
#W  klreview.gd                                  QGNAG
##
##  Declarations: checks of the review notebook, Kazhdan-Lusztig data
##  (quantum polynomials, blocks), Hilbert series and the section of the
##  paper "Hilbert series".
##
##  The functions of kltex.gd, characters.gd and classify_blocks.gd are not
##  repeated here.
##
#############################################################################

#############################################################################
##  Checks (used by the review notebook)
#############################################################################

# A name of this file may already be defined in the session (for example pasted in a notebook cell before loading the package):
# DeclareGlobalFunction needs a free name, so those definitions are unbound first (the package version replaces them).
(function( names )
    local name;
    for name in names do
        if IsBoundGlobal( name ) then
            if IsReadOnlyGlobal( name ) then
                MakeReadWriteGlobal( name );
            fi;
            UnbindGlobal( name );
        fi;
    od;
end)( [ "QGNAG_CHECKS",
         "QGNAG_ResetChecks",
         "QGNAG_Check",
         "QGNAG_ChecksSummary",
         "QGNAG_FileContains",
         "QGNAG_CountInFile",
         "QGNAG_IndexVarChars",
         "QGNAG_PrintQuantumPolynomials",
         "QGNAG_GraphFromQuantumPols",
         "QGNAG_DecompositionFromNegativeDegreeToZero",
         "QGNAG_DecompositionFromNegativeDegree",
         "QGNAG_PrintDecompositionFromNegativeDegree",
         "QGNAG_FilterZeroDecompositions",
         "QGNAG_DecompositionToString",
         "QGNAG_HilbertSeriesCoefficients",
         "QGNAG_HilbertSeriesNegativePart",
         "QGNAG_IsPal",
         "QGNAG_HilbertSeriesIsPalindromic",
         "QGNAG_HilbertSectionToLaTeX",
         "QGNAG_WriteCharAndHilbertTeX",
         "QGNAG_WritePolynomialsKLTeX",
         "QGNAG_WriteSeriesKLTeX",
         "QGNAG_KLTeXText",
         "QGNAG_VisibleLength",
         "QGNAG_LaurentTerms",
         "QGNAG_MonomialToTeX",
         "QGNAG_LaurentToTeX",
         "QGNAG_CoefficientTimes",
         "QGNAG_JoinSignedTerms",
         "QGNAG_EquationToTeX",
         "QGNAG_IotasOfBlock",
         "QGNAG_BlockEquations",
         "QGNAG_DegreeOfD",
         "QGNAG_CurrentDirectory",
         "QGNAG_FullPath" ] );

# Results of QGNAG_Check, in a mutable record (the binding is read-only, the record is not).
BindGlobal( "QGNAG_CHECKS", rec( results := [] ) );

#! @Description
#!  Empties the list of results of <C>QGNAG_Check</C>.
DeclareGlobalFunction( "QGNAG_ResetChecks" );

#! @Description
#!  Prints <C>[ OK ]</C> or <C>[FAIL]</C> followed by <A>label</A>, and records the result.
#!  The check passes iff <A>condition</A> = true.
#! @Arguments label, condition
DeclareGlobalFunction( "QGNAG_Check" );

#! @Description
#!  Prints <C>N of M checks passed.</C> and <C>ALL CHECKS PASSED</C> or <C>SOME CHECKS FAILED</C>.
#! @Returns true iff every recorded check passed
DeclareGlobalFunction( "QGNAG_ChecksSummary" );

#! @Description
#!  true iff the file <A>filename</A> contains the string <A>text</A>.
#! @Arguments filename, text
DeclareGlobalFunction( "QGNAG_FileContains" );

#! @Description
#!  Number of occurrences of <A>text</A> in the file <A>filename</A>.
#! @Arguments filename, text
DeclareGlobalFunction( "QGNAG_CountInFile" );

#############################################################################
##  Weights and quantum polynomials
#############################################################################

#! @Description
#!  Index of the weight at the highest degree of a decomposition <A>rec_info</A>
#!  (a record whose components are the degrees; each one is a list of pairs [ multiplicity, index ]).
#! @Arguments rec_info
#! @Returns a positive integer
DeclareGlobalFunction( "QGNAG_IndexVarChars" );

#! @Description
#!  Prints, in LaTeX, the relations  eps_p = sum_q t_{p,q} nu_q  for p = 1, ..., Length( <A>epsilon_and_coeffs</A> ).
#! @Arguments epsilon_and_coeffs, nu_names
DeclareGlobalFunction( "QGNAG_PrintQuantumPolynomials" );

#! @Description
#!  Graph of the blocks: an edge [p,q], p &lt; q, whenever t_{p,q}(1) + t_{q,p}(1) &lt;&gt; 0.
#! @Arguments data_quantum_pols_eval
#! @Returns a record with the components <C>nodes</C> and <C>edges</C>
DeclareGlobalFunction( "QGNAG_GraphFromQuantumPols" );

#############################################################################
##  Decompositions by negative degree (from test_review.g)
#############################################################################

#! @Description
#!  Multiplicities by negative degree of <A>record_data_decomp</A>, shifted so that the highest nonzero degree is 0.
#!  Returns a record whose components are the degrees -n_top, ..., 0 (as strings), each one a list of multiplicities.
#! @Arguments record_data_decomp
DeclareGlobalFunction( "QGNAG_DecompositionFromNegativeDegreeToZero" );

#! @Description
#!  Decomposition of <A>record_data_decomp</A> at the degree -<A>j</A>: a record with the single component String(-j).
#! @Arguments j, record_data_decomp
DeclareGlobalFunction( "QGNAG_DecompositionFromNegativeDegree" );

#! @Description
#!  Prints, for each degree, the nonzero multiplicities of <A>rec_bijs</A> as  degree d = M1 + 2*M5 + ...
#! @Arguments rec_bijs
DeclareGlobalFunction( "QGNAG_PrintDecompositionFromNegativeDegree" );

#! @Description
#!  <A>rec_bijs</A> without the degrees whose multiplicities are all zero.
#! @Arguments rec_bijs
DeclareGlobalFunction( "QGNAG_FilterZeroDecompositions" );

#! @Description
#!  The decomposition <A>rec_bijs</A> as a string  Char = M1[d] + 2*M5[d'] + ...
#! @Arguments rec_bijs
DeclareGlobalFunction( "QGNAG_DecompositionToString" );

#############################################################################
##  Hilbert series
#############################################################################

#! @Description
#!  For each simple module (in the order of the weights, i.e. permuted by tau) computes its Hilbert series
#!  as a list of pairs [ coefficient, degree ] sorted by increasing degree.
#! @Arguments data_record_data_decomp, degreeofreps
#! @Returns a list with one entry per simple module
DeclareGlobalFunction( "QGNAG_HilbertSeriesCoefficients" );

#! @Description
#!  Same as <C>QGNAG_HilbertSeriesCoefficients</C>, keeping only the pairs with degree &lt;= 0.
#! @Arguments data_record_data_decomp, degreeofreps
DeclareGlobalFunction( "QGNAG_HilbertSeriesNegativePart" );

#! @Description
#!  <A>L</A> is a list of pairs [ coefficient, degree ] sorted by degree: true iff the coefficients read the same
#!  forwards and backwards.
#! @Arguments L
#! @Returns true or false
DeclareGlobalFunction( "QGNAG_IsPal" );

#! @Description
#!  For each simple module (same order as <C>QGNAG_HilbertSeriesCoefficients</C>), true iff its full Hilbert
#!  series is palindromic.
#! @Arguments data_record_data_decomp, degreeofreps
#! @Returns a list of booleans
DeclareGlobalFunction( "QGNAG_HilbertSeriesIsPalindromic" );

#! @Description
#!  Writes to <A>filename</A> the subsection "Hilbert series" of the paper: the Lemma with Lambda_L and Lambda_V
#!  (weights whose L(lambda) has one degree, or all the degrees) and the Proposition with the Hilbert series of the
#!  remaining weights, grouped by family (tau, rho, chi, eta) and by equal series.
#!  <A>data_rec_info</A>[i] is the record of the weight i (permuted by tau; see <C>QGNAG_PrepareDecomposition</C>),
#!  <A>names</A> the LaTeX names (SimpleNames), <A>degreeofreps</A> the dimensions and
#!  <A>pals</A> the result of <C>QGNAG_HilbertSeriesIsPalindromic</C>.
#! @Arguments filename, data_rec_info, names, degreeofreps, pals
#! @Returns a record with the components L, V, groups, dims, palindromic
DeclareGlobalFunction( "QGNAG_HilbertSectionToLaTeX" );

#! @Description
#!  For each weight writes to <A>filename</A> a <C>\subsubsection{$L...$}</C> with its character (the decomposition of
#!  L(lambda) into simple modules, by degree), its Hilbert series and its dimension.
#!  <A>data_rec_info</A>[i] is the record of the weight i permuted by tau, <A>names</A> the LaTeX names (SimpleNames),
#!  <A>degreeofreps</A> the dimensions. If <A>filtered</A> is true the weights of Lambda_L and Lambda_V are skipped.
#!  If <A>underline</A> is true the simple modules of the character are written as \underline{k} (their position),
#!  otherwise with their names. Uses <C>QGNAG_ExtractTuple</C> for the name of L.
#! @Arguments filename, data_rec_info, names, degreeofreps, filtered, underline
#! @Returns a record with the components written and excluded
DeclareGlobalFunction( "QGNAG_WriteCharAndHilbertTeX" );

#############################################################################
##  polynomialsKL and seriesKL in the format of the paper (from kltex.gd)
#############################################################################

#! @Description
#!  Writes <A>filename</A> with the Verma characters in terms of the irreducible characters
#!  (epsilon_i = sum_j t_{i,j} nu_j), block by block, in the format of the paper: the principal block,
#!  the blocks of size 6 and 2 side by side (cases), the blocks of size 1 in one sentence. The repeated
#!  coefficients are factored, q^{-1}(\nu_{10}+\nu_{16}), and the repeated non-monomial coefficients are named
#!  \iota_{1}(q), \iota_{2}(q), ... The coefficients are built from the Laurent coefficients of the entries,
#!  never from their printed form.
#! @Arguments filename, blocks
#! @Returns true
DeclareGlobalFunction("QGNAG_WritePolynomialsKLTeX");

#! @Description
#!  Writes <A>filename</A> with the irreducible characters in terms of the Verma characters
#!  (nu_i = d^k sum_j c_{i,j} epsilon_j, d = (1-q^{-6})^{-1}, 2k the size of the block), block by block, in the format
#!  of the paper. The coefficients c_{i,j} are Laurent polynomials in q^{-1}, written as short sums, and the repeated
#!  coefficients are factored. <A>inv_blocks</A> is the output of QGNAG_InvertBlocks.
#! @Arguments filename, inv_blocks
#! @Returns true
DeclareGlobalFunction("QGNAG_WriteSeriesKLTeX");

#! @Description
#!  The whole text of one of the two files, as a string. <A>kind</A> is "polynomials" or "series".
#! @Arguments blocks, kind, factor, widths
#!  <A>widths</A> = [ full line, two systems side by side, one system alone ]: estimated glyphs per line.
DeclareGlobalFunction("QGNAG_KLTeXText");
DeclareGlobalFunction("QGNAG_VisibleLength");

# Internal helpers.
DeclareGlobalFunction("QGNAG_LaurentTerms");
DeclareGlobalFunction("QGNAG_MonomialToTeX");
DeclareGlobalFunction("QGNAG_LaurentToTeX");
DeclareGlobalFunction("QGNAG_CoefficientTimes");
DeclareGlobalFunction("QGNAG_JoinSignedTerms");
DeclareGlobalFunction("QGNAG_EquationToTeX");
DeclareGlobalFunction("QGNAG_IotasOfBlock");
DeclareGlobalFunction("QGNAG_BlockEquations");
DeclareGlobalFunction("QGNAG_DegreeOfD");

#############################################################################
##  Where are the files
#############################################################################

#! @Description
#!  Absolute path of the current directory of GAP (the directory where the files are written when the output
#!  directory is "").  Returns fail if it cannot be found.
DeclareGlobalFunction( "QGNAG_CurrentDirectory" );

#! @Description
#!  Full path of the file <A>name</A> in the output directory <A>outdir</A> ("" = the current directory of GAP;
#!  otherwise <A>outdir</A> must end with "/").
#! @Arguments outdir, name
#! @Returns a string
DeclareGlobalFunction( "QGNAG_FullPath" );
