InstallGlobalFunction( QGNAG_HSData, function(BasisMod, BasisSubMod, BasisNichols, NicholsGradingData)
    local all_data_deg, s_j, coeffs, dec, degrees_HP, idx_bi, bi, deg, data_deg, HScoeffs;
    all_data_deg := [];
    for s_j in BasisSubMod do
        coeffs     := Coefficients(BasisMod, s_j);
        dec        := Filtered( [1..Length(coeffs)], i -> coeffs[i] <> 0);
        degrees_HP := List(dec, i -> [coeffs[i], RemInt(i, Length(BasisNichols))]);
        idx_bi     := First(degrees_HP)[2];
        if idx_bi = 0 then
            idx_bi := Length(BasisNichols);
        fi;
        bi         := BasisNichols[idx_bi];
        deg        := Length(bi[1][1]);
        data_deg   := First(NicholsGradingData, ell -> ell.graded_i = deg);
        Add( all_data_deg, data_deg );
    od;
    HScoeffs := List([0..(Length(NicholsGradingData)-1)], i ->
        rec( graded_i := i, count := Number(all_data_deg, r -> r.graded_i = i))
    );;
    return HScoeffs;
end);


InstallGlobalFunction( QGNAG_PrintHS, function(HScoeffs)
    local poly_string;
    poly_string := JoinStringsWithSeparator(
        List(
            Filtered(HScoeffs, r -> r.count <> 0),
                function(r)
                    if r.count = 1 then
                        return Concatenation("t^", String(r.graded_i));
                    else
                        return Concatenation(String(r.count), "t^", String(r.graded_i));
                    fi;
                end),
            " + "
        );;
    Print(" Hilbert Serie: H(t) = ", poly_string, ".\n");
end);