InstallGlobalFunction(QGNAG_QuamtumCoefficientsShifted, function( data_record_data_decomp )
    local names,
          n,
          R,
          x,
          q,
          d_min,
          tau,
          j,
          nu,
          nu_j;
    names := [];
    R     := PolynomialRing(Rationals, ["q"]);;
    q     := R.1;;
    tau   := QGNAG_PermutationVarChars( data_record_data_decomp );;
    nu    := QGNAG_MultiplicitiesToVector(Permuted(data_record_data_decomp, tau));;
    for n in [1 .. Length(nu)] do
        d_min := PositionProperty(nu[n],x -> Sum(x) <> 0);
        for j in [0 .. d_min - 1] do
            nu_j := q^(-j);
            Add(names, nu_j);
        od;
    od;
    return names;
end);

# base[j] = index of the unshifted nu that column j comes from.
InstallGlobalFunction(QGNAG_BaseIndexOfColumns, function( nu_coeffs )
    local base, k, j;
    base := [];
    k := 0;
    for j in [1 .. Length( nu_coeffs )] do
        if IsOne( nu_coeffs[j] ) then
            k := k + 1;
        fi;
        Add( base, k );
    od;
    return base;
end);

# Square matrix: M[i][k] = coefficient of nu_k in epsilon_i (polynomial in q).
# The shifted copies q^-s * nu_k are collapsed into the single column k.
InstallGlobalFunction(QGNAG_CoefficientMatrix, function( epsilon_and_coeffs, nu_coeffs, base )
    local n, M, i, j, row;
    n := Maximum( base );
    M := [];
    for i in [1 .. Length( epsilon_and_coeffs )] do
        row := List( [1 .. n], k -> Zero( nu_coeffs[1] ) );
        for j in [1 .. Length( base )] do
            row[ base[j] ] := row[ base[j] ]
                              + epsilon_and_coeffs[i].coefficients[j] * nu_coeffs[j];
        od;
        Add( M, row );
    od;
    return M;
end);

# Connected components of the bipartite graph (rows, columns) given by M <> 0.
# Each block is rec( rows, cols, matrix ), largest first.
InstallGlobalFunction(QGNAG_BlockDecomposition, function( M )
    local blocks, 
          i, 
          supp, 
          touching, 
          new, 
          b, 
          rest;

    blocks := [];
    for i in [1 .. Length( M )] do
        supp := Filtered( [1 .. Length( M[i] )], k -> not IsZero( M[i][k] ) );
        touching := Filtered( blocks, b -> not IsEmpty( Intersection( b.cols, supp ) ) );
        new := rec( rows := [ i ], cols := ShallowCopy( supp ) );
        for b in touching do
            new.rows := Union( new.rows, b.rows );
            new.cols := Union( new.cols, b.cols );
        od;
        rest := Filtered( blocks, b -> not ForAny( touching, t -> IsIdenticalObj( t, b ) ) );
        Add( rest, new );
        blocks := rest;
    od;
    for b in blocks do
        b.matrix := M{ b.rows }{ b.cols };
    od;
    Sort( blocks, function( a, b )
        if Length( a.rows ) <> Length( b.rows ) then
            return Length( a.rows ) > Length( b.rows );
        fi;
        return a.rows[1] < b.rows[1];
    end );
    return blocks;
end);

# Whole 22 x 22 matrix with rows and columns permuted to be block diagonal.
InstallGlobalFunction(QGNAG_BlockDiagonalMatrix, function( M )
    local blocks, rows, cols;
    blocks := QGNAG_BlockDecomposition( M );
    rows := Concatenation( List( blocks, b -> b.rows ) );
    cols := Concatenation( List( blocks, b -> b.cols ) );
    return rec( rows := rows, cols := cols, blocks := blocks, matrix := M{ rows }{ cols } );
end);


# Symbolic test: nu_k are indeterminates, q is the one used in nu_coeffs_pkg.
InstallGlobalFunction(QGNAG_TestCoefficientMatrix, function( epsilon_and_coeffs, nu_coeffs, base, M )
    local n, 
          nus, 
          lhs, 
          rhs, 
          i, 
          j, 
          bad;

    n   := Maximum( base );
    nus := List( [1 .. n], k -> Indeterminate( Rationals, Concatenation( "\\nu_{", String( k ), "}" ) ) );
    bad := [];
    for i in [1 .. Length( epsilon_and_coeffs )] do
        # via the block matrix: (M * nus)[i]
        lhs := M[i] * nus;
        # via the original expansion with the 40 shifted vectors:
        # shifted vector j = nu_coeffs[j] * nu_{base[j]}
        rhs := Sum( [1 .. Length( base )], j -> epsilon_and_coeffs[i].coefficients[j] * nu_coeffs[j] * nus[ base[j] ] );
        if lhs <> rhs then
            Add( bad, i );
        fi;
    od;
    return bad;     # [] means M * nus = epsilons for every i
end);

# String of one entry coefficient (empty if it is 1; parenthesized if it has several terms).
InstallGlobalFunction(QGNAG_CoeffToString, function( c )
    local s;
    if IsOne( c ) then
        return "";
    fi;
    s := String( c );
    if Position( s, '+' ) <> fail or PositionSublist( s, " - " ) <> fail then
        s := Concatenation( "(", s, ")" );
    fi;
    return Concatenation( s, "*" );
end);

# Explicit linear combination of a matrix row: "c1*nu_k1 + c2*nu_k2 + ..."
# `cols` are the nu indices to use for the entries of `row` (in order).
InstallGlobalFunction(QGNAG_RowToCombination, function( row, cols )
    local terms, t, k;
    terms := [];
    for t in [1 .. Length( row )] do
        if not IsZero( row[t] ) then
            k := cols[t];
            Add( terms, Concatenation( QGNAG_CoeffToString( row[t] ), "\\nu_{", String( k ), "}" ) );
        fi;
    od;
    if IsEmpty( terms ) then
        return "0";
    fi;
    return JoinStringsWithSeparator( terms, " + " );
end);

# Prints every block, one epsilon after another, as an explicit combination.
InstallGlobalFunction(QGNAG_PrintBlockCombinations, function( blocks )
    local bi, b, r;
    for bi in [1 .. Length( blocks )] do
        b := blocks[bi];
        Print( "Block ", bi, "  (", Length( b.rows ), " \\times ", Length( b.cols ), ")",
               "   epsilons = ", b.rows, "   nus = ", b.cols, "\n" );
        for r in [1 .. Length( b.rows )] do
            Print( "  \\epsilon_{", b.rows[r], "} = ", QGNAG_RowToCombination( b.matrix[r], b.cols ), "\n" );
        od;
        Print( "\n" );
    od;
    return true;
end);

# Inverse of every block. Fails loudly if a block is singular over Q(q).
# Each result block: rec( rows, cols, matrix, inverse, det )
# Meaning: nu_{cols[r]} = sum_t inverse[r][t] * eps_{rows[t]}
InstallGlobalFunction(QGNAG_InvertBlocks, function( blocks )
    local result, b, d, new;
    result := [];
    for b in blocks do
        d := DeterminantMat( b.matrix );
        if IsZero( d ) then
            Error( "Block with epsilons ", b.rows, " is singular" );
        fi;
        new := ShallowCopy( b );
        new.det     := d;
        new.inverse := Inverse( b.matrix );
        Add( result, new );
    od;
    return result;
end);

# Coefficient to string, parenthesized when it is not a single term.
InstallGlobalFunction(QGNAG_CoeffToString2, function( c )
    local s;
    if IsOne( c ) then
        return "";
    fi;
    s := String( c );
    if Position( s, '+' ) <> fail or Position( s, '/' ) <> fail
       or PositionSublist( s, " - " ) <> fail
       or ( s[1] = '-' and Length( s ) > 2 ) then
        s := Concatenation( "(", s, ")" );
    fi;
    return Concatenation( s, "*" );
end);

# Row as explicit linear combination: "c1*prefix_k1 + c2*prefix_k2 + ..."
InstallGlobalFunction(QGNAG_RowToCombinationP, function( row, idx, prefix )
    local terms,
          t;
    terms := [];
    for t in [1 .. Length( row )] do
        if not IsZero( row[t] ) then
            Add( terms, Concatenation( QGNAG_CoeffToString2( row[t] ), prefix, "_", String( idx[t] ) ) );
        fi;
    od;
    if IsEmpty( terms ) then
        return "0";
    fi;
    return JoinStringsWithSeparator( terms, " + " );
end);

InstallGlobalFunction(QGNAG_PrintInverseCombinations, function( inv_blocks )
    local bi, b, r;
    for bi in [1 .. Length( inv_blocks )] do
        b := inv_blocks[bi];
        Print( "Block ", bi, "  (", Length( b.rows ), " x ", Length( b.cols ), ")",
               "   det = ", b.det, "\n" );
        for r in [1 .. Length( b.cols )] do
            Print( "  nu_", b.cols[r], " = ",
                   QGNAG_RowToCombinationP( b.inverse[r], b.rows, "eps" ), "\n" );
        od;
        Print( "\n" );
    od;
    return true;
end);

# Test: inverse * matrix = identity in every block (and the other order too).
InstallGlobalFunction(QGNAG_TestInverseBlocks, function( inv_blocks )
    return ForAll( inv_blocks, function( b )
        local I;
        I := IdentityMat( Length( b.rows ) ) * One( b.matrix[1][1] );
        return b.inverse * b.matrix = I and b.matrix * b.inverse = I;
    end );
end);


# ---------------------------------------------------------------------------------------
# Position of the first character `ch` of s that is outside parentheses (fail if none).
InstallGlobalFunction( QGNAG_TopLevelPosition, function( s, ch )
    local depth, i;
    depth := 0;
    for i in [1 .. Length( s )] do
        if s[i] = '(' then
            depth := depth + 1;
        elif s[i] = ')' then
            depth := depth - 1;
        elif depth = 0 and s[i] = ch then
            return i;
        fi;
    od;
    return fail;
end );

# Removes one pair of parentheses if it wraps the whole string.
InstallGlobalFunction( QGNAG_StripOuterParens, function( s )
    local depth, i;
    if Length( s ) < 2 or s[1] <> '(' then
        return s;
    fi;
    depth := 0;
    for i in [1 .. Length( s )] do
        if s[i] = '(' then
            depth := depth + 1;
        elif s[i] = ')' then
            depth := depth - 1;
            if depth = 0 and i < Length( s ) then
                return s;
            fi;
        fi;
    od;
    return s{[2 .. Length( s ) - 1]};
end );

# "1-3*q^-2+q^-10"  ->  "1-3q^{-2}+q^{-10}"
InstallGlobalFunction( QGNAG_PolyStringToLaTeX, function( s )
    local result, i;
    result := "";
    i := 1;
    while i <= Length( s ) do
        if s[i] = '*' then
            i := i + 1;
        elif s[i] = '^' then
            Append( result, "^{" );
            i := i + 1;
            if i <= Length( s ) and s[i] = '-' then
                Add( result, '-' );
                i := i + 1;
            fi;
            while i <= Length( s ) and s[i] in "0123456789" do
                Add( result, s[i] );
                i := i + 1;
            od;
            Add( result, '}' );
        else
            Add( result, s[i] );
            i := i + 1;
        fi;
    od;
    return result;
end );

# LaTeX for one coefficient (rational function in q).
# Returns rec( tex, sign, isSum ): sign is "+" or "-", tex has no leading sign,
# isSum is true if tex needs parentheses when multiplying a vector name.
InstallGlobalFunction( QGNAG_CoeffToLaTeX, function( c )
    local s, p, num, den, sign, tex, SeveralTerms;

    # true if the printed polynomial has more than one term (a + or - outside parentheses, not leading, not an exponent sign)
    SeveralTerms := function( str )
        local depth, i;
        depth := 0;
        for i in [2 .. Length( str )] do
            if str[i] = '(' then
                depth := depth + 1;
            elif str[i] = ')' then
                depth := depth - 1;
            elif depth = 0 and ( str[i] = '+' or str[i] = '-' ) and str[i - 1] <> '^' then
                return true;
            fi;
        od;
        return false;
    end;

    s := QGNAG_StripOuterParens( String( c ) );
    p := QGNAG_TopLevelPosition( s, '/' );

    if p <> fail then
        num  := QGNAG_StripOuterParens( s{[1 .. p - 1]} );
        den  := QGNAG_StripOuterParens( s{[p + 1 .. Length( s )]} );
        sign := "+";
        if Length( num ) > 0 and num[1] = '-' and not SeveralTerms( num ) then
            sign := "-";
            num  := num{[2 .. Length( num )]};
        fi;
        tex := Concatenation( "\\frac{", QGNAG_PolyStringToLaTeX( num ), "}{",
                              QGNAG_PolyStringToLaTeX( den ), "}" );
        return rec( tex := tex, sign := sign, isSum := false );
    fi;

    sign := "+";
    if Length( s ) > 0 and s[1] = '-' and not SeveralTerms( s ) then
        sign := "-";
        s    := s{[2 .. Length( s )]};
    fi;
    return rec( tex := QGNAG_PolyStringToLaTeX( s ), sign := sign, isSum := SeveralTerms( s ) );
end );

# One row as a linear combination: "c_1 \nu_{k_1} + c_2 \nu_{k_2} - ..."
# idx[t] is the index of the vector multiplying row[t]; symbol is "\\nu" or "\\epsilon".
InstallGlobalFunction( QGNAG_RowToLaTeX, function( row, idx, symbol )
    local result, t, info, name, coeff, first;
    result := "";
    first := true;
    for t in [1 .. Length( row )] do
        if IsZero( row[t] ) then
            continue;
        fi;
        name := Concatenation( symbol, "_{", String( idx[t] ), "}" );
        if IsOne( row[t] ) or IsOne( -row[t] ) then
            info := rec( sign := "+", tex := "" );
            if IsOne( -row[t] ) then info.sign := "-"; fi;
            coeff := "";
        else
            info := QGNAG_CoeffToLaTeX( row[t] );
            if info.isSum then
                coeff := Concatenation( "(", info.tex, ")" );
            else
                coeff := info.tex;
            fi;
        fi;
        if first then
            if info.sign = "-" then Append( result, "-" ); fi;
            first := false;
        else
            Append( result, Concatenation( " ", info.sign, " " ) );
        fi;
        Append( result, Concatenation( coeff, name ) );
    od;
    if first then
        return "0";
    fi;
    return result;
end );

# Join a list of indices as "1, 3, 5".
InstallGlobalFunction( QGNAG_IndicesToLaTeX, function( list )
    return JoinStringsWithSeparator( List( list, String ), ", " );
end );

# epsilon_i = sum_k M[i][k] nu_k, one subsection per block.
InstallGlobalFunction( QGNAG_LoadBlockMatricesToLaTeX, function( filename, blocks )
    local out, bi, b, r;
    out := OutputTextFile( filename, false );
    for bi in [1 .. Length( blocks )] do
        b := blocks[bi];
        AppendTo( out, Concatenation(
            "\\subsubsection{Block ", String( bi ), ": $\\epsilon_{", QGNAG_IndicesToLaTeX( b.rows ),
            "}$ in terms of $\\nu_{", QGNAG_IndicesToLaTeX( b.cols ), "}$}\n",
            "Indices of the block ($", String( Length( b.rows ) ), "\\times ", String( Length( b.cols ) ),
            "$): $\\epsilon \\in \\{", QGNAG_IndicesToLaTeX( b.rows ),
            "\\}$, $\\nu \\in \\{", QGNAG_IndicesToLaTeX( b.cols ), "\\}$.\n",
            "\\begin{align*}\n" ) );
        for r in [1 .. Length( b.rows )] do
            AppendTo( out, Concatenation( "\\epsilon_{", String( b.rows[r] ), "} &= ",
                                          QGNAG_RowToLaTeX( b.matrix[r], b.cols, "\\nu" ) ) );
            if r < Length( b.rows ) then
                AppendTo( out, "\\\\\n" );
            else
                AppendTo( out, "\n" );
            fi;
        od;
        AppendTo( out, "\\end{align*}\n\n" );
    od;
    CloseStream( out );
end );

# nu_k = sum_i inverse[k][i] epsilon_i, one subsection per block.
# Needs the blocks returned by QGNAG_InvertBlocks (fields rows, cols, inverse, det).
InstallGlobalFunction( QGNAG_LoadBlockInversesToLaTeX, function( filename, inv_blocks )
    local out, bi, b, r, d;
    out := OutputTextFile( filename, false );
    for bi in [1 .. Length( inv_blocks )] do
        b := inv_blocks[bi];
        d := QGNAG_CoeffToLaTeX( b.det );
        AppendTo( out, Concatenation(
            "\\subsubsection{Block ", String( bi ), ": $\\nu_{", QGNAG_IndicesToLaTeX( b.cols ),
            "}$ in terms of $\\epsilon_{", QGNAG_IndicesToLaTeX( b.rows ), "}$}\n",
            "Indices of the block ($", String( Length( b.rows ) ), "\\times ", String( Length( b.cols ) ),
            "$): $\\epsilon \\in \\{", QGNAG_IndicesToLaTeX( b.rows ),
            "\\}$, $\\nu \\in \\{", QGNAG_IndicesToLaTeX( b.cols ), "\\}$.\n",
            "Determinant: $", d.sign, d.tex, "$.\n",
            "\\begin{align*}\n" ) );
        for r in [1 .. Length( b.cols )] do
            AppendTo( out, Concatenation( "\\nu_{", String( b.cols[r] ), "} &= ",
                                          QGNAG_RowToLaTeX( b.inverse[r], b.rows, "\\epsilon" ) ) );
            if r < Length( b.cols ) then
                AppendTo( out, "\\\\\n" );
            else
                AppendTo( out, "\n" );
            fi;
        od;
        AppendTo( out, "\\end{align*}\n\n" );
    od;
    CloseStream( out );
end );

# ---------------------------------------------------------------------------

# LaTeX of one matrix entry (no vector name attached).
InstallGlobalFunction( QGNAG_EntryToLaTeX, function( c )
    local info;
    if IsZero( c ) then
        return "0";
    fi;
    if IsOne( c ) then
        return "1";
    fi;
    if IsOne( -c ) then
        return "-1";
    fi;
    info := QGNAG_CoeffToLaTeX( c );
    if info.sign = "-" then
        return Concatenation( "-", info.tex );
    fi;
    return info.tex;
end );

# pmatrix of a list of rows.
InstallGlobalFunction( QGNAG_MatrixToLaTeX, function( mat )
    local rows, row;
    rows := List( mat, row -> JoinStringsWithSeparator(
                                  List( row, QGNAG_EntryToLaTeX ), " & " ) );
    return Concatenation( "\\begin{pmatrix}\n",
                          JoinStringsWithSeparator( rows, " \\\\\n" ),
                          "\n\\end{pmatrix}" );
end );

# Column vector "symbol_{i1}, symbol_{i2}, ..." as a pmatrix.
InstallGlobalFunction( QGNAG_ColumnVectorToLaTeX, function( idx, symbol )
    local entries;
    entries := List( idx, i -> Concatenation( symbol, "_{", String( i ), "}" ) );
    return Concatenation( "\\begin{pmatrix}\n",
                          JoinStringsWithSeparator( entries, " \\\\\n" ),
                          "\n\\end{pmatrix}" );
end );

# One equation: lhs_vector = matrix * rhs_vector.
InstallGlobalFunction( QGNAG_MatrixEquationToLaTeX, function( lhsIdx, lhsSymbol,
                                                           mat,
                                                           rhsIdx, rhsSymbol )
    return Concatenation( "\\[\n",
                          QGNAG_ColumnVectorToLaTeX( lhsIdx, lhsSymbol ),
                          "\n=\n",
                          QGNAG_MatrixToLaTeX( mat ),
                          "\n",
                          QGNAG_ColumnVectorToLaTeX( rhsIdx, rhsSymbol ),
                          "\n\\]\n" );
end );

# epsilon = M * nu, one subsection per block.
# `blocks` comes from QGNAG_BlockDecomposition (fields rows, cols, matrix).
InstallGlobalFunction( QGNAG_LoadBlockMatrixFormToLaTeX, function( filename, blocks )
    local out, bi, b;
    out := OutputTextFile( filename, false );
    SetPrintFormattingStatus( out, false );
    for bi in [1 .. Length( blocks )] do
        b := blocks[bi];
        AppendTo( out, Concatenation(
            "\\subsubsection{Block ", String( bi ), ": $\\epsilon_{", QGNAG_IndicesToLaTeX( b.rows ),
            "}$ in terms of $\\nu_{", QGNAG_IndicesToLaTeX( b.cols ), "}$}\n",
            "Indices of the block ($", String( Length( b.rows ) ), "\\times ",
            String( Length( b.cols ) ), "$): $\\epsilon \\in \\{", QGNAG_IndicesToLaTeX( b.rows ),
            "\\}$, $\\nu \\in \\{", QGNAG_IndicesToLaTeX( b.cols ), "\\}$.\n",
            QGNAG_MatrixEquationToLaTeX( b.rows, "\\epsilon", b.matrix, b.cols, "\\nu" ),
            "\n" ) );
    od;
    CloseStream( out );
end );

# nu = M^{-1} * epsilon, one subsection per block.
# `inv_blocks` comes from QGNAG_InvertBlocks (fields rows, cols, inverse, det).
InstallGlobalFunction( QGNAG_LoadBlockInverseMatrixFormToLaTeX, function( filename, inv_blocks )
    local out, bi, b, d;
    out := OutputTextFile( filename, false );
    SetPrintFormattingStatus( out, false );
    for bi in [1 .. Length( inv_blocks )] do
        b := inv_blocks[bi];
        d := QGNAG_CoeffToLaTeX( b.det );
        AppendTo( out, Concatenation(
            "\\subsubsection{Block ", String( bi ), ": $\\nu_{", QGNAG_IndicesToLaTeX( b.cols ),
            "}$ in terms of $\\epsilon_{", QGNAG_IndicesToLaTeX( b.rows ), "}$}\n",
            "Indices of the block ($", String( Length( b.rows ) ), "\\times ",
            String( Length( b.cols ) ), "$): $\\epsilon \\in \\{", QGNAG_IndicesToLaTeX( b.rows ),
            "\\}$, $\\nu \\in \\{", QGNAG_IndicesToLaTeX( b.cols ), "\\}$.\n",
            "Determinant: $", d.sign, d.tex, "$.\n",
            QGNAG_MatrixEquationToLaTeX( b.cols, "\\nu", b.inverse, b.rows, "\\epsilon" ),
            "\n" ) );
    od;
    CloseStream( out );
end );


# ------------------------------------------------------- new


# Adjugate of a block matrix: det * inverse. Its entries must be
# Laurent polynomials in q (no denominators).
InstallGlobalFunction( QGNAG_AdjugateOfBlock, function( b )
    local adj;
    adj := b.det * b.inverse;
    if not ForAll( adj, row -> ForAll( row, IsLaurentPolynomial ) ) then
        Error( "Adjugate of block ", b.rows, " is not a Laurent polynomial matrix" );
    fi;
    return adj;
end );

# Test: adj * matrix = det * identity (both orders) in every block.
InstallGlobalFunction( QGNAG_TestAdjugateBlocks, function( inv_blocks )
    return ForAll( inv_blocks, function( b )
        local adj, D;
        adj := QGNAG_AdjugateOfBlock( b );
        D   := b.det * IdentityMat( Length( b.rows ) ) * One( b.matrix[1][1] );
        return adj * b.matrix = D and b.matrix * adj = D;
    end );
end );


# nu = (1/D) * adj(A) * epsilon, one subsection per block.
# Blocks with more than maxCols columns are wrapped in \resizebox
# (needs \usepackage{graphicx}).
InstallGlobalFunction( QGNAG_LoadBlockAdjugateFormToLaTeX, function( filename, inv_blocks, maxCols )
    local out, bi, b, n, adj, detName, factor, eq;
    out := OutputTextFile( filename, false );
    SetPrintFormattingStatus( out, false );
    for bi in [1 .. Length( inv_blocks )] do
        b   := inv_blocks[bi];
        n   := Length( b.rows );
        adj := QGNAG_AdjugateOfBlock( b );
        detName := Concatenation( "D_{", String( bi ), "}" );

        AppendTo( out, Concatenation(
            "\\subsubsection{Block ", String( bi ), ": $\\nu_{", QGNAG_IndicesToLaTeX( b.cols ),
            "}$ in terms of $\\epsilon_{", QGNAG_IndicesToLaTeX( b.rows ), "}$}\n",
            "Indices of the block ($", String( n ), "\\times ", String( Length( b.cols ) ),
            "$): $\\epsilon \\in \\{", QGNAG_IndicesToLaTeX( b.rows ),
            "\\}$, $\\nu \\in \\{", QGNAG_IndicesToLaTeX( b.cols ), "\\}$.\n" ) );

        if IsOne( b.det ) then
            factor := "";
        else
            AppendTo( out, Concatenation(
                "Let $", detName, " = \\det(A_{", String( bi ), "}) = ",
                QGNAG_EntryToLaTeX( b.det ), "$ be the determinant of the block matrix ",
                "and $\\operatorname{adj}(A_{", String( bi ), "})$ its adjugate, so that ",
                "$A_{", String( bi ), "}^{-1} = \\frac{1}{", detName, "}\\operatorname{adj}(A_{",
                String( bi ), "})$.\n" ) );
            factor := Concatenation( "\\frac{1}{", detName, "}\n" );
        fi;

        eq := Concatenation( QGNAG_ColumnVectorToLaTeX( b.cols, "\\nu" ), "\n=\n",
                             factor,
                             QGNAG_MatrixToLaTeX( adj ), "\n",
                             QGNAG_ColumnVectorToLaTeX( b.rows, "\\epsilon" ), "\n" );

        if Length( b.cols ) > maxCols then
            AppendTo( out, Concatenation(
                "\\begin{center}\n\\resizebox{\\textwidth}{!}{$\\displaystyle\n",
                eq, "$}\n\\end{center}\n\n" ) );
        else
            AppendTo( out, Concatenation( "\\[\n", eq, "\\]\n\n" ) );
        fi;
    od;
    CloseStream( out );
end );