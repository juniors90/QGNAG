

InstallGlobalFunction( QGNAG_HSData, function( L, Simple, BasisNichols, NicholsGradingData)
    local all_data_deg, s_j, coeffs, dec, degrees_HP, idx_bi, bi, deg,
          data_deg, HScoeffs, S, BasisSubMod, DimNichols, verma_data, count, BasisMod;
    all_data_deg   := [];
    DimNichols     := Length(BasisNichols);
    BasisMod       := Basis(L);
    S              := SubAlgebraModule( L, List([1..Length(Simple.base)], i -> BasisMod[DimNichols * i]) );
    BasisSubMod    := Basis( S );
    for s_j in BasisSubMod do
        coeffs     := Coefficients(BasisMod, s_j);
        dec        := Filtered( [1..Length(coeffs)], i -> coeffs[i] <> 0);
        degrees_HP := List(dec, i -> [coeffs[i], RemInt(i, DimNichols)]);
        idx_bi     := First(degrees_HP)[2];
        if idx_bi = 0 then
            idx_bi := DimNichols;
        fi;
        bi         := BasisNichols[idx_bi];
        deg        := Length(bi[1][1]);
        data_deg   := First(NicholsGradingData, ell -> ell.graded_i = deg);
        Add( all_data_deg, data_deg );
    od;
    HScoeffs := List(NicholsGradingData, i ->
        rec( graded_i := i.graded_i, count := Number(all_data_deg, r -> r.graded_i = i.graded_i))
    );;
    verma_data := rec(
        HScoeffs := HScoeffs,
        VermaModule := L, 
        Socle       := S,
    );
    return verma_data;
end);


InstallGlobalFunction( QGNAG_Character, function( L, Simple, BasisNichols, NicholsGradingData)
    local all_data_deg, s_j, coeffs, idx_bi, bi, deg,
          DimNichols, BasisMod, S, BasisSubMod, HScoeffs, verma_data,
          counts, graded_vectors, i;

    DimNichols := Length(BasisNichols);
    BasisMod   := Basis(L);
    
    # Construcción del submódulo S
    S           := SubAlgebraModule( L, List([1..Length(Simple.base)], i -> BasisMod[DimNichols * i]) );
    BasisSubMod := Basis( S );

    # Inicializamos los registros para contar y para almacenar los vectores por grado
    counts         := rec();
    graded_vectors := rec();
    
    for i in NicholsGradingData do
        counts.(String(i.graded_i))         := 0;
        graded_vectors.(String(i.graded_i)) := [];
    od;

    # Bucle principal
    for s_j in BasisSubMod do
        coeffs := Coefficients(BasisMod, s_j);
        
        # Encontrar el primer índice no nulo de manera eficiente
        idx_bi := First([1..Length(coeffs)], i -> coeffs[i] <> 0);
        
        if idx_bi <> fail then
            idx_bi := RemInt(idx_bi, DimNichols);
            if idx_bi = 0 then
                idx_bi := DimNichols;
            fi;

            # Extraer el grado algebraico
            bi  := BasisNichols[idx_bi];
            deg := Length(bi[1][1]);

            # Si el grado pertenece a la graduación conocida, clasificamos el vector
            if IsBound(counts.(String(deg))) then
                counts.(String(deg)) := counts.(String(deg)) + 1;
                Add(graded_vectors.(String(deg)), s_j);
            fi;
        fi;
    od;

    # Reconstruir HScoeffs a partir de los contadores precalculados
    HScoeffs := List(NicholsGradingData, i -> 
        rec( graded_i := i.graded_i, count := counts.(String(i.graded_i)) )
    );

    # Empaquetamos todo en verma_data con la nueva clave GradedBasis
    verma_data := rec(
        HScoeffs    := HScoeffs,
        VermaModule := L, 
        Socle       := S,
        GradedBasis := graded_vectors
    );

    return verma_data;
end);


InstallGlobalFunction( QGNAG_PrintHS, function(verma_data)
    local poly_string;
    poly_string := JoinStringsWithSeparator(
        List(
            Filtered(verma_data.HScoeffs, r -> r.count <> 0),
                function(r)
                    if r.count = 1 then
                        return Concatenation("t^", String(r.graded_i));
                    else
                        if r.graded_i = 0 then
                            return String(r.count);
                        else
                            if r.graded_i = 1 then
                                return Concatenation(String(r.count), "t");
                            else
                                return Concatenation(String(r.count), "t^", String(r.graded_i));
                            fi;
                        fi;
                    fi;
                end),
            " + "
        );;
    Print(" Hilbert polynomial: H(t) = ", poly_string, ".\n");
end);
