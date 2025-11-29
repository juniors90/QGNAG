InstallGlobalFunction( DeltaFunctionForSDP, function( x )
    if not( IsElementSDPObj( x ) ) then
        Error("the argument must be an element of the semidirect product");
    fi;

    return function( y )
        if not( IsElementSDPObj( y ) ) then
            Error("the argument must be an element of the semidirect product");
        fi;

        if x!.FieldPart = y!.FieldPart and x!.CyclicPart = y!.CyclicPart then
            return 1;
        else
            return 0;
        fi;
    end;
end);