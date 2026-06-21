
InstallGlobalFunction( QGNAG_VermaModuleSocleDecomposition, function( AllMatricesDG, AllMatricesByDegree )
    local r, result, keys, key, s, sum, first, value, MatricesByDegree, DGActionMatrices;
    r := Length(AllMatricesByDegree);
    if r = 0 then
        return rec();
    fi;
    keys             :=  List(RecNames(AllMatricesByDegree[1]), Int);
    result           := rec();
    DGActionMatrices := List(AllMatricesDG, z -> z.matrix);
    Sort(keys); 
    for key in keys do
        MatricesByDegree := List(AllMatricesByDegree, p -> p.(key));
        first            := true;
        for s in [1..r] do
            value := AllMatricesByDegree[s].(key);
            if value <> [] then
                if first then
                    sum          := QGNAG_DimHomAModules(DGActionMatrices, MatricesByDegree);
                    result.(key) := sum;
                    first        := false;
                fi;
            fi;
        od;
        if first then
            result.(key) := 0;
        fi;   
    od;
    return result;
end);


InstallGlobalFunction(QGNAG_RecordToHTMLTable, function(data_record, col_key, col_value, show_index)
    local html, keys, k, i;
    keys := RecNames(data_record);
    if ForAll(keys, k -> ForAll(k, c -> c in "-0123456789")) then
        keys := List(keys, Int);
        Sort(keys);
        keys := Reversed(List(keys, String));
    fi;
    html := "<table border=\"1\" class=\"dataframe\">\n";
    html := Concatenation(html, "  <thead>\n");
    html := Concatenation(html, "    <tr style=\"text-align: right;\">\n");
    if show_index then
        html := Concatenation(html, "      <th></th>\n");
    fi;
    html := Concatenation(html, "      <th>", col_key, "</th>\n");
    html := Concatenation(html, "      <th>", col_value, "</th>\n");
    html := Concatenation(html, "    </tr>\n");
    html := Concatenation(html, "  </thead>\n");
    html := Concatenation(html, "  <tbody>\n");
    for i in [1..Length(keys)] do
        k := keys[i];
        html := Concatenation(html, "    <tr>\n");
        if show_index then
            html := Concatenation(html, "      <th>", String(i-1), "</th>\n");
        fi;
        html := Concatenation(html, "      <td>", String(k), "</td>\n");
        html := Concatenation(html, "      <td>", String(data_record.(k)), "</td>\n");
        html := Concatenation(html, "    </tr>\n");
    od;
    html := Concatenation(html, "  </tbody>\n</table>");
    return JupyterRenderable(
        rec(
            text\/plain := html,
            text\/html := html
        ),
        rec()
    );
end);


InstallGlobalFunction( QGNAG_RecordOfListsToHTMLTable, function(data_record, show_index)
        local html,
              cols,
              nrows,
              i,
              j,
              col;
        cols := RecNames(data_record);
        if Length(cols) = 0 then
            Error("Empty record.");
        fi;
        nrows := Length(data_record.(cols[1]));
        if not ForAll(cols, c -> Length(data_record.(c)) = nrows) then
            Error("All columns must have the same length.");
        fi;
        html := "<table border=\"1\" class=\"dataframe\">\n";
        html := Concatenation(html, "  <thead>\n");
        html := Concatenation(html, "    <tr style=\"text-align: right;\">\n");
        if show_index then
            html := Concatenation(html, "      <th></th>\n");
        fi;
        for col in cols do
            html := Concatenation(
                html,
                "      <th>",
                col,
                "</th>\n"
            );
        od;
        html := Concatenation(html, "    </tr>\n");
        html := Concatenation(html, "  </thead>\n");
        html := Concatenation(html, "  <tbody>\n");
        for i in [1..nrows] do
            html := Concatenation(html, "    <tr>\n");
            if show_index then
                html := Concatenation(
                    html,
                    "      <th>",
                    String(i-1),
                    "</th>\n"
                );
            fi;
            for col in cols do
                html := Concatenation(
                    html,
                    "      <td>",
                    String(data_record.(col)[i]),
                    "</td>\n"
                );
            od;
            html := Concatenation(html, "    </tr>\n");
        od;
        html := Concatenation(html, "  </tbody>\n");
        html := Concatenation(html, "</table>");
        return JupyterRenderable(
            rec(
                text\/html := html
            ),
            rec()
        );
end);


InstallGlobalFunction( QGNAG_GradedRecordToColumns, function(data_record)
    local keys, values;
    keys := RecNames(data_record);
    if ForAll(keys, k -> ForAll(k, c -> c in "-0123456789")) then
        keys := List(keys, Int);
        Sort(keys);
    fi;
    values := List(keys, k -> data_record.(String(k)));
    return rec(
        degree := keys,
        value := values
    );
end);


InstallGlobalFunction(QGNAG_RecordListToHTMLTable, function(record_list, show_index)
        local html,
              degrees,
              degree,
              i;
        if Length(record_list) = 0 then
            Error("Empty list.");
        fi;
        degrees := RecNames(record_list[1]);
        if ForAll(degrees, k -> ForAll(k, c -> c in "-0123456789")) then
            degrees := List(degrees, Int);
            Sort(degrees);
            degrees := List(degrees, String);
        fi;
        html := "<table border=\"1\" class=\"dataframe\">\n";
        html := Concatenation(
            html,
            "  <thead>\n",
            "    <tr style=\"text-align: right;\">\n"
        );

        html := Concatenation(html, "      <th></th>\n");

        for i in [1..Length(record_list)] do
            html := Concatenation(html, "      <th>", String(i), "</th>\n" ); # está el head
        od;

        html := Concatenation(
            html,
            "    </tr>\n",
            "  </thead>\n",
            "  <tbody>\n"
        );
        for degree in degrees do
            html := Concatenation(
                html,
                "    <tr>\n",
                "      <td>",
                degree,
                "</td>\n"
            );
            for i in [1..Length(record_list)] do
                html := Concatenation( html, "      <td>", String(record_list[i].(degree)), "</td>\n" );
            od;
            html := Concatenation(html, "    </tr>\n");
        od;
        html := Concatenation( html, "  </tbody>\n", "</table>");
        return JupyterRenderable(
            rec(
                text\/html := html
            ),
            rec()
        );
end);


InstallGlobalFunction(QGNAG_FilterZeroRows, function(record_list)
    local cols, nonzero_cols, col, r, new_list, new_rec;
    if Length(record_list) = 0 then
        return [];
    fi;
    cols := RecNames(record_list[1]);
    nonzero_cols := Filtered(cols, col -> ForAny(record_list, r -> r.(col) <> 0) );
    new_list := List(record_list, function(r)
        new_rec := rec();
        for col in nonzero_cols do
            new_rec.(col) := r.(col);
        od;
        return new_rec;
    end);
    return new_list;
end);


InstallGlobalFunction(QGNAG_DecompositionSummary, function(record_list)
    local rows, row, col_idx, r, terms, coeff;
    if Length(record_list) = 0 then
        return rec();
    fi;
    rows := rec();
    for row in RecNames(record_list[1]) do
        terms := [];
        for col_idx in [1..Length(record_list)] do
            coeff := record_list[col_idx].(row);
            if coeff <> 0 then
                Add(terms, Concatenation( String(coeff), "*M", String(col_idx)) );
            fi;
        od;
        if Length(terms) > 0 then
            rows.(row) := JoinStringsWithSeparator(terms, "+");
        fi;
    od;
    return rows;
end);


InstallGlobalFunction(QGNAG_Decomposition, function(record_list)
    local result, degree, col, coeff, terms;
    result := rec();
    for degree in RecNames(record_list[1]) do
        terms := [];
        for col in [1..Length(record_list)] do
            coeff := record_list[col].(degree);
            if coeff <> 0 then
                Add(terms, [ coeff, col ]);
            fi;
        od;
        if Length(terms) > 0 then
            result.(degree) := terms;
        fi;
    od;
    return result;
end);


InstallGlobalFunction(QGNAG_PrintDecomposition, function(rec_info)
    local degrees, d, pair, first;
    degrees := List(RecNames(rec_info), Int);
    Sort(degrees);
    for d in degrees do
        Print("degree ", d, " = ");
        first := true;
        for pair in rec_info.(String(d)) do
            if not first then
                Print(" + ");
            fi;
            if pair[1] = 1 then
                Print("M", pair[2]);
            else
                Print(pair[1], "*M", pair[2]);
            fi;
            first := false;
        od;
        Print("\n");
    od;
end);


InstallGlobalFunction(QGNAG_DisplayDecomposition, function(rec_info, SimplesMn)
    local degrees, d, pair, idx, mult, M;
    degrees := List(RecNames(rec_info), Int);
    Sort(degrees);
    for d in degrees do
        Print("\n==================================================\n");
        Print("Degree ", d);
        Print("\n==================================================\n");
        for pair in rec_info.(d) do
            mult := pair[1];
            idx  := pair[2];
            M    := SimplesMn[idx];
            Print("-------------------\n");
            Print("Simple M", idx);
            if mult > 1 then
                Print(" (multiplicity ", mult, ")");
            fi;
            Print("\n");
            Print("-------------------\n\n");
            Print("* Weight:\n");
            Print("  - g: ", M.weightSDP.g, "\n");
            Print("  - rho: ", M.weightSDP.rho, "\n\n");
            Print("* Base: ", M.base, "\n\n");
            Print("* Dimension: ", Length(M.base), "\n");
        od;
    od;
end);


InstallGlobalFunction(QGNAG_DisplayDecompositionByDegree, function(rec_info, SimplesMn, degree)
    local d, pair, idx, mult, M;
    d := String(degree);
    if not IsBound(rec_info.(d)) then
        Error("Degree ", degree, " not found.");
    fi;
    Print("\n");
    Print("==================================================\n");
    Print("Degree ", degree, "\n");
    Print("==================================================\n");
    for pair in rec_info.(d) do
        mult := pair[1];
        idx  := pair[2];
        M    := SimplesMn[idx];
        Print("\n");
        Print("--------------------------------------------------\n");
        Print("Simple M", idx);
        if mult > 1 then
            Print(" (multiplicity ", mult, ")");
        fi;
        Print("\n");
        Print("--------------------------------------------------\n");
        Print("* Dimension: ", Length(M.base), "\n\n");
        Print("* Weight:\n");
        Print("     g: ", M.weightSDP.g, "\n");
        Print("   rho: ", M.weightSDP.rho, "\n\n");
        Print("* Base: ", M.base, "\n");
    od;
end);


InstallGlobalFunction(QGNAG_PrintDecompositionSimples, function(rec_info_simples)
    local degrees, d, M, i;
    degrees := List(RecNames(rec_info_simples), Int);
    Sort(degrees);
    for d in degrees do
        Print("\n========================================\n");
        Print("Degree ", d, "\n");
        Print("========================================\n");
        for i in [1..Length(rec_info_simples.(d))] do
            M := rec_info_simples.(d)[i];
            Print("\nSimple ", i, ":\n");
            Print(M, "\n");
        od;
    od;
end);


InstallGlobalFunction(QGNAG_PrintDecompositionSimplesByDegree, function(rec_info_simples, degree)
    local key, M, i;
    key := String(degree);
    if not IsBound(rec_info_simples.(key)) then
        Error("Degree ", degree, " not found.");
    fi;
    Print("\n========================================\n");
    Print("Degree ", degree, "\n");
    Print("========================================\n");
    for i in [1..Length(rec_info_simples.(key))] do
        M := rec_info_simples.(key)[i];
        Print("\nSimple ", i, ":\n");
        Print(M, "\n");
    od;
end);


InstallGlobalFunction(QGNAG_CharacterSummary, function(rec_info, SimplesMn)
    local degrees, d, pair, first, charstr;
    degrees := List(RecNames(rec_info), Int);
    Sort(degrees);
    charstr := "Char(t) = ";
    first   := true;
    for d in degrees do
        for pair in rec_info.(d) do
            if not first then
                charstr := Concatenation(charstr, " + ");
            fi;
            if pair[1] = 1 then
                charstr := Concatenation(charstr, "M", String(pair[2]), "[", String(d), "]" );
            else
                charstr := Concatenation(charstr, String(pair[1]), "*M", String(pair[2]), "[", String(d), "]");
            fi;
            first := false;
        od;
    od;
    Print(charstr, "\n\n");
    Print("SUMMARY:\n");
    QGNAG_DisplayDecomposition(rec_info, SimplesMn);
end);