###########################################################
# Constructor implementation
###########################################################

TensorElement := function(x, k)
    local r;
    r := Objectify(TensorType, rec());
    SetGroupElement(r, x);
    SetVectorSpaceElement(r, k);
    return r;
end;

###########################################################
# Print methods installation
###########################################################

InstallMethod(ViewString, "show tensor element", [IsTensorObj],
    function(t)
        return Concatenation(
            "(", ViewString(GroupElement(t)), ") ⊗ ",
            ViewString(VectorSpaceElement(t))
        );
end);

InstallMethod(String, "convert tensor element to string", [IsTensorObj],
    function(t)
        return Concatenation(
            "(", String(GroupElement(t)), ") ⊗ ",
            String(VectorSpaceElement(t))
        );
end);

InstallMethod(\=, "equiality for tensor elements", [IsTensorObj, IsTensorObj],
    function(x,y)
        return GroupElement(x) = GroupElement(y) and VectorSpaceElement(x) = VectorSpaceElement(y); 
end);