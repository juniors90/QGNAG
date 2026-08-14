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


InstallGlobalFunction(NonzeroDeltaStructureMatrices, function(simple)
    local basisConj, result, el, mat;
    basisConj := Conj4Basis(simple);
    result    := [];
    for el in GetElementsOfG() do
        mat   := StructureMatrixSimpleModule(DeltaFunctionForSDP(el), simple).matrix;
        if not ForAll(mat, row -> ForAll(row, x -> x = 0)) then
            Add(result,
                rec(
                    element          := el,
                    conjugationBasis := basisConj,
                    matrix           := mat
                )
            );
        fi;
    od;
    return result;
end);


InstallGlobalFunction(PrintNonzeroDeltaStructureMatrices, function(simple)
    local data, r;
    Print("Basis: ", simple.base, "\n\n");
    Print("Weight: \n");
    Print("   g: ", simple.weightSDP.g, "\n");
    Print(" rho: ", simple.weightSDP.rho, "\n\n");
    data := NonzeroDeltaStructureMatrices(simple);
    # StringFormatted("The algorithm has to process {} layers.", Length(pcps)-1)
    Print("Conjugation basis: ", data[1].conjugationBasis, "\n\n");
    #Print(data = [] and "[]\n" or data[1].conjugationBasis, "\n\n");
    for r in data do
        Print("Group element: ", r.element, "\n");
        Print("Structure matrix of delta_", r.element,": \n");
        Display(r.matrix);
        Print("-----------------------------------------------------\n");
    od;
end);

InstallGlobalFunction(QGNAG_PrintDGStructureMatrices, function(simple)
    local data, r, gensG, gen;
    Print("Basis: ", simple.base, "\n\n");
    Print("Weight: \n");
    Print("   g: ", simple.weightSDP.g, "\n");
    Print(" rho: ", simple.weightSDP.rho, "\n\n");
    gensG := GeneratorsOfGroup(Source(simple.simple));
    for gen in gensG do
        Print("Images on generator ", gen, ":\n");
        Display(simple.simple(gen));
        Print("\n");
    od;
    data := NonzeroDeltaStructureMatrices(simple);
    # StringFormatted("The algorithm has to process {} layers.", Length(pcps)-1)
    Print("Conjugation basis: ", data[1].conjugationBasis, "\n\n");
    #Print(data = [] and "[]\n" or data[1].conjugationBasis, "\n\n");
    for r in data do
        Print("Group element: ", r.element, "\n");
        Print("Structure matrix of delta_", r.element,": \n");
        Display(r.matrix);
        Print("-----------------------------------------------------\n");
    od;
end);


InstallGlobalFunction(AttachDeltaStructureMatrices, function(simple)
    simple!.DeltaStructureMatrices := List(
        GetElementsOfG(),
        el -> rec(
                element := el,
                matrix  := StructureMatrixSimpleModule(
                    DeltaFunctionForSDP(el),
                    simple
                ).matrix
            )
        );
    return simple;
end);


InstallGlobalFunction(PrintDeltaStructureMatrices, function(simple)
    local r;
    if not IsBound(simple!.DeltaStructureMatrices) then
        Error("Run AttachDeltaStructureMatrices(simple) first.");
    fi;
    Print("Basis: ", simple.base, "\n\n");
    # Print("Conjugation basis: ", Conj4Basis(simple), "\n\n");
    for r in simple!.DeltaStructureMatrices do
        Print("delta_", r.element, ":\n");
        Display(r.matrix);
        Print("-----------------------------------------------------\n");
    od;
end);


InstallGlobalFunction(QGNAG_DeltaMatrixOfElement, function(simple, h)
    local r;
    
    if not IsBound(simple!.DeltaStructureMatrices) then
        Error("Run AttachDeltaStructureMatrices(simple) first.");
    fi;

    for r in simple!.DeltaStructureMatrices do
        if r.element = h then
            return r.matrix;
        fi;
    od;
    
    Error("No delta matrix stored for ", h);

end);
