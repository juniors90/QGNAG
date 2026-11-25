#############################################################################
##  Blocks of Rep D for FK_3 over S_3 (clean version).  Same code as the new section of the notebook.
##  Run after the main loop and after data_graded:   Read( "bloques_FK3.g" );
#############################################################################

# ---------------------------------------------------------------- cell 1
# Helpers of this section (they do not depend on the package).
FK3_checks := rec( passed := 0, failed := 0 );;

FK3_Check := function( label, condition )
    if condition = true then
        FK3_checks.passed := FK3_checks.passed + 1;
        Print( "[ OK ]  ", label, "\n" );
    else
        FK3_checks.failed := FK3_checks.failed + 1;
        Print( "[FAIL]  ", label, "\n" );
    fi;
end;;

FK3_Summary := function()
    Print( "\n", FK3_checks.passed, " of ", FK3_checks.passed + FK3_checks.failed, " checks passed.\n" );
    if FK3_checks.failed = 0 then
        Print( "ALL CHECKS PASSED\n" );
    else
        Print( "SOME CHECKS FAILED\n" );
    fi;
end;;

# Directory of the .tex files ("" = current directory; otherwise it must end with "/").
FK3_OUTDIR := "";;

# Runs func( args ) and returns [ true, result ] or [ false, message ] instead of stopping the cell.
FK3_Try := function( func, args )
    local saved, result;
    saved        := BreakOnError;
    BreakOnError := false;
    result       := CALL_WITH_CATCH( func, args );
    BreakOnError := saved;
    return result;
end;;

# Calls writer( file ) and checks that the file was written; an error in one writer does not stop the others.
FK3_TryWrite := function( name, writer )
    local file, result, ok;
    file := Concatenation( FK3_OUTDIR, name );
    if IsExistingFile( file ) then
        RemoveFile( file );
    fi;
    result := FK3_Try( writer, [ file ] );
    ok     := ( result[1] = true and IsExistingFile( file ) );
    FK3_Check( Concatenation( "written: ", file ), ok );
    if not ok then
        Print( "        the writer failed: run it alone in a new cell to see the error message\n" );
    fi;
end;;

# Functions of the package and data from the earlier cells that this section uses.
fk3_needed  := [ "QGNAG_Decomposition", "QGNAG_IndexVarChars", "QGNAG_PermutationVarChars",
                 "QGNAG_GetShiftedBijs", "QGNAG_MultiplicitiesToDecomposition", "QGNAG_PermutationFromRecInfo",
                 "QGNAG_AllShiftLeft", "QGNAG_VermaModuleCharactersAndCoefficients",
                 "QGNAG_QuantumPolynomialsToRecord", "QGNAG_EvaluateQuantumPolynomialsRecord",
                 "QGNAG_NamesOfShiftedVectors", "QGNAG_PrintQuantumPolynomials",
                 "data_record_data_decomp", "data_graded", "SimpleNames" ];;
fk3_missing := Filtered( fk3_needed, n -> not IsBoundGlobal( n ) );;
if fk3_missing <> [] then
    Print( "[MISSING]  not defined: ", fk3_missing, "\n" );
    Print( "           functions: install the klreview files of the package and restart GAP;\n" );
    Print( "           data: run the main loop and the cell that defines data_graded first.\n" );
else
    Print( "[ OK ]  all the functions and the data of this section are available\n" );
fi;

# ---------------------------------------------------------------- cell 2
FK3_Check( "8 simple modules: data_record_data_decomp", Length( data_record_data_decomp ) = 8 );
FK3_Check( "8 simple names: SimpleNames",              Length( SimpleNames ) = 8 );
FK3_Check( "8 graded Verma data: data_graded",         Length( data_graded ) = 8 );
Print( "numbering of the weights: ", List( [ 1 .. Length( SimpleNames ) ], i -> [ i, SimpleNames[i] ] ), "\n" );

data_rec_info     := List( data_record_data_decomp, QGNAG_Decomposition );;
vee               := PermList( List( data_rec_info, QGNAG_IndexVarChars ) );;
tau               := QGNAG_PermutationVarChars( data_record_data_decomp );;
bijs_by_degree    := List( Permuted( data_record_data_decomp, tau ), QGNAG_GetShiftedBijs );;
data_rec_info_neg := List( bijs_by_degree, QGNAG_MultiplicitiesToDecomposition );;
sigma             := QGNAG_PermutationFromRecInfo( data_rec_info_neg );;
Print( "vee   = ", vee, "\ntau   = ", tau, "\nsigma = ", sigma, "\n" );

FK3_Check( "vee = identity (B^top(V) = M(e,+) is trivial)",                   vee = () );
FK3_Check( "tau = (3,6): S(e,rho) = L(tau,0) and S(tau,0) = L(e,rho)",        tau = (3,6) );
FK3_Check( "sigma = (3,6): bottom weight of L(e,rho) is (tau,0) and conversely", sigma = (3,6) );
FK3_Check( "tau = vee * sigma",                                               tau = vee * sigma );

# ---------------------------------------------------------------- cell 3
shifted_vectors        := QGNAG_AllShiftLeft( data_record_data_decomp );;
epsilon_and_coeffs     := QGNAG_VermaModuleCharactersAndCoefficients( data_graded, shifted_vectors );;
data_quantum_pols      := QGNAG_QuantumPolynomialsToRecord( Permuted( data_record_data_decomp, sigma ), epsilon_and_coeffs );;
data_quantum_pols_eval := QGNAG_EvaluateQuantumPolynomialsRecord( data_quantum_pols );;
NuVectorNamesPermuted  := QGNAG_NamesOfShiftedVectors( data_record_data_decomp );;

# eps_p = sum_q t_{p,q} nu_q  (compare with the table of the cell "Polynomials t_{j,p}" above).
QGNAG_PrintQuantumPolynomials( epsilon_and_coeffs, NuVectorNamesPermuted );

# t_{p,q}(1) as a matrix (0 for the entries that are not stored).
fk3_value := function( eval, p, q )
    if String( q ) in RecNames( eval[p] ) then
        return eval[p].(String( q ));
    fi;
    return 0;
end;;
fk3_T := List( [ 1 .. 8 ], p -> List( [ 1 .. 8 ], q -> fk3_value( data_quantum_pols_eval, p, q ) ) );;
Print( "t_{p,q}(1):\n" );
Display( fk3_T );

# Expected values for FK_3 (rows p = Verma module, columns q = simple head L(q)).
fk3_E := [ [ 2, 0, 0, 0, 1, 0, 0, 0 ],
           [ 0, 1, 0, 0, 0, 0, 0, 0 ],
           [ 0, 0, 1, 0, 1, 1, 0, 0 ],
           [ 0, 0, 0, 1, 0, 0, 0, 0 ],
           [ 2, 0, 1, 0, 2, 1, 0, 0 ],
           [ 0, 0, 1, 0, 1, 1, 0, 0 ],
           [ 0, 0, 0, 0, 0, 0, 1, 0 ],
           [ 0, 0, 0, 0, 0, 0, 0, 1 ] ];;
fk3_dimL := [ 1, 12, 7, 36, 10, 7, 24, 24 ];;     # dim L(q)
fk3_dimM := [ 1, 1, 2, 3, 3, 2, 2, 2 ];;          # dim M(p);  dim of the Verma module = 12 * dim M(p)

FK3_Check( "8 Verma characters: Length( epsilon_and_coeffs ) = 8", Length( epsilon_and_coeffs ) = 8 );
FK3_Check( "t_{p,p}(1) > 0 for every p (so that p belongs to R_p)",      ForAll( [ 1 .. 8 ], p -> fk3_T[p][p] > 0 ) );
FK3_Check( "sum_q t_{p,q}(1) dim L(q) = 12 dim M(p)  (dimension of every Verma module)",
           ForAll( [ 1 .. 8 ], p -> Sum( [ 1 .. 8 ], q -> fk3_T[p][q] * fk3_dimL[q] ) = 12 * fk3_dimM[p] ) );
FK3_Check( "t_{p,q}(1) = composition multiplicities of the paper (Theorems 6--10)", fk3_T = fk3_E );

# ---------------------------------------------------------------- cell 4
# R_p = { q : t_{p,q}(1) <> 0  (or / and)  t_{q,p}(1) <> 0 };  B_1 = R_p,  B_{k+1} = union of R_q over q in B_k.
FK3_BlocksFromRelation := function( pols, requireBoth )
    local n, R, p, q, tpq, tqp, related, visited, blocks, index, block, blockNext, stable;
    n := Length( pols );
    R := List( [ 1 .. n ], x -> [] );
    for p in [ 1 .. n ] do
        for q in [ 1 .. n ] do
            tpq := Sum( pols[p].(String( q )) );     # value at 1 = sum of the coefficients
            tqp := Sum( pols[q].(String( p )) );
            if requireBoth then
                related := ( tpq <> 0 and tqp <> 0 );
            else
                related := ( tpq <> 0 or tqp <> 0 );
            fi;
            if related then
                Add( R[p], q );
            fi;
        od;
        if not p in R[p] then
            Error( "FK3_BlocksFromRelation: p = ", p, " is not in R_p (t_{p,p}(1) = 0)" );
        fi;
    od;
    visited := List( [ 1 .. n ], x -> false );
    blocks  := rec();
    index   := 1;
    for p in [ 1 .. n ] do
        if not visited[p] then
            block := Set( R[p] );
            repeat
                blockNext := Set( Concatenation( List( block, x -> R[x] ) ) );
                stable    := ( blockNext = block );
                block     := blockNext;
            until stable;
            for q in block do
                visited[q] := true;
            od;
            blocks.(String( index )) := block;
            index := index + 1;
        fi;
    od;
    return blocks;
end;;

if IsBoundGlobal( "QGNAG_ClassifySimplesIntoBlocksByRelation" ) then
    block_classification := QGNAG_ClassifySimplesIntoBlocksByRelation( data_quantum_pols );;
else
    block_classification := FK3_BlocksFromRelation( data_quantum_pols, false );;
fi;

fk3_nblocks := Length( RecNames( block_classification ) );;
for fk3_k in [ 1 .. fk3_nblocks ] do
    fk3_b := block_classification.(String( fk3_k ));
    Print( "B_", fk3_k, " = ", fk3_b, "   ", List( fk3_b, i -> SimpleNames[i] ), "\n" );
od;

fk3_sets := Set( List( [ 1 .. fk3_nblocks ], k -> block_classification.(String( k )) ) );;
fk3_or   := FK3_BlocksFromRelation( data_quantum_pols, false );;
fk3_and  := FK3_BlocksFromRelation( data_quantum_pols, true );;

FK3_Check( "5 blocks", fk3_nblocks = 5 );
FK3_Check( "block sizes: four of size 1 and one of size 4", Collected( List( fk3_sets, Length ) ) = [ [ 1, 4 ], [ 4, 1 ] ] );
FK3_Check( "blocks = {1,3,5,6}, {2}, {4}, {7}, {8}", fk3_sets = Set( [ [ 1, 3, 5, 6 ], [ 2 ], [ 4 ], [ 7 ], [ 8 ] ] ) );
FK3_Check( "the blocks of size 1 are the simple Verma modules (2,4,7,8)",
           Concatenation( Filtered( fk3_sets, b -> Length( b ) = 1 ) ) = [ 2, 4, 7, 8 ] );
FK3_Check( "the classification of the package = the one with 'or'", block_classification = fk3_or );
FK3_Check( "'or' and 'and' give the same blocks", fk3_or = fk3_and );

# ---------------------------------------------------------------- cell 5
# LaTeX file with the blocks (the writer was renamed in the package; use the one that is loaded).
if IsBoundGlobal( "QGNAG_LoadBlockClassificationToLaTeX" ) then
    QGNAG_LoadBlockClassificationToLaTeX( "block_classification_FK3.tex", block_classification, SimpleNames );
elif IsBoundGlobal( "QGNAG_SaveBlockClassificationToLaTeX" ) then
    QGNAG_SaveBlockClassificationToLaTeX( "block_classification_FK3.tex", block_classification, SimpleNames );
else
    Print( "[SKIP]  no LaTeX writer for the block classification is loaded\n" );
fi;
FK3_Summary();

# ---------------------------------------------------------------- cell 6
# Functions of the package used in sections 4 and 5.
fk3_needed_B := [ "QGNAG_QuamtumCoefficientsShifted", "QGNAG_BaseIndexOfColumns", "QGNAG_CoefficientMatrix",
                  "QGNAG_BlockDecomposition", "QGNAG_InvertBlocks", "QGNAG_TestCoefficientMatrix", "QGNAG_TestInverseBlocks",
                  "QGNAG_LoadBlockMatricesToLaTeX", "QGNAG_LoadBlockMatrixFormToLaTeX", "QGNAG_LoadBlockInversesToLaTeX",
                  "QGNAG_LoadBlockInverseMatrixFormToLaTeX", "QGNAG_LoadBlockAdjugateFormToLaTeX",
                  "QGNAG_WritePolynomialsKLTeX", "QGNAG_WriteSeriesKLTeX",
                  "QGNAG_LoadQuantumCharactersToLaTeX", "QGNAG_ThePolynomialCoefficients" ];;
fk3_missing_B := Filtered( fk3_needed_B, n -> not IsBoundGlobal( n ) );;
if fk3_missing_B <> [] then
    Print( "[MISSING]  not defined: ", fk3_missing_B, "\n" );
else
    Print( "[ OK ]  all the functions of sections 4 and 5 are available\n" );
fi;

nu_coeffs_pkg := QGNAG_QuamtumCoefficientsShifted( data_record_data_decomp );;     # (sic) name used by the package
coeff_base    := QGNAG_BaseIndexOfColumns( nu_coeffs_pkg );;
coeff_M       := QGNAG_CoefficientMatrix( epsilon_and_coeffs, nu_coeffs_pkg, coeff_base );;
blocks_M      := QGNAG_BlockDecomposition( coeff_M );;
inv_blocks    := QGNAG_InvertBlocks( blocks_M );;

FK3_Check( "coefficient matrix reproduces the Verma characters",
           QGNAG_TestCoefficientMatrix( epsilon_and_coeffs, nu_coeffs_pkg, coeff_base, coeff_M ) = [] );
FK3_Check( "every block is square (rows = columns)", ForAll( blocks_M, b -> b.rows = b.cols ) );
FK3_Check( "blocks of M: sizes 4 x 1, 1 x 4",        Collected( List( blocks_M, b -> Length( b.rows ) ) ) = [ [ 1, 4 ], [ 4, 1 ] ] );
FK3_Check( "classification = block decomposition of M",
           Set( List( [ 1 .. fk3_nblocks ], k -> block_classification.(String( k )) ) ) = Set( List( blocks_M, b -> Set( b.cols ) ) ) );
FK3_Check( "QGNAG_TestInverseBlocks",                QGNAG_TestInverseBlocks( inv_blocks ) = true );
FK3_Check( "inverse * matrix = identity in every block",
           ForAll( inv_blocks, b -> b.inverse * b.matrix = IdentityMat( Length( b.rows ) ) * One( b.matrix[1][1] ) ) );

# Determinants (compare with the expected (1-q^-2)^2 (1-q^-6) of the size-4 block).
for fk3_i in [ 1 .. Length( inv_blocks ) ] do
    if IsBound( inv_blocks[fk3_i].det ) then
        Print( "block ", fk3_i, " ", inv_blocks[fk3_i].cols, ":  det = ", inv_blocks[fk3_i].det, "\n" );
    fi;
od;

# Informative only (not counted in the summary).
fk3_adj := FK3_Try( QGNAG_TestAdjugateBlocks, [ inv_blocks ] );;
if fk3_adj[1] = true and Length( fk3_adj ) > 1 then
    Print( "[INFO]  QGNAG_TestAdjugateBlocks = ", fk3_adj[2], "   (informative)\n" );
else
    Print( "[INFO]  QGNAG_TestAdjugateBlocks raised an error   (informative)\n" );
fi;

# ---------------------------------------------------------------- cell 7
# The five files of the blocks.
FK3_TryWrite( "block_matrices_FK3.tex",               function( f ) QGNAG_LoadBlockMatricesToLaTeX( f, blocks_M ); end );
FK3_TryWrite( "block_matrix_form_FK3.tex",            function( f ) QGNAG_LoadBlockMatrixFormToLaTeX( f, blocks_M ); end );
FK3_TryWrite( "block_inverses_FK3.tex",               function( f ) QGNAG_LoadBlockInversesToLaTeX( f, inv_blocks ); end );
FK3_TryWrite( "block_inverse_matrix_form_FK3.tex",    function( f ) QGNAG_LoadBlockInverseMatrixFormToLaTeX( f, inv_blocks ); end );
FK3_TryWrite( "block_adjugate_form_FK3.tex",          function( f ) QGNAG_LoadBlockAdjugateFormToLaTeX( f, inv_blocks, 1 ); end );

# polynomialsKL and seriesKL, and the quantum characters.
FK3_TryWrite( "polynomialsKL_FK3.tex",                function( f ) QGNAG_WritePolynomialsKLTeX( f, blocks_M ); end );
FK3_TryWrite( "seriesKL_FK3.tex",                     function( f ) QGNAG_WriteSeriesKLTeX( f, inv_blocks ); end );
FK3_TryWrite( "quantum_characters_FK3.tex",           function( f ) QGNAG_LoadQuantumCharactersToLaTeX( f, epsilon_and_coeffs, NuVectorNamesPermuted, SimpleNames ); end );
FK3_TryWrite( "the_polynomial_coefficients_FK3.tex",  function( f ) QGNAG_ThePolynomialCoefficients( f, Permuted( data_record_data_decomp, sigma ), epsilon_and_coeffs, SimpleNames ); end );

FK3_Summary();
