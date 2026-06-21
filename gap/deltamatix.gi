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