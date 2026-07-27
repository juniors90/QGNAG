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
    if not IsBound(simple!.DeltaStructureMatrices) then
        Error("Run AttachDeltaStructureMatrices(simple) first.");
    fi;
    return Concatenation( simple.genimages, List( simple.DeltaStructureMatrices, r -> r.matrix ) );
end);


InstallGlobalFunction(QGNAG_DecomposeDGRepresentation, function(rep, simples)
    local result, remaining, s, rho, degree_s, mats_rep, mats_s, mult_s;
    result    := [];
    remaining := DegreeOfRepresentation(rep.rho);
    mats_rep  := QGNAG_RepresentationMatrices(rep);
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
            Add(result, [ mult_s, s ]);
            remaining := remaining - mult_s * degree_s;
            if remaining = 0 then
                break;
            fi;
        fi;
    od;
    return result;
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


InstallGlobalFunction(QGNAG_FusionRuleToIndex, function(M, simples, simpleNames)
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