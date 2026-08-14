InstallGlobalFunction(QGNAG_GroupDegreesOfBasis, function( BaseNichols )
    local g_is, degrees, bi, monos, coefs, g_i, list_rep_g_is;
    # Asume que 'gensA' y 'elmsG' están definidos en el entorno global.
    g_is    := List(QGNAG.Config.gensA, x -> ElementSDP( x, 1));
    degrees := [];
    for bi in BaseNichols do
        monos := bi[1];
        coefs := bi[2];
        if Length(monos[1]) = 0 then
            g_i := QGNAG.Config.elmsG[1]; # El grado del elemento 1 es la identidad del grupo
            Add(degrees, g_i);
        else
            list_rep_g_is := List(monos[1], j -> g_is[j]);
            g_i           := Product( list_rep_g_is ); # Multiplica los grados
            Add(degrees, g_i);
        fi;
    od;
    return degrees;
end);


InstallGlobalFunction(QGNAG_DeltaMatricesNichols, function( BaseNichols )
    local N, deltaMatrices, i, pos, degrees;
    degrees       := QGNAG_GroupDegreesOfBasis( BaseNichols );
    N             := Length(degrees);
    # Crea una matriz nula de N x N para cada elemento del grupo en elmsG
    deltaMatrices := List(QGNAG.Config.elmsG, g -> NullMat(N, N));
    for i in [1..N] do
        pos := Position(QGNAG.Config.elmsG, degrees[i]);
        if pos <> fail then
            deltaMatrices[pos][i][i] := 1;
        fi;
    od;
    return deltaMatrices;
end);


#InstallGlobalFunction(DeltaMatricesByDegree, function( degrees )
#    local N, deltaMatrices, i, pos;
#    N             := Length(degrees);
#    # Crea una matriz nula de N x N para cada elemento del grupo en elmsG
#    deltaMatrices := List(QGNAG.Config.elmsG, g -> NullMat(N, N));
#    for i in [1..N] do
#        pos := Position(elmsG, degrees[i]);
#        if pos <> fail then
#            deltaMatrices[pos][i][i] := 1;
#        fi;
#    od;
#    return deltaMatrices;
#end);

InstallGlobalFunction(QGNAG_DeltaBlocksByDegree, function( BaseNichols )
    local MaxDeg, idx_by_deg, DeltaBlocks, h, R, d, idx_d, dim_d, M_d, j, degrees;

    # Grado tensorial máximo en la base
    MaxDeg := Maximum(List(BaseNichols, p -> Length(p[1][1])));

    # Precalculamos los índices para cada grado tensorial 'd' (d=0..MaxDeg)
    # Nota: GAP usa índices base 1, por lo que la posición d+1 corresponde al grado d.
    idx_by_deg := List([0..MaxDeg], d -> Filtered([1..Length(BaseNichols)], i -> Length(BaseNichols[i][1][1]) = d));

    DeltaBlocks := [];
    degrees     := QGNAG_GroupDegreesOfBasis(BaseNichols);
    for h in QGNAG.Config.elmsG do
        R := rec();
        for d in [0..MaxDeg] do
            idx_d := idx_by_deg[d + 1]; # Obtenemos los índices del grado d
            dim_d := Length(idx_d);
            if dim_d = 0 then
                continue;
            fi;
            M_d := NullMat(dim_d, dim_d);
            for j in [1..dim_d] do
                if degrees[idx_d[j]] = h then
                    M_d[j][j] := 1;
                fi;
            od;
            # Guarda el bloque matricial en el registro con la clave del grado como String
            R.(String(d)) := M_d;
        od;
        Add(DeltaBlocks, R);
    od;
    return DeltaBlocks;
end);


InstallGlobalFunction( QGNAG_BlockDiagonalMatrixForDeltas, function(R)
    local degs, dims, n, M, pos, d, B, i, j;
    degs := List(RecNames(R), x -> Int(x));
    Sort(degs);
    dims := List(degs, d -> NrRows(R.(String(d))));
    n    := Sum(dims);
    M    := NullMat(n,n);
    pos  := 1;
    for d in degs do
        B := R.(String(d));
        for i in [1..NrRows(B)] do
            for j in [1..NrCols(B)] do
                M[pos+i-1][pos+j-1] := B[i][j];
            od;
        od;
        pos := pos + NrRows(B);
    od;
    return M;
end);


InstallGlobalFunction(DeltaFromRelations, function(Dh, bi, BaseNichols)
    local h, g_i_inverse_x_h, g_i_inverse, g_is, list_rep_g_is, coefs, monos, di, gensDeltas;
    
    g_is := List(QGNAG.Config.gensA, x -> ElementSDP( x, 1));
    if bi in BaseNichols then
        monos := bi[1];
        coefs := bi[2];
        if Length(monos[1]) = 0 then
            gensDeltas := List(QGNAG.Config.deltaIndex, z -> [[[z]], [1]]);
            return QGNAG.Config.elmsG[Position(gensDeltas, Dh)];
        fi;
        list_rep_g_is := List(monos[1], j -> g_is[j]);
        g_i_inverse   := Product( list_rep_g_is )^-1;
    fi;
    di := Last( Dh[1][1] );;
    if di in QGNAG.Config.deltaIndex then
        h := QGNAG.Config.elmsG[di - ( QGNAG.Config.nX + QGNAG.Config.nGensOfG )];
    fi;
    g_i_inverse_x_h := g_i_inverse * h;
    return g_i_inverse_x_h;
end);


InstallGlobalFunction( DeltaMatForReps, function(Dh, simple, BaseNichols)
    local list_idx_of_deltas, delta_fuctions, diag_mat_Dh, Dh_matrix;
    list_idx_of_deltas := List( BaseNichols, bi -> DeltaFromRelations( Dh, bi, BaseNichols ) );;
    delta_fuctions     := List( list_idx_of_deltas, z -> DeltaFunctionForSDP( z ) );;
    diag_mat_Dh        := Concatenation( List( Conj4Basis( simple ), conj -> List( delta_fuctions, Df -> Df( conj ) ) ) );;
    Dh_matrix          := DiagonalMat( diag_mat_Dh );
    return Dh_matrix;
end);


InstallGlobalFunction( QGNAG_DeltaFunctions, function(Dh, BaseNichols)
    local list_idx_of_deltas, delta_fuctions;
    list_idx_of_deltas := List( BaseNichols, bi -> DeltaFromRelations(Dh, bi, BaseNichols) );
    delta_fuctions     := List( list_idx_of_deltas, z -> DeltaFunctionForSDP(z) );
    return delta_fuctions;
end);


InstallGlobalFunction(QGNAG_DeltaMatrix, function(delta_functions, simple)
    local diag_mat_Dh, Dh_matrix;
    diag_mat_Dh := Concatenation( List( Conj4Basis(simple), conj -> List( delta_functions, Df -> Df(conj) ) ) );
    Dh_matrix   := DiagonalMat(diag_mat_Dh);
    return Dh_matrix;
end);
