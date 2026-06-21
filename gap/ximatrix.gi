#############################################################################
##
#W  structurematrix.gi
##
#############################################################################

InstallGlobalFunction( StructureMatrixForXi, function(
    XiActionOnBasisNichols, # x_i bi x_i in B basis nichols
    BaseNichols             # {b_i}_{i=1}^N
    )
    local monos, bi, M, coeff, mon, pos_mon, j, m, i, DimNichols, Xi_matrix;
    monos       := List( BaseNichols, x -> x[1][1] );
    DimNichols  := Length( BaseNichols );
    M           := NullMat( DimNichols, DimNichols, Rationals );
    for bi in [1..Length(XiActionOnBasisNichols)] do
        mon     := XiActionOnBasisNichols[bi][1];
        coeff   := XiActionOnBasisNichols[bi][2];
        pos_mon := List( mon, x -> Position( monos, x ) );
        if mon <> [] then
            for m in [ 1..Length( mon ) ] do
                i        := Position( monos, mon[m] );
                M[i][bi] := coeff[m];
            od;
        fi;
    od;
    return M;
end );