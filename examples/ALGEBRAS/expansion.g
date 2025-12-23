DeltaActionsFiltered4Basis := function(prod, simple)
    local monos, coefs, resMonos, resCoefs, conj, k, xi, mon, coef;
 
    monos := prod[1];
    coefs := prod[2];
 
    resMonos := [];
    resCoefs := [];
    for k in [1..Length(monos)] do
        mon := monos[k];
        coef := coefs[k];
        xi := Last( mon );
        if xi in [8..32] then
            for conj in Conj4Basis(simple) do
                if all_deltas[ xi - ( nX + nElemOfG ) ]( conj ) <> 0 then
                    Add(resMonos, mon);
                    Add(resCoefs, coef);
                fi;
            od;
        else
            Add(resMonos, mon);
            Add(resCoefs, coef);
        fi;
    od;
    return [resMonos, resCoefs];
end;


ExpActionOnBivk := function( prod, Yjbis_lst, simple, nX, nElemOfG )
    local monos, coefs, i, j, k, pos_bi, pos_bj, bi, bj, yj, xi, M, A, N,
        m, mon, coef, idx_i_mat, idx_j_mat, monos_to_matrix;
        
    monos := prod[1];
    coefs := prod[2];
    monos_to_matrix := [];
    N := 72; # dimNichols
    m := Length( simple.base );
    j := Position( Yjbis_lst, prod );
    
    for k in [1..Length(monos)] do
        mon := monos[k];
        coef := coefs[k];
        xi := Last( mon );
        if xi in [9..32] then
            M := NullMat( N * m, N * m, Rationals );
            i := Position( Base_T4, MonomialForSmallIndex( [[mon], [coef]], nX ) );
            A := MatrixForDrinfeldDoubleElement( MonomialForLargeIndex( [[mon], [coef]], nX ), simple, nX, nElemOfG);
            for idx_i_mat in [1..m] do
                for idx_j_mat in [1..m] do
                    if A[idx_i_mat ][idx_j_mat] <> 0 then
                        M[ i + N * ( idx_i_mat - 1 ) ][ j + N * ( idx_j_mat - 1 ) ] := A[ idx_i_mat ][ idx_j_mat ];
                    fi;
                od;
            od;
            Add( monos_to_matrix, M );
        elif xi in [5..8] then
            M := NullMat( N * m, N * m, Rationals );
            i := Position( Base_T4, MonomialForSmallIndex( [[mon], [coef]], nX ) );
            A := MatrixForDrinfeldDoubleElement( MonomialForLargeIndex( [[mon], [coef]], nX ), simple, nX, nElemOfG);
            for idx_i_mat in [1..m] do
                for idx_j_mat in [1..m] do
                    if A[idx_i_mat ][idx_j_mat] <> 0 then
                        M[i + N * ( idx_i_mat - 1)][j + N * ( idx_j_mat - 1)] := A[idx_i_mat][idx_j_mat];
                    fi;
                od;
            od;
            Add(monos_to_matrix, M);
        else
            M := NullMat( N * m, N * m, Rationals );
            i := Position( Base_T4, MonomialForSmallIndex( [[mon], [coef]], nX ) );
            A := coef * IdentityMat( m, Rationals );            
            for idx_i_mat in [1..m] do
                for idx_j_mat in [1..m] do
                    if A[idx_i_mat][idx_j_mat] <> 0 then
                        M[i + N * ( idx_i_mat - 1)][j + N * ( idx_j_mat - 1)] := A[idx_i_mat][idx_j_mat];
                    fi;
                od;
            od;
            Add(monos_to_matrix, M);
        fi;
    od;
    return Sum(monos_to_matrix);
end;