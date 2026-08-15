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