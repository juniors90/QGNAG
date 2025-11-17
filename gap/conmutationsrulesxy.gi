

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


BindGlobal( "elmsInSDP", GetElementsOfG( ) );


InstallGlobalFunction(GetConmutationRuleOnB4w, function(i, j, xIndex, groupIndex, deltaIndex, yIndex)
    local gensA, g_i, res, pos_x_i, pos_y_j, index_g_i,
        pos_res, trsp, mji, mij, coeff,
          relstrsp, index_delta, k;

    gensA := List(Elements( GF( ConfigSDP.p ) ), x -> ElementF4(x));;

    pos_x_i := xIndex[ Position( gensA, i ) ];;
    pos_y_j := yIndex[ Position( gensA, j ) ];;

    g_i := ElementSDP( FieldPart(i), 1 );; # elemento g en F4⋊C6
    res := (g_i^-1) * j ;;                 # elemento en F4
    
    index_g_i := groupIndex[ Position( elmsInSDP, g_i ) ];;
    pos_res := yIndex[ Position( gensA, res ) ];;

    mji := Concatenation( [ pos_y_j ], [ pos_x_i ] );;    # Y_j * X_i
    mij := Concatenation( [ pos_x_i ], [ pos_res ] );;    # X_i * Y_j
    
    
    relstrsp := [ ];;
    
    Add( relstrsp, mji );
    Add( relstrsp, mij );
    # Recorremos los transporters
    trsp := TransporterOfG( elmsInSDP, i, j);;
    coeff := [ 1, 1 ];;
    if i = j then
        Add( relstrsp, [ ] );;
        Add( coeff, -1 );;
    fi;
    
    for k in [ 1..Length( trsp ) ] do
        index_delta := deltaIndex[Position( elmsInSDP, (g_i^-1) * trsp[ k ] * g_i )];
        Add( relstrsp, Concatenation( index_g_i, [ index_delta ] ));
        Add( coeff, ChiForSemidirectProduct( trsp[ k ] ) );
    od;
    return [ relstrsp, coeff ];
end);

