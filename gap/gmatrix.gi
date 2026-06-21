#############################################################################
##
#W  structurematrices.gi
##
#############################################################################

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
