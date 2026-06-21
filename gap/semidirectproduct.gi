InstallGlobalFunction(AddModM, function(s, t)
    local fam, a, b;
    if not IsBound(QGNAG.Config.m) then
        Error("QGNAG modulus is not initialized. Call QGNAGSetModulus(m) first.");
    fi;
    fam := QGNAG.Config.CyclicFamily;
    a   := ZmodnZObj(fam, s);
    b   := ZmodnZObj(fam, t);
    return Int(a + b);

end);


SumOnC6@ := function(s, t)
    local a, b, fam;
    if not IsBound(QGNAG.Config.m) then
        Error("QGNAG modulus is not initialized. Call QGNAGSetModulus(m) first.");
    fi;
    fam := QGNAG.Config.CyclicFamily;
    a   := ZmodnZObj( fam, s );
    b   := ZmodnZObj( fam, t );
    return Int( a + b );
end;


StringAlias@ := function(f)
    local z, k;
    if not(f in GF(QGNAG.Config.q)) then
        Error("f must belong to a finite field.");
    fi;
    if IsZero(f) then
        return "0";
    fi;
    z := Z(QGNAG.Config.q);
    if f = One(f) then
        return "1";
    fi;
    k := LogFFE(f, z);
    if k = 1 then
        return Concatenation("ζ_", String(QGNAG.Config.q-1));
    else
        return Concatenation("ζ_", String(QGNAG.Config.q-1), "^", String(k));
    fi;
end;


GetAlias@ := function(f, i)
    return Concatenation( "( ", StringAlias@(f), " , ", String(i), " )" );
end;


ElementSDP := function( f, i )
    local obj, a, alias, fam;
    if not IsBound(QGNAG.Config.CyclicFamily) then
        Error("QGNAG modulus is not initialized. Call QGNAGSetModulus(m) first.");
    fi;
    fam := QGNAG.Config.CyclicFamily;
    if not(IsInt(i)) then
        Error("cyclic part must be an integer");
    fi;
    a     := ZmodnZObj( fam, i );
    alias := GetAlias@( f, String( Int( a ) ) );
    obj   := Objectify( TypeElementSDP, rec( ) );
    SetFieldPart( obj, f );
    SetCyclicPart( obj, Int( a ) );
    SetAlias( obj, alias );
    return obj;
end;


InstallMethod(IsDistinguishedElement, [IsElementSDPObj],
    r -> CyclicPart(r) = 1
);


InstallMethod(\*, "multiply two elements of the semi-direct product", [IsElementSDPObj, IsElementSDPObj],
    function(x, y)
    local w, a, b, i, j, c, k, q;
    if not( IsElementSDPObj( x ) ) then
        Error("first argument must be an element of the semidirect product");
    fi;
    if not( IsElementSDPObj( y ) ) then
        Error("second argument must be an element of the semidirect product");
    fi;
    a := FieldPart(x);
    b := FieldPart(y);
    i := CyclicPart(x);
    j := CyclicPart(y);
    w := Z(QGNAG.Config.q);;
    c := a + w^Int(i) * b;
    k := SumOnC6@(i, j);    
    return ElementSDP(c, k);
end);


InstallMethod(\=, "equiality for SDP elements", [IsElementSDPObj, IsElementSDPObj],
    function(x,y)
        return FieldPart(x)=FieldPart(y) and CyclicPart(y)=CyclicPart(x); 
end);


InstallMethod(OneOp,
    "identity element of SDP",
    [IsElementSDPObj],
    function(x)
        return ElementSDP( One(x!.FieldPart), One(x!.CyclicPart) );    
end);


InstallMethod(InverseOp, "inverse of an element of the SDP", [IsElementSDPObj],
    function(x)
    local w, a, i, ainv;
    if not( IsElementSDPObj( x ) ) then
        Error("the argument must be an element of the semidirect product");
    fi;
    a    := FieldPart(x);
    i    := CyclicPart(x);
    w    := Z(QGNAG.Config.q);;
    ainv := - w^(-Int(i)) * a;
    return ElementSDP(ainv, -i);
end);


InstallMethod(ViewString, "show SDP element", [IsElementSDPObj],
    function(x)
        return Concatenation("( ", String(FieldPart(x))," , ",String(CyclicPart(x)), " )");
end);


InstallMethod(String, "SDP element to string", [IsElementSDPObj],
    function(x)
        return Alias(x);
end);


InstallGlobalFunction( ChiForSemidirectProduct, function(x)
    if not( IsElementSDPObj( x ) ) then
        Error("the argument must be an element of the semidirect product");
    fi;
    return (-1)^x!.CyclicPart;;
end
);;
