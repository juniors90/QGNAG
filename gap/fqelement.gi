ElementFq := function(f)
    local obj, alias;
    # Comprobamos que los argumentos son de tipo correcto
    # q := Size( DefaultField([f]) );
    if not(f in Elements(GF(QGNAG.Config.q))) then
        Error(Concatenation("fiel part must be an element of GF(p), with p:=", String(QGNAG.Config.q), "."));
    fi;
    alias := StringAlias@( f );
    obj := Objectify( TypeElementFq, rec( ) );
    SetFieldPart( obj, f );
    SetAlias( obj, alias );
    return obj;
end;

InstallMethod(OneOp, "identity element of SDP", [IsElementFqObj],
    function(x)
        return ElementFq( One(x!.FieldPart) );    
end);

InstallMethod(InverseOp, "inverse of an element of the SDP", [IsElementFqObj],
    function(x)
    local a, ainv;
    if not( IsElementFqObj( x ) ) then
        Error("the argument must be an element of the semidirect product");
    fi;
    a := x!.FieldPart;
    # Definición: (a,i)^{-1} = (w^{-i} * a, -i)
    ainv := a^-1;
    return ElementFq(ainv);
end);

InstallMethod(ViewString, "show F4 element", [IsElementFqObj],
    function(x)
        return String(FieldPart(x));
end);

InstallMethod(String, "F4 element to string", [IsElementFqObj],
    function(x)
        return Alias(x);
end);


InstallMethod(\*,
    "multiply two elements of F4",
    [IsElementFqObj, IsElementFqObj],
    function(x, y)
    local a, b, c;

    if not( IsElementFqObj( x ) ) then
        Error("first argument must be an element of F4");
    fi;

    if not( IsElementFqObj( y ) ) then
        Error("second argument must be an element of F4");
    fi;

    # Tomamos los datos
    a := x!.FieldPart;
    b := y!.FieldPart;

    # Producto según la regla
    c := a * b;  

    return ElementFq( c );
end);


InstallMethod(\=, "equiality for F4 elements", [IsElementFqObj, IsElementFqObj],
    function(x,y)
        return FieldPart(x)=FieldPart(y); 
end);


InstallMethod(\*, "action of SDP element on GF(q)",
    [IsElementSDPObj, IsFFE], function(x, alpha)

    local a, i, q, omega, m, result;

    if not( IsElementSDPObj( x ) ) then
        Error("the argument must be an element of GF(p)");
    fi;

    # datos del elemento (a,i)
    a := x!.FieldPart;
    i := x!.CyclicPart;

    # raiz q-esima primitiva
    omega := Z(QGNAG.Config.q);

    # accion
    result := (1 - omega) * a + omega^Int( i ) * alpha;

    return ElementFq( result );

end );


InstallMethod(\*, "action of SDP element on GF(p)",
    [IsElementSDPObj, IsElementFqObj],   # IsFFE = finite field element
    function(x, alpha)
    local omega, a, i, result, alias, obj, q, z;

    if not( IsElementSDPObj( x ) ) then
        Error("the argument must be an element of the semidirect product");
    fi;

    if not( IsElementFqObj( alpha ) ) then
        Error("the argument must be an element of the F4");
    fi;

    # Datos del objeto
    a := x!.FieldPart;
    i := x!.CyclicPart;

    # El cuerpo F = GF(4)
    omega := Z(QGNAG.Config.q);;  # generador primitivo (w^3=1 en GF(4))

    # acción: (a, i) * alpha = (1-\omega)a + \omega^i alpha.
    result := (1-omega) * a + omega^Int( i ) * alpha!.FieldPart;

    obj :=  ElementFq( result );
    return obj;
end);