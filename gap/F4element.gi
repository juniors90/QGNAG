ElementF4 := function( f)
    local obj, a, alias;
    # Comprobamos que los argumentos son de tipo correcto
    if not(f in Elements(GF(ConfigSDP.p))) then
        Error(Concatenation("fiel part must be an element of GF(p), with p:=", String(ConfigSDP.p), "."));
    fi;
    alias := StringAlias@( f );
    obj := Objectify( TypeElementF4, rec( ) );
    SetFieldPart( obj, f );
    SetAlias( obj, alias );
    return obj;
end;

InstallMethod(OneOp,
    "identity element of SDP",
    [IsElementF4Obj],
    function(x)
        return ElementF4( One(x!.FieldPart) );    
end);

InstallMethod(InverseOp,
    "inverse of an element of the SDP",
    [IsElementF4Obj],
    function(x)
    local F, w, a, i, ainv;

    if not( IsElementF4Obj( x ) ) then
        Error("the argument must be an element of the semidirect product");
    fi;

    a := x!.FieldPart;

    # Cuerpo F = GF(4)
    F := Parent(a);

    # Definición: (a,i)^{-1} = (w^{-i} * a, -i)
    ainv := a^-1;

    return ElementF4(ainv);
    
end);

InstallMethod(ViewString, "show F4 element", [IsElementF4Obj],
    function(x)
        return String(FieldPart(x));
end);

InstallMethod(String, "F4 element to string", [IsElementF4Obj],
    function(x)
        return Alias(x);
end);


InstallMethod(\*,
    "multiply two elements of F4t",
    [IsElementF4Obj, IsElementF4Obj],
    function(x, y)
    local w, a, b, i, j, c, k;

    if not( IsElementF4Obj( x ) ) then
        Error("first argument must be an element of F4");
    fi;

    if not( IsElementF4Obj( y ) ) then
        Error("second argument must be an element of F4");
    fi;

    # Tomamos los datos
    a := x!.FieldPart;
    b := y!.FieldPart;

    # Producto según la regla
    c := a * b;  

    return ElementF4( c );
end);


InstallMethod(\=, "equiality for F4 elements", [IsElementF4Obj, IsElementF4Obj],
    function(x,y)
        return FieldPart(x)=FieldPart(y); 
end);

InstallMethod(\*,
    "action of SDP element on GF(p)",
    [IsElementSDPObj, IsFFE],   # IsFFE = finite field element
    function(x, alpha)
    local w, a, i, result, alias, obj;

    if not( IsElementSDPObj( x ) ) then
        Error("the argument must be an element of GF(p)");
    fi;

    # Datos del objeto
    a := x!.FieldPart;
    i := x!.CyclicPart;

    # El cuerpo F = GF(4)
    w := Elements(GF(4))[3];;  # generador primitivo (w^3=1 en GF(4))

    # Acción: w^2 * a + w^i * alpha
    result := w^2 * a + w^Int( i ) * alpha;

    obj :=  ElementF4( result );
    return obj;
    end
);

InstallMethod(\*,
    "action of SDP element on GF(p)",
    [IsElementSDPObj, IsElementF4Obj],   # IsFFE = finite field element
    function(x, alpha)
    local w, a, i, result, alias, obj;

    if not( IsElementSDPObj( x ) ) then
        Error("the argument must be an element of the semidirect product");
    fi;

    if not( IsElementF4Obj( alpha ) ) then
        Error("the argument must be an element of the F4");
    fi;

    # Datos del objeto
    a := x!.FieldPart;
    i := x!.CyclicPart;

    # El cuerpo F = GF(4)
    w := Elements(GF(4))[3];;  # generador primitivo (w^3=1 en GF(4))

    # Acción: w^2 * a + w^i * alpha
    result := w^2 * a + w^Int( i ) * alpha!.FieldPart;

    obj :=  ElementF4( result );
    return obj;
    end
);