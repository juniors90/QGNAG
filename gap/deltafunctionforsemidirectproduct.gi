InstallGlobalFunction( DeltaFunctionForSDP, function( elm1 )
    if not( IsElementSDPObj( elm1 ) ) then
        Error("the argument elm1 must be an element of the semidirect product");
    fi;

    return function( y )
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