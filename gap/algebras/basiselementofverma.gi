###########################################################
# Constructor implementation
###########################################################

BasisElementOfVermaModule := function(b, x, v)
    local r;
    r := Objectify(BasisElementOfVermaModuleType, rec());
    SetNicholsAlgebraElement(r, b);
    SetGroupElement(r, x);
    SetVectorSpaceElement(r, v);
    return r;
end;

###########################################################
# Print methods installation
###########################################################

InstallMethod(ViewString, "show a basis element of Verma Module", [IsBasisElementOfVermaModuleObj],
    function(t)
        return Concatenation(
            String(NicholsAlgebraElement(t)), " ⊗ (",
            ViewString(GroupElement(t)), ") ⊗ ",
            ViewString(VectorSpaceElement(t))
        );
end);

InstallMethod(String, "convert a basis element of Verma Module to string", [IsBasisElementOfVermaModuleObj],
    function(t)
        return Concatenation(
            String(NicholsAlgebraElement(t)), " ⊗ (",
            ViewString(GroupElement(t)), ") ⊗ ",
            ViewString(VectorSpaceElement(t))
        );
end);

InstallMethod(\=, "equiality for two basis elements of Verma Module", [IsBasisElementOfVermaModuleObj, IsBasisElementOfVermaModuleObj],
    function(x,y)
        return
        NicholsAlgebraElement(x) = NicholsAlgebraElement(y) and
        GroupElement(x) = GroupElement(y) and
        VectorSpaceElement(x) = VectorSpaceElement(y); 
end);