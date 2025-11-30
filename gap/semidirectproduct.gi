#############################################################################
# Constructor
#############################################################################



BindGlobal("fam", ElementsFamily( FamilyObj( ZmodnZ( ConfigSDP.m ) ) ) );

# ---------------------------------------------------------------------- #
# ----------                2. Operation On C_6             ------------ #
# ---------------------------------------------------------------------- #

SumOnC6@ := function(s, t)
    local a, b;
    a := ZmodnZObj( fam, s );
    b := ZmodnZObj( fam, t );
    return Int( a + b );
end;

# ---------------------------------------------------------------------- #
# ----------------             Print         --------------------------- #
# ---------------------------------------------------------------------- #

StringAlias@ := function(f)
    local alias;
    if not(f in Elements(GF(ConfigSDP.p))) then
        Error(Concatenation("fiel part must be an element of GF(p), with p:=", String(ConfigSDP.p), "."));
    fi;
    if f = 0*Z(2)  then
        alias := "0";
    elif f =  Z(2)^0 then
        alias := "1";
    elif f = Z(2^2) then
        alias := "ω";
    elif f = Z(2^2)^2 then
        alias := "ω^2";
    fi;
    return alias;
end;

GetAlias@ := function(f, i)
    local alias;
    alias := Concatenation("( ", StringAlias@(f), " , ", String(i), " )" );
    return alias;
end;

# ---------------------------------------------------------------------- #
# ----------        3. Element Of Semidirect Product        ------------ #
# ---------------------------------------------------------------------- #

# Constructor de un objeto ElementSDP
ElementSDP := function( f, i )
    local obj, a, alias;
    # Comprobamos que los argumentos son de tipo correcto
    if not(f in Elements(GF(ConfigSDP.p))) then
        Error(Concatenation("fiel part must be an element of GF(p), with p:=", String(ConfigSDP.p), "."));
    fi;

    if not(IsInt(i)) then
        Error("cyclic part must be an integer");
    fi;
    a := ZmodnZObj( fam, i );
    alias := GetAlias@( f, String( Int( a ) ) );
    obj := Objectify( TypeElementSDP, rec( ) );
    SetFieldPart( obj, f );
    SetCyclicPart( obj, Int( a ) );
    SetAlias( obj, alias );
    return obj;
end;

#############################################################################
# Propiedad IsDistinguishedElement
#############################################################################

InstallMethod(IsDistinguishedElement,
    [IsElementSDPObj],
    r -> CyclicPart(r) = 1
);

#############################################################################
# 4. Operation On  Semidirect Product ( MultiplicativeElement )                                      #
#############################################################################

InstallMethod(\*,
    "multiply two elements of the semi-direct product",
    [IsElementSDPObj, IsElementSDPObj],
    function(x, y)
    local w, a, b, i, j, c, k;

    if not( IsElementSDPObj( x ) ) then
        Error("first argument must be an element of the semidirect product");
    fi;
    if not( IsElementSDPObj( y ) ) then
        Error("second argument must be an element of the semidirect product");
    fi;

    # Tomamos los datos
    a := FieldPart(x);
    b := FieldPart(y);
    i := CyclicPart(x);
    j := CyclicPart(y);

    # Cuerpo F = GF(4)
    w := Z(2^2);; # raíz primitiva

    # Producto según la regla
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

InstallMethod(InverseOp,
    "inverse of an element of the SDP",
    [IsElementSDPObj],
    function(x)
    local F, w, a, i, ainv;

    if not( IsElementSDPObj( x ) ) then
        Error("the argument must be an element of the semidirect product");
    fi;

    a := FieldPart(x);
    i := CyclicPart(x);

    # Cuerpo F = GF(4)
    F := Parent(a);
    w := Z(2^2);;   # generador primitivo de F4

    # Definición: (a,i)^{-1} = (w^{-i} * a, -i)
    ainv := w^(-Int(i)) * a;

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


# InstallMethod(\*,
#    "action of GF(p) on SDP element",
#    [IsFFE, IsElementSDPObj],   # IsFFE = finite field element
#    function(j, r)
#        local a, g, newa;
#
#        a := r!.FieldPart;
#        g := r!.CyclicPart;
#
#        # acción elegida: multiplicar la primera coordenada
#        newa := j * a;
#
#        return ElementSDP(newa, g);
#    end
#);

InstallGlobalFunction( ChiForSemidirectProduct, function(x)
    if not( IsElementSDPObj( x ) ) then
        Error("the argument must be an element of the semidirect product");
    fi;
    return (-1)^x!.CyclicPart;;
end
);;

