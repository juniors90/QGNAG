InstallGlobalFunction( QGNAG_SaveSimpleModulesNotationToLaTeX, function( filename, SimpleNames )
        local out, n, i, j, k;

        n := Length( SimpleNames );

        if n mod 4 <> 0 then
            Error( "The number of simple modules must be divisible by 4" );
        fi;

        out := OutputTextFile( filename, false );

        AppendTo( out,
            "## Notation for the Simple $\\mathcal{D}(G)$-Modules\n\n" );

        AppendTo( out, "$$\n" );
        AppendTo( out,
            "\\begin{array}{|c|l||c|l||c|l||c|l|}\n" );
        AppendTo( out, "\\hline\n" );

        for i in [ 1 .. n / 4 ] do

            for j in [ 1 .. 4 ] do

                k := 4 * ( i - 1 ) + j;

                AppendTo(
                    out,
                    "M_{", String(k), "} & ", SimpleNames[k]
                );

                if j < 4 then
                    AppendTo( out, " & \n" );
                else
                    AppendTo( out, "\\\\\n" );
                    AppendTo( out, "\\hline\n" );
                fi;

            od;

        od;

        AppendTo( out,
            "\\end{array}\n" );
        AppendTo( out,
            "$$\n" );

        CloseStream( out );

        return filename;
end);
### ------------------------------------------------------------ ###
InstallGlobalFunction( QGNAG_AllFusionRules, function( SimplesMn )
    local data,
          theta,
          i,
          j,
          k,
          Mi,
          Mj,
          tensor,
          decomposition,
          vector,
          term;

    theta := Length( SimplesMn );
    data  := [];
    for i in [2..theta] do
        for j in [i..theta] do
            Mi            := SimplesMn[i];
            Mj            := SimplesMn[j];
            tensor        := QGNAG_TensorProductOfSimples( Mi, Mj );
            decomposition := QGNAG_DecomposeDGRepresentation( tensor, SimplesMn );
            vector        := List( [1..theta], k -> 0 );
            for term in decomposition do
                k         := Position( SimplesMn, term[2] );
                vector[k] := term[1];
            od;
            Add( data, rec( first := i, second := j, vector := vector ) );
        od;
    od;
    return data;
end );


InstallGlobalFunction( QGNAG_GetTensorVectorEntry, function(data_fusion_rules, i, j, k)
    local pos, index_i, index_j;
    index_i := Minimum(i, j);
    index_j := Maximum(i, j);
    pos     := PositionProperty(
        data_fusion_rules,
        r -> r.first = index_i and r.second = index_j 
    );
    if pos = fail then
        Error("No record found for the pair (i, j)");
    fi;
    return data_fusion_rules[pos].vector[k];
end);


InstallGlobalFunction( QGNAG_PrintFusionRules, function( data_fusion_rules )
    local theta,
          i,
          j,
          k,
          rhs,
          mult;

    theta := Maximum(List(data_fusion_rules, r -> r.second));;
    for i in [2..theta] do
        Print("--------------------------------------------------------------\n");
        for j in [i..theta] do
            rhs := "";
            for k in [1..theta] do
                mult := QGNAG_GetTensorVectorEntry(data_fusion_rules, i, j, k);
                if mult > 0 then
                    if rhs <> "" then
                        rhs := Concatenation(rhs, " \\oplus ");
                    fi;
                    if mult = 1 then
                        rhs := Concatenation( rhs, "M", String(k) );
                    else
                        rhs := Concatenation( rhs, String(mult), " M", String(k)
                        );
                    fi;
                fi;
            od;
            Print( "M", i, " \\otimes M", j, " \\simeq ", rhs, "\n");
        od;
    od;
end );


InstallGlobalFunction( QGNAG_LoadFusionRuleToLaTeX, function( out, data_fusion_rules, i, j )
    local vector,
          k,
          mult,
          first,
          theta;
    
    theta := Maximum(List(data_fusion_rules, r -> r.second));;
    AppendTo( out, "M_{", String(i), "} &\\otimes M_{", String(j), "} \\simeq " );
    first := true;
    for k in [1..theta] do
        mult := QGNAG_GetTensorVectorEntry(data_fusion_rules, i, j, k);;
        if mult > 0 then
            if not first then
                AppendTo(out, " \\oplus ");
            fi;
            first := false;
            if mult = 1 then
                AppendTo( out, "M_{", String(k), "}" );
            else
                AppendTo( out, String(mult), "M_{", String(k), "}" );
            fi;
        fi;
    od;
end );

InstallGlobalFunction( QGNAG_LoadAllFusionRulesToLaTeX, function(filename, data_fusion_rules )
    local theta,
          i,
          j,
          out;

    out   := OutputTextFile(filename, false);
    theta := Maximum(List(data_fusion_rules, r -> r.second));;
    for i in [2..theta] do
        AppendTo(out, Concatenation( "\\subsubsection{$ M_{", String(i), "}\\otimes -$}\n\\begin{align*}\n"));
        for j in [i..theta] do
            QGNAG_LoadFusionRuleToLaTeX( out, data_fusion_rules, i, j);
            AppendTo(out, " \\\\\n");
        od;
        AppendTo(out, "\\end{align*}\n\n");
    od;
end);


InstallGlobalFunction(QGNAG_LoadFusionRuleWithNamesToLaTeX, function( out, data_fusion_rules, i, j, SimpleNames )
    local theta,
          k,
          mult,
          first;
    theta := Maximum(List(data_fusion_rules, r -> r.second));;
    AppendTo( out, SimpleNames[i], " &\\otimes ", SimpleNames[j], " \\simeq " );
    first := true;
    for k in [2..theta] do
        mult := QGNAG_GetTensorVectorEntry(data_fusion_rules, i, j, k);;
        if mult > 0 then
            if not first then
                AppendTo(out, " \\oplus ");
            fi;
            first := false;
            if mult = 1 then
                AppendTo(out, SimpleNames[k]);
            else
                AppendTo( out, String(mult), " ", SimpleNames[k] );
            fi;
        fi;
    od;
end );

InstallGlobalFunction(QGNAG_LoadAllFusionRulesWithNamesToLaTeX, function( filename, data_fusion_rules, SimpleNames )
    local theta,
          i,
          j,
          out;

    out   := OutputTextFile(filename, false);
    theta := Maximum(List(data_fusion_rules, r -> r.second));;

    for i in [2..theta] do
        AppendTo( out, Concatenation("\\subsubsection{$ ", SimpleNames[i], "\\otimes -$}\n", "\\begin{align*}\n" ) );
        for j in [i..theta] do
            QGNAG_LoadFusionRuleWithNamesToLaTeX(out, data_fusion_rules, i, j, SimpleNames);
            AppendTo(out, " \\\\\n");
        od;
        AppendTo( out, "\\end{align*}\n\n" );
    od;
    CloseStream(out);
end);


InstallGlobalFunction( QGNAG_LoadFusionRulesToLaTeXSingleLong, function( filename, data_fusion_rules, SimpleNames, maxTerms )
    local out,
          i,
          j,
          pos,
          theta,
          vector,
          numberOfTerms,
          pending;

    out   := OutputTextFile(filename, false);
    theta := Maximum(List(data_fusion_rules, r -> r.second));;
    
    for i in [2..theta] do
        AppendTo( out, StringFormatted( "\\subsubsection{{$ {}\\otimes -$}}\n\\begin{{align*}}\n", SimpleNames[i] ) );
        pending := false;
        for j in [i..theta] do
            pos           := PositionProperty( data_fusion_rules, r -> r.first = i and r.second = j );
            vector        := data_fusion_rules[pos].vector;
            numberOfTerms := Number( vector, x -> x > 0);
            #
            # Regla demasiado larga:
            # siempre ocupa una línea.
            #
            if numberOfTerms > maxTerms then
                if pending then
                    AppendTo(out, "\\\\\n");
                    pending := false;
                fi;
                QGNAG_LoadFusionRuleWithNamesToLaTeX( out, data_fusion_rules, i, j, SimpleNames );
                AppendTo(out, "\\\\\n");
            #
            # Regla corta.
            #
            else
                if not pending then
                    QGNAG_LoadFusionRuleWithNamesToLaTeX( out, data_fusion_rules, i, j, SimpleNames );
                    pending := true;
                else
                    AppendTo(out, " &&& ");
                    QGNAG_LoadFusionRuleWithNamesToLaTeX( out, data_fusion_rules, i, j, SimpleNames );
                    AppendTo(out, "\\\\\n");
                    pending := false;
                fi;
            fi;
        od;
        if pending then
            AppendTo(out, "\n");
        fi;
        AppendTo(out, "\\end{align*}\n\n");
    od;
    CloseStream(out);
end);

#--------------------------------------------------------------------------- #
InstallGlobalFunction( QGNAG_PermutationFusionRulesFailures, function( sigma, Simples, data_fusion_rules )
    local a, 
          b, 
          c,
          theta,
          a_sigma, 
          b_sigma,
          c_sigma,
          a_sigma_m,
          b_sigma_m,
          vector_ab,
          vector_sigma,
          pos_ab,
          pos_sigma,
          degree_a,
          degree_b,
          degree_c,
          dimension_ab,
          dimension_sigma,
          dimension_from_decomposition,
          failures;

    failures := [];
    theta    := Length(Simples);

    for a in [2..theta] do
        for b in [a..theta] do
            pos_ab       := PositionProperty( data_fusion_rules, r -> r.first = a and r.second = b );
            vector_ab    := data_fusion_rules[pos_ab].vector;
            a_sigma      := a^sigma;
            b_sigma      := b^sigma;
            a_sigma_m    := Minimum(a_sigma, b_sigma);
            b_sigma_m    := Maximum(a_sigma, b_sigma);
            pos_sigma    := PositionProperty( data_fusion_rules, r -> r.first = a_sigma_m and r.second = b_sigma_m );
            vector_sigma := data_fusion_rules[pos_sigma].vector;
            #--------------------------------------------------
            # Check dimensions
            #--------------------------------------------------
            degree_a     := DegreeOfRepresentation(Simples[a].simple);
            degree_b     := DegreeOfRepresentation(Simples[b].simple);
            dimension_ab := degree_a * degree_b;
            dimension_from_decomposition := 0;

            for c in [1..theta] do
                degree_c                     := DegreeOfRepresentation(Simples[c].simple);
                dimension_from_decomposition := dimension_from_decomposition + vector_ab[c] * degree_c;
            od;

            if dimension_ab <> dimension_from_decomposition then
                Print(
                    StringFormatted(
                        "Dimension mismatch: a = {}, b = {}, {} <> {}\n",
                        a,
                        b,
                        dimension_ab,
                        dimension_from_decomposition
                    )
                );

                Add(
                    failures,
                    rec(
                        type := "dimension",
                        a := a,
                        b := b,
                        dimension_tensor := dimension_ab,
                        dimension_decomposition :=
                            dimension_from_decomposition
                    )
                );

                continue;

            fi;

            #--------------------------------------------------
            # Check permutation of fusion rules
            #--------------------------------------------------

            for c in [1..theta] do

                c_sigma := c^(sigma^-1);

                if vector_sigma[c] <> vector_ab[c_sigma] then

                    Print(
                        StringFormatted(
                            "Mismatch: a = {}, b = {}, c = {}, {} <> {}\n",
                            a,
                            b,
                            c,
                            vector_sigma[c],
                            vector_ab[c_sigma]
                        )
                    );

                    Add(
                        failures,
                        rec(
                            type := "multiplicity",
                            a := a,
                            b := b,
                            c := c,
                            mult_sigma := vector_sigma[c],
                            mult := vector_ab[c_sigma]
                        )
                    );

                fi;

            od;

        od;

    od;
    return failures;
end );

InstallGlobalFunction( QGNAG_TestPermutationFusionRules, function( sigma, Simples, data_fusion_rules )

    local failures, failure;

    failures := QGNAG_PermutationFusionRulesFailures( sigma, Simples, data_fusion_rules );

    if IsEmpty(failures) then

        Print(
            "\n",
            "========================================\n",
            "  Permutation fusion test: PASSED\n",
            "========================================\n",
            "The permutation preserves all fusion rules.\n",
            "\n"
        );
        return true;
    fi;

    Print(
        "\n",
        "========================================\n",
        "  Permutation fusion test: FAILED\n",
        "========================================\n",
        "Number of failures: ",
        Length(failures),
        "\n",
        "\n"
    );
    for failure in failures do

        if failure.type = "dimension" then

            Print(
                "Dimension mismatch:\n",
                "  (a,b) = (",
                failure.a,
                ", ",
                failure.b,
                ")\n",
                "  dim(M_a tensor M_b) = ",
                failure.dimension_tensor,
                "\n",
                "  dimension from fusion rule = ",
                failure.dimension_decomposition,
                "\n",
                "\n"
            );

        elif failure.type = "multiplicity" then
            Print(
                "Multiplicity mismatch:\n",
                "  (a,b,c) = (",
                failure.a,
                ", ",
                failure.b,
                ", ",
                failure.c,
                ")\n",
                "  N_c^{a^sigma,b^sigma} = ",
                failure.mult_sigma,
                "\n",
                "  N_{c^sigma^-1}^{a,b} = ",
                failure.mult,
                "\n",
                "\n"
            );
        fi;
    od;
    return false;
end );

#-------------------------------------------------------------------------


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



InstallGlobalFunction( QGNAG_PrintAllQP, function( epsilon_and_coeffs, names )
    local index_s;
    for index_s in [1..Length(epsilon_and_coeffs)] do
        QGNAG_PrintQP(epsilon_and_coeffs[index_s].coefficients, names);
        Print("=============================================================================\n");
    od;
    return 0;
end);


InstallGlobalFunction(QGNAG_LoadNuTableToLaTeX, function( filename, data_record_data_decomp, SimpleNames, sign )
    local out,
          NuVectorNames,
          i,
          j,
          d,
          dmin,
          dminDisplay,
          shifts,
          nshift,
          total,
          lname,
          degrees,
          supportDegrees,
          n,
          half,
          left,
          right,
          GetRow;

    out           := OutputTextFile( filename, false );
    NuVectorNames := QGNAG_NuVectorNames( data_record_data_decomp );  # always on the ORIGINAL, unshifted data
    total         := Length( NuVectorNames );

    n    := Length( data_record_data_decomp );
    half := Int( n / 2 );

    GetRow := function( i )
        local dmin,
          dminDisplay,
          degrees,
          supportDegrees,
          d,
          shifts,
          nshift,
          lname,
          shiftedEnd,
          rangeLow,
          rangeHigh;
          
        # Degree-key-agnostic d_min(L_i), computed on the ORIGINAL (positive)
        # degree keys -- this never depends on sign.
        degrees := List( RecNames( data_record_data_decomp[i][1] ), Int );
        supportDegrees := Filtered( degrees, d ->
            Sum( List( data_record_data_decomp[i], x -> x.(String(d)) ) ) > 0
        );
        if Length(supportDegrees) = 0 then
            dmin := fail;
            dminDisplay := fail;
        else
            dmin := Minimum( supportDegrees );
            dminDisplay := sign * dmin;
        fi;
        
        # Number of admissible shifts for L_i -- also computed on the
        # original NuVectorNames, unaffected by sign.
        
        shifts := Filtered( NuVectorNames, name -> PositionSublist(
            name, Concatenation("\\nu_{", String(i), ",") ) <> fail );
        
        nshift := Length( shifts );
        lname := Concatenation( "L", SimpleNames[i]{[2 .. Length(SimpleNames[i])]} );  # Name L_i
        if nshift = 1 then
            return [ lname, String(dminDisplay), shifts[1] ];
        else
            shiftedEnd := sign * (nshift - 1);
            rangeLow   := Minimum( 0, shiftedEnd );  # always display low..high, never 0..negative
            rangeHigh  := Maximum( 0, shiftedEnd );
            return [
                    lname, 
                    String(dminDisplay),
                    Concatenation( "\\nu_{", String(i), ",d}, ", "d=", String(rangeLow), ",\\dots,", String(rangeHigh) )
                ];
        fi;
    end;

    AppendTo( out, "\\[\n" );
    AppendTo( out, "\\begin{array}{c|c|c||c|c|c}\n" );
    AppendTo(
        out,
        "L_i & d_{\\min}(L_i) & \\text{Shift }(\\nu) ",
        "&- ", 
        "L_i & d_{\\min}(L_i) & \\text{Shift }(\\nu) \\\\ \\hline\n"
    );

    for j in [1 .. half] do
        left  := GetRow( j );
        right := GetRow( j + half );
        AppendTo(
            out,
            left[1], " & ",
            left[2], " & ",
            left[3],
            " & ",
            right[1], " & ",
            right[2], " & ",
            right[3],
            " \\\\ \n"
        );
    od;
    AppendTo( out, "\\hline\n" );
    AppendTo(
        out,
        "\\multicolumn{3}{c||}{\\text{Total}} ",
        "& \\multicolumn{3}{c}{\\mathbf{", String(total), "}} \\\\ \n"
    );
    AppendTo( out, "\\end{array}\n" );
    AppendTo( out, "\\]\n" );
    CloseStream( out );
end );


# ------------------------------------------------------------------------
InstallGlobalFunction( QGNAG_FusionRulesMultiplicity, function( index_i, index_s, index_k, data_fusion_rules )
    local i, s, theta, N_is_k;

    theta := Maximum(List(data_fusion_rules, r -> r.second));;

    if not IsInt(index_i) or index_i < 1 or index_i > theta then
        Error("index_i must be an integer between 1 and ", theta);
    fi;

    if not IsInt(index_s) or index_s < 1 or index_s > theta then
        Error("index_s must be an integer between 1 and ", theta);
    fi;

    if not IsInt(index_k) or index_k < 1 or index_k > theta then
        Error("index_k must be an integer between 1 and ", theta);
    fi;

    # Los datos están almacenados con i <= s.
    i := Minimum(index_i, index_s);
    s := Maximum(index_i, index_s);

    # M_1 es el objeto neutro:
    #
    # M_1 tensor M_s = M_s.
    #
    # Por tanto N_{1,s}^k = delta_{s,k}.
    if i = 1 then
        if s = index_k then
            return 1;
        else
            return 0;
        fi;
    fi;
    N_is_k := QGNAG_GetTensorVectorEntry(data_fusion_rules, i, s, index_k);
    return N_is_k;

end );

InstallGlobalFunction( QGNAG_NicholsGradedMultiplicity, function( index_i, index_j, rec_info_nichols )
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


InstallGlobalFunction( QGNAG_GradedFusionRulesMultiplicity, function( index_l, index_k, index_j, rec_info_nichols, data_fusion_rules)
    local index_i,
          N_il_k,
          b_ij,
          theta,
          result;

    result := 0;
    theta := Maximum(List(data_fusion_rules, r -> r.second));;
    for index_i in [1 .. theta] do
        # Mi_tensor_Ml_mats, Mk_mats
        N_il_k  := QGNAG_FusionRulesMultiplicity( index_i, index_l, index_k, data_fusion_rules ); 
        b_ij    := QGNAG_NicholsGradedMultiplicity( index_i, index_j, rec_info_nichols );
        result  := result + N_il_k * b_ij;
    od;    
    return result;
end);


InstallGlobalFunction(QGNAG_GradedFusionRulesByDegree, function( index_s, rec_info_nichols, data_fusion_rules )
    local theta,
          ell,
          data,
          index_k,
          index_j,
          r;
    ell   := Maximum( List( RecNames( rec_info_nichols ), Int ) );
    theta := Maximum( List( data_fusion_rules, r -> r.second ) );;
    data  := [];
    for index_k in [1 .. theta] do
        r := rec();
        for index_j in [0 .. ell] do
            r.(String(index_j)) := QGNAG_GradedFusionRulesMultiplicity( index_s, index_k, index_j, rec_info_nichols, data_fusion_rules );
        od;
        Add(data, r);
    od;
    return data;
end);


InstallGlobalFunction( QGNAG_GradedFusionRulesVector, function( index_s, data_graded )
    local epsilon_s,
          index_j,
          index_k,
          theta,
          ell;

    theta     := Length(data_graded);
    ell       := Maximum(List(RecNames(data_graded[1][1]), Int));
    epsilon_s := [];
    for index_j in [0 .. ell] do
        for index_k in [1 .. theta] do
            Add( epsilon_s, data_graded[index_s][index_k].(String(index_j)) );
        od;
    od;
    return epsilon_s;
end );



InstallGlobalFunction( QGNAG_AllGradedFusionData, function( rec_info_nichols, data_fusion_rules)
    local data,
          data_s,
          data_k,
          index_s,
          index_k,
          index_j,
          theta,
          ell;

    theta := Maximum(List(data_fusion_rules, r -> r.second));;
    ell   := Maximum(List(RecNames(rec_info_nichols), Int));

    data := [];

    for index_s in [1 .. theta] do
        data_s := [];
        for index_k in [1 .. theta] do
            data_k := rec();
            for index_j in [0 .. ell] do
                data_k.(String(index_j)) := QGNAG_GradedFusionRulesMultiplicity(
                        index_s,
                        index_k,
                        index_j,
                        rec_info_nichols,
                        data_fusion_rules
                    );
            od;
            Add(data_s, data_k);
        od;
        Add(data, data_s);
    od;
    return data;
end );


InstallGlobalFunction( QGNAG_GradedFusionDataMultiplicity, function( index_s, index_k, index_j, data_gradeed )
    return data_gradeed[index_s][index_k](String(index_j));
end );


InstallGlobalFunction( QGNAG_ExportGradedFusionRulesByDegreeToLaTeX, function( filename, data_graded )
    local out,
          s,
          j,
          k,
          theta,
          ell;

    theta := Length(data_graded);
    ell   := Maximum(List(RecNames(data_graded[1][1]), Int));
    out   := OutputTextFile(filename, false);
    for s in [1..theta] do
        AppendTo( out, Concatenation( "\\subsubsection{Multiplicity table for $M_{", String(s), "}$}\n\n" )
        );
        AppendTo(out, "\\begin{table}[ht]\n");
        AppendTo(out, "\\centering\n");
        AppendTo(out, "\\begin{tabular}{c|");
        for k in [1..theta] do
            AppendTo(out, "c");
        od;
        AppendTo(out, "}\n\\hline\n");
        AppendTo(out, "$j$");
        for k in [1..theta] do
            AppendTo( out, StringFormatted( " & $M_{{{}}}$", k )
            );
        od;
        AppendTo(out, " \\\\\n\\hline\n");
        for j in [0..ell] do
            AppendTo( out, String(j) );
            for k in [1..theta] do
                AppendTo( out, StringFormatted( " & {}", data_graded[s][k].(String(j)) ) );
            od;
            AppendTo(out, " \\\\\n");
        od;
        AppendTo(out, "\\hline\n");
        AppendTo(out, "\\end{tabular}\n");
        AppendTo( out, Concatenation( "\\caption{Multiplicity table for $M_{", String(s), "}$.}\n" ) );
        AppendTo(out, "\\end{table}\n\n");
    od;
    CloseStream(out);

end );

# -----------------------------------------------------------------

InstallGlobalFunction( QGNAG_QuantumCharatersAndCoefficients, function( data_graded, nu )
    local theta,
          results,
          index_i,
          epsilon_i,
          coeffs;
    
    theta   := Length( data_graded );
    results := [];
    for index_i in [1 .. theta] do
        epsilon_i := QGNAG_GradedFusionRulesVector( index_i, data_graded );  # 1. Compute epsilon for the current index
        coeffs    := SolutionMat( nu, epsilon_i ); # 2. Solve the linear system (nu * coeffs = epsilon)
        Add( results, rec(                         # 3. Store in the list of records
             vector       := epsilon_i, 
             coefficients := coeffs                # If no solution exists, SolutionMat returns 'fail'
        ));
    od;
    return results;
end );


InstallGlobalFunction( QGNAG_QPToLaTeX, function( coeffs, names, index )
    local terms,
          i,
          c,
          s,
          result;

    terms  := [];
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
        result := Concatenation("\\epsilon_{", String(index), "} = 0");
    else
        result := Concatenation("\\epsilon_{", String(index), "} = ");
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


InstallGlobalFunction( QGNAG_LoadQuantumCharactersToLaTeX, function(filename, epsilon_and_coeffs, NuVectorNames, SimpleNames)
    local isValid,
          out,
          index_s,
          epsilon,
          sNames,
          coefficients,
          result;

    isValid := IsList(epsilon_and_coeffs) 
               and not IsEmpty(epsilon_and_coeffs)
               and ForAll(epsilon_and_coeffs, r -> 
                   IsRecord(r) 
                   and IsBound(r.vector) and IsList(r.vector)
                   and IsBound(r.coefficients) and IsList(r.coefficients)
               );

    if not isValid then
        Error("Invalid 'epsilon_and_coeffs' argument.\n",
              "It must be a list of records with 'vector' and 'coefficients' fields.\n",
              "Please generate it using:\n",
              "  epsilon_and_coeffs := QGNAG_QuantumCharatersAndCoefficients( data_graded, nu );\n");
    fi;

    out    := OutputTextFile(filename, false);
    sNames := List(SimpleNames, QGNAG_ExtractTuple);
    for index_s in [1..Length(epsilon_and_coeffs)] do
        epsilon      := epsilon_and_coeffs[index_s].vector;
        coefficients := epsilon_and_coeffs[index_s].coefficients;
        result       := QGNAG_QPToLaTeX( coefficients, NuVectorNames, index_s );
        
        #AppendTo(out, Concatenation("\\subsubsection*{$L", sNames[index_s], "$}\n"));
        AppendTo(out, Concatenation("\\subsubsection*{$L_{", String(index_s), "}$}\n"));
        AppendTo(out, "$\n");
        AppendTo(out, result);
        AppendTo(out, "\n$\n\n");
    od;
    
    CloseStream(out);
end);


# ---------------------------------------------------------------------
InstallGlobalFunction( QGNAG_QuantumPolynomialsToRecord, function( data_record_data_decomp, epsilon_and_coeffs )
    local epsilon,
          coefficients,
          data,
          polynomial,
          theta,
          numShifts,
          shiftData,
          shiftCounts,
          index_s,
          p,
          d,
          k,
          coeff;

    theta      := Length(epsilon_and_coeffs);    # Number of simples
    numShifts  := Length(epsilon_and_coeffs[1].coefficients);
    shiftData  := []; 
    for p in [1..theta] do     # Number of admissible shifts for each p.
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
    
    for index_s in [1..theta] do
        data[index_s] := rec();
        for p in [1..theta] do       # Every t_{j,p} starts as the zero polynomial.
            data[index_s].(String(p)) := [0];
        od;
    od;

    for index_s in [1..theta] do # Compute the coefficients f_{p,d}^j.
        epsilon      := epsilon_and_coeffs[index_s].vector;
        coefficients := epsilon_and_coeffs[index_s].coefficients;
        if Length(coefficients) <> numShifts then
             Error( "Unexpected number of coefficients: ", Length(coefficients), " instead of ", numShifts );
        fi;
        k := 0; # Map the flattened coefficient vector to (p,d).
        for p in [1..theta] do
            for d in [0..shiftCounts[p]-1] do
                k := k + 1;
                coeff := coefficients[k];
                if coeff <> 0 then
                    polynomial := data[index_s].(String(p));
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
                    data[index_s].(String(p)) := polynomial;
                fi;
            od;
        od;
    od;
    return data;
end );


InstallGlobalFunction( QGNAG_EvaluateQuantumPolynomialsRecord, function( data_quantum_pols )
    local EvaluateSingleRecord;
    # Función auxiliar para evaluar un solo record
    EvaluateSingleRecord := function( r )
        local eval_rec, name, val;
        eval_rec := rec();
        for name in RecNames( r ) do
            val := r.(name);
            if IsList( val ) then
                eval_rec.(name) := Sum( val );
            else
                eval_rec.(name) := val;
            fi;
        od;
        return eval_rec;
    end;

    # Permite recibir la lista completa de records o un solo record
    if IsList( data_quantum_pols ) then
        return List( data_quantum_pols, EvaluateSingleRecord );
    elif IsRecord( data_quantum_pols ) then
        return EvaluateSingleRecord( data_quantum_pols );
    else
        Error("Input must be a record or a list of records.");
    fi;
end);


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


InstallGlobalFunction( QGNAG_ClassifySimplesIntoBlocksContiguous, function( data_pols_decomp )
    local numSimples,
          adjacency,
          p,
          q,
          polynomial_pq,
          polynomial_qp,
          visited,
          components,
          comp,
          queue,
          current,
          neighbor,
          blocks,
          blockIndex;

    numSimples := Length(data_pols_decomp);
    # Grafo simetrico: p ~ q  si  t_{p,q}(1) <> 0  o  t_{q,p}(1) <> 0
    adjacency := List( [1..numSimples], x -> [] );
    for p in [1..numSimples] do
        for q in [1..numSimples] do
            if p <> q then
                polynomial_pq := data_pols_decomp[p].(String(q));
                polynomial_qp := data_pols_decomp[q].(String(p));
                if Sum(polynomial_pq) <> 0 or Sum(polynomial_qp) <> 0 then
                    Add( adjacency[p], q );
                fi;
            fi;
        od;
    od;
    # Componentes conexas via BFS: esto reproduce el "seguir clasificando"
    # transitivamente del algoritmo del pizarron, no solo los vecinos directos de j.
    visited    := BlistList( [1..numSimples], [] );
    components := [];
    for p in [1..numSimples] do
        if not visited[p] then
            comp       := [];
            queue      := [p];
            visited[p] := true;
            while Length(queue) > 0 do
                current := Remove(queue, 1);
                Add(comp, current);
                for neighbor in adjacency[current] do
                    if not visited[neighbor] then
                        visited[neighbor] := true;
                        Add(queue, neighbor);
                    fi;
                od;
            od;
            Sort(comp);
            Add(components, comp);
        fi;
    od;
    # Ordenar los bloques por su elemento minimo (orden j_1 < j_2 < ... del pizarron)
    # e indexar consecutivamente.
    Sort( components, function(a,b) return a[1] < b[1]; end );
    blocks     := rec();
    blockIndex := 1;
    for comp in components do
        blocks.(String(blockIndex)) := comp;
        blockIndex := blockIndex + 1;
    od;
    return blocks;
end);


InstallGlobalFunction( QGNAG_LoadBlockClassificationToLaTeX, function( filename, block_classification, SimpleNames )
    local out,
          blockNames,
          block,
          blockIndex,
          p,
          sNamesL,
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
    AppendTo( out, "\\text{Simple }D(H)\\text{-modules} " );
    AppendTo( out, "\\\\\\hline\n" );
    # ============================================================
    # Blocks
    # ============================================================
    blockNames := List(RecNames(block_classification), Int);
    sNamesL := List( SimpleNames, QGNAG_ExtractTuple);
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
            AppendTo( out, "$L", sNamesL[p], "$");
            first := false;
        od;
        AppendTo( out, " \\\\\n" );
    od;
    # ============================================================
    # Finish table
    # ============================================================
    AppendTo( out, "\\end{tabular}\n" );
    AppendTo( out, "\\caption{Block decomposition of the simple " );
    AppendTo( out, "$D(H)$-modules.}\n" );
    AppendTo( out, "\\label{tab:block-decomposition}\n" );
    AppendTo( out, "\\end{table}\n\n" );
    CloseStream(out);
end);



InstallGlobalFunction( QGNAG_LoadAllTPolynomialsToLaTeX, function( filename, data_record_data_decomp, epsilon_and_coeffs, SimpleNames )
    local
        out,
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
        theta,
        numShifts,
        shiftCounts,
        simpleName,
        shiftData,
        closebrace;

    out        := OutputTextFile(filename, false);
    # ============================================================
    # The admissible shifted vectors
    # ============================================================
    NuVectorNames := QGNAG_NuVectorNames(data_record_data_decomp);
    shiftData     := []; 
    theta         := Length(epsilon_and_coeffs);    # Number of simples
    for p in [1..theta] do     # Number of admissible shifts for each p.
        shiftData[p] := QGNAG_AllShiftedVectorsLeft( [ data_record_data_decomp[p] ] );
    od;
    shiftCounts := List( shiftData, Length );
    numShifts   := Length(epsilon_and_coeffs[1].coefficients);
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
    for p in [1..theta] do
        T[p] := [];
        for j in [1..theta] do
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
    for j in [1..theta] do
        epsilon      := epsilon_and_coeffs[j].vector;
        coefficients := epsilon_and_coeffs[j].coefficients;
        if Length(coefficients) <> numShifts then
            Error( "Unexpected number of coefficients: ", Length(coefficients),  " instead of ", numShifts );
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
                T[pName][j][dName+1] := T[pName][j][dName+1] + coeff;
            fi;
        od;
    od;
    AppendTo( out, "\\section{Polynomials $t_{j,p}(\\boldsymbol{q})$}\n\n" ); # Section
    AppendTo( out, "\\[\nt_{j,p}(\\boldsymbol{q}) = \\sum_{d} f_{p,d}^{j}\\boldsymbol{q}^{-d}\n\\]\n\n"); # Formula
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
    for p in [1..theta] do
        AppendTo(out, "|c");
    od;
    AppendTo( out, "}\n" );
    # Header
    AppendTo( out, "j & \\text{Simple}" );
    for p in [1..theta] do
        AppendTo( out, " & t_{j,", String(p), "}(\\boldsymbol{q})" );
    od;
    AppendTo( out, " \\\\\\hline\n");
    # ============================================================
    # Rows
    # ============================================================
    for j in [1..theta] do
        AppendTo( out, String(j), " & ", SimpleNames[j] );
        for p in [1..theta] do
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
                            term := Concatenation( "\\boldsymbol{q}^{-", String(d), "}" );
                        elif coeff = -1 then
                            term := Concatenation( "-\\boldsymbol{q}^{-", String(d), "}" );
                        else
                            term := Concatenation( String(coeff), "\\,\\boldsymbol{q}^{-", String(d), "}" );
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