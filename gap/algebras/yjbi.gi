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

########
# OJO: esto, de acá para abajo, es más general, hay que reveer la
# arquitectura porque sirve tanto para la contrucción de la matrz
# de Yj como dla de delta_h en la vase del modulo de verma.
########

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
        weight := simple.weight,
        matrix := M
    );

    return obj;
end);

######## hasta acá ########


InstallGlobalFunction(MatrixForDrinfeldDoubleElement, function(mon, simple, nX, nElemOfG)
    local lst, coef, M, h, i;
    # OJO: mon tiene que ser un monomio... con un polinomio
    # se complica y no lo he pensado aún
    lst  := mon[1][1];     # indices: [i1, i2, i3, ...]
    coef := mon[2][1];     # coef, por ej. -1 o 1

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


InstallGlobalFunction( Conj4BasisElement, function( simple, elm_base )
    local g_elm, conj_xgxinv, conj4basis;
    if not (elm_base in simple.base) then
        Error("The element elm_base is not in the base of the simple.\n");
    fi;
    g_elm       := GetElementsOfG()[Position(allPairsInG, simple.weight.g)];;
    conj_xgxinv := el -> (el * g_elm * el ^(-1));; ## <------ el error
    conj4basis  := conj_xgxinv(elm_base!.GroupElement);
    return conj4basis;
end);

InstallGlobalFunction( Conj4Basis, function( simple )
    local conj_xgxinv, conj4basis;
    conj_xgxinv := el -> (el * simple.weightSDP.g * el^(-1));; ## <-------------- error
    conj4basis  := List(simple.base, x -> conj_xgxinv(x!.GroupElement));
    return conj4basis;
end);

InstallGlobalFunction( DeltaActionsFiltered4Basis, function( prod, simple, nX, nElemOfG)
    local monos, coefs, resMonos, resCoefs, conj, k, all_deltas,
    xi, mon, coef, idx_deltas, nXs, nG, IsConstantList, conj_basis;

    monos      := prod[1];
    coefs      := prod[2];
    idx_deltas := [9..32];
    resMonos   := [];
    resCoefs   := [];
    all_deltas := List(GetElementsOfG(), x -> DeltaFunctionForSDP(x));
    conj_basis:=Conj4Basis( simple );
    IsConstantList := function(L)
        return ForAll(L, x -> x = L[1]);
    end;
    for k in [ 1..Length(monos) ] do
        mon  := monos[k];
        coef := coefs[k];
        xi   := Last( mon );
        if xi in idx_deltas then
            if IsConstantList(conj_basis) then
                conj := conj_basis[1];
                if all_deltas[ xi - ( nX + nElemOfG ) ]( conj ) <> 0 then
                    Add( resMonos, mon );
                    Add( resCoefs, coef );
                fi;
            else
                for conj in conj_basis do
                    if all_deltas[ xi - ( nX + nElemOfG ) ]( conj ) <> 0 then
                        Add( resMonos, mon );
                        Add( resCoefs, coef );
                    fi;
                od;
            fi;
        else
            Add( resMonos, mon );
            Add( resCoefs, coef );
        fi;
    od;
    return [ resMonos, resCoefs ];
end );


InstallGlobalFunction( ReducedDeltaAction, function( resY_lst, simple, nX, nElemOfG )
    local resYresDeltas_lst, elm;
    
    resYresDeltas_lst := [];;
    
    for elm in resY_lst do
        Add( resYresDeltas_lst, DeltaActionsFiltered4Basis( elm, simple, nX, nElemOfG ) );
    od;
    
    return resYresDeltas_lst;
end);


# %%
InstallGlobalFunction( RemoveYterms, function(prod)
    local monos, coefs, resMonos, resCoefs, i, ult;
    monos    := prod[1];
    coefs    := prod[2];
    resMonos := [];
    resCoefs := [];
    for i in [1..Length(monos)] do
        ult := Last(monos[i]);  # último índice del monomio
        # si el último índice NO es Y0,Y1,Y2,Y3 (33..36), lo conservamos
        if not (ult in [33, 34, 35, 36]) then
            Add(resMonos, monos[i]);
            Add(resCoefs, coefs[i]);
        fi;
    od;
    return [resMonos, resCoefs];
end);

# %%
InstallGlobalFunction( CommuteYBeforeX, function(prod)
    local monos, coefs, resMonos, resCoefs, xIndex, yIndex,deltaIndex, groupIndex,
        i, j, k, pos, yj, xi, rule, newMonos,
        newCoefs, m, c, pref, suf, mon, coef, Penultimate, list_mon,_monos, _coefs;
 
    monos       := prod[1];
    coefs       := prod[2];
    resMonos    := [];
    resCoefs    := [];
    Penultimate := list_mon -> list_mon[Length(list_mon) - 1];
    xIndex      := [ 1..4 ];;
    deltaIndex  := [ 9..32 ];;
    yIndex      := [ 33..36 ];;
    groupIndex  := [ 
        [  ],               # (0, 0)
        [ 5 ],              # (0, 1)
        [ 6 ],              # (0, 2)
        [ 5, 6 ],           # (0, 3)
        [ 6, 6 ],           # (0, 4)
        [ 5, 6, 6 ],        # (0, 5)
        [ 8 ],              # (1, 0)
        [ 8, 5 ],           # (1, 1)
        [ 6, 7 ],           # (1, 2)
        [ 5, 6, 8 ],        # (1, 3)
        [ 6, 7, 6 ],        # (1, 4)
        [ 5, 6, 6, 7 ],     # (1, 5)
        [ 7 ],              # (w, 0)
        [ 5, 8 ],           # (w, 1)
        [ 7, 6 ],           # (w, 2)
        [ 5, 6, 7 ],        # (w, 3)
        [ 6, 6, 8 ],        # (w, 4)
        [ 5, 6, 6, 7, 8 ],  # (w, 5)
        [ 7, 8 ],           # (w^2, 0)
        [ 5, 7 ],           # (w^2, 1)
        [ 6, 8 ],           # (w^2, 2)
        [ 5, 7, 6 ],        # (w^2, 3)
        [ 6, 6, 7 ],        # (w^2, 4)
        [ 5, 6, 6, 8 ]      # (w^2, 5)
    ];
    for k in [1..Length(monos)] do
        mon  := monos[k];
        coef := coefs[k];
        xi   := Last( mon );
        if Length(mon) > 1 then
            # PrintNP([[mon], [coef]]);
            yj := Penultimate( mon );
            pos := Position( mon, yj );
            # Verificar si es un par Y_i X_j
            if yj in [33,34,35,36] and xi in [1,2,3,4] then
                # Obtener índices i y j reales
                j := Position([33,34,35,36], yj);   # Y_j
                i := xi;                            # X_i
                # Obtener la regla de conmutación correspondiente
                rule := GetConmutationRuleOnB4w(
                        ElementF4(Elements(GF(4))[i]),
                        ElementF4(Elements(GF(4))[j]),
                        xIndex,
                        groupIndex,
                        deltaIndex,
                        yIndex);
                newMonos := [];
                newCoefs := [];
                # prefijo y sufijo del monomio alrededor de Y_j X_i
                pref := mon{[1..pos-1]};
                suf  := mon{[pos+2..Length(mon)]};
                # Expandir según la regla
                for m in [3..Length(rule[1])] do
                    #Print(rule[1][m], "\n");
                    Add(resMonos, Concatenation(pref, rule[1][m], suf));
                    Add(resCoefs, - coef * rule[2][m]);
                od;
            else
                Add(resMonos, mon);
                Add(resCoefs, coef);
            fi;
        else
            Add(resMonos, mon);
            Add(resCoefs, coef);
        fi;
    od;
    return [resMonos, resCoefs];
end);

# %%
InstallGlobalFunction( RemoveAndCommuteYInYjBis, function(Yjbis)
    local YjbisresY, p, prod_rem_yj, cybx;
    YjbisresY := [];;
    for p in [1.. Length(Yjbis)] do
        prod_rem_yj := RemoveYterms(Yjbis[p].prod);
        cybx        := CommuteYBeforeX(prod_rem_yj);
        Add(YjbisresY, cybx);
    od;
    return YjbisresY;
end);

# %%
InstallGlobalFunction( CollectLinearCombination, function( L )
    local words, coeffs, dict, i, w, key, res_words, res_coeffs;
    words  := L[1];
    coeffs := L[2];
    dict   := rec();  # diccionario: palabra -> coeficiente total
    for i in [1..Length(words)] do
        w   := words[i];
        key := String(w);   # usamos string como clave
        if IsBound(dict.(key)) then
            dict.(key) := dict.(key) + coeffs[i];
        else
            dict.(key) := coeffs[i];
        fi;
    od;
    res_words  := [];
    res_coeffs := [];
    for key in RecNames(dict) do
        if dict.(key) <> 0 then
            Add(res_words, EvalString(key));
            Add(res_coeffs, dict.(key));
        fi;
    od;
    return [res_words, res_coeffs];
end);

# %%
InstallGlobalFunction( GetInfoList, function(prod, BaseNichols)
    local monos, coefs, InfoProd, k, mon, coef, small, large, pos;
    monos     := prod[1];;
    coefs     := prod[2];;
    InfoProd  := List([1..Length(BaseNichols)], i -> [ [], [] ]);
    for k in [1..Length(monos)] do
        mon   := monos[k];
        coef  := coefs[k];        
        small := MonomialForSmallIndex([[mon],[1]], nX);
        large := MonomialForLargeIndex([[mon],[coef]], nX);
        pos   := Position(BaseNichols, small);
        if pos <> fail then
            # concatenar monomios y coeficientes
            Append(InfoProd[pos][1], large[1]);
            Append(InfoProd[pos][2], large[2]);
        fi;
    od;
    return InfoProd;
end );

# %%
InstallGlobalFunction( IiqToMatrix, function(I_iq, simple, list_mat)
    local I_iq_to_matrix, info, n;
    I_iq_to_matrix := [];
    n              := Length(simple.base);
    for info in I_iq do
        if info = [ [], [] ] then
            Add(I_iq_to_matrix, NullMat(n, n));
        else
            Add(I_iq_to_matrix, EvalLinearCombination(info, list_mat));
        fi;
    od;
    return I_iq_to_matrix;
end );

# %%
InstallGlobalFunction( MatrixActionYiOnNicholsBasis, function(Yibqs, simple, nX, nElemOfG, BaseNichols, mat_in_DG)
    local YibqsresY, YibqsresYresDeltas, YibqsresYresDeltasCollected,
    N, m, M_lambda, q, p, a, b, Yibq, I_iq, I_iq_Mat, I_iq_p, entry;
    # Paso 1: reescritura y acción
    YibqsresY                   := RemoveAndCommuteYInYjBis(Yibqs);
    YibqsresYresDeltas          := ReducedDeltaAction( YibqsresY, simple, nX, nElemOfG );
    YibqsresYresDeltasCollected := List(YibqsresYresDeltas, CollectLinearCombination);
    N                           := Length(BaseNichols);
    m                           := Length(simple.base);
    M_lambda                    := NullMat(N * m, N * m);
    # Construcción de la matriz
    for q in [1..N] do
        Yibq     := YibqsresYresDeltasCollected[q];
        I_iq     := GetInfoList(Yibq, BaseNichols);
        I_iq_Mat := IiqToMatrix(I_iq, simple, mat_in_DG);;
        for p in [1..Length(I_iq_Mat)] do
            I_iq_p := I_iq_Mat[p];
            for a in [1..m] do
                for b in [1..m] do
                    entry := I_iq_p[a][b];
                    if entry <> 0 then
                        M_lambda[ N * (a - 1) + p ][ N * (b - 1) + q ] := entry;
                    fi;
                od;
            od;
        od;
    od;
    return M_lambda;
end);
