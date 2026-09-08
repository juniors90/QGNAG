

InstallGlobalFunction( QGNAG_VermaModuleSocleDecomposition, function( AllMatricesDG, AllMatricesByDegree )
    local r, result, keys, key, s, sum, first, value, MatricesByDegree, DGActionMatrices;
    r := Length(AllMatricesByDegree);
    if r = 0 then
        return rec();
    fi;
    keys             := List(RecNames(AllMatricesByDegree[1]), Int);
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


InstallGlobalFunction(QGNAG_SimpleVermaModuleDecomposition, function(Simples, allPairsInG, BaseNichols, AllMatricesByDegree)
    local record_data_decomp, simple, DGActMat, decomp_char_s;
    record_data_decomp := [];
    for simple in Simples do
        DGActMat := QGNAG_DGActionMatrices( simple, allPairsInG, BaseNichols );
        decomp_char_s := QGNAG_VermaModuleSocleDecomposition( DGActMat, AllMatricesByDegree );
        Add(record_data_decomp, decomp_char_s);
    od;
    return record_data_decomp;
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


InstallGlobalFunction( QGNAG_FilterZeroSimples, function( record_list )
    local indices, filtered_list;

    if Length(record_list) = 0 then
        return rec( records := [], indices := [] );
    fi;
    indices := Filtered( [1 .. Length(record_list)], i -> ForAny( RecNames(record_list[i]), degree -> record_list[i].(degree) <> 0 ) );
    filtered_list := List(indices, i -> record_list[i] );
    return rec( records := filtered_list, indices := indices );
end);



InstallGlobalFunction( QGNAG_RecordListToHTMLTableFiltered, function( record_list, show_index )
    local filtered,
              records,
              indices,
              degrees,
              degree,
              i,
              html;

        if Length(record_list) = 0 then
            Error("Empty list.");
        fi;

        filtered := QGNAG_FilterZeroSimples(record_list);

        records := filtered.records;
        indices := filtered.indices;

        if Length(records) = 0 then
            Error("All simples have zero multiplicity.");
        fi;

        degrees := RecNames(records[1]);

        degrees := List(degrees, Int);
        Sort(degrees);
        degrees := List(degrees, String);

        html := "<table border=\"1\" class=\"dataframe\">\n";

        html := Concatenation(
            html,
            "  <thead>\n",
            "    <tr style=\"text-align: right;\">\n",
            "      <th></th>\n"
        );

        # Columnas = simples M_i
        for i in [1 .. Length(indices)] do
            html := Concatenation(
                html,
                "      <th>M",
                String(indices[i]),
                "</th>\n"
            );
        od;

        html := Concatenation(
            html,
            "    </tr>\n",
            "  </thead>\n",
            "  <tbody>\n"
        );

        # Filas = grados
        for degree in degrees do

            html := Concatenation(
                html,
                "    <tr>\n",
                "      <td>",
                degree,
                "</td>\n"
            );

            for i in [1 .. Length(records)] do

                html := Concatenation(
                    html,
                    "      <td>",
                    String(records[i].(degree)),
                    "</td>\n"
                );

            od;

            html := Concatenation(
                html,
                "    </tr>\n"
            );

        od;

        html := Concatenation(
            html,
            "  </tbody>\n",
            "</table>"
        );

        return JupyterRenderable(
            rec(
                text\/html := html
            ),
            rec()
        );
    end
);


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
    local result,
          degree,
          col,
          coeff,
          terms;
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
    charstr := " Char(t) = ";
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
    Print(" SUMMARY:\n");
    QGNAG_DisplayDecomposition(rec_info, SimplesMn);
end);


InstallGlobalFunction(QGNAG_DisplayDecompositionLaTeX, function(rec_info, SimplesMn, SimpleNames)
    local degrees, d, pair, idx, mult, M;
    degrees := List(RecNames(rec_info), Int);
    Sort(degrees);
    for d in degrees do
        Print("\n==================================================\n");
        Print("Degree ", d, "\n");
        Print("==================================================\n");
        for pair in rec_info.(d) do
            mult := pair[1];
            idx  := pair[2];
            M    := SimplesMn[idx];
            Print("-------------------\n");
            Print("Simple ", SimpleNames[idx]);
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


InstallGlobalFunction(QGNAG_CharacterSummaryLaTeX, function(rec_info, SimplesMn, SimpleNames)
    local degrees,
          d,
          pair,
          mult,
          idx,
          first,
          charstr,
          term,
          sNamesL;
    degrees := List(RecNames(rec_info), Int);
    Sort(degrees);
    sNamesL := List( SimpleNames, QGNAG_ExtractTuple);
    pair    := rec_info.(Last(degrees));
    charstr := StringFormatted("\\operatorname{{Char}}{}", sNamesL[pair[1][2]]);
    first   := true;
    for d in degrees do
        for pair in rec_info.(d) do
            mult := pair[1];
            idx  := pair[2];
            if mult = 1 then
                term := Concatenation( SimpleNames[idx], "[", String(d), "]" );
            else
                term := Concatenation( String(mult), "\\,", SimpleNames[idx], "[", String(d), "]" );
            fi;
            if first then
                charstr := StringFormatted("{} = {}", charstr, term);
                first := false;
            else
                charstr := Concatenation(charstr, " + ", term);
            fi;
        od;
    od;
    charstr := Concatenation(charstr, "\n");
    Print(charstr, "\n\n");
    QGNAG_DisplayDecompositionLaTeX( rec_info, SimplesMn, SimpleNames);
end);

InstallGlobalFunction(QGNAG_CharacterSummaryToLaTeX, function(filename, rec_info, SimpleNames)
    local out, degrees, d, pair, mult, idx, first, term;
    out := OutputTextFile(filename, false);
    AppendTo(out, "\\[\n");
    AppendTo(out, "\\operatorname{Char}(t)=");
    degrees := List(RecNames(rec_info), Int);
    Sort(degrees);
    first := true;
    for d in degrees do
        for pair in rec_info.(String(d)) do
            mult := pair[1];
            idx  := pair[2];
            if mult = 1 then
                term := StringFormatted("{}[{}]", SimpleNames[idx], d);
            else
                term := StringFormatted("{}\\,{}[{}]", mult,SimpleNames[idx], d);
            fi;

            if first then
                AppendTo(out, term);
                first := false;
            else
                AppendTo(out, " + ", term);
            fi;
        od;
    od;
    AppendTo(out, "\n\\]\n");
    CloseStream(out);
end);


InstallGlobalFunction(QGNAG_LoadHilbertPolynomialsToLaTeX, function(filename, verma_data, SimpleNames)
    local out,
          i,
          data,
          name,
          LName,
          r,
          term,
          poly,
          first,
          dim;

    out := OutputTextFile(filename, false);
    AppendTo(out, "\\subsection{Hilbert Polynomials}\n\n");
    AppendTo(out, "\\begin{center}\n");
    AppendTo(out, "\\begin{tabular}{c|c|c}\n");
    AppendTo(out, "\\hline\n");
    AppendTo(out, "$L(s,\\varrho)$ & $\\dim$ & Hilbert polynomial $H(t)$ \\\\\n");
    AppendTo(out, "\\hline\n");
    for i in [1..Length(verma_data)] do
        data  := verma_data[i];
        name  := SimpleNames[i]; # M(s,rho) -> s,rho
        LName := name{[3..Length(name)-1]};
        dim   := Sum(data.HScoeffs, r -> r.count); # Dimension
        poly  := ""; # Hilbert polynomial
        first := true;
        for r in Filtered(data.HScoeffs, x -> x.count <> 0) do
            if r.graded_i = 0 then
                if r.count = 1 then
                    term := "1";
                else
                    term := String(r.count);
                fi;
            elif r.graded_i = 1 then
                if r.count = 1 then
                    term := "t";
                else
                    term := StringFormatted("{}t", r.count);
                fi;
            else
                if r.count = 1 then
                    term := StringFormatted("t^{{{}}}", r.graded_i);
                else
                    term := StringFormatted("{}t^{{{}}}", r.count, r.graded_i);
                fi;
            fi;
            if first then
                poly := term;
                first := false;
            else
                poly := Concatenation(poly, " + ", term);
            fi;
        od;
        AppendTo(out, "$L(", LName, ")$ & $", String(dim), "$ & $", poly, "$ \\\\\n");
    od;
    AppendTo(out, "\\hline\n");
    AppendTo(out, "\\end{tabular}\n");
    AppendTo(out, "\\end{center}\n");
    CloseStream(out);
end);


InstallGlobalFunction( QGNAG_MultiplicitiesToDecomposition, function( bijs_by_degree )
    local rec_decomp,
          degree,
          bijs,
          nonzero_positions,
          decomposition,
          i;

    rec_decomp := rec();;
    for degree in RecNames( bijs_by_degree ) do
        bijs              := bijs_by_degree.(degree);;
        nonzero_positions := Filtered([1 .. Length(bijs)],i -> bijs[i] <> 0);;
        decomposition     := List(nonzero_positions,i -> [ bijs[i], i ]);;
        if Length(decomposition) > 0 then
            rec_decomp.(degree) := decomposition;;
        fi;
    od;
    return rec_decomp;
end);;


InstallGlobalFunction( QGNAG_PermutationVarChars, function(data_record_data_decomp)
    local check, 
          index_var_chars,
          bijs_by_degree,
          data_rec_info_neg, 
          IndexVarChars,
          tau;
          
    bijs_by_degree    := List(data_record_data_decomp, QGNAG_GetShiftedBijs);;
    data_rec_info_neg := List( bijs_by_degree, QGNAG_MultiplicitiesToDecomposition );;
    check             := ForAll(data_rec_info_neg, r -> Maximum(List(RecNames(r), Int)) = 0);;
    if not check then
        Error("Invalid degree: maximum degree is not 0");
    fi;
    IndexVarChars := function(rec_info)
        local degrees, max_degree, pair;    
        degrees         := List(RecNames(rec_info), Int);
        max_degree      := Maximum( degrees );
        pair            := rec_info.(max_degree);
        return pair[1][2];
    end;
    index_var_chars := List(data_rec_info_neg, IndexVarChars);
    tau             := PermList( index_var_chars );
    return tau;
end);


# InstallGlobalFunction(QGNAG_LoadCharactersToLaTeX, function(filename, data_rec_info, SimpleNames)
#    local out, 
#          i, 
#          rec_info, 
#          degrees, 
#          d, 
#          pair, 
#          mult, 
#          idx, 
#          first, 
#          term,
#          tau, 
#          sNamesL;
    
#    out     := OutputTextFile(filename, false);
#    sNamesL := List( SimpleNames, QGNAG_ExtractTuple);
#    tau     := QGNAG_PermutationVarChars(data_rec_info);
#    for i in [1..Length(data_rec_info)] do
    
#        rec_info := data_rec_info[i^tau];
#        degrees  := List(RecNames(rec_info), Int); # Obtener e,rho a partir de M(e,rho)
#        Sort(degrees);
#        pair     := rec_info.(Last(degrees));
#        AppendTo(out, "\\subsubsection{$L", sNamesL[pair[1][2]], "$}\n");
#        AppendTo(out, "\\[\n");
#        AppendTo(out, "\\operatorname{Char}", sNamesL[pair[1][2]], " =");
#        first := true;
    
#        for d in degrees do
#            for pair in rec_info.(d) do
#                mult := pair[1];
#                idx  := pair[2];
#                if mult = 1 then
#                    term := StringFormatted("{}[{}]", SimpleNames[idx], d);
#                else
#                    term := StringFormatted("{}\\,{}[{}]", mult, SimpleNames[idx], d);
#                fi;
#                if first then
#                    AppendTo(out, term);
#                    first := false;
#                else
#                    AppendTo(out, " + ", term);
#                fi;
#            od;
#        od;
#        AppendTo(out, "\n\\]\n\n");
#    od;
#    CloseStream(out);
# end);


InstallGlobalFunction(QGNAG_LoadCharactersToLaTeXByIndex, function(filename, data_rec_info)
    local out, i, rec_info, degrees, d, pair, mult, idx, first, term;
    out := OutputTextFile(filename, false);
    for i in [1..Length(data_rec_info)] do
        rec_info := data_rec_info[i];
        # Obtener e,rho a partir de M(e,rho)
        AppendTo(out, "\\subsubsection{$L_{", String(i), "}$}\n");
        AppendTo(out, "\\[\n");
        AppendTo(out, "\\operatorname{Char}_{", String(i), "} = ");
        degrees := List(RecNames(rec_info), Int);
        Sort(degrees);
        first := true;
        for d in degrees do
            for pair in rec_info.(String(d)) do
                mult := pair[1];
                idx  := pair[2];
                if mult = 1 then
                    term := StringFormatted("M_{{{}}}[{}]", String(idx), d);
                else
                    term := StringFormatted("{}\\,M_{{{}}}[{}]", mult, String(idx), d);
                fi;
                if first then
                    AppendTo(out, term);
                    first := false;
                else
                    AppendTo(out, " + ", term);
                fi;
            od;
        od;
        AppendTo(out, "\n\\]\n\n");
    od;
    CloseStream(out);
end);

InstallGlobalFunction(QGNAG_LoadCharactersToLaTeX, function(filename, data_rec_info, SimpleNames)
    local out,
          i,
          rec_info,
          degrees,
          d,
          pair,
          mult,
          idx,
          first,
          term,
          theta,
          sNamesL,
          LName;

    sNamesL := List( SimpleNames, QGNAG_ExtractTuple );
    out     := OutputTextFile( filename, false );
    theta   := Length(data_rec_info);

    for i in [1..theta] do
        rec_info := data_rec_info[i];
        LName    := sNamesL[i];
        AppendTo(out, "\\subsubsection{$L", LName, "$}\n");
        AppendTo(out, "\\[\n");
        AppendTo(out, "\\operatorname{Char}", LName, " = ");
        degrees := List(RecNames(rec_info), Int);
        Sort(degrees);
        first := true;
        for d in degrees do
            for pair in rec_info.(String(d)) do
                mult := pair[1];
                idx  := pair[2];
                if mult = 1 then
                    term := StringFormatted("{}[{}]", SimpleNames[idx], d);
                else
                    term := StringFormatted("{}\\,{}[{}]", mult, SimpleNames[idx], d);
                fi;
                if first then
                    AppendTo(out, term);
                    first := false;
                else
                    AppendTo(out, " + ", term);
                fi;
            od;
        od;
        AppendTo(out, "\n\\]\n\n");
    od;
    CloseStream(out);
end);


InstallGlobalFunction(QGNAG_ShiftRecordKeys, function( rec_info, sign )
    local recordNames,
          numericKeys,
          baseKey,
          recordName,
          newKey,
          shiftedValue,
          shiftedRecord;

    # Collect the record's keys and convert them to integers to find the base.
    recordNames := RecNames( rec_info );
    numericKeys := List( recordNames, Int );
    baseKey     := Minimum( numericKeys );

    shiftedRecord := rec();
    for recordName in recordNames do
        shiftedValue := rec_info.(recordName);
        newKey       := sign * ( Int(recordName) - baseKey );
        shiftedRecord.(String(newKey)) := shiftedValue;
    od;

    return shiftedRecord;
end);

InstallGlobalFunction( QGNAG_NegateRecordKeys, function( rec_info )
    local rec_info_new,
          rec_info_names,
          keys,
          ell,
          k;

    rec_info_new   := rec();
    rec_info_names := List( RecNames( rec_info ), Int );
    ell            := Maximum( rec_info_names );
    for k in [0 .. ell] do
        rec_info_new.( String(-k) ) := rec_info.(String(k));
    od;
    return rec_info_new;
end);


InstallGlobalFunction( QGNAG_ShiftRecordKeysToZero, function( rec_info )
    local rec_info_names,
          rec_info_name,
          topKey,
          newKey,
          rec_info_shifted;
    
    rec_info_shifted := rec();
    rec_info_names   := List( RecNames( rec_info ), Int );
    topKey           := Maximum( rec_info_names );  # anchor the largest key at 0
    for rec_info_name in rec_info_names do
        newKey                      := rec_info_name - topKey;
        rec_info_shifted.( newKey ) := rec_info.(rec_info_name);
    od;
    return rec_info_shifted;
end);


InstallGlobalFunction( QGNAG_ShiftRecordKeysDecomp, function( rec_info, sign )
    local recordNames,
          numericKeys,
          baseKey,
          recordName,
          newKey,
          shiftedValue,
          shiftedRecord;

    recordNames := RecNames( rec_info );
    numericKeys := List( recordNames, Int );

    # El ancla (lo que pasa a valer 0) depende de la dirección:
    #  - sign = 1  -> ancla en el mínimo (rango queda 0..ell)
    #  - sign = -1 -> ancla en el máximo (rango queda -ell..0, orden preservado)
    if sign = -1 then
        baseKey := Maximum( numericKeys );
    else
        baseKey := Minimum( numericKeys );
    fi;

    shiftedRecord := rec();
    for recordName in recordNames do
        shiftedValue := rec_info.(recordName);
        newKey       := Int(recordName) - baseKey;
        shiftedRecord.(String(newKey)) := shiftedValue;
    od;

    return shiftedRecord;
end);

InstallGlobalFunction( QGNAG_ShiftDecompositionKeys, function( data_record_data_decomp, sign )
    local shiftedData, s, shifted, r;

    shiftedData := [];
    for s in data_record_data_decomp do
        shifted := List( s, r -> QGNAG_ShiftRecordKeysDecomp( r, sign ) );
        Add( shiftedData, shifted );
    od;

    return shiftedData;
end);