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