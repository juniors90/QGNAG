InstallGlobalFunction( RelationsOfkGdual, function( deltaIndex )
    local result, i, j, entry, monPart, coeffPart, x;
    result := [];;
    for i in deltaIndex do
        for j in deltaIndex do
            if i = j then
                entry := [ [ [i, j], [i] ], [1, -1] ];
            else
                entry := [ [ [i, j] ], [1] ];
            fi;
            Add(result, entry);;
        od;
    od;
    monPart := List(deltaIndex, i -> [i]);;
    Add(monPart, []);
    coeffPart := Concatenation(List([1..Length(monPart)-1], x -> 1), [-1]);;
    Add(result, [ monPart, coeffPart ]);;
    return result;
end);;

InstallGlobalFunction( DeltaFunctionForSDP, function( elm1 )
    if not( IsElementSDPObj( elm1 ) ) then
        Error("the argument elm1 must be an element of the semidirect product");
    fi;

    return function( elm2 )
        if not( IsElementSDPObj( elm2 ) ) then
            Error("the argument elm2 must be an element of the semidirect product");
        fi;

        if elm1!.FieldPart = elm2!.FieldPart and elm1!.CyclicPart = elm2!.CyclicPart then
            return 1;
        else
            return 0;
        fi;
    end;
end);
