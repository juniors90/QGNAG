InstallGlobalFunction(QGNAG_TensorBasisOfProductOfSimples, function(simple1, simple2)
    local B1, B2, TensorBase;
    B1 := simple1.base;
    B2 := simple2.base;
    TensorBase := List(
        Cartesian(B1, B2),
        x -> TensorElement(x[1], x[2])
    );
    return TensorBase;
end);


InstallGlobalFunction(QGNAG_TensorProductOfSimples, function( simple1, simple2 )
    local gens, mgens, gen1, gen2, newrho, rep, deltaData,
          h, a, b, mat, delta_a_mat, delta_b_mat;
    
    if not IsBound(simple1!.DeltaStructureMatrices) then
        Error("Run AttachDeltaStructureMatrices(simple1) first.");
    fi;
    
    if not IsBound(simple2!.DeltaStructureMatrices) then
        Error("Run AttachDeltaStructureMatrices(simple2) first.");
    fi;


    gens   := simple1.generatorsofgroup;
    gen1   := simple1.genimages;
    gen2   := simple2.genimages;
    
    mgens  := List( [1..Length( gens )], i -> KroneckerProduct( gen2[i], gen1[i] ) );
    newrho := GroupHomomorphismByImages( simple1.group , Group( mgens ), gens, mgens );
    rep    := rec(
        group             := simple1.group,
        generatorsofgroup := gens,        # new feature
        rho               := newrho,      # new feature
        # irreps            := simple1.irreps, # new feature
        genimages         := mgens,
        isRepresentation  := true,
        isSimple          := false,
        # isIrreps          := newrho in simple1.irreps,
        dimension         := Length(mgens[1]),
        base              := QGNAG_TensorBasisOfProductOfSimples(simple1, simple2),
        simples           := [simple1, simple2],
    );
    deltaData := [];
    for h in GetElementsOfG() do
        mat := NullMat( rep.dimension, rep.dimension );
        for a in GetElementsOfG() do
            b           := a^-1 * h;
            delta_a_mat := QGNAG_DeltaMatrixOfElement(simple1, a);
            delta_b_mat := QGNAG_DeltaMatrixOfElement(simple2, b);
            mat         := mat + KroneckerProduct( delta_b_mat, delta_a_mat);
        od;
        Add(deltaData, rec( element := h, matrix := mat ) );
    od;
    rep!.DeltaStructureMatrices := deltaData;
    return rep;
end);


InstallGlobalFunction(QGNAG_RepresentationMatrices, function(simple)
    local genimages;
    if not IsBound(simple!.DeltaStructureMatrices) then
        Error("Run AttachDeltaStructureMatrices(simple) first.");
    fi;
    if simple.isSimple then
        genimages := List(GeneratorsOfGroup(Source(simple.simple)), x -> simple.simple(x) );
    else
        genimages := simple.genimages;
    fi;
    return Concatenation( simple.genimages, List( simple.DeltaStructureMatrices, r -> r.matrix ) );
end);


InstallGlobalFunction( QGNAG_DecomposeDGRepresentation, function(rep, simples)
    local decomposition, remaining, s, rho, degree_s, mats_rep, mats_s, mult_s;
    decomposition    := [];
    remaining := DegreeOfRepresentation(rep.rho);
    mats_rep  := QGNAG_RepresentationMatrices(rep); # tomo las matrices
    for s in simples do
        rho      := s.simple;
        degree_s := DegreeOfRepresentation(rho);
        if degree_s > remaining then
            #Print("\n.........: ", degree_s);
            continue;
        fi;
        mats_s := QGNAG_RepresentationMatrices(s);
        mult_s := QGNAG_DimHomAModules(mats_rep, mats_s);
        #Print("\n----------------: ", degree_s);
        if mult_s > 0 then
            Add(decomposition, [ mult_s, s ]);
            remaining := remaining - mult_s * degree_s;
            if remaining = 0 then
                break;
            fi;
        fi;
    od;
    return decomposition;
end);


InstallGlobalFunction(QGNAG_FusionRuleToLaTeX, function(M, simples, simpleNames)
    local lhs, rhs, term, mult, simple, pos, decomposition, name1, name2;
    name1 := simpleNames[Position(simples, M.simples[1])];
    name2 := simpleNames[Position(simples, M.simples[2])];
    lhs   := StringFormatted("{} \\otimes {}", name1, name2);
    rhs   := "";
    decomposition := QGNAG_DecomposeDGRepresentation(M, simples);
    for term in decomposition do
        mult   := term[1];
        simple := term[2];
        pos    := Position(simples, simple);

        if rhs <> "" then
            rhs := Concatenation(rhs, " \\oplus ");
        fi;

        if mult = 1 then
            rhs := Concatenation( rhs, simpleNames[pos] );
        else
            rhs := Concatenation( rhs, String(mult), " ", simpleNames[pos] );
        fi;
    od;
    return Concatenation( lhs, " \\simeq ", rhs );
end);

InstallGlobalFunction(QGNAG_FusionRuleToLaTeXForExport, function(M, simples, simpleNames)
    local lhs, rhs, term, mult, simple, pos, decomposition, name1, name2;
    name1 := simpleNames[Position(simples, M.simples[1])];
    name2 := simpleNames[Position(simples, M.simples[2])];
    lhs   := StringFormatted("{} &\\otimes {}", name1, name2);
    rhs   := "";
    decomposition := QGNAG_DecomposeDGRepresentation(M, simples);
    for term in decomposition do
        mult   := term[1];
        simple := term[2];
        pos    := Position(simples, simple);

        if rhs <> "" then
            rhs := Concatenation(rhs, " \\oplus ");
        fi;

        if mult = 1 then
            rhs := Concatenation( rhs, simpleNames[pos] );
        else
            rhs := Concatenation( rhs, String(mult), " ", simpleNames[pos] );
        fi;
    od;
    return Concatenation( lhs, " \\simeq ", rhs );
end);


InstallGlobalFunction(QGNAG_FusionRuleToIndex, function(M, simples)
    local lhs, rhs, term, mult, simple, pos, decomposition;
    lhs := Concatenation( "M", String(Position( simples, M.simples[1] )), " \\otimes M", String(Position( simples, M.simples[2] )) );
    rhs := "";
    decomposition := QGNAG_DecomposeDGRepresentation(M, simples);
    for term in decomposition do
        mult   := term[1];
        simple := term[2];
        pos    := Position(simples, simple);
        if rhs <> "" then
            rhs := Concatenation(rhs, " \\oplus ");
        fi;
        if mult = 1 then
            rhs := Concatenation( rhs, "M", String(pos) );
        else
            rhs := Concatenation( rhs, String(mult), " M", String(pos) );
        fi;
    od;
    return Concatenation( lhs, " \\simeq ", rhs );
end);

InstallGlobalFunction(QGNAG_FusionRuleToIndexTex, function(M, simples, simpleNames)
    local lhs, rhs, term, mult, simple, pos, decomposition;
    lhs := Concatenation( "M_{", String(Position( simples, M.simples[1] )), "} \\otimes M_{", String(Position( simples, M.simples[2] )), "}" );
    rhs := "";
    decomposition := QGNAG_DecomposeDGRepresentation(M, simples);
    for term in decomposition do
        mult   := term[1];
        simple := term[2];
        pos    := Position(simples, simple);
        if rhs <> "" then
            rhs := Concatenation(rhs, " \\oplus ");
        fi;
        if mult = 1 then
            rhs := Concatenation( rhs, "M_{", String(pos), "}" );
        else
            rhs := Concatenation( rhs, String(mult), " M_{", String(pos), "}" );
        fi;
    od;
    return Concatenation( lhs, " \\simeq ", rhs );
end);


InstallGlobalFunction(QGNAG_WriteFusionRuleToLaTeX, function(out, M, simples, simpleNames)

    local decomposition, term, mult, simple, pos, first;

    AppendTo(
        out,
        simpleNames[Position(simples, M.simples[1])],
        " &\\otimes ",
        simpleNames[Position(simples, M.simples[2])],
        " \\simeq "
    );

    decomposition := QGNAG_DecomposeDGRepresentation(M, simples);

    first := true;
    for term in decomposition do
        if not first then
            AppendTo(out, " \\oplus ");
        fi;
        first := false;

        mult   := term[1];
        simple := term[2];
        pos    := Position(simples, simple);

        if mult = 1 then
            AppendTo(out, simpleNames[pos]);
        else
            AppendTo(out, String(mult), " ", simpleNames[pos]);
        fi;
    od;
end );


InstallGlobalFunction( QGNAG_WriteFusionRuleToLaTeXWithIndex, function(out, M, simples)

    local decomposition, term, mult, simple, pos, first;

    AppendTo(
        out,
        "M_{", Position(simples, M.simples[1]),
        "} &\\otimes M_{",
        Position(simples, M.simples[2]),
        "} \\simeq "
    );
    decomposition := QGNAG_DecomposeDGRepresentation(M, simples);
    first := true;
    for term in decomposition do
        if not first then
            AppendTo(out, " \\oplus ");
        fi;
        first := false;

        mult   := term[1];
        simple := term[2];
        pos    := Position(simples, simple);

        if mult = 1 then
            AppendTo(out, "M_{", String(pos), "}");
        else
            AppendTo(out, String(mult), "M_{", String(pos), "}");
        fi;
    od;

end);


InstallGlobalFunction( QGNAG_ExportFusionRulesToLaTeXSingleLong, function(filename, Simples, SimplesMn, SimpleNames, maxTerms)
    local out, i, j, n, tensorproduct, decomposition, pending;
    out := OutputTextFile(filename, false);
    n   := Length(Simples);
    for i in [2..n] do
        AppendTo(out, StringFormatted( "\\subsubsection{{$ {}\\otimes -$}}\n\\begin{{align*}}\n", SimpleNames[i] ) );
        pending := false;
        for j in [i..n] do
            tensorproduct := QGNAG_TensorProductOfSimples(Simples[i], Simples[j]);
            decomposition := QGNAG_DecomposeDGRepresentation( tensorproduct, SimplesMn );

            #
            # Regla demasiado larga: siempre ocupa una línea.
            #
            if Length(decomposition) > maxTerms then
                if pending then
                    AppendTo(out, "\\\\\n");
                    pending := false;
                fi;
                QGNAG_WriteFusionRuleToLaTeX( out, tensorproduct, SimplesMn, SimpleNames );
                AppendTo(out, "\\\\\n");
            #
            # Regla corta.
            #
            else
                if not pending then
                    QGNAG_WriteFusionRuleToLaTeX( out, tensorproduct, SimplesMn, SimpleNames );
                    pending := true;
                else
                    AppendTo(out, " &&& ");
                    QGNAG_WriteFusionRuleToLaTeX( out, tensorproduct, SimplesMn, SimpleNames );
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


InstallGlobalFunction( QGNAG_AllTensorProductRepresentationMatrices, function( simples )
    local all_mats_tensor,
          i,
          j,
          tensor,
          rec_mat;

    all_mats_tensor := [];
    for i in [2..Length(simples)] do
        for j in [i..Length(simples)] do
            tensor := QGNAG_TensorProductOfSimples( simples[i], simples[j]);
            rec_mat  := rec(
                tensor := QGNAG_RepresentationMatrices(tensor),
                first  := i,
                second := j
            );
            Add(all_mats_tensor, rec_mat);
        od;
    od;
    return all_mats_tensor;
end);


InstallGlobalFunction( QGNAG_FusionRulesAsVectors, function(all_mats_tensor, data_mats_simples)
    local theta, data_fusion_rules, i, j, tensor, decomposition,
          remaining, mats_s, degree_s, mult_s, vector, term, k;

    theta := Length(data_mats_simples);
    data_fusion_rules := [];

    for i in [2..theta] do
        for j in [i..theta] do

            tensor := First(
                all_mats_tensor,
                r -> r.first = i and r.second = j
            ).tensor;

            decomposition := [];
            remaining := Length(tensor[1]);

            for mats_s in data_mats_simples do

                degree_s := Length(mats_s[1]);

                if degree_s > remaining then
                    continue;
                fi;

                mult_s := QGNAG_DimHomAModules(tensor, mats_s);

                if mult_s > 0 then
                    Add(
                        decomposition,
                        [mult_s, Position(data_mats_simples, mats_s)]
                    );

                    remaining := remaining - mult_s * degree_s;

                    if remaining = 0 then
                        break;
                    fi;
                fi;

            od;

            vector := List([1..theta], k -> 0);

            for term in decomposition do
                k := term[2];
                vector[k] := term[1];
            od;

            Add(
                data_fusion_rules,
                rec(
                    first := i,
                    second := j,
                    vector := vector
                )
            );

        od;
    od;

    return data_fusion_rules;
end);


