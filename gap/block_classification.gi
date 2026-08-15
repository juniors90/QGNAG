### ------------------------------------------------------------ ###
InstallGlobalFunction( QGNAG_AllFusionRules, function( SimplesMn )
    local data,
          theta,
          i,
          l,
          k,
          Mi,
          Ml,
          tensor,
          decomposition,
          vector,
          term;

    theta := Length(SimplesMn);
    data  := rec();
    for i in [1..theta] do
        data.(String(i)) := rec();
        for l in [i..theta] do
            Mi            := SimplesMn[i];
            Ml            := SimplesMn[l];
            tensor        := QGNAG_TensorProductOfSimples( Mi, Ml );
            decomposition := QGNAG_DecomposeDGRepresentation( tensor, SimplesMn );
            vector        := List([1..theta], k -> 0);
            for term in decomposition do
                k := Position(SimplesMn, term[2]);
                vector[k] := term[1];
            od;
            data.(String(i)).(String(l)) := rec(
                first := i,
                second := l,
                vector := vector
            );
        od;
    od;
    return data;
end );

InstallGlobalFunction( QGNAG_FusionMultiplicityRecord, function( data_fusion, index_i, index_l, index_k )
    local i, l, theta;

    theta := Length(RecNames(data_fusion));
    if not IsInt(index_i) or index_i < 1 or index_i > theta then
        Error("index_i must be an integer between 1 and ", theta);
    fi;
    if not IsInt(index_l) or index_l < 1 or index_l > theta then
        Error("index_l must be an integer between 1 and ", theta);
    fi;
    if not IsInt(index_k) or index_k < 1 or index_k > theta then
        Error("index_k must be an integer between 1 and ", theta);
    fi;
    i := Minimum(index_i, index_l);
    l := Maximum(index_i, index_l);

    return data_fusion.(String(i)).(String(l)).vector[index_k];

end );

InstallGlobalFunction( QGNAG_PrintFusionRules, function( data_fusion )
    local theta,
          i,
          l,
          k,
          vector,
          rhs,
          mult;

    theta := Length(RecNames(data_fusion));
    for i in [2..theta] do
        Print("--------------------------------------------------------------\n");
        for l in [i..theta] do
            vector := data_fusion.(String(i)).(String(l)).vector;
            rhs := "";
            for k in [1..theta] do
                mult := vector[k];
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
            Print( "M", String(i), " \\otimes M", String(l), " \\simeq ", rhs, "\n"
            );
        od;
    od;
end );

InstallGlobalFunction( QGNAG_LoadFusionRuleToLaTeX, function( out, data_fusion, i, l )
    local vector,
          k,
          mult,
          first;

    vector := data_fusion.(String(Minimum(i,l))).(String(Maximum(i,l))).vector;
    AppendTo( out, "M_{", String(i), "} &\\otimes M_{", String(l), "} \\simeq " );
    first := true;
    for k in [1..Length(vector)] do
        mult := vector[k];
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

InstallGlobalFunction( QGNAG_LoadAllFusionRulesToLaTeX, function(filename, data_fusion )
    local theta, i, l, out;
    out := OutputTextFile(filename, false);
    theta := Length(RecNames(data_fusion));

    for i in [2..theta] do
        AppendTo(out, Concatenation( "\\subsubsection{$ M_{", String(i), "}\\otimes -$}\n\\begin{align*}\n"));
        for l in [i..theta] do
            QGNAG_LoadFusionRuleToLaTeX( out, data_fusion, i, l);
            AppendTo(out, " \\\\\n");
        od;
        AppendTo(out, "\\end{align*}\n\n");
    od;
end);

#--------------------------------------------------------------------------- #
InstallGlobalFunction( QGNAG_PermutationFusionRules, function(
    sigma, Simples, data_record )

    local a, b, c,
          theta,
          a_sigma, b_sigma,
          c_sigma,
          vector_ab,
          vector_sigma,
          degree_a,
          degree_b,
          degree_c,
          dimension_ab,
          dimension_sigma,
          dimension_from_decomposition,
          failures;

    failures := [];
    theta := Length(Simples);

    for a in [2..theta] do

        for b in [a..theta] do

            vector_ab :=
                data_record.(String(a)).(String(b)).vector;

            a_sigma := a^sigma;
            b_sigma := b^sigma;

            vector_sigma :=
                data_record.(
                    String(Minimum(a_sigma, b_sigma))
                ).(
                    String(Maximum(a_sigma, b_sigma))
                ).vector;

            #--------------------------------------------------
            # Check dimensions
            #--------------------------------------------------

            degree_a :=
                DegreeOfRepresentation(Simples[a].simple);

            degree_b := DegreeOfRepresentation(Simples[b].simple);
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

InstallGlobalFunction( QGNAG_TestPermutationFusionRules, function( sigma, Simples, data_fusion )

    local failures, failure;

    failures := QGNAG_PermutationFusionRules( sigma, Simples, data_fusion );

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