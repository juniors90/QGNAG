
InstallGlobalFunction(GetElementsOfG, function()
    local l, k, elmsofG;
    elmsofG := [];;
    for l in Elements(GF(QGNAG.Config.q)) do
        for k in [0..(QGNAG.Config.m-1)] do
            Add(elmsofG, ElementSDP(l, k));
        od;
    od;
    return elmsofG;
end);


InstallGlobalFunction( GetConmutationRules, function(i, j)
    local g_i, res, pos_x_i, pos_y_j, index_g_i, pos_res,
          trsp, mji, mij, coeff, relstrsp, index_delta, k;

    pos_x_i   := QGNAG.Config.xIndex[ Position( QGNAG.Config.gensA, i ) ];;
    pos_y_j   := QGNAG.Config.yIndex[ Position( QGNAG.Config.gensA, j ) ];;
    g_i       := ElementSDP( i, 1 );;                           # elemento g en F4⋊C6
    res       := (g_i^-1) * j ;;                                # elemento en F4
    index_g_i := QGNAG.Config.groupIndex[ Position( QGNAG.Config.elmsG, g_i ) ];;
    pos_res   := QGNAG.Config.yIndex[ Position( QGNAG.Config.gensA, FieldPart(res) ) ];;
    mji       := Concatenation( [ pos_y_j ], [ pos_x_i ] );;     # Y_j * X_i
    mij       := Concatenation( [ pos_x_i ], [ pos_res ] );;     # X_i * Y_j
    relstrsp  := [ ];;
    trsp      := TransporterOfG( QGNAG.Config.elmsG, i, j);;
    coeff     := [ 1, 1 ];;
    Add( relstrsp, mji );
    Add( relstrsp, mij );
    if i = j then
        Add( relstrsp, [ ] );;
        Add( coeff, -1 );;
    fi;
    for k in [ 1..Length( trsp ) ] do
        index_delta := QGNAG.Config.deltaIndex[Position( QGNAG.Config.elmsG, (g_i^-1) * trsp[ k ] * g_i )];
        Add( relstrsp, Concatenation( index_g_i, [ index_delta ] ));
        Add( coeff, ChiForSemidirectProduct( trsp[ k ] ) );
    od;
    return [ relstrsp, coeff ];
end);


InstallGlobalFunction(ApplyYXCommutationOnce, function(prod)
    local monos, coefs, resMonos, resCoefs, k, mon, coef,
          p, yj, xi, i, j, rule, pref, suf, m, applied;
    monos    := prod[1];
    coefs    := prod[2];
    resMonos := [];
    resCoefs := [];
    for k in [1..Length(monos)] do
        mon  := monos[k];
        coef := coefs[k];
        # Flag para saber si aplicamos alguna conmutación
        applied := false;
        for p in [1..Length(mon)-1] do
            yj := mon[ p ];
            xi := mon[ p + 1 ];
            if yj in QGNAG.Config.yIndex and xi in QGNAG.Config.xIndex then
                applied := true;
                j       := Position(QGNAG.Config.yIndex, yj);
                i       := xi;
                rule    := GetConmutationRules(QGNAG.Config.gensA[i], QGNAG.Config.gensA[j]);
                pref    := mon{[1..p-1]};
                suf     := mon{[p+2..Length(mon)]};
                for m in [2..Length( rule[1] )] do
                    Add(resMonos, Concatenation(pref, rule[1][m], suf));
                    Add(resCoefs, -coef * rule[2][m]);
                od;
                break;  # IMPORTANTE: solo una conmutación por pasada
            fi;
        od;
        if not applied then
            Add(resMonos, mon);
            Add(resCoefs, coef);
        fi;
    od;
    return [ resMonos, resCoefs ];
end);