#############################################################################
##
#W  structurematrices.gi
##
#############################################################################


InstallGlobalFunction(QGNAG_NicholsBasisAction, function( BaseNichols, allPairsInG, gen )
    local genGi, Pols, bj, mon, Pol, PolN, Lt;
    genGi    := QGNAG.Config.elmsG[Position(allPairsInG, gen)];
    Pols:= [];
    Lt      := List(QGNAG.Config.gensA, ElementFq);
    for bj in [1..Length(BaseNichols)] do
        mon  := BaseNichols[bj][1];
        Pol  := [ [ List(mon[1], m -> Position( Lt, genGi * QGNAG.Config.gensA[m] ) ) ], [1] ];
        Add(Pols, Pol);
    od;
    return Pols;
end);

InstallGlobalFunction(QGNAG_GroupActionOnNicholsBasis, function( BaseNichols, PolNorm, allPairsInG, gen )
    local N, Amat, genGi, bj, pos_bj, pol, pos, coeffss, pos_bi;
    N     := Length(BaseNichols);
    Amat  := NullMat(N, N);
    genGi := QGNAG.Config.elmsG[Position( allPairsInG, gen )];
    for bj in PolNorm do
        pos_bj  := Position(PolNorm, bj);
        pol     := BaseNichols[pos_bj];
        pos     := List(bj[1], tx -> Position(BaseNichols, [[tx], [1]]));
        coeffss := bj[2] * ChiForSemidirectProduct( genGi )^Length(pol[1][1]);
        for pos_bi in pos do
            Amat[pos_bi][pos_bj] := coeffss[Position(pos, pos_bi)];
        od;
    od;
    return Amat;
end);


InstallGlobalFunction( QGNAG_ActionBlocksByGenerator, function( BaseNichols, PolsNorm, allPairsInG, gen )
    local MaxDeg,
          MatsByDegree,
          genGi,
          d,
          Base_d, 
          dim_d,
          M_d,
          j,
          pol,
          mon,
          PolGd,
          pos,
          coeffs,
          k;
    genGi        := QGNAG.Config.elmsG[Position( allPairsInG, gen )];
    MaxDeg       := Maximum(List(BaseNichols, p -> Length(p[1][1])));
    MatsByDegree := rec();
    for d in [0..MaxDeg] do
        Base_d := Filtered(BaseNichols, p -> Length(p[1][1]) = d);
        dim_d  := Length(Base_d);
        if dim_d = 0 then
            continue;
        fi;
        M_d := NullMat(dim_d, dim_d, Rationals);
        for j in [1..dim_d] do
            pol    := Base_d[j];
            mon    := pol[1];
            PolGd  := PolsNorm[Position(BaseNichols, pol)];
            pos    := List(PolGd[1], tx -> Position(Base_d, [[tx], [1]]));
            coeffs := PolGd[2] * ChiForSemidirectProduct( genGi )^d;
            for k in [1..Length(pos)] do
                M_d[pos[k]][j] := coeffs[k];
            od;
        od;
        MatsByDegree.(String(d)) := M_d;
    od;
    return MatsByDegree;
end);


InstallGlobalFunction(QGNAG_BlockMatricesByDegree, function( block_mats, k )
    local keys, names, ell, i;
    if Length(block_mats) = 0 then
        Error("The list of block matrices is empty.");
    fi;
    names := RecNames(block_mats[1]);
    keys  := List(names, Int);
    Sort(keys);
    for i in [2..Length(block_mats)] do
        if Set(RecNames(block_mats[i])) <> Set(names) then
            Error("The block matrices are not homogeneous.");
        fi;
    od;
    ell := Maximum(keys);
    if keys <> [0..ell] then
        Error("The keys must be exactly 0,1,...,ell.");
    fi;
    if not k in keys then
        Error("Degree ", k, " is not available.");
    fi;
    return List(block_mats, r -> r.(String(k)));
end);

InstallGlobalFunction( StructureMatrixOfG, function( Conjugation, BaseNichols )
    local monos, bi, M, coeff, mon, pos_mon, m, i, DimNichols;

    monos      := List( BaseNichols, x -> x[1][1] );
    DimNichols := Length( BaseNichols );
    M := NullMat( DimNichols, DimNichols, Rationals );
    for bi in [ 1 .. Length( Conjugation ) ] do
        mon     := Conjugation[bi][1];
        coeff   := Conjugation[bi][2];
        pos_mon := List( mon, x -> Position( monos, x ) );
        if mon <> [] then
            for m in [ 1 .. Length( mon ) ] do
                i := Position( monos, mon[m] );
                M[i][bi] := coeff[m];
            od;
        fi;
    od;
    return M;
end );

InstallGlobalFunction( QGNAG_GiMatrixAction, function(GiMatrixOnNichols, GiMatrix)
    return KroneckerProduct(GiMatrix, GiMatrixOnNichols);
end);