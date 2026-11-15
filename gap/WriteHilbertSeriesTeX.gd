#############################################################################
##
#F  QGNAG_WriteHilbertSeriesTeX( <data_record_data_decomp>, <SimpleNames>,
##                                <degreeofreps>, <filename> )
##
##  For each simple module (as described by <data_record_data_decomp>),
##  writes to <filename> a LaTeX block containing:
##    - the character decomposition  "Char L_i = ..."
##    - the Hilbert series           "H_{L_i}(t) = ..."
##    - the total dimension          "dim L_i = ..."
##
##  Arguments:
##    data_record_data_decomp : list of decomposition records, one per
##                               simple module, as expected by
##                               QGNAG_PermutationVarChars and
##                               QGNAG_PrepareDecomposition.
##    SimpleNames              : list of simple-module name descriptors,
##                               one per entry of data_record_data_decomp,
##                               as expected by QGNAG_ExtractTuple.
##    degreeofreps             : list giving, for each representation
##                               index, the degree of that representation
##                               (used to compute dimensions).
##    filename                 : string, path of the .tex file to
##                               (over)write.
##
##  Returns true on success. The file is closed before returning.
##
DeclareGlobalFunction( "QGNAG_WriteHilbertSeriesTeX" );
DeclareGlobalFunction( "QGNAG_WeightsPermutation" );
DeclareGlobalFunction( "QGNAG_PrintWeightsPermutation" ); 
DeclareGlobalFunction( "QGNAG_WeightsPermutationToLaTeX" );
