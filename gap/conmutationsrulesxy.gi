

InstallGlobalFunction(GetElementsOfG, function()
    local l, k, p, elmsofG;
    elmsofG:=[];;
    for l in Elements(GF(ConfigSDP.p)) do
        for k in [0..(ConfigSDP.m-1)] do
            Add(elmsofG, ElementSDP(l, k));
        od;
    od;
    return elmsofG;
end);


InstallValue( QGNAG_ElementsInSDP, GetElementsOfG( ) );



InstallGlobalFunction(GetConmutationRuleOnB4w, function(i, j, xIndex, groupIndex, deltaIndex, yIndex)
    local gensA, g_i, res, pos_x_i, pos_y_j, index_g_i,
        pos_res, trsp, mji, mij, coeff,
          relstrsp, index_delta, k;

    gensA := List(Elements( GF( ConfigSDP.p ) ), x -> ElementF4(x));;

    pos_x_i := xIndex[ Position( gensA, i ) ];;
    pos_y_j := yIndex[ Position( gensA, j ) ];;

    g_i := ElementSDP( FieldPart(i), 1 );; # elemento g en F4⋊C6
    res := (g_i^-1) * j ;;                 # elemento en F4
    
    index_g_i := groupIndex[ Position( QGNAG_ElementsInSDP, g_i ) ];;
    pos_res := yIndex[ Position( gensA, res ) ];;

    mji := Concatenation( [ pos_y_j ], [ pos_x_i ] );;    # Y_j * X_i
    mij := Concatenation( [ pos_x_i ], [ pos_res ] );;    # X_i * Y_j
    
    
    relstrsp := [ ];;
    
    Add( relstrsp, mji );
    Add( relstrsp, mij );
    # Recorremos los transporters
    trsp := TransporterOfG( QGNAG_ElementsInSDP, i, j);;
    coeff := [ 1, 1 ];;
    if i = j then
        Add( relstrsp, [ ] );;
        Add( coeff, -1 );;
    fi;
    
    for k in [ 1..Length( trsp ) ] do
        index_delta := deltaIndex[Position( QGNAG_ElementsInSDP, (g_i^-1) * trsp[ k ] * g_i )];
        Add( relstrsp, Concatenation( index_g_i, [ index_delta ] ));
        Add( coeff, ChiForSemidirectProduct( trsp[ k ] ) );
    od;
    return [ relstrsp, coeff ];
end);


InstallGlobalFunction(ApplyYXCommutationOnce, function(prod)
    local monos, coefs, resMonos, resCoefs,
          xIndex, deltaIndex, yIndex, groupIndex,
          k, mon, coef, p, yj, xi, i, j,
          rule, pref, suf, m, applied;

    monos := prod[1];
    coefs := prod[2];

    resMonos := [];
    resCoefs := [];

    xIndex := [1..4];
    deltaIndex := [9..32];
    yIndex := [33..36];

    groupIndex:=[ 
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
        mon := monos[k];
        coef := coefs[k];

        # Flag para saber si aplicamos alguna conmutación
        applied := false;

        for p in [1..Length(mon)-1] do

            yj := mon[p];
            xi := mon[p+1];

            if yj in yIndex and xi in xIndex then

                applied := true;

                j := Position(yIndex, yj);
                i := xi;

                rule := GetConmutationRuleOnB4w(
                            ElementF4(Elements(GF(4))[i]),
                            ElementF4(Elements(GF(4))[j]),
                            xIndex,
                            groupIndex,
                            deltaIndex,
                            yIndex);

                pref := mon{[1..p-1]};
                suf  := mon{[p+2..Length(mon)]};

                for m in [2..Length(rule[1])] do
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

    return [resMonos, resCoefs];
end
);

#Versión todavía más simple:

# Today I worked on the construction with an algebra and its left module.
# I translated part of the computations into OSCAR.”

# Pronunciación:

# Tudéi ai uórkt on de constrákshon uith an álgebra and its left módul.
# Ai transléitid part ov de computations intu Óscar.”