
InstallGlobalFunction(EvalWord, function(w, A)
    if Length(w) = 0 then
        return One(A[1]);   # identidad del mismo tipo que A1
    else
        return Product(List(w, i -> A[i]));
    fi;
end);


InstallGlobalFunction(EvalLinearCombination, function(B, A)
    return Sum(List([1..Length(B[1])], i ->
        B[2][i] * EvalWord(B[1][i], A)
    ));
end);


InstallGlobalFunction( EvalWordShift, function(w, A, shift)
    if Length(w) = 0 then
        return One(A[1]);
    else
        return Product( List(w, i -> A[i - shift]) );
    fi;
end);


InstallGlobalFunction( EvalLinearCombinationShift, function(B, A, shift)
    return Sum( List([1..Length(B[1])], i -> 
        B[2][i] * EvalWordShift(B[1][i], A, shift) 
    ));
end);


InstallGlobalFunction(QGNAG_ShiftPolynomial, function(p, k)
    local q;

    q := ShallowCopy(p);
    q[1] := List(q[1], m -> List(m, x -> x - k));

    return q;
end);


InstallGlobalFunction(QGNAG_ShiftPolynomialList, function(L, k)
    return List(L, p -> QGNAG_ShiftPolynomial(p, k));
end);


InstallGlobalFunction(QGNAG_TestRelationsForDGModSimple, function(matrix_s, relsGroup, relskG, relsDG)
    local okGroup,   # True if all group relations are satisfied.
          okkG,      # True if all relations of the dual algebra kG are satisfied.
          okDG,      # True if all Drinfeld double relations are satisfied.
          passed;    # True if every simple module satisfies all defining relations.
    
    passed := true;
    
    okGroup  := ForAll(QGNAG_ShiftPolynomialList(relsGroup, QGNAG.Config.nX), rel -> IsZero(EvalLinearCombination(rel, matrix_s)));
    okkG     := ForAll(QGNAG_ShiftPolynomialList(relskG, QGNAG.Config.nX), rel -> IsZero(EvalLinearCombination(rel, matrix_s)));
    okDG     := ForAll(QGNAG_ShiftPolynomialList(relsDG, QGNAG.Config.nX), rel -> IsZero(EvalLinearCombination(rel, matrix_s)));
    if not (okGroup and okkG and okDG) then
        passed := false;
        Print("Simple failed:\n");
        if not okGroup then
            Print("   - Group relations\n");
        fi;
        if not okkG then
            Print("   - kG relations\n");
        fi;
        if not okDG then
            Print("   - Drinfeld Double relations\n");
        fi;
        Print("\n");
    fi;
    if passed then
        Print(
            "All simple modules satisfy the defining relations ",
            "of the group algebra kG, k^G and the Drinfeld double D(G).\n"
        );
        return true;
    else
        return false;
    fi;
end);


InstallGlobalFunction(QGNAG_TestRelationsForDGModSimples, function(SimplesMn, relsGroup, relskG, relsDG)
    local s,         # Current simple module.
          pos,       # Position of the simple module in SimplesMn.
          matrix_s,  # Complete list of representation matrices used to evaluate the defining relations.
          okGroup,   # True if all group relations are satisfied.
          okkG,      # True if all relations of the dual algebra kG are satisfied.
          okDG,      # True if all Drinfeld double relations are satisfied.
          passed;    # True if every simple module satisfies all defining relations.
    
    passed := true;

    for s in SimplesMn do
        pos      := Position(SimplesMn, s);
        # matrix_s := QGNAG_ConstructDGActionMatrices(s);
        matrix_s := QGNAG_RepresentationMatrices(s); # ver por que no anda
        
        okGroup  := ForAll(QGNAG_ShiftPolynomialList(relsGroup, QGNAG.Config.nX), rel -> IsZero(EvalLinearCombination(rel, matrix_s)));
        okkG     := ForAll(QGNAG_ShiftPolynomialList(relskG, QGNAG.Config.nX), rel -> IsZero(EvalLinearCombination(rel, matrix_s)));
        okDG     := ForAll(QGNAG_ShiftPolynomialList(relsDG, QGNAG.Config.nX), rel -> IsZero(EvalLinearCombination(rel, matrix_s)));
        if not (okGroup and okkG and okDG) then
            passed := false;
            Print("Simple M", pos, " failed:\n");
            if not okGroup then
                Print("   - Group relations\n");
            fi;
            if not okkG then
                Print("   - kG relations\n");
            fi;
            if not okDG then
                Print("   - Drinfeld Double relations\n");
            fi;
            Print("\n");
        fi;
    od;
    if passed then
        Print(
            "All simple modules satisfy the defining relations ",
            "of the group algebra kG, k^G and the Drinfeld double D(G).\n"
        );
        return true;
    else
        return false;
    fi;
end);


InstallGlobalFunction(QGNAG_TestRelationsForAllDegrees, function(block_mats, relsGroup, relskG, relsDG)
    local degrees,
          d,
          mats;
          
    degrees := List( RecNames(block_mats[1]), x -> Int(x) );
    Sort(degrees);
    for d in degrees do
        Print("\n");
        Print("========================================\n");
        Print("Testing degree ", d, "\n");
        Print("========================================\n");
        mats := QGNAG_BlockMatricesByDegree(block_mats, d);
        QGNAG_TestRelationsForDGModSimple( mats, relsGroup, relskG, relsDG);
    od;
    Print("\n");
    Print("========================================\n");
    Print("Finished testing all degrees.\n");
    Print("========================================\n");
end);


InstallGlobalFunction(CheckSimplesVermas, function(simple, mat_in_DG)
    local YtopXtop, deltas_filt, deltas_filt_to_mat;
    
    YtopXtop:=
        [ [ [ 5, 6, 7, 6, 12 ],
            [ 5, 6, 7, 6, 9 ],
            [ 5, 6, 6, 8, 12 ],
            [ 5, 6, 6, 8, 9 ],
            [ 5, 6, 6, 7, 12 ],
            [ 5, 6, 6, 7, 9 ],
            [ 6, 7, 6, 12 ],
            [ 6, 7, 6, 9 ],
            [ 6, 6, 8, 12 ],
            [ 6, 6, 8, 9 ],
            [ 6, 6, 7, 12 ],
            [ 6, 6, 7, 9 ],
            [ 5, 7, 6, 30 ],
            [ 5, 7, 6, 27 ],
            [ 5, 7, 6, 12 ],
            [ 5, 7, 6, 9 ],
            [ 5, 6, 8, 18 ],
            [ 5, 6, 8, 15 ],
            [ 5, 6, 8, 12 ],
            [ 5, 6, 8, 9 ],
            [ 5, 6, 7, 24 ],
            [ 5, 6, 7, 21 ],
            [ 5, 6, 7, 12 ],
            [ 5, 6, 7, 9 ],
            [ 5, 6, 6, 12 ],
            [ 5, 6, 6, 9 ],
            [ 8, 5, 12 ],
            [ 8, 5, 9 ],
            [ 7, 8, 30 ],
            [ 7, 8, 27 ],
            [ 7, 8, 12 ],
            [ 7, 8, 9 ],
            [ 7, 6, 12 ],
            [ 7, 6, 9 ],
            [ 6, 8, 12 ],
            [ 6, 8, 9 ],
            [ 6, 7, 12 ],
            [ 6, 7, 9 ],
            [ 6, 6, 12 ],
            [ 6, 6, 9 ],
            [ 5, 8, 12 ],
            [ 5, 8, 9 ],
            [ 5, 7, 12 ],
            [ 5, 7, 9 ],
            [ 5, 6, 30 ],
            [ 5, 6, 27 ],
            [ 5, 6, 24 ],
            [ 5, 6, 21 ],
            [ 5, 6, 18 ],
            [ 5, 6, 15 ],
            [ 5, 6, 12 ],
            [ 5, 6, 9 ],
            [ 8, 18 ],
            [ 8, 15 ],
            [ 8, 12 ],
            [ 8, 9 ],
            [ 7, 24 ],
            [ 7, 21 ],
            [ 7, 12 ],
            [ 7, 9 ],
            [ 6, 12 ],
            [ 6, 9 ],
            [ 5, 12 ],
            [ 5, 9 ],
            [ 30 ],
            [ 27 ],
            [ 24 ],
            [ 21 ],
            [ 18 ],
            [ 15 ],
            [ 12 ],
            [ 9 ] ],
        [ -6, 6, -6, 6, -6, 6, -6, -6, -6, -6, -6,
          -6, -4, 4, -4, 4, -4, 4, -4, 4, -4, 4, -4,
           4, -6, 6, -6, 6, -4, -4, -4, -4, -6, -6,
           -6, -6, -6, -6, -6, -6, -6, 6, -6, 6, -4,
           4, -4, 4, -4, 4, -12, 12, -4, -4, -4, -4,
           -4, -4, -4, -4, -6, -6, -6, 6, -4, -4, -4,
           -4, -4, -4, -12, -12 ] ];;
    deltas_filt        := DeltaActionsFiltered4Basis( YtopXtop, simple );
    deltas_filt_to_mat := EvalLinearCombination(deltas_filt, mat_in_DG);
    return not IsZero(deltas_filt_to_mat);
end);

InstallGlobalFunction(SimplesVermasOperator, function(simple, mat_in_DG)
    local YtopXtop, deltas_filt, deltas_filt_to_mat;
    
    YtopXtop:=
        [ [ [ 5, 6, 7, 6, 12 ],
            [ 5, 6, 7, 6, 9 ],
            [ 5, 6, 6, 8, 12 ],
            [ 5, 6, 6, 8, 9 ],
            [ 5, 6, 6, 7, 12 ],
            [ 5, 6, 6, 7, 9 ],
            [ 6, 7, 6, 12 ],
            [ 6, 7, 6, 9 ],
            [ 6, 6, 8, 12 ],
            [ 6, 6, 8, 9 ],
            [ 6, 6, 7, 12 ],
            [ 6, 6, 7, 9 ],
            [ 5, 7, 6, 30 ],
            [ 5, 7, 6, 27 ],
            [ 5, 7, 6, 12 ],
            [ 5, 7, 6, 9 ],
            [ 5, 6, 8, 18 ],
            [ 5, 6, 8, 15 ],
            [ 5, 6, 8, 12 ],
            [ 5, 6, 8, 9 ],
            [ 5, 6, 7, 24 ],
            [ 5, 6, 7, 21 ],
            [ 5, 6, 7, 12 ],
            [ 5, 6, 7, 9 ],
            [ 5, 6, 6, 12 ],
            [ 5, 6, 6, 9 ],
            [ 8, 5, 12 ],
            [ 8, 5, 9 ],
            [ 7, 8, 30 ],
            [ 7, 8, 27 ],
            [ 7, 8, 12 ],
            [ 7, 8, 9 ],
            [ 7, 6, 12 ],
            [ 7, 6, 9 ],
            [ 6, 8, 12 ],
            [ 6, 8, 9 ],
            [ 6, 7, 12 ],
            [ 6, 7, 9 ],
            [ 6, 6, 12 ],
            [ 6, 6, 9 ],
            [ 5, 8, 12 ],
            [ 5, 8, 9 ],
            [ 5, 7, 12 ],
            [ 5, 7, 9 ],
            [ 5, 6, 30 ],
            [ 5, 6, 27 ],
            [ 5, 6, 24 ],
            [ 5, 6, 21 ],
            [ 5, 6, 18 ],
            [ 5, 6, 15 ],
            [ 5, 6, 12 ],
            [ 5, 6, 9 ],
            [ 8, 18 ],
            [ 8, 15 ],
            [ 8, 12 ],
            [ 8, 9 ],
            [ 7, 24 ],
            [ 7, 21 ],
            [ 7, 12 ],
            [ 7, 9 ],
            [ 6, 12 ],
            [ 6, 9 ],
            [ 5, 12 ],
            [ 5, 9 ],
            [ 30 ],
            [ 27 ],
            [ 24 ],
            [ 21 ],
            [ 18 ],
            [ 15 ],
            [ 12 ],
            [ 9 ] ],
        [ -6, 6, -6, 6, -6, 6, -6, -6, -6, -6, -6,
          -6, -4, 4, -4, 4, -4, 4, -4, 4, -4, 4, -4,
           4, -6, 6, -6, 6, -4, -4, -4, -4, -6, -6,
           -6, -6, -6, -6, -6, -6, -6, 6, -6, 6, -4,
           4, -4, 4, -4, 4, -12, 12, -4, -4, -4, -4,
           -4, -4, -4, -4, -6, -6, -6, 6, -4, -4, -4,
           -4, -4, -4, -12, -12 ] ];;
    deltas_filt        := DeltaActionsFiltered4Basis( YtopXtop, simple );
    deltas_filt_to_mat := EvalLinearCombination(deltas_filt, mat_in_DG);
    return deltas_filt_to_mat;
end);

InstallGlobalFunction( QGNAG_CheckRelationsShift, function(rels, matrices, shift)
    local valid;
    valid := ForAll( rels, rel -> IsZero( EvalLinearCombinationShift(rel, matrices, shift) ) );
    if valid then
        Print("All relations are satisfied.\n");
    else
        Print("Some relations are not satisfied.\n");
    fi;
    return valid;
end);