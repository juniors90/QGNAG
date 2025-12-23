InstallGlobalFunction( TransporterOfG, function( G, i, j )
    local res, ress, g;
    ress:=[];;
    for g in G do
        res := g * i;
        if FieldPart(res) = FieldPart(j) then
            Add(ress, g);
        fi;
    od;
    return ress;
end);

InstallGlobalFunction( IndexForDeltaInConmutationRules, function(trsp, i)
    local g, g_i, delta_index;
    g_i := ElementSDP(i!.FieldPart, 1);;
    
    delta_index:=[];;
    for g in trsp do 
        Add(delta_index, g_i^-1 * g * g_i);
    od;
    return delta_index;
end);