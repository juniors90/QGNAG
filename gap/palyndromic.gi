#############################################################################
##
#F  QGNAG_HilbertSectionToLaTeX( <filename>, <data_rec_info>, <names>,
##                               <degreeofreps>, <pals> )
##
##  Writes to <filename> the subsection "Hilbert series" of the paper:
##  the Lemma with Lambda_L and Lambda_V and the Proposition with the
##  Hilbert series of L(lambda) for the remaining weights, grouped by family
##  (tau, rho, chi, eta) and by equal series.
##
##  <data_rec_info>[i] is the record of the weight i (in the order of the
##  enumeration, i.e. already permuted by tau): its components are the
##  negative degrees (as strings) and each one holds a list of pairs
##  [ multiplicity, index of the simple module ].  This is what
##  Permuted( List( data_record_data_decomp, QGNAG_PrepareDecomposition ), tau )
##  returns.  <names>[i] is the LaTeX name of the module i (SimpleNames) and
##  <degreeofreps>[i] its dimension.  <pals> is the list of booleans returned by
##  QGNAG_HilbertSeriesIsPalindromic( data_record_data_decomp, degreeofreps ):
##  pals[i] = true if H(lambda_i) is palindromic (same order as <names>).
##
##  Lambda_L = weights whose L(lambda) lives in one degree.
##  Lambda_V = weights whose L(lambda) has all the degrees (simple Verma).
##  Groups are ordered by their first weight; weights inside a group by
##  position.  Returns a record with the data of the section.
##
InstallGlobalFunction(QGNAG_HilbertSectionToLaTeX, function( filename, data_rec_info, names, degreeofreps, pals )
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
end);;