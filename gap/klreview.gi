#############################################################################
##
#W  klreview.gi                                  QGNAG
##
##  Implementation of klreview.gd.
##
##  The functions are defined with  NAME := function ... end  (after MakeReadWriteGlobal) instead of InstallGlobalFunction,
##  so that they replace a function of the same name already installed by another file of the package.
##
#############################################################################

#############################################################################
##  Checks
#############################################################################

MakeReadWriteGlobal( "QGNAG_ResetChecks" );
QGNAG_ResetChecks := function(  )
    QGNAG_CHECKS.results := [];
end;;
MakeReadOnlyGlobal( "QGNAG_ResetChecks" );

MakeReadWriteGlobal( "QGNAG_Check" );
QGNAG_Check := function( label, condition )
    local ok;
    ok := ( condition = true );
    Add( QGNAG_CHECKS.results, ok );
    if ok then
        Print( "[ OK ]  ", label, "\n" );
    else
        Print( "[FAIL]  ", label, "\n" );
    fi;
end;;
MakeReadOnlyGlobal( "QGNAG_Check" );

MakeReadWriteGlobal( "QGNAG_ChecksSummary" );
QGNAG_ChecksSummary := function(  )
    local results;
    results := QGNAG_CHECKS.results;
    Print( "\n", Number( results, x -> x ), " of ", Length( results ), " checks passed.\n" );
    if ForAll( results, x -> x ) then
        Print( "ALL CHECKS PASSED\n" );
        return true;
    fi;
    Print( "SOME CHECKS FAILED: see the lines starting with [FAIL]\n" );
    return false;
end;;
MakeReadOnlyGlobal( "QGNAG_ChecksSummary" );

MakeReadWriteGlobal( "QGNAG_FileContains" );
QGNAG_FileContains := function( filename, text )
    return PositionSublist( StringFile( filename ), text ) <> fail;
end;;
MakeReadOnlyGlobal( "QGNAG_FileContains" );

MakeReadWriteGlobal( "QGNAG_CountInFile" );
QGNAG_CountInFile := function( filename, text )
    local s, i, n, len;
    s   := StringFile( filename );
    len := Length( text );
    n   := 0;
    for i in [ 1 .. Length( s ) - len + 1 ] do
        if s{ [ i .. i + len - 1 ] } = text then
            n := n + 1;
        fi;
    od;
    return n;
end;;
MakeReadOnlyGlobal( "QGNAG_CountInFile" );

#############################################################################
##  Weights and quantum polynomials
#############################################################################

MakeReadWriteGlobal( "QGNAG_IndexVarChars" );
QGNAG_IndexVarChars := function( rec_info )
    local degrees, max_degree, pair;
    degrees    := List(RecNames(rec_info), Int);
    max_degree := Maximum(degrees);
    pair       := rec_info.(max_degree);
    return pair[1][2];
end;;
MakeReadOnlyGlobal( "QGNAG_IndexVarChars" );

MakeReadWriteGlobal( "QGNAG_PrintQuantumPolynomials" );
QGNAG_PrintQuantumPolynomials := function( epsilon_and_coeffs, nu_names )
    local theta, index_s;
    theta := Length(epsilon_and_coeffs);
    for index_s in [1 .. theta] do
        Print(QGNAG_EpsilonToLaTeX(index_s, epsilon_and_coeffs, nu_names), "\n");
    od;
end;;
MakeReadOnlyGlobal( "QGNAG_PrintQuantumPolynomials" );

MakeReadWriteGlobal( "QGNAG_GraphFromQuantumPols" );
QGNAG_GraphFromQuantumPols := function( data_quantum_pols_eval )
    local theta, edges, p, q;
    theta := Length(data_quantum_pols_eval);
    edges := [];
    for p in [1 .. theta] do
        for q in [p + 1 .. theta] do
            if data_quantum_pols_eval[p].(String(q)) + data_quantum_pols_eval[q].(String(p)) <> 0 then
                Add(edges, [p, q]);
            fi;
        od;
    od;
    return rec(nodes := [1 .. theta], edges := edges);
end;;
MakeReadOnlyGlobal( "QGNAG_GraphFromQuantumPols" );

#############################################################################
##  Decompositions by negative degree (from test_review.g)
#############################################################################

MakeReadWriteGlobal( "QGNAG_DecompositionFromNegativeDegreeToZero" );
QGNAG_DecompositionFromNegativeDegreeToZero := function( record_data_decomp )
    local n_top,
          zero_vector,
          nonzero_keys,
          first_nonzero_degree,
          shift,
          shifted,
          bijs_by_degree,
          used_degrees,
          key,
          degree,
          value,
          new_degree,
          remaining_degrees,
          d;
    bijs_by_degree := QGNAG_MultiplicitiesByNegativeDegree( record_data_decomp );;
    n_top        := Length(RecNames(bijs_by_degree)) - 1;
    zero_vector  := List( bijs_by_degree.(RecNames(bijs_by_degree)[1]), x -> 0 );
    nonzero_keys := Filtered( RecNames(bijs_by_degree), key -> Sum(bijs_by_degree.(key)) <> 0 );
    if IsEmpty(nonzero_keys) then
        Error("all multiplicity vectors are zero");
    fi;
    first_nonzero_degree := Maximum( List(nonzero_keys, Int) );
    shift                := -first_nonzero_degree;
    shifted              := rec();
    used_degrees := [];
    for key in nonzero_keys do
        degree                       := Int(key);
        value                        := bijs_by_degree.(key);
        new_degree                   := degree + shift;
        shifted.(String(new_degree)) := value;
        Add(used_degrees, new_degree);
    od;
    Sort(used_degrees);
    remaining_degrees := Filtered( [-n_top .. 0], d -> not d in used_degrees );
    for d in remaining_degrees do
        shifted.(String(d)) := zero_vector;
    od;
    return shifted;
end;;
MakeReadOnlyGlobal( "QGNAG_DecompositionFromNegativeDegreeToZero" );

MakeReadWriteGlobal( "QGNAG_DecompositionFromNegativeDegree" );
QGNAG_DecompositionFromNegativeDegree := function( j, record_data_decomp )
    local rec_info,
          degrees,
          n_top,
          rec_bijs,
          bijs,
          decomposition,
          pair;

    rec_info := QGNAG_Decomposition( record_data_decomp );;
    degrees  := List( RecNames( rec_info ), Int );;
    n_top    := Maximum( degrees );;
    if not j in [0 .. n_top] then
        Error( StringFormatted( "The degree {} is not present in rec_info.", j ) );
    fi;

    rec_bijs := rec();;

    # Initialize all multiplicities to zero
    bijs := List([1 .. Length( record_data_decomp )], x -> 0);;
    if not IsBound( rec_info.(String(j)) ) then
        rec_bijs.(String(-j)) := bijs;
        return rec_bijs;
    fi;
    # Decomposition at degree j
    decomposition := rec_info.(String(j));;
    # Fill the multiplicities
    for pair in decomposition do
        bijs[pair[2]] := pair[1];
    od;
    rec_bijs.(String(-j)) := bijs;
    return rec_bijs;
end;;
MakeReadOnlyGlobal( "QGNAG_DecompositionFromNegativeDegree" );

MakeReadWriteGlobal( "QGNAG_PrintDecompositionFromNegativeDegree" );
QGNAG_PrintDecompositionFromNegativeDegree := function( rec_bijs )
    local name,
          bijs,
          nonzero,
          i,
          coeff,
          first;
    for name in RecNames( rec_bijs ) do
        bijs := rec_bijs.(name);;
        # Positions of the non-zero coefficients
        nonzero := Filtered(
            [1 .. Length(bijs)],
            i -> bijs[i] <> 0
        );;
        if Length(nonzero) = 0 then
            continue;
        fi;
        Print("degree ", name, " = ");
        first := true;
        for i in nonzero do
            coeff := bijs[i];;
            if not first then
                Print(" + ");
            fi;
            if coeff = 1 then
                Print("M", i);
            else
                Print(coeff, "*M", i);
            fi;
            first := false;
        od;

        Print("\n");

    od;
end;;
MakeReadOnlyGlobal( "QGNAG_PrintDecompositionFromNegativeDegree" );

MakeReadWriteGlobal( "QGNAG_FilterZeroDecompositions" );
QGNAG_FilterZeroDecompositions := function( rec_bijs )
    local rec_filtered, name;
    rec_filtered := rec();;
    for name in RecNames( rec_bijs ) do
        if not ForAll(rec_bijs.(name), x -> x = 0) then
            rec_filtered.(name) := rec_bijs.(name);;
        fi;
    od;
    return rec_filtered;
end;;
MakeReadOnlyGlobal( "QGNAG_FilterZeroDecompositions" );

MakeReadWriteGlobal( "QGNAG_DecompositionToString" );
QGNAG_DecompositionToString := function( rec_bijs )
    local name,
          bijs,
          nonzero,
          i,
          degrees,
          coeff,
          terms,
          term;
          
    terms := [];
    degrees := List(RecNames( rec_bijs ), Int);
    Sort(degrees);
    for name in degrees do
        bijs := rec_bijs.(String(name));;
        nonzero := Filtered( [1 .. Length(bijs)], i -> bijs[i] <> 0 );;
        for i in nonzero do
            coeff := bijs[i];
            if coeff = 1 then
                term := Concatenation( "M", String(i), "[", String(name), "]" );
            else
                term := Concatenation( String(coeff), "*M", String(i), "[", String(name), "]");
            fi;
            Add(terms, term);
        od;
    od;
    return Concatenation("Char = ", JoinStringsWithSeparator(terms, " + "));
end;;
MakeReadOnlyGlobal( "QGNAG_DecompositionToString" );


#############################################################################
##  Hilbert series
#############################################################################

MakeReadWriteGlobal( "QGNAG_HilbertSeriesCoefficients" );
QGNAG_HilbertSeriesCoefficients := function( data_record_data_decomp, degreeofreps )
    local tau,
          data_rec_info_to_zero_negative,
          data_rec_info_to_zero_negative_permuted,
          theta,
          i,
          rec_info,
          degrees,
          d,
          pair,
          mult,
          idx,
          total,
          series,
          result;

    tau := QGNAG_PermutationVarChars(data_record_data_decomp);
    data_rec_info_to_zero_negative := List(data_record_data_decomp, QGNAG_PrepareDecomposition);
    data_rec_info_to_zero_negative_permuted := Permuted(data_rec_info_to_zero_negative, tau);
    theta  := Length(data_rec_info_to_zero_negative_permuted);
    result := [];

    for i in [1 .. theta] do
        rec_info := data_rec_info_to_zero_negative_permuted[i];
        degrees := List(RecNames(rec_info), Int);
        Sort(degrees);
        series := [];
        for d in degrees do
            total := 0;
            for pair in rec_info.(String(d)) do
                mult  := pair[1];
                idx   := pair[2];
                total := total + mult * degreeofreps[idx];
            od;
            Add(series, [total, d]);
        od;
        Add(result, series);
    od;
    return result;
end;;
MakeReadOnlyGlobal( "QGNAG_HilbertSeriesCoefficients" );

MakeReadWriteGlobal( "QGNAG_HilbertSeriesNegativePart" );
QGNAG_HilbertSeriesNegativePart := function( data_record_data_decomp, degreeofreps )
    local full, result, series, neg_part;

    full   := QGNAG_HilbertSeriesCoefficients(data_record_data_decomp, degreeofreps);
    result := [];

    for series in full do
        neg_part := Filtered(series, pair -> pair[2] <= 0);
        Add(result, neg_part);
    od;

    return result;
end;;
MakeReadOnlyGlobal( "QGNAG_HilbertSeriesNegativePart" );

MakeReadWriteGlobal( "QGNAG_IsPal" );
QGNAG_IsPal := function( L )
    local m, k;

    m := Length(L);

    for k in [1 .. QuoInt(m, 2)] do
        if L[k][1] <> L[m - k + 1][1] then
            return false;
        fi;
    od;

    return true;
end;;
MakeReadOnlyGlobal( "QGNAG_IsPal" );

MakeReadWriteGlobal( "QGNAG_HilbertSeriesIsPalindromic" );
QGNAG_HilbertSeriesIsPalindromic := function( data_record_data_decomp, degreeofreps )
    local full, result, series;

    full   := QGNAG_HilbertSeriesCoefficients(data_record_data_decomp, degreeofreps);
    result := [];

    for series in full do
        Add(result, QGNAG_IsPal(series));
    od;

    return result;
end;;
MakeReadOnlyGlobal( "QGNAG_HilbertSeriesIsPalindromic" );

MakeReadWriteGlobal( "QGNAG_HilbertSectionToLaTeX" );
QGNAG_HilbertSectionToLaTeX := function( filename, data_rec_info, names, degreeofreps, pals )
    local nW, series, dims, n_top, Lambda_L, Lambda_V, rest, palindromic, notpal,
          FamilyOf, SeriesToString, SetToString, Roman, out, Emit,
          familydata, f, fam, sym, style, with_subset, all_in_fam, members, groups,
          pos, i, k, g, lambdaset, excluded, chunks, result;

    nW := Length( data_rec_info );
    if Length( names ) <> nW or Length( degreeofreps ) <> nW or Length( pals ) <> nW then
        Error( "data_rec_info, names, degreeofreps and pals must have the same length" );
    fi;

    # series[i] = [ [degree, total], ... ] sorted by degree; total = dimension of the graded piece
    series := List( data_rec_info, function( rec_info )
        local degrees, d, res;
        degrees := List( RecNames( rec_info ), Int );
        Sort( degrees );
        res := [];
        for d in degrees do
            Add( res, [ d, Sum( rec_info.(String(d)), p -> p[1] * degreeofreps[ p[2] ] ) ] );
        od;
        return res;
    end );
    dims   := List( series, s -> Sum( s, p -> p[2] ) );
    n_top  := Maximum( List( series, Length ) );
    Lambda_L := Filtered( [1 .. nW], i -> Length( series[i] ) = 1 );
    Lambda_V := Filtered( [1 .. nW], i -> Length( series[i] ) = n_top );
    rest     := Difference( [1 .. nW], Union( Lambda_L, Lambda_V ) );

    notpal      := Filtered( [1 .. nW], i -> pals[i] <> true );
    palindromic := IsEmpty( notpal );
    if not palindromic then
        Print( "[WARNING] H(lambda) is not palindromic for the weights ", notpal, "\n" );
    fi;

    FamilyOf := function( name )
        if PositionSublist( name, "\\tau" ) <> fail then return "tau";
        elif PositionSublist( name, "\\rho" ) <> fail then return "rho";
        elif PositionSublist( name, "\\chi" ) <> fail then return "chi";
        elif PositionSublist( name, "\\eta" ) <> fail then return "eta";
        fi;
        Error( "unknown family in the name ", name );
    end;

    SeriesToString := function( s )
        local terms, p, term;
        terms := [];
        for p in s do
            if p[2] = 0 then continue; fi;
            if p[1] = 0 then
                term := String( p[2] );
            elif p[2] = 1 then
                term := Concatenation( "t^{", String( p[1] ), "}" );
            else
                term := Concatenation( String( p[2] ), "t^{", String( p[1] ), "}" );
            fi;
            Add( terms, term );
        od;
        return JoinStringsWithSeparator( terms, " + " );
    end;

    SetToString := function( positions )
        return Concatenation( "\\{", JoinStringsWithSeparator( List( positions, i -> names[i] ), ", " ), "\\}" );
    end;

    Roman := [ "i", "ii", "iii", "iv", "v", "vi", "vii", "viii", "ix", "x", "xi", "xii", "xiii", "xiv", "xv", "xvi" ];

    out := OutputTextFile( filename, false );
    SetPrintFormattingStatus( out, false );
    Emit := function( str ) AppendTo( out, str ); end;

    # ------------------------------------------------------------------ introduction and lemma
    Emit( "\\subsection{Hilbert series}\\label{sec:hilbert}\n\n" );
    Emit( "We compute the Hilbert series and the dimension of every simple $\\D$-module. " );
    Emit( "This is done in \\com{socle.gi} as explained above.\n\n" );
    Emit( "Let us first extract the information about $\\Lambda_L\\cup\\Lambda_V$.\n" );
    Emit( "\\begin{lemma}\n\tThe following holds:\n\t\\begin{align*}\n" );
    Emit( Concatenation( "\t\t\\Lambda_L&= ", SetToString( Lambda_L ), ", \\\\\n" ) );
    chunks := [];
    for k in [ 0 .. QuoInt( Length( Lambda_V ) + 3, 4 ) - 1 ] do
        Add( chunks, Lambda_V{ [ 4*k + 1 .. Minimum( 4*k + 4, Length( Lambda_V ) ) ] } );
    od;
    Emit( "\t\t\\Lambda_V&=\\{" );
    for k in [ 1 .. Length( chunks ) ] do
        if k > 1 then Emit( "\t\t&\\qquad " ); fi;
        Emit( JoinStringsWithSeparator( List( chunks[k], i -> names[i] ), ", " ) );
        if k < Length( chunks ) then Emit( ", \\\\\n" ); fi;
    od;
    Emit( "\\}.\n\t\\end{align*}\n\\end{lemma}\n" );
    Emit( "\\begin{proof}\n\tComputed with \\texttt{socle.gi}.\n\\end{proof}\n" );

    # ------------------------------------------------------------------ proposition
    Emit( "\\begin{proposition}\\label{pro:verma-simple}\n\tThe following holds.\n\t\\begin{enumerate}[leftmargin=*]\n" );
    familydata := [ [ "tau", "\\tau", "A", true ], [ "rho", "\\rho", "A", false ],
                    [ "chi", "\\chi", "A", false ], [ "eta", "\\eta", "B", false ] ];
    result := rec( L := Lambda_L, V := Lambda_V, groups := rec(), dims := dims, palindromic := palindromic );
    for f in familydata do
        fam := f[1];  sym := f[2];  style := f[3];  with_subset := f[4];
        all_in_fam := Filtered( [ 1 .. nW ], i -> FamilyOf( names[i] ) = fam );
        members    := Filtered( rest, i -> FamilyOf( names[i] ) = fam );
        if IsEmpty( members ) then continue; fi;
        excluded := Length( members ) < Length( all_in_fam );
        groups := [];
        for i in members do
            pos := PositionProperty( groups, g -> series[ g[1] ] = series[i] );
            if pos = fail then Add( groups, [ i ] ); else Add( groups[pos], i ); fi;
        od;
        result.groups.(fam) := groups;
        lambdaset := Concatenation( "\\Lambda_", sym, "'" );
        if not excluded then lambdaset := Concatenation( lambdaset, "=\\Lambda_", sym ); fi;
        if Length( groups ) = 1 then
            Emit( Concatenation( "\t\t\\item Assume $\\lambda\\in ", lambdaset, "=", SetToString( groups[1] ), "$. Then\n" ) );
            Emit( Concatenation( "\t\t\\[\n\t\t\\H(\\lambda)=", SeriesToString( series[ groups[1][1] ] ),
                                 ", \\quad \\dim \\L(\\lambda)=", String( dims[ groups[1][1] ] ), ".\n\t\t\\]\n" ) );
            continue;
        fi;
        if excluded then
            Emit( Concatenation( "\t\t\\item Assume $\\lambda\\in ", lambdaset, "$.\n" ) );
        else
            Emit( Concatenation( "\t\t\\item Assume $\\lambda\\in", lambdaset, "$. Then\n" ) );
        fi;
        Emit( "\t\t\\begin{itemize}[leftmargin=*]\n" );
        for k in [ 1 .. Length( groups ) ] do
            g := groups[k];
            if style = "A" then
                Emit( Concatenation( "\t\t\t\\item[(", Roman[k], ")] If $\\lambda\\in", SetToString( g ) ) );
                if with_subset then Emit( Concatenation( "   \\subset\\Lambda_", sym, "'" ) ); fi;
                Emit( "$, then\n" );
                Emit( Concatenation( "\t\t\t\\[\n\t\t\t\\H(\\lambda)=", SeriesToString( series[ g[1] ] ),
                                     ", \\quad \\dim \\L(\\lambda)=", String( dims[ g[1] ] ), ".\n\t\t\t\\]\n" ) );
            else
                Emit( Concatenation( "\t\t\t\\item[(", Roman[k], ")] If $\\lambda\\in ", SetToString( g ),
                                     "$, then $\\dim \\L(\\lambda)=", String( dims[ g[1] ] ), "$,\n" ) );
                Emit( Concatenation( "\t\t\t\\begin{align*}\n\t\t\t\t\\H(\\lambda)&=", SeriesToString( series[ g[1] ] ),
                                     ".\n\t\t\t\\end{align*}\n" ) );
            fi;
        od;
        Emit( "\t\t\\end{itemize}\n" );
    od;
    Emit( "\t\\end{enumerate}\n" );
    if palindromic then
        Emit( "\tIn particular, $\\H(\\lambda)$ is palindromic for every $\\lambda\\in \\Lambda$.\n" );
    fi;
    Emit( "\\end{proposition}\n\\begin{proof}\n\tComputed with \\texttt{socle.gi}.\n\\end{proof}\n" );
    CloseStream( out );

    Print( "Written ", filename, ": |Lambda_L| = ", Length( Lambda_L ), ", |Lambda_V| = ", Length( Lambda_V ),
           ", groups: ", List( RecNames( result.groups ), r -> [ r, Length( result.groups.(r) ) ] ),
           ", palindromic: ", palindromic, "\n" );
    return result;
end;;
MakeReadOnlyGlobal( "QGNAG_HilbertSectionToLaTeX" );

MakeReadWriteGlobal( "QGNAG_WriteCharAndHilbertTeX" );
QGNAG_WriteCharAndHilbertTeX := function( filename, data_rec_info, names, degreeofreps, filtered, underline )
    local theta, n_top, excluded, written, out, i, rec_info, LName, degrees, d, pair, mult, idx,
          term, first_char, first, total, dim_total;

    theta    := Length( data_rec_info );
    n_top    := Maximum( List( data_rec_info, r -> Length( RecNames( r ) ) ) );
    excluded := [];
    if filtered then
        excluded := Filtered( [ 1 .. theta ], i -> Length( RecNames( data_rec_info[i] ) ) in [ 1, n_top ] );
    fi;
    written := [];

    out := OutputTextFile( filename, false );
    SetPrintFormattingStatus( out, false );
    for i in [ 1 .. theta ] do
        if i in excluded then
            continue;
        fi;
        Add( written, i );
        rec_info := data_rec_info[i];
        LName    := QGNAG_ExtractTuple( names[i] );
        degrees  := List( RecNames( rec_info ), Int );
        Sort( degrees );

        # character
        AppendTo( out, "\\subsubsection{$L", LName, "$}\n" );
        AppendTo( out, "\\[\n" );
        AppendTo( out, "\\operatorname{Char}", LName, " = " );
        first_char := true;
        for d in degrees do
            for pair in rec_info.(String(d)) do
                mult := pair[1];
                idx  := pair[2];
                if underline then
                    if mult = 1 then
                        term := StringFormatted( "\\underline{{{}}}[{}]", idx, d );
                    else
                        term := StringFormatted( "{}\\,\\underline{{{}}}[{}]", mult, idx, d );
                    fi;
                else
                    if mult = 1 then
                        term := StringFormatted( "{}[{}]", names[idx], d );
                    else
                        term := StringFormatted( "{}\\,{}[{}]", mult, names[idx], d );
                    fi;
                fi;
                if first_char then
                    AppendTo( out, term );
                    first_char := false;
                else
                    AppendTo( out, " + ", term );
                fi;
            od;
        od;
        AppendTo( out, "\n\\]\n\n" );

        # Hilbert series and dimension
        AppendTo( out, "\\[\n" );
        AppendTo( out, "\\operatorname{H}_{", LName, "}(t) = " );
        first     := true;
        dim_total := 0;
        for d in degrees do
            total := 0;
            for pair in rec_info.(String(d)) do
                total := total + pair[1] * degreeofreps[ pair[2] ];
            od;
            dim_total := dim_total + total;
            if d = 0 then
                term := StringFormatted( "{}", total );
            elif total = 1 then
                term := StringFormatted( "t^{{{}}}", d );
            else
                term := StringFormatted( "{}t^{{{}}}", total, d );
            fi;
            if first then
                AppendTo( out, term );
                first := false;
            else
                AppendTo( out, " + ", term );
            fi;
        od;
        AppendTo( out, "\n\\]\n" );
        AppendTo( out, "\\[\n\\dim L", LName, " = ", String( dim_total ), "\n\\]\n\n" );
    od;
    CloseStream( out );
    Print( "Written ", filename, ": ", Length( written ), " weights", ", excluded: ", excluded, "\n" );
    return rec( written := written, excluded := excluded );
end;;
MakeReadOnlyGlobal( "QGNAG_WriteCharAndHilbertTeX" );


#############################################################################
##  polynomialsKL and seriesKL in the format of the paper (from kltex.gi)
#############################################################################

MakeReadWriteGlobal( "QGNAG_LaurentTerms" );
QGNAG_LaurentTerms := function( c )
    local cv, terms, i;
    if IsZero(c) then
        return [];
    fi;
    cv := CoefficientsOfLaurentPolynomial(c);
    terms := [];
    for i in [1 .. Length(cv[1])] do
        if not IsZero(cv[1][i]) then
            Add(terms, [cv[1][i], cv[2] + i - 1]);
        fi;
    od;
    Sort(terms, function(s, t) return s[2] > t[2]; end);
    return terms;

end;;
MakeReadOnlyGlobal( "QGNAG_LaurentTerms" );

MakeReadWriteGlobal( "QGNAG_MonomialToTeX" );
QGNAG_MonomialToTeX := function( a, e )
    local absA, coef;
    absA := AbsoluteValue(a);
    if e = 0 then
        return String(absA);
    fi;
    if absA = 1 then
        coef := "";
    else
        coef := String(absA);
    fi;
    return Concatenation(coef, "q^{", String(e), "}");

end;;
MakeReadOnlyGlobal( "QGNAG_MonomialToTeX" );

MakeReadWriteGlobal( "QGNAG_LaurentToTeX" );
QGNAG_LaurentToTeX := function( c )
    local terms, text, k;
    terms := QGNAG_LaurentTerms(c);
    if IsEmpty(terms) then
        return "0";
    fi;
    text := "";
    for k in [1 .. Length(terms)] do
        if k = 1 then
            if terms[k][1] < 0 then
                Append(text, "-");
            fi;
        elif terms[k][1] < 0 then
            Append(text, " - ");
        else
            Append(text, " + ");
        fi;
        Append(text, QGNAG_MonomialToTeX(terms[k][1], terms[k][2]));
    od;
    return text;

end;;
MakeReadOnlyGlobal( "QGNAG_LaurentToTeX" );

MakeReadWriteGlobal( "QGNAG_CoefficientTimes" );
QGNAG_CoefficientTimes := function( c, name, iotas )
    local terms, a, e, body, i;
    terms := QGNAG_LaurentTerms(c);
    if Length(terms) = 1 then
        a := terms[1][1];
        e := terms[1][2];
        if e = 0 and AbsoluteValue(a) = 1 then
            body := name;
        else
            body := Concatenation(QGNAG_MonomialToTeX(a, e), name);
        fi;
        if a < 0 then
            return ["-", body];
        fi;
        return ["+", body];
    fi;
    for i in iotas do
        if i[1] = c then
            return ["+", Concatenation(i[2], name)];
        fi;
    od;
    return ["+", Concatenation("(", QGNAG_LaurentToTeX(c), ")", name)];

end;;
MakeReadOnlyGlobal( "QGNAG_CoefficientTimes" );

MakeReadWriteGlobal( "QGNAG_VisibleLength" );
QGNAG_VisibleLength := function( s )
    local n, i, j, c, cmd, letters;
    letters := "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    n := 0;
    i := 1;
    while i <= Length(s) do
        c := s[i];
        if c = '\\' then
            j := i + 1;
            while j <= Length(s) and s[j] in letters do
                j := j + 1;
            od;
            cmd := s{[i + 1 .. j - 1]};
            if not cmd in ["Big", "big", "quad"] then
                n := n + 1;
            fi;
            i := Maximum(j, i + 1);
        elif c in "{}_^ \n" then
            i := i + 1;
        else
            n := n + 1;
            i := i + 1;
        fi;
    od;
    return n;

end;;
MakeReadOnlyGlobal( "QGNAG_VisibleLength" );

MakeReadWriteGlobal( "QGNAG_JoinSignedTerms" );
QGNAG_JoinSignedTerms := function( terms, maxWidth, cont, offset )
    local text, k, w, cur;
    text := "";
    cur  := offset;
    for k in [1 .. Length(terms)] do
        w := 3 + QGNAG_VisibleLength(terms[k][2]);
        if k = 1 then
            if terms[k][1] = "-" then
                Append(text, "-");
            fi;
            Append(text, terms[k][2]);
            cur := cur + w;
        elif cur + w > maxWidth then
            Append(text, Concatenation("\\\\\n", cont, terms[k][1], " ", terms[k][2]));
            cur := w;
        else
            Append(text, Concatenation(" ", terms[k][1], " ", terms[k][2]));
            cur := cur + w;
        fi;
    od;
    return text;

end;;
MakeReadOnlyGlobal( "QGNAG_JoinSignedTerms" );

MakeReadWriteGlobal( "QGNAG_EquationToTeX" );
QGNAG_EquationToTeX := function( lhs, row, idx, symbol, factor, iotas, cont, maxWidth, sep, wrapOpen, wrapClose )
    local groups, g, j, found, terms, name;
    groups := [];
    for j in [1 .. Length(row)] do
        if not IsZero(row[j]) then
            found := false;
            if factor then
                for g in groups do
                    if g[1] = row[j] then
                        Add(g[2], idx[j]);
                        found := true;
                        break;
                    fi;
                od;
            fi;
            if not found then
                Add(groups, [row[j], [idx[j]]]);
            fi;
        fi;
    od;
    terms := [];
    for g in groups do
        if Length(g[2]) = 1 then
            name := Concatenation(symbol, "_{", String(g[2][1]), "}");
        else
            name := Concatenation("(", JoinStringsWithSeparator(
                        List(g[2], i -> Concatenation(symbol, "_{", String(i), "}")), "+"), ")");
        fi;
        Add(terms, QGNAG_CoefficientTimes(g[1], name, iotas));
    od;
    return Concatenation(lhs, sep, wrapOpen,
                         QGNAG_JoinSignedTerms(terms, maxWidth, cont, QGNAG_VisibleLength(Concatenation(lhs, sep, wrapOpen))), wrapClose);

end;;
MakeReadOnlyGlobal( "QGNAG_EquationToTeX" );

MakeReadWriteGlobal( "QGNAG_IotasOfBlock" );
QGNAG_IotasOfBlock := function( matrix )
    local found, row, c, t, i, iotas, k;
    found := [];
    for row in matrix do
        for c in row do
            if Length(QGNAG_LaurentTerms(c)) > 1 then
                t := false;
                for i in found do
                    if i[1] = c then
                        i[2] := i[2] + 1;
                        t := true;
                    fi;
                od;
                if not t then
                    Add(found, [c, 1]);
                fi;
            fi;
        od;
    od;
    iotas := [];
    k := 0;
    for i in found do
        if i[2] >= 2 then
            k := k + 1;
            Add(iotas, [i[1], Concatenation("\\iota_{", String(k), "}(q)")]);
        fi;
    od;
    return iotas;

end;;
MakeReadOnlyGlobal( "QGNAG_IotasOfBlock" );

MakeReadWriteGlobal( "QGNAG_DegreeOfD" );
QGNAG_DegreeOfD := function( b )
    local q, d6, k;
    q  := IndeterminateOfUnivariateRationalFunction(b.det);
    d6 := One(q) - q^-6;
    k  := 0;
    while not ForAll(b.inverse, r -> ForAll(r, c -> IsLaurentPolynomial(c * d6^k))) do
        k := k + 1;
        if k > Length(b.rows) + 2 then
            Error("QGNAG_DegreeOfD: the inverse of the block ", b.rows, " is not d^k times a Laurent polynomial");
        fi;
    od;
    return k;

end;;
MakeReadOnlyGlobal( "QGNAG_DegreeOfD" );

MakeReadWriteGlobal( "QGNAG_BlockEquations" );
QGNAG_BlockEquations := function( b, kind, factor, iotas, mode, maxWidth )
    local eqs, r, lhs, sep, cont, k, q, d6, row, wo, wc;
    eqs := [];
    if mode = "align" then
        cont := "&";
    else
        cont := "\\quad";
    fi;
    if kind = "polynomials" then
        if mode = "align" then sep := " &= "; else sep := " = "; fi;
        for r in [1 .. Length(b.rows)] do
            lhs := Concatenation("\\epsilon_{", String(b.rows[r]), "}");
            Add(eqs, QGNAG_EquationToTeX(lhs, b.matrix[r], b.cols, "\\nu", factor, iotas, cont, maxWidth, sep, "", ""));
        od;
    else
        if mode = "align" then sep := " =& "; else sep := " = "; fi;
        k  := QGNAG_DegreeOfD(b);
        q  := IndeterminateOfUnivariateRationalFunction(b.det);
        d6 := One(q) - q^-6;
        if k >= 3 then
            wo := Concatenation("\\d^{", String(k), "}\\Big(");  wc := "\\Big)";
        elif k = 2 then
            wo := "\\d^{2}\\big(";                                wc := "\\big)";
        else
            wo := "\\d(";                                         wc := ")";
        fi;
        for r in [1 .. Length(b.cols)] do
            row := List(b.inverse[r], c -> c * d6^k);
            lhs := Concatenation("\\nu_{", String(b.cols[r]), "}");
            Add(eqs, QGNAG_EquationToTeX(lhs, row, b.rows, "\\epsilon", factor, [], cont, maxWidth, sep, wo, wc));
        od;
    fi;
    return eqs;

end;;
MakeReadOnlyGlobal( "QGNAG_BlockEquations" );

MakeReadWriteGlobal( "QGNAG_KLTeXText" );
QGNAG_KLTeXText := function( blocks, kind, factor, widths )
    local text, sizes, size, group, b, eqs, items, k, i, perRow, iotas, heading, ones, defs, j, r, row, nu, ep, mode, rowsText;
    text  := "";
    sizes := Reversed(Set(List(blocks, b -> Length(b.rows))));
    for size in sizes do
        group := Filtered(blocks, b -> Length(b.rows) = size);
        if size = 1 then
            ones := List(group, b -> b.rows[1]);
            if kind = "polynomials" then
                nu := "\\epsilon_i=\\nu_i";
            else
                nu := "\\nu_i=\\epsilon_i";
            fi;
            text := Concatenation(text, "\\subsubsection{The blocks of size 1}\n",
                    "For $i\\in\\{", JoinStringsWithSeparator(List(ones, String), ", "), "\\}$ we have $", nu, "$.\n\n");
        elif size > 6 then
            for b in group do
                if kind = "polynomials" and 1 in b.rows then
                    heading := "The principal block";
                elif Length(group) = 1 then
                    heading := Concatenation("The block of size ", String(size));
                else
                    heading := Concatenation("The blocks of size ", String(size));
                fi;
                iotas := [];
                if kind = "polynomials" then
                    iotas := QGNAG_IotasOfBlock(b.matrix);
                fi;
                eqs := QGNAG_BlockEquations(b, kind, factor, iotas, "align", widths[1]);
                text := Concatenation(text, "\\subsubsection{", heading, "}\n\n\\begin{align*}\n");
                for i in [1 .. Length(eqs)] do
                    text := Concatenation(text, eqs[i]);
                    if i < Length(eqs) then
                        text := Concatenation(text, ",\\\\\n");
                    else
                        text := Concatenation(text, ".\n");
                    fi;
                od;
                text := Concatenation(text, "\\end{align*}\n");
                if Length(iotas) > 0 then
                    defs := List(iotas, i -> Concatenation("$", i[2], "\\coloneqq ", QGNAG_LaurentToTeX(i[1]), "$"));
                    text := Concatenation(text, "Here ", JoinStringsWithSeparator(defs, ", "), ".\n");
                fi;
                text := Concatenation(text, "\n");
            od;
        else
            if size = 6 then
                if kind = "polynomials" then perRow := 2; else perRow := 1; fi;
            elif kind = "polynomials" then
                perRow := 3;
            else
                perRow := 2;
            fi;
            if Length(group) = 1 then
                heading := Concatenation("The block of size ", String(size));
            else
                heading := Concatenation("The blocks of size ", String(size));
            fi;
            items := [];
            for b in group do
                if perRow = 1 then
                    eqs := QGNAG_BlockEquations(b, kind, factor, [], "cases", widths[3]);
                else
                    eqs := QGNAG_BlockEquations(b, kind, factor, [], "cases", widths[2]);
                fi;
                rowsText := "";
                for i in [1 .. Length(eqs)] do
                    rowsText := Concatenation(rowsText, eqs[i]);
                    if i < Length(eqs) then
                        rowsText := Concatenation(rowsText, ",\\\\\n");
                    else
                        rowsText := Concatenation(rowsText, ".\n");
                    fi;
                od;
                Add(items, Concatenation("\\begin{cases}\n", rowsText, "\\end{cases}"));
            od;
            text := Concatenation(text, "\\subsubsection{", heading, "}\n\n\\begin{align*}\n");
            k := 0;
            while k < Length(items) do
                row := items{[k + 1 .. Minimum(k + perRow, Length(items))]};
                text := Concatenation(text, "&", JoinStringsWithSeparator(row, "\n&&"));
                k := k + perRow;
                if k < Length(items) then
                    text := Concatenation(text, "\n\\\\\n");
                else
                    text := Concatenation(text, "\n");
                fi;
            od;
            text := Concatenation(text, "\\end{align*}\n\n");
        fi;
    od;
    return text;

end;;
MakeReadOnlyGlobal( "QGNAG_KLTeXText" );

MakeReadWriteGlobal( "QGNAG_WritePolynomialsKLTeX" );
QGNAG_WritePolynomialsKLTeX := function( filename, blocks )
    local out;
    out := OutputTextFile(filename, false);
    SetPrintFormattingStatus(out, false);
    AppendTo(out, "% Verma characters in terms of the irreducible characters, generated by QGNAG_WritePolynomialsKLTeX\n",
                  "% Requires: amsmath, \\coloneqq (mathtools)\n\n",
                  QGNAG_KLTeXText(blocks, "polynomials", true, [ 70, 29, 60 ]));
    CloseStream(out);
    return true;

end;;
MakeReadOnlyGlobal( "QGNAG_WritePolynomialsKLTeX" );

MakeReadWriteGlobal( "QGNAG_WriteSeriesKLTeX" );
QGNAG_WriteSeriesKLTeX := function( filename, inv_blocks )
    local out;
    out := OutputTextFile(filename, false);
    SetPrintFormattingStatus(out, false);
    AppendTo(out, "% Irreducible characters in terms of the Verma characters, generated by QGNAG_WriteSeriesKLTeX\n",
                  "% Requires: amsmath;  \\d = (1-q^{-6})^{-1}\n\n",
                  QGNAG_KLTeXText(inv_blocks, "series", true, [ 70, 29, 60 ]));
    CloseStream(out);
    return true;

end;;
MakeReadOnlyGlobal( "QGNAG_WriteSeriesKLTeX" );

#############################################################################
##  Where are the files
#############################################################################

MakeReadWriteGlobal( "QGNAG_CurrentDirectory" );
QGNAG_CurrentDirectory := function(  )
    local pwd, str, out;
    pwd := Filename( DirectoriesSystemPrograms( ), "pwd" );
    if pwd = fail then
        return fail;
    fi;
    str := "";
    out := OutputTextString( str, true );
    Process( DirectoryCurrent( ), pwd, InputTextNone( ), out, [ ] );
    CloseStream( out );
    return Filtered( str, c -> c <> '\n' );
end;;
MakeReadOnlyGlobal( "QGNAG_CurrentDirectory" );

MakeReadWriteGlobal( "QGNAG_FullPath" );
QGNAG_FullPath := function( outdir, name )
    local dir;
    if Length( outdir ) > 0 and outdir[1] = '/' then
        return Concatenation( outdir, name );
    fi;
    dir := QGNAG_CurrentDirectory( );
    if dir = fail then
        return Concatenation( outdir, name );
    fi;
    return Concatenation( dir, "/", outdir, name );
end;;
MakeReadOnlyGlobal( "QGNAG_FullPath" );

