InstallGlobalFunction( QGNAG_MultiplicitiesAtDegree, function( j, SimplesMn, rec_info )
    local bijs, decomposition, pair, rec_bijs;

    # Check that the degree exists
    rec_bijs := rec();
    if not IsBound( rec_info.(String(j)) ) then
        Error( StringFormatted("The degree {} is not present in rec_info.", j) );
    fi;
    # Initialize all multiplicities to zero
    bijs := List( [1 .. Length(SimplesMn)], x -> 0 );
    # Decomposition at degree j
    decomposition := rec_info.(String(j));
    # Fill the multiplicities
    for pair in decomposition do
        bijs[pair[2]] := pair[1];
    od;
    rec_bijs.(String(j)) := bijs;
    return rec_bijs;
end);


InstallGlobalFunction( QGNAG_MultiplicitiesByDegree, function( SimplesMn, rec_info )
    local theta, bijs, bijs_by_degree, j, degrees;
    degrees        := List( RecNames( rec_info ), Int );
    theta          := Maximum( degrees );
    bijs_by_degree := [];
    for j in [0 .. theta] do
        bijs := QGNAG_MultiplicitiesAtDegree( j, SimplesMn, rec_info );
        Add( bijs_by_degree, bijs);
    od;
    return bijs_by_degree;
end);


InstallGlobalFunction( QGNAG_DecompositionFromMultiplicities, function( bijs_by_degree )
    local decomposition, j, i, bijs, bijs_idx, degree_decomposition, bijs_by_degree_list;
    decomposition := rec();
    bijs_by_degree_list := List( [1 .. Length(bijs_by_degree)], i -> bijs_by_degree[i].(String(i - 1)) );
    for j in [0 .. Length(bijs_by_degree_list) - 1] do
        bijs := bijs_by_degree_list[j + 1];
        degree_decomposition := [];

        for i in [1 .. Length(bijs)] do
            if bijs[i] <> 0 then
                Add(degree_decomposition, [ bijs[i], i ]);
            fi;
        od;

        decomposition.(String(j)):=degree_decomposition;
    od;
    return decomposition;
end);


# --------------------------------------------- #
InstallGlobalFunction( QGNAG_FusionMultiplicity, function( index_i, index_s, index_k, SimplesMn )
    local Mi_tensor_Ms,
          Mi_tensor_Ms_mats,
          Mk_mats,
          Mi,
          Ms,
          Mk,
          N_is_k;
    
    Mi                := SimplesMn[index_i];
    Ms                := SimplesMn[index_s];
    Mk                := SimplesMn[index_k];
    Mi_tensor_Ms      := QGNAG_TensorProductOfSimples( Mi, Ms);
    Mi_tensor_Ms_mats := QGNAG_RepresentationMatrices(Mi_tensor_Ms);
    Mk_mats           := QGNAG_RepresentationMatrices(Mk);
    N_is_k            := QGNAG_DimHomAModules( Mi_tensor_Ms_mats, Mk_mats);
    
    return N_is_k;
end);


InstallGlobalFunction(QGNAG_GradedMultiplicity, function( index_i, index_j, rec_info_nichols )
    local decomposition,
          pair;
    
    if not IsBound( rec_info_nichols.(String(index_j)) ) then
        return 0;
    fi;
    decomposition := rec_info_nichols.(String(index_j));
    for pair in decomposition do
        if pair[2] = index_i then
            return pair[1];
        fi;
    od;
    
    return 0;
end);


InstallGlobalFunction(QGNAG_GradedFusionMultiplicity, function( index_s, index_k, index_j, SimplesMn, rec_info_nichols )
    local index_i,
          N_ik_s,
          b_ij,
          result;

    result := 0;
    for index_i in [1 .. Length(SimplesMn)] do
        # Mi_tensor_Ms_mats, Mk_mats
        N_ik_s  := QGNAG_FusionMultiplicity( index_i, index_s, index_k, SimplesMn ); 
        b_ij    := QGNAG_GradedMultiplicity( index_i, index_j, rec_info_nichols );
        result  := result + N_ik_s * b_ij;
    od;    
    return result;
end);


InstallGlobalFunction(QGNAG_GradedFusionByDegree, function( s, SimplesMn, rec_info_nichols )
    local theta, data, j, k, r;
    theta := Maximum( List( RecNames(rec_info_nichols), Int ) );
    data  := [];
    for k in [1 .. Length(SimplesMn)] do
        r := rec();
        for j in [0 .. theta] do
            r.(String(j)) := QGNAG_GradedFusionMultiplicity( s, k, j, SimplesMn, rec_info_nichols );
        od;
        Add(data, r);
    od;
    return data;
end);


InstallGlobalFunction(QGNAG_GradedFusionVector, function( s, SimplesMn, rec_info )
    local data, epsilon, j, k, theta;
    data    := QGNAG_GradedFusionByDegree( s, SimplesMn, rec_info );
    theta   := Maximum( List( RecNames(rec_info), Int ) );
    epsilon := [];
    for j in [0 .. theta] do
        for k in [1 .. Length(SimplesMn)] do
            Add(epsilon, data[k].(String(j)));
        od;
    od;
    return epsilon;
end);


InstallGlobalFunction(QGNAG_ExportGradedFusionByDegreeToLaTeX, function(filename, SimplesMn, rec_info_nichols)
    local out, s, j, k, n, ell, data_s;
    ell := Maximum( List( RecNames(rec_info_nichols), Int ) );
    out := OutputTextFile(filename, false);
    n   := Length(SimplesMn);
    for s in [1..n] do
        data_s := QGNAG_GradedFusionByDegree( s, SimplesMn, rec_info_nichols );
        AppendTo( out, Concatenation("\\subsubsection{Multiplicity table for $M_{", String(s), "}$}\n\n" ) );
        AppendTo(out, "\\begin{table}[ht]\n");
        AppendTo(out, "\\centering\n");
        AppendTo(out, "\\begin{tabular}{c|");
        for k in [1..n] do
            AppendTo(out, "c");
        od;
        AppendTo(out, "}\n\\hline\n");
        AppendTo(out, "$j$");
        for k in [1..n] do
            AppendTo(out,StringFormatted(" & $M_{{{}}}$", k));
        od;
        AppendTo(out, " \\\\\n\\hline\n");
        for j in [0 .. ell]  do
            AppendTo(out, String(j));
            for k in [1..n] do
                AppendTo(out,StringFormatted(" & {}", data_s[k].(String(j))));
            od;
            AppendTo(out, " \\\\\n");
        od;
        AppendTo(out, "\\hline\n");
        AppendTo(out, "\\end{tabular}\n");
        AppendTo(out, Concatenation( "\\caption{Multiplicity table for $M_{", String(s), "}$.}\n" ));
        AppendTo(out, "\\end{table}\n\n");
    od;
    CloseStream(out);
end);

# -----------------------------------------------------------------------

InstallGlobalFunction(QGNAG_AllCharToShiftedVectorsLeft, function( record_data_decomp )
    local N,
          degrees,
          ell,
          min_degree,
          vector,
          shifted_vectors,
          j,
          d,
          index,
          degree,
          i;

    N       := Length(record_data_decomp);
    degrees := List(RecNames(record_data_decomp[1]), x -> Int(x));
    Sort(degrees);
    ell := Maximum(degrees);

    # Find the smallest degree with a non-zero multiplicity.
    min_degree := First( degrees, d -> ForAny( [1..N], i -> record_data_decomp[i].(String(d)) <> 0 ) );
    shifted_vectors := [];
    # Compute all possible left shifts.
    for j in [0..min_degree] do
        vector := [];
        for d in [0..ell] do
            index  := (d + j) mod (ell + 1);
            degree := String(index);
            for i in [1..N] do
                Add(vector, record_data_decomp[i].(degree));
            od;
        od;
        Add(shifted_vectors, vector);
    od;
    return shifted_vectors;
end);

InstallGlobalFunction(QGNAG_AllShiftedVectorsLeft, function( data_record_data_decomp )
    local shifted_vectors,
          record_data_decomp,
          i;

    shifted_vectors := [];
    for i in [1..Length(data_record_data_decomp)] do
        record_data_decomp := data_record_data_decomp[i];
        Append( shifted_vectors, QGNAG_AllCharToShiftedVectorsLeft( record_data_decomp ) );
    od;
    return shifted_vectors;
end);


InstallGlobalFunction(QGNAG_CharToShiftedVectorLeft, function( record_data_decomp, j )
    local degrees,
          ell,
          N,
          vector,
          d,
          i,
          index,
          degree;

    N       := Length(record_data_decomp);
    degrees := List(RecNames(record_data_decomp[1]), x -> Int(x));
    ell     := Maximum(degrees);
    vector := [];
    for d in [0..ell] do
        index := ((d + j) mod (ell + 1));
        degree := String(index);
        for i in [1..N] do
            Add(vector, record_data_decomp[i].(degree));
        od;
    od;
    return vector;
end);


InstallGlobalFunction( QGNAG_NuVectorNames, function( data_record_data_decomp )
    local names,
          i,
          number_of_shifts,
          nu_ij,
          j;

    names := [];
    for i in [1..Length(data_record_data_decomp)] do
        nu_ij := QGNAG_AllCharToShiftedVectorsLeft( data_record_data_decomp[i] );
        number_of_shifts := Length( nu_ij );
        for j in [0..number_of_shifts-1] do
            Add(names, Concatenation("\\nu_{", String(i),",", String(j), "}" ));
        od;
    od;
    return names;
end );

InstallGlobalFunction( QGNAG_PrintQP, function( coeffs, names )
    local terms,
          i,
          c,
          s,
          result;
    
    terms := [];
    
    for i in [1 .. Length(coeffs)] do
        c := coeffs[i];
        if c <> 0 then
            if c = 1 then
                s := names[i];
            elif c = -1 then
                s := Concatenation("-", names[i]);
            else
                s := Concatenation(String(c), " ", names[i]);
            fi;
            Add(terms, s);
        fi;
    od;
    if Length(terms) = 0 then
        result := "\\epsilon = 0";
    else
        result := "\\epsilon = ";
        for i in [1 .. Length(terms)] do
            if i = 1 then
                result := Concatenation(result, terms[i]);
            else
                if terms[i][1] = '-' then
                    result := Concatenation(result, " - ", terms[i]{[2 .. Length(terms[i])]});
                else
                    result := Concatenation(result, " + ", terms[i]);
                fi;
            fi;
        od;
    fi;
    Print(result, "\n");
    return result;
end);


InstallGlobalFunction( QGNAG_QPToLaTeX, function( coeffs, names, index )
    local terms,
          i,
          c,
          s,
          result;

    terms := [];

    for i in [1..Length(coeffs)] do
        c := coeffs[i];
        if c <> 0 then
            if c = 1 then
                s := names[i];
            elif c = -1 then
                s := Concatenation("-", names[i]);
            else
                s := Concatenation(String(c), "\\,", names[i]);
            fi;
            Add(terms, s);
        fi;
    od;
    if Length(terms) = 0 then
        result := Concatenation("\\epsilon_", String(index), " = 0");
    else
        result := Concatenation("\\epsilon_", String(index), " = ");
        for i in [1..Length(terms)] do
            if i = 1 then
                result := Concatenation(result, terms[i]);
            else
                if terms[i][1] = '-' then
                    result := Concatenation( result, " - ", terms[i]{[2..Length(terms[i])]} );
                else
                    result := Concatenation( result, " + ", terms[i] );
                fi;
            fi;
        od;
    fi;
    return result;
end);

InstallGlobalFunction( QGNAG_SaveQPToLaTeX, function(filename, coeffs, names, index)
    local out,
          result;

    out    := OutputTextFile(filename, false);
    result := QGNAG_QPToLaTeX(coeffs, names, index);
    AppendTo(out, "\\[\n");
    AppendTo(out, result);
    AppendTo(out, "\n\\]\n");
    CloseStream(out);
end);


InstallGlobalFunction( QGNAG_SaveAllQPToLaTeX, function(filename, data_record_data_decomp, SimplesMn, rec_info_nichols )
    local out,
          nu,
          A,
          NuVectorNames,
          index,
          epsilon,
          coefficients,
          result;
    out           := OutputTextFile(filename, false);
    nu            := QGNAG_AllShiftedVectorsLeft( data_record_data_decomp);
    A             := TransposedMat(nu);
    NuVectorNames := QGNAG_NuVectorNames(data_record_data_decomp);
    for index in [1..Length(data_record_data_decomp)] do
        epsilon := QGNAG_GradedFusionVector( index, SimplesMn, rec_info_nichols );
        if RankMat(A) = RankMat( TransposedMat( Concatenation(nu, [epsilon]) ) ) then
            coefficients := SolutionMat( TransposedMat(A), epsilon );
            result := QGNAG_QPToLaTeX( coefficients, NuVectorNames, index );
            AppendTo(out, "\\[\n");
            AppendTo(out, result);
            AppendTo(out, "\n\\]\n\n");
        fi;
    od;
    CloseStream(out);
end);

# -----------------------------------------------------------------------


InstallGlobalFunction( QGNAG_VectorToLaTeX, function( vector )
    local result, i;
    result := "(";
    for i in [1 .. Length(vector)] do
        Append( result, String(vector[i]) );
        if i < Length(vector) then
            Append( result, ", " );
        fi;
    od;
    Append( result, ")" );
    return result;
end);

InstallGlobalFunction( QGNAG_SaveNuVectorsToLaTeX, function( filename, data_record_data_decomp )
    local out,
          nu,
          NuVectorNames,
          i,
          j;

    out           := OutputTextFile( filename, false );
    nu            := QGNAG_AllShiftedVectorsLeft( data_record_data_decomp );
    NuVectorNames := QGNAG_NuVectorNames( data_record_data_decomp );
    for i in [1 .. Length(nu)] do
        AppendTo( out, "\\[\n" );
        AppendTo( out, NuVectorNames[i], " = (" );
        for j in [1 .. Length(nu[i])] do
            AppendTo( out, String(nu[i][j]) );
            if j < Length(nu[i]) then
                AppendTo( out, ", " );
            fi;
        od;
        AppendTo( out, ")\n" );
        AppendTo( out, "\\]\n\n" );
    od;
    CloseStream(out);
end);

InstallGlobalFunction( QGNAG_SaveNuTableToLaTeX, function(filename, data_record_data_decomp, SimpleNames )
    local out,
          NuVectorNames,
          i,
          j,
          d,
          dmin,
          shifts,
          nshift,
          total,
          lname,
          degrees,
          ell;

    out           := OutputTextFile( filename, false );
    NuVectorNames := QGNAG_NuVectorNames( data_record_data_decomp );
    total         := Length( NuVectorNames );
    AppendTo( out, "\\[\n" );
    AppendTo( out, "\\begin{array}{c|c|c}\n" );
    AppendTo( out, "L_i & d_{\\min}(L_i) & \\text{Shift }(\\nu) \\\\ \\hline\n\n" );
    for i in [1 .. Length(data_record_data_decomp)] do
        # Compute d_min(L_i)
        dmin    := fail;
        degrees := List(RecNames(data_record_data_decomp[i][1]),Int);
        ell     := Maximum( degrees );
        for d in [0 .. ell] do
            if Sum( List( data_record_data_decomp[i], x -> x.(String(d)) ) ) > 0 then
                dmin := d;
                break;
            fi;

        od;

        # Number of admissible shifts for L_i
        shifts := Filtered(NuVectorNames, name -> PositionSublist( name, Concatenation("\\nu_{", String(i), ",") ) <> fail );
        nshift := Length(shifts);
        # Name L_i instead of M_i
        lname := Concatenation( "L", SimpleNames[i]{[2 .. Length(SimpleNames[i])]} );
        if nshift = 1 then
            AppendTo( out, lname, "\n& ", String(dmin), "\n& ", shifts[1], " \\\\ \\hline\n\n" );
        else
            AppendTo( out, "\\multirow{", String(nshift), "}{*}{$", lname, "$}\n" );
            AppendTo( out, "& \\multirow{", String(nshift), "}{*}{", String(dmin), "}\n" );
            for j in [1 .. nshift] do
                if j = 1 then
                    AppendTo( out, "& " );
                else
                    AppendTo( out, "&& " );
                fi;
                AppendTo( out, shifts[j] );

                if j < nshift then
                    AppendTo( out, " \\\\ \\cline{3-3}\n" );
                else
                    AppendTo( out, " \\\\ \\hline\n\n" );
                fi;
            od;
        fi;
    od;
    AppendTo( out, "\\text{Total}\n" );
    AppendTo( out, "&\n" );
    AppendTo( out, "&\n" );
    AppendTo( out, "\\mathbf{", String(total), "}\n" );
    AppendTo( out, "\\end{array}\n" );
    AppendTo( out, "\\]\n" );
    CloseStream( out );
end);

InstallGlobalFunction( QGNAG_SaveAllTPolynomialsToLaTeX, function( filename, data_record_data_decomp, SimplesMn, rec_info_nichols, SimpleNames )
    local
        out,
        nu,
        A,
        NuVectorNames,
        epsilon,
        coefficients,
        T,
        p,
        j,
        d,
        k,
        name,
        brace,
        comma,
        pName,
        dName,
        coeff,
        terms,
        term,
        firstTerm,
        numSimples,
        numShifts,
        shiftCounts,
        position,
        index,
        simpleName,
        closebrace;

    out := OutputTextFile(filename, false);
    numSimples := Length(SimpleNames);
    # ============================================================
    # The admissible shifted vectors
    # ============================================================
    nu := QGNAG_AllShiftedVectorsLeft(data_record_data_decomp);
    A := TransposedMat(nu);
    NuVectorNames := QGNAG_NuVectorNames(data_record_data_decomp);
    shiftCounts   := List(data_record_data_decomp, Length);
    numShifts     := Length(nu);
    Print("Length(nu) = ", numShifts, "\n"); # Number of shifts for each simple.
    Print("Shift counts = ", shiftCounts, "\n");
    # ============================================================
    # T[p][j][d+1] = f_{p,d}^j
    #
    # p = simple appearing in the shifted vectors
    # j = Verma character epsilon_j
    # d = shift
    # ============================================================
    T := [];
    for p in [1..numSimples] do
        T[p] := [];
        for j in [1..numSimples] do
            T[p][j] := [];
            # We only need the shifts which actually occur
            # for the simple p.
            for d in [0..shiftCounts[p]-1] do
                T[p][j][d+1] := 0;
            od;
        od;
    od;
    # ============================================================
    # Compute the coefficients for every epsilon_j
    # ============================================================
    for j in [1..Length(SimplesMn)] do
        epsilon := QGNAG_GradedFusionVector( j, SimplesMn, rec_info_nichols );
        if RankMat(A) = RankMat( TransposedMat( Concatenation(nu, [epsilon]) ) ) then
            coefficients := SolutionMat( TransposedMat(A), epsilon );
            if Length(coefficients) <> numShifts then
                Error(
                    "Unexpected number of coefficients: ",
                    Length(coefficients),
                    " instead of ",
                    numShifts
                );
            fi;
            # ----------------------------------------------------
            # Each coefficient corresponds to exactly one
            # shifted vector nu_{p,d}.
            # ----------------------------------------------------
            for k in [1..numShifts] do
                coeff := coefficients[k];
                if coeff <> 0 then
                    name := NuVectorNames[k];
                    # Expected format:
                    #
                    #     \nu_{p,d}
                    #
                    # Extract p and d.
                    brace := Position(name, '{');
                    comma := Position(name, ',');
                    pName := Int( name{ [brace+1..comma-1] } );
                    dName := Int( name{ [comma+1..Length(name)-1] } );
                    T[pName][j][dName+1] :=
                        T[pName][j][dName+1] + coeff;

                fi;
            od;
        else
            Print( "Warning: epsilon_", j, " is not in the span of the shifted vectors.\n" );
        fi;
    od;
    # ============================================================
    # Section
    # ============================================================
    AppendTo( out, "\\section{Polynomials $t_{j,p}(\\boldsymbol{q})$}\n\n" );
    # ============================================================
    # Formula
    # ============================================================
    AppendTo( out, "\\[\nt_{j,p}(\\boldsymbol{q}) = \\sum_{d} f_{p,d}^{j}\\boldsymbol{q}^{d}\n\\]\n\n");
    # ============================================================
    # Epsilon expressions
    # ============================================================
    AppendTo( out, "\\begin{align*}\n" );
    for j in [1..numSimples] do
        epsilon := QGNAG_GradedFusionVector( j, SimplesMn, rec_info_nichols );
        if RankMat(A) = RankMat( TransposedMat( Concatenation(nu, [epsilon]) ) ) then
            coefficients := SolutionMat( TransposedMat(A), epsilon );
            terms := [];
            firstTerm := true;
            for k in [1..numShifts] do
                coeff := coefficients[k];
                if coeff <> 0 then
                    name := NuVectorNames[k];
                    # Extract p and d from \nu_{p,d}.
                    brace := Position(name, '{');
                    comma := Position(name, ',');
                    closebrace := Position(name, '}');
                    pName := Int(name{[brace+1..comma-1]});
                    dName := Int(name{[comma+1..closebrace-1]});
                    # Reconstruct the LaTeX name without line breaks.
                    name := Concatenation( "\\nu_{", String(pName), ",", String(dName), "}" );
                    if coeff = 1 then
                        term := name;
                    elif coeff = -1 then
                        term := Concatenation("-", name);
                    elif coeff > 0 then
                        term := Concatenation( String(coeff), "\\,", name );
                    else
                        term := Concatenation( "-", String(-coeff), "\\,", name );
                    fi;                
                    if not firstTerm and coeff > 0 then
                        term := Concatenation("+ ", term);
                    fi;                
                    Add(terms, term);
                    firstTerm := false;
                fi;
            od;
            SizeScreen([ 4096, 4096 ]);
            if Length(terms) = 0 then
                AppendTo( out, "\\epsilon_", String(j), " &= 0" );
            else
                AppendTo( out, "\\epsilon_", String(j), " &= ", JoinStringsWithSeparator(terms, " ") );
            fi;
            if j < numSimples then
                AppendTo(out, " \\\\\n");
            else
                AppendTo(out, "\n");
            fi;
        fi;
    od;
    AppendTo( out, "\\end{align*}\n\n" );
    # ============================================================
    # Table
    #
    # Rows: j = 1,...,8
    # Columns: p = 1,...,8
    #
    # Entry:
    #
    #     t_{j,p}(q)
    #
    # ============================================================
    AppendTo( out, "\\[\n" );
    AppendTo( out, "\\begin{array}{c|c" );
    for p in [1..numSimples] do
        AppendTo(out, "|c");
    od;
    AppendTo( out, "}\n" );
    # Header
    AppendTo( out, "j & \\text{Simple}" );
    for p in [1..numSimples] do
        AppendTo( out, " & t_{j,", String(p), "}(\\boldsymbol{q})" );
    od;
    AppendTo( out, " \\\\\\hline\n");
    # ============================================================
    # Rows
    # ============================================================
    for j in [1..numSimples] do
        AppendTo( out, String(j), " & ", SimpleNames[j] );
        for p in [1..numSimples] do
            terms := [];
            firstTerm := true;
            for d in [0..shiftCounts[p]-1] do
                coeff := T[p][j][d+1];
                if coeff <> 0 then
                    # ------------------------------------------------
                    # Construct q^d
                    # ------------------------------------------------
                    if d = 0 then
                        if coeff = 1 then
                            term := "1";
                        elif coeff = -1 then
                            term := "-1";
                        else
                            term := String(coeff);
                        fi;
                    elif d = 1 then
                        if coeff = 1 then
                            term := "\\boldsymbol{q}";
                        elif coeff = -1 then
                            term := "-\\boldsymbol{q}";
                        else
                            term := Concatenation( String(coeff), "\\,\\boldsymbol{q}" );
                        fi;
                    else
                        if coeff = 1 then
                            term := Concatenation( "\\boldsymbol{q}^{", String(d), "}" );
                        elif coeff = -1 then
                            term := Concatenation( "-\\boldsymbol{q}^{", String(d), "}" );
                        else
                            term := Concatenation( String(coeff), "\\,\\boldsymbol{q}^{", String(d), "}" );
                        fi;
                    fi;
                    # ------------------------------------------------
                    # Add sign between terms
                    # ------------------------------------------------
                    if not firstTerm then
                        if coeff > 0 then
                            term := Concatenation( "+ ", term );
                        fi;
                    fi;
                    Add(terms, term);
                    firstTerm := false;
                fi;
            od;
            if Length(terms) = 0 then
                AppendTo(out, " & 0");
            else
                AppendTo( out, " & ", JoinStringsWithSeparator(terms, " ") );
            fi;
        od;
        AppendTo( out, " \\\\\n");
    od;
    AppendTo( out, "\\end{array}\n");
    AppendTo( out, "\\]\n" );
    CloseStream(out);
end);

InstallGlobalFunction( QGNAG_SaveBasisNuToLaTeX, function( filename, data_record_data_decomp )
    local out,
          nu,
          NuVectorNames,
          theta,
          N,
          dimension,
          i,
          d,
          index,
          indices,
          degrees,
          vectors,
          normalized,
          normalized_vectors,
          regular,
          nonzero_positions,
          coeff,
          term,
          terms,
          j,
          p,
          local_position,
          max_degree,
          name;

    nu            := QGNAG_AllShiftedVectorsLeft( data_record_data_decomp );
    NuVectorNames := QGNAG_NuVectorNames( data_record_data_decomp );
    theta         := Length( data_record_data_decomp );
    N             := Maximum( List( RecNames( data_record_data_decomp[1][1] ), Int ) );
    dimension     := theta * (N + 1);
    out           := OutputTextFile( filename, false );
    AppendTo( out, "\\begin{align*}\n" );
    #
    # Process each simple separately.
    #
    for i in [1 .. theta] do
        indices := [];
        degrees := [];
        #
        # Find in nu the vectors belonging to the i-th simple.
        #
        # We do NOT assume that every (i,d) occurs.
        #
        for d in [0 .. N] do
            name := Concatenation( "\\nu_{", String(i), ",", String(d), "}" );
            index := Position( NuVectorNames, name );
            if index <> fail then
                Add( indices, index );
                Add( degrees, d );
            fi;
        od;
        #
        # Extract the corresponding vectors.
        #
        vectors := List( indices, j -> nu[j] );
        # Normalize the vectors by removing the degree shift.
        # If e_j occurs in nu_{i,d}, replace it by e_{j + theta*d}.
        normalized_vectors := [];
        for j in [1 .. Length(vectors)] do
            d                 := degrees[j];
            normalized        := [];
            nonzero_positions := Filtered( [1 .. Length(vectors[j])], p -> vectors[j][p] <> 0 );
            for p in nonzero_positions do
                local_position := p + theta*d;
                Add( normalized, [ local_position, vectors[j][p] ]);
            od;
            Add( normalized_vectors, normalized );
        od;
        #
        # Detect regularity.
        #
        regular := Length(normalized_vectors) > 1;
        if regular then
            for j in [2 .. Length(normalized_vectors)] do
                if normalized_vectors[j] <>
                   normalized_vectors[1] then
                    regular := false;
                    break;
                fi;
            od;
        fi;
        #
        # ----------------------------------------------------------
        # REGULAR CASE
        # ----------------------------------------------------------
        #
        if regular then
            AppendTo( out, "\\nu_{", String(i), ",d} &= " );
            terms := [];
            for p in normalized_vectors[1] do
                local_position := p[1];
                coeff          := p[2];
                if coeff = 1 then
                    term := Concatenation( "\\mathbf{e}_{", String(local_position), "-\\theta d}" );
                elif coeff = -1 then
                    term := Concatenation( "-\\mathbf{e}_{", String(local_position), "-\\theta d}" );
                else
                    term := Concatenation( String(coeff), "\\mathbf{e}_{", String(local_position), "-\\theta d}" );
                fi;
                Add( terms, term );
            od;
            for j in [1 .. Length(terms)] do
                if j > 1 then
                    if normalized_vectors[1][j][2] > 0 then
                        AppendTo( out, " + " );
                    else
                        AppendTo( out, " " );
                    fi;
                fi;
                AppendTo( out, terms[j] );
            od;
            AppendTo( out, ",\\qquad d=", String(degrees[1]), ",\\dots,", String(degrees[Length(degrees)]), ".\n" );
        #
        # ----------------------------------------------------------
        # NON-REGULAR CASE
        # ----------------------------------------------------------
        #
        else
            for j in [1 .. Length(vectors)] do
                d := degrees[j];
                AppendTo( out, "\\nu_{", String(i), ",", String(d), "} &= " );
                nonzero_positions := Filtered( [1 .. Length(vectors[j])], p -> vectors[j][p] <> 0 );
                if Length(nonzero_positions) = 0 then
                    AppendTo( out, "0" );
                else
                    terms := [];
                    for p in nonzero_positions do
                        coeff := vectors[j][p];
                        if coeff = 1 then
                            term := Concatenation( "\\mathbf{e}_{", String(p), "}" );
                        elif coeff = -1 then
                            term := Concatenation("-\\mathbf{e}_{", String(p), "}" );
                        else
                            term := Concatenation( String(coeff), "\\mathbf{e}_{", String(p), "}" );
                        fi;
                        Add( terms, term );
                    od;
                    for p in [1 .. Length(terms)] do
                        if p > 1 then
                            if vectors[j][nonzero_positions[p]] > 0 then
                                AppendTo( out, " + " );
                            else
                                AppendTo( out, " " );
                            fi;
                        fi;
                        AppendTo( out, terms[p] );
                    od;
                fi;
                if j < Length(vectors) then
                    AppendTo( out, " \\\\\n" );
                else
                    AppendTo( out, "\n" );
                fi;
            od;
        fi;
    od;
    AppendTo( out, "\\end{align*}\n\n" );
    AppendTo(
        out,
        "\\[\n",
        "\\mathbf{e}_i \\in \\mathbb{Q}^{",
        String(dimension),
        "},\n",
        "\\qquad 1 \\leq i \\leq ",
        String(dimension),
        ".\n",
        "\\]\n"
    );
    CloseStream( out );
    return true;
end);

# ---------------------------------------------------------------------

InstallGlobalFunction( QGNAG_AllTPolynomialsToRecord, function( data_record_data_decomp, SimplesMn, rec_info_nichols )
    local nu,
          A,
          epsilon,
          coefficients,
          data,
          polynomial,
          numSimples,
          numShifts,
          shiftData,
          shiftCounts,
          j,
          p,
          d,
          k,
          coeff;

    numSimples := Length(SimplesMn);                                      # Number of simples
    nu         := QGNAG_AllShiftedVectorsLeft( data_record_data_decomp ); # Admissible shifted vectors
    A          := TransposedMat( nu );
    numShifts  := Length(nu);
    shiftData  := []; 
    for p in [1..numSimples] do     # Number of admissible shifts for each p.
        shiftData[p] := QGNAG_AllShiftedVectorsLeft( [ data_record_data_decomp[p] ] );
    od;
    shiftCounts := List( shiftData, Length );
    Print("Length(nu) = ", numShifts, "\n");
    Print("Shift counts = ", shiftCounts, "\n");
    # ============================================================
    # Initialize every polynomial directly as [0].
    #
    # data[j].p represents t_{j,p}(q).
    # ============================================================
    data := [];
    for j in [1..numSimples] do
        data[j]   := rec();
        # data[j].0 := [0];                 # Zero polynomial
        for p in [1..numSimples] do       # Every t_{j,p} starts as the zero polynomial.
            data[j].(String(p)) := [0];
        od;
    od;
    for j in [1..numSimples] do # Compute the coefficients f_{p,d}^j.
        epsilon := QGNAG_GradedFusionVector( j, SimplesMn, rec_info_nichols );
        if RankMat(A) = RankMat( TransposedMat( Concatenation(nu, [epsilon]) ) ) then
            coefficients := SolutionMat( TransposedMat(A), epsilon);
            if Length(coefficients) <> numShifts then
                Error( "Unexpected number of coefficients: ", Length(coefficients), " instead of ", numShifts );
            fi;
            k := 0; # Map the flattened coefficient vector to (p,d).
            for p in [1..numSimples] do
                for d in [0..shiftCounts[p]-1] do
                    k := k + 1;
                    coeff := coefficients[k];
                    if coeff <> 0 then
                        polynomial := data[j].(String(p));
                        # ------------------------------------------------
                        # Extend the coefficient vector only when
                        # the required degree is larger than its
                        # current length.
                        #
                        # For example:
                        #
                        #     [0] + coefficient at d=1
                        #          -> [0,coeff]
                        #
                        #     [0,coeff] + coefficient at d=3
                        #          -> [0,coeff,0,coeff]
                        # ------------------------------------------------
                        while Length(polynomial) < d + 1 do
                            Add(polynomial, 0);
                        od;
                        polynomial[d + 1] := polynomial[d + 1] + coeff;
                        data[j].(String(p)) := polynomial;
                    fi;
                od;
            od;
        else
            Print("Warning: epsilon_", j," is not in the span of the shifted vectors.\n");
        fi;
    od;
    return data;
end );

# ---------------------------------------------------------------------------------

InstallGlobalFunction( QGNAG_ClassifySimplesIntoBlocks, function( data_pols_decomp )
    local numSimples,
          remaining,
          blocks,
          j,
          p,
          block,
          newElements,
          polynomial,
          value;

        numSimples := Length(data_pols_decomp); # Number of simples
        remaining  := [1..numSimples];          # Initially every simple is unclassified.
        blocks     := rec();
        # ============================================================
        # Construct the blocks.
        #
        # For the smallest unclassified j:
        #
        #     B_j = { p : t_{j,p}(1) <> 0 }.
        #
        # Then continue until every simple is classified.
        # ============================================================
        while Length(remaining) > 0 do
            # --------------------------------------------------------
            # Smallest unclassified simple.
            # --------------------------------------------------------
            j := remaining[1];
            block := [];
            # --------------------------------------------------------
            # Compute
            #
            #     t_{j,p}(1)
            #
            # by summing the coefficient vector of t_{j,p}.
            # --------------------------------------------------------
            for p in remaining do
                polynomial := data_pols_decomp[j].(String(p));
                value      := Sum(polynomial);
                if value <> 0 then
                    Add(block, p);
                fi;
            od;
            blocks.(String(j)) := block;
            for p in block do # Remove all simples belonging to this block.
                RemoveSet(remaining, p);
            od;

        od;
        return blocks;
end);

InstallGlobalFunction( QGNAG_ClassifySimplesIntoBlocksContiguous,
    function( data_pols_decomp )
        local
            numSimples,
            unclassified,
            blocks,
            j,
            p,
            block,
            polynomial,
            blockIndex;

        numSimples := Length(data_pols_decomp);

        unclassified := [1..numSimples];

        blocks := rec();

        blockIndex := 1;

        while Length(unclassified) > 0 do

            # --------------------------------------------------------
            # Smallest unclassified simple.
            # --------------------------------------------------------
            j := unclassified[1];

            block := [];

            # --------------------------------------------------------
            # B_j = { p : t_{j,p}(1) <> 0 }.
            # --------------------------------------------------------
            for p in [1..numSimples] do

                polynomial :=
                    data_pols_decomp[j].(String(p));

                if Sum(polynomial) <> 0 then
                    Add(block, p);
                fi;

            od;

            # --------------------------------------------------------
            # Keep only unclassified simples.
            # --------------------------------------------------------
            block := Intersection(
                block,
                unclassified
            );

            # --------------------------------------------------------
            # Store with consecutive block index.
            # --------------------------------------------------------
            blocks.(String(blockIndex)) := block;

            # --------------------------------------------------------
            # Mark as classified.
            # --------------------------------------------------------
            for p in block do
                RemoveSet(unclassified, p);
            od;

            blockIndex := blockIndex + 1;

        od;

        return blocks;
    end);


InstallGlobalFunction( QGNAG_SaveBlockClassificationToLaTeX, function( filename, block_classification, SimpleNames )
    local out,
          blockNames,
          block,
          blockIndex,
          p,
          first;

    out := OutputTextFile(filename, false);
    
    AppendTo( out, "\\subsection{Separation into blocks}\n\n" );
    AppendTo( out, "Evaluate at $\\boldsymbol{q}=1$ to obtain the " );
    AppendTo( out, "ordinary multiplicities\n" );
    AppendTo( out, "\\[\n" );
    AppendTo( out, "t_{j,p}(1)");
    AppendTo( out, " = \\sum_{d=0}^{N_p} f_{p,d}^{j}.\n" );
    AppendTo( out, "\\]\n\n" );
    AppendTo( out, "The simple modules are partitioned into blocks according " );
    AppendTo( out, "to the non-vanishing of these ordinary multiplicities. " );
    AppendTo( out, "Starting with the smallest unclassified index $j$, we " );
    AppendTo( out, "define\n\n" );
    AppendTo( out, "\\[\n" );
    AppendTo( out, "B_j = \\{p : t_{j,p}(1) \\neq 0\\}.\n" );
    AppendTo( out, "\\]\n\n" );
    AppendTo( out, "The procedure is continued until every simple module " );
    AppendTo( out, "belongs to exactly one block.\n\n" );
    AppendTo( out, "\\begin{table}[ht]\n");
    AppendTo( out, "\\centering\n" );
    AppendTo( out, "\\begin{tabular}{c|c|l}\n" );
    AppendTo( out, "\\text{Block} & " );
    AppendTo( out, "\\text{Indices} & " );
    AppendTo( out, "\\text{Simple }D(G)\\text{-modules} " );
    AppendTo( out, "\\\\\\hline\n" );
    # ============================================================
    # Blocks
    # ============================================================
    blockNames := List(RecNames(block_classification), Int);
    Sort(blockNames);
    for blockIndex in [1..Length(blockNames)] do
        block := block_classification.( blockNames[blockIndex] );
        # --------------------------------------------------------
        # Block name
        # --------------------------------------------------------
        AppendTo( out, "$B_{", String(blockIndex), "}$ & " );
        # --------------------------------------------------------
        # Indices
        # --------------------------------------------------------
        AppendTo(out, "$\\{");
        first := true;
        for p in block do
            if not first then
                AppendTo(out, ",\\ ");
            fi;
            AppendTo( out, String(p) );
            first := false;
        od;
        AppendTo(out, "\\}$ & ");
        # --------------------------------------------------------
        # Simple names
        # --------------------------------------------------------
        first := true;
        for p in block do
            if not first then
                AppendTo(out, ",\\ ");
            fi;
            AppendTo( out, "$", SimpleNames[p], "$");
            first := false;
        od;
        AppendTo( out, " \\\\\n" );
    od;
    # ============================================================
    # Finish table
    # ============================================================
    AppendTo( out, "\\end{tabular}\n" );
    AppendTo( out, "\\caption{Block decomposition of the simple " );
    AppendTo( out, "$D(G)$-modules.}\n" );
    AppendTo( out, "\\label{tab:block-decomposition}\n" );
    AppendTo( out, "\\end{table}\n\n" );
    CloseStream(out);
end);