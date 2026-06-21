InstallGlobalFunction( TransporterOfGOld , function( G, i, j )
    local res, ress, g;
    ress:=[];;
    for g in G do
        res := g * i; # esto signifixa g actuango en i
        if FieldPart(res) = FieldPart(j) then
            Add(ress, g);
        fi;
    od;
    return ress;
end);

InstallGlobalFunction( TransporterOfG, function( G, a, b )
    return Filtered(G, h -> h * ElementSDP(a, 1) * h^-1 = ElementSDP(b, 1) );
end );

InstallGlobalFunction( IndexForDeltaInConmutationRules, function(trsp, i)
    local g, g_i, delta_index;
    # validar que  i sea ElementFq 
    g_i := ElementSDP(i!.FieldPart, 1);;
    
    delta_index:=[];;
    for g in trsp do 
        Add(delta_index, g_i^-1 * g * g_i);
    od;
    return delta_index;
end);