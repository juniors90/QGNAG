DeclareGlobalFunction( "QGNAG_QuamtumCoefficientsShifted" );
# base[j] = index of the unshifted nu that column j comes from.
DeclareGlobalFunction( "QGNAG_BaseIndexOfColumns" );
# Square matrix: M[i][k] = coefficient of nu_k in epsilon_i (polynomial in q).
# The shifted copies q^-s * nu_k are collapsed into the single column k.
DeclareGlobalFunction( "QGNAG_CoefficientMatrix" );
# Connected components of the bipartite graph (rows, columns) given by M <> 0.
# Each block is rec( rows, cols, matrix ), largest first.
DeclareGlobalFunction( "QGNAG_BlockDecomposition");;
# Whole 22 x 22 matrix with rows and columns permuted to be block diagonal.
DeclareGlobalFunction( "QGNAG_BlockDiagonalMatrix" );
# Symbolic test: nu_k are indeterminates, q is the one used in nu_coeffs_pkg.
DeclareGlobalFunction( "QGNAG_TestCoefficientMatrix" );
# String of one entry coefficient (empty if it is 1; parenthesized if it has several terms).
DeclareGlobalFunction( "QGNAG_CoeffToString" );
# Explicit linear combination of a matrix row: "c1*nu_k1 + c2*nu_k2 + ..."
# `cols` are the nu indices to use for the entries of `row` (in order).
DeclareGlobalFunction( "QGNAG_RowToCombination" );
# Prints every block, one epsilon after another, as an explicit combination.
DeclareGlobalFunction( "QGNAG_PrintBlockCombinations");
# Inverse of every block. Fails loudly if a block is singular over Q(q).
# Each result block: rec( rows, cols, matrix, inverse, det )
# Meaning: nu_{cols[r]} = sum_t inverse[r][t] * eps_{rows[t]}
DeclareGlobalFunction( "QGNAG_InvertBlocks" );
# Coefficient to string, parenthesized when it is not a single term.
DeclareGlobalFunction( "QGNAG_CoeffToString2" );
# Row as explicit linear combination: "c1*prefix_k1 + c2*prefix_k2 + ..."
DeclareGlobalFunction( "QGNAG_RowToCombinationP" );
DeclareGlobalFunction( "QGNAG_PrintInverseCombinations" );
# Test: inverse * matrix = identity in every block (and the other order too).
DeclareGlobalFunction( "QGNAG_TestInverseBlocks");
DeclareGlobalFunction( "QGNAG_TopLevelPosition" );
DeclareGlobalFunction( "QGNAG_StripOuterParens" );
DeclareGlobalFunction( "QGNAG_PolyStringToLaTeX" );
DeclareGlobalFunction( "QGNAG_CoeffToLaTeX" );
DeclareGlobalFunction( "QGNAG_RowToLaTeX" );
DeclareGlobalFunction( "QGNAG_IndicesToLaTeX" ); 
DeclareGlobalFunction( "QGNAG_LoadBlockMatricesToLaTeX" );
DeclareGlobalFunction( "QGNAG_LoadBlockInversesToLaTeX" );
DeclareGlobalFunction( "QGNAG_EntryToLaTeX" );
DeclareGlobalFunction( "QGNAG_MatrixToLaTeX" ); 
DeclareGlobalFunction( "QGNAG_ColumnVectorToLaTeX" ); 
DeclareGlobalFunction( "QGNAG_MatrixEquationToLaTeX" ); 
DeclareGlobalFunction( "QGNAG_LoadBlockMatrixFormToLaTeX" );
DeclareGlobalFunction( "QGNAG_LoadBlockInverseMatrixFormToLaTeX" );
DeclareGlobalFunction( "QGNAG_AdjugateOfBlock" ); 
DeclareGlobalFunction( "QGNAG_TestAdjugateBlocks" );
DeclareGlobalFunction( "QGNAG_LoadBlockAdjugateFormToLaTeX" );