# Devuelve sólo los índices en {1,2,3,4}, manteniendo el orden.
# El coeficiente resultante será 1 (positivo).
InstallGlobalFunction( MonomialForSmallIndex, function( mono, nX )
    local lst, small;
    lst := mono[1][1];
    small := Filtered(lst, i -> i in [1..nX]);  # preserva orden
    return [ [ small ], [ 1 ] ];
end);

# Devuelve sólo los índices > 4, manteniendo el orden.
# Conserva el coeficiente original.
InstallGlobalFunction( MonomialForLargeIndex, function( mono, nX )
    local lst, large, coef;
    lst := mono[1][1];
    coef := mono[2][1];
    large := Filtered(lst, i -> i > nX);        # preserva orden
    return [ [ large ], [ coef ] ];
end);


InstallGlobalFunction( ActionkGdualOnYDModule, function( delta_h, simple, elmofB )
    local BaseMgrho, pos_wi, x, g, conj;
    BaseMgrho := simple.base;
    pos_wi := Position(BaseMgrho, elmofB);
    x := elmofB!.GroupElement;
    g := simple.weightSDP.g;
    conj := x * g * x ^ (-1);
    if delta_h(conj) <> 0 then
       return elmofB;
    else
        return 0;
    fi;
end);

InstallGlobalFunction(StructureMatrixSimpleModule, function( delta_h, simple )
    local BaseMod, bi, M, degreeMod, mon, j, m, i, obj;
    BaseMod := simple.base;
    degreeMod := Length( BaseMod );
    M := NullMat( degreeMod, degreeMod, Rationals );
    for bi in [1..Length(BaseMod)] do
        mon := ActionkGdualOnYDModule( delta_h, simple, BaseMod[bi]);
        if mon <> 0 then
            j := Position( BaseMod, BaseMod[bi] );
            i := Position( BaseMod, mon );
            M[i][j] := 1;
        fi;
    od;
    obj := rec(
        weightSDP := simple.weightSDP,
        matrix := M
    );

    return obj;
end);


InstallGlobalFunction(MatrixForDrinfeldDoubleElement, function(mon, simple, nX, nElemOfG)
    local lst, coef, M, h, i;
    # OJO: mon tiene que ser un monomio... con un polinomio
    # se complica y no lo he pensado aún
    lst := mon[1][1];     # indices: [i1, i2, i3, ...]
    coef := mon[2][1];    # coef, por ej. -1 o 1

    # Empezamos con la identidad del tamaño correcto:
    # Tomamos la del primer índice que aparezca.
    if lst[1] in [9..32] then
        h := GetElementsOfG()[lst[1] - (nX + nElemOfG)];
        M := StructureMatrixSimpleModule( DeltaFunctionForSDP( h ), simple ).matrix;
        return M;
    fi;
    M := simple.simple( simple.generatorsofgroup[ lst[ 1 ] - nX ] );
    # Multiplicamos en orden
    for i in lst{ [ 2..Length( lst ) ] } do
        if (i - nX) in [1..4] then
            M := M * simple.simple( simple.generatorsofgroup[ lst[ Position( lst, i ) ] - nX ] );
        else 
            h := GetElementsOfG()[ i - ( nX + nElemOfG ) ];
            M := M * StructureMatrixSimpleModule( DeltaFunctionForSDP( h ), simple ).matrix;
        fi;
    od;
    M := coef * M;
    return M;
end);


InstallGlobalFunction(NonZeroEntriesForMatrix, function(A)
    local i, j, D;
    D := [];

    for i in [1..Length(A)] do
        for j in [1..Length(A[i])] do
            if A[i][j] <> 0 then
                Add(D, rec(i := i, j := j, val := A[i][j]));
            fi;
        od;
    od;

    return D;
end);


InstallGlobalFunction( Conj4Basis, function( simple )
    local conj_xgxinv, conj4basis;
    conj_xgxinv := el -> (el * simple.weightSDP.g * el^(-1));; ## <-------------- error
    conj4basis := List(simple.base, x -> conj_xgxinv(x!.GroupElement));
    return conj4basis;
end);


InstallGlobalFunction( DeltaActionsFiltered4Basis, function( prod, simple, nX, nElemOfG)
    local monos, coefs, resMonos, resCoefs, conj, k, all_deltas,
    xi, mon, coef, idx_deltas, nXs, nG;
 
    monos := prod[1];
    coefs := prod[2];

    idx_deltas := [9..32];
    resMonos := [];
    resCoefs := [];
    all_deltas := List(GetElementsOfG(), x -> DeltaFunctionForSDP(x));
    for k in [1..Length(monos)] do
        mon := monos[k];
        coef := coefs[k];
        xi := Last( mon );
        if xi in idx_deltas then
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
end );


InstallGlobalFunction( ReducedDeltaAction, function( resY_lst, simple, nX, nElemOfG )
    local resYresDeltas_lst, elm;
    
    resYresDeltas_lst := [];;
    
    for elm in resY_lst do
        Add( resYresDeltas_lst, DeltaActionsFiltered4Basis( elm, simple, nX, nElemOfG ) );
    od;
    
    return resYresDeltas_lst;
end);


InstallGlobalFunction( ExpActionOnBivk, function( prod, Yjbis_lst, simple, nX, nElemOfG, BaseNichols)
    local monos, coefs, i, j, k, pos_bi, pos_bj, bi, bj, yj, xi, M, A, N,
        m, mon, coef, idx_i_mat, idx_j_mat, monos_to_matrix, Base_T4;
        
    monos := prod[1];
    coefs := prod[2];
    monos_to_matrix := [];
    
    m := Length( simple.base );
    j := Position( Yjbis_lst, prod );

    Base_T4 := BaseNichols;
    N := Length(Base_T4); # dimNichols
    
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

end);