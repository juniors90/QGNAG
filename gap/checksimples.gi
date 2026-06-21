
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