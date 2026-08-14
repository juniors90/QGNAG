InstallGlobalFunction( QGNAG_MultiplicitiesAtDegree, function( j, SimplesMn, rec_info )
    local bijs, decomposition, pair, rec_bijs;

    # Check that the degree exists
    rec_bijs := rec();
    if not IsBound( rec_info.(String(j)) ) then
        Error( StringFormatted("The degree {} is not present in rec_info.", j) );
    fi;
    # Initialize all multiplicities to zero
    bijs := List( [1 .. Length(SimplesMn)], x -> 0 );
    # Decomposition at degree j
    decomposition := rec_info.(String(j));
    # Fill the multiplicities
    for pair in decomposition do
        bijs[pair[2]] := pair[1];
    od;
    rec_bijs.(String(j)) := bijs;
    return rec_bijs;
end);


InstallGlobalFunction( QGNAG_MultiplicitiesByDegree, function( SimplesMn, rec_info )
    local theta, bijs, bijs_by_degree, j, degrees;
    degrees        := List( RecNames( rec_info ), Int );
    theta          := Maximum( degrees );
    bijs_by_degree := [];
    for j in [0 .. theta] do
        bijs := QGNAG_MultiplicitiesAtDegree( j, SimplesMn, rec_info );
        Add( bijs_by_degree, bijs);
    od;
    return bijs_by_degree;
end);


InstallGlobalFunction( QGNAG_DecompositionFromMultiplicities, function( bijs_by_degree )
    local decomposition, j, i, bijs, bijs_idx, degree_decomposition, bijs_by_degree_list;
    decomposition := rec();
    bijs_by_degree_list := List( [1 .. Length(bijs_by_degree)], i -> bijs_by_degree[i].(String(i - 1)) );
    for j in [0 .. Length(bijs_by_degree_list) - 1] do
        bijs := bijs_by_degree_list[j + 1];
        degree_decomposition := [];

        for i in [1 .. Length(bijs)] do
            if bijs[i] <> 0 then
                Add(degree_decomposition, [ bijs[i], i ]);
            fi;
        od;

        decomposition.(String(j)):=degree_decomposition;
    od;
    return decomposition;
end);


# --------------------------------------------- #
InstallGlobalFunction( QGNAG_FusionMultiplicity, function( index_i, index_s, index_k, SimplesMn )
    local Mi_tensor_Ms,
          Mi_tensor_Ms_mats,
          Mk_mats,
          Mi,
          Ms,
          Mk,
          N_is_k;
    
    Mi                := SimplesMn[index_i];
    Ms                := SimplesMn[index_s];
    Mk                := SimplesMn[index_k];
    Mi_tensor_Ms      := QGNAG_TensorProductOfSimples( Mi, Ms);
    Mi_tensor_Ms_mats := QGNAG_RepresentationMatrices(Mi_tensor_Ms);
    Mk_mats           := QGNAG_RepresentationMatrices(Mk);
    N_is_k            := QGNAG_DimHomAModules( Mi_tensor_Ms_mats, Mk_mats);
    
    return N_is_k;
end);


InstallGlobalFunction(QGNAG_GradedMultiplicity, function( index_i, index_j, rec_info_nichols )
    local decomposition,
          pair;
    
    if not IsBound( rec_info_nichols.(String(index_j)) ) then
        return 0;
    fi;
    decomposition := rec_info_nichols.(String(index_j));
    for pair in decomposition do
        if pair[2] = index_i then
            return pair[1];
        fi;
    od;
    
    return 0;
end);


InstallGlobalFunction(QGNAG_GradedFusionMultiplicity, function( index_s, index_k, index_j, SimplesMn, rec_info_nichols )
    local index_i,
          N_ik_s,
          b_ij,
          result;

    result := 0;
    for index_i in [1 .. Length(SimplesMn)] do
        N_ik_s  := QGNAG_FusionMultiplicity( index_i, index_s, index_k, SimplesMn );
        b_ij    := QGNAG_GradedMultiplicity( index_i, index_j, rec_info_nichols );
        result  := result + N_ik_s * b_ij;
    od;    
    return result;
end);


InstallGlobalFunction(QGNAG_GradedFusionByDegree, function( s, SimplesMn, rec_info_nichols )
    local theta, data, j, k, r;
    theta := Maximum( List( RecNames(rec_info_nichols), Int ) );
    data  := [];
    for k in [1 .. Length(SimplesMn)] do
        r := rec();
        for j in [0 .. theta] do
            r.(String(j)) := QGNAG_GradedFusionMultiplicity( s, k, j, SimplesMn, rec_info_nichols );
        od;
        Add(data, r);
    od;
    return data;
end);


InstallGlobalFunction(QGNAG_GradedFusionVector, function( s, SimplesMn, rec_info )
    local data, epsilon, j, k, theta;
    data    := QGNAG_GradedFusionByDegree( s, SimplesMn, rec_info );
    theta   := Maximum( List( RecNames(rec_info), Int ) );
    epsilon := [];
    for j in [0 .. theta] do
        for k in [1 .. Length(SimplesMn)] do
            Add(epsilon, data[k].(String(j)));
        od;
    od;
    return epsilon;
end);


InstallGlobalFunction(QGNAG_ExportGradedFusionByDegreeToLaTeX, function(filename, SimplesMn, rec_info_nichols)
    local out, s, j, k, n, ell, data_s;
    ell := Maximum( List( RecNames(rec_info_nichols), Int ) );
    out := OutputTextFile(filename, false);
    n   := Length(SimplesMn);
    for s in [1..n] do
        data_s := QGNAG_GradedFusionByDegree( s, SimplesMn, rec_info_nichols );
        AppendTo( out, Concatenation("\\subsubsection{Multiplicity table for $M_{", String(s), "}$}\n\n" ) );
        AppendTo(out, "\\begin{table}[ht]\n");
        AppendTo(out, "\\centering\n");
        AppendTo(out, "\\begin{tabular}{c|");
        for k in [1..n] do
            AppendTo(out, "c");
        od;
        AppendTo(out, "}\n\\hline\n");
        AppendTo(out, "$j$");
        for k in [1..n] do
            AppendTo(out,StringFormatted(" & $M_{{{}}}$", k));
        od;
        AppendTo(out, " \\\\\n\\hline\n");
        for j in [0 .. ell]  do
            AppendTo(out, String(j));
            for k in [1..n] do
                AppendTo(out,StringFormatted(" & {}", data_s[k].(String(j))));
            od;
            AppendTo(out, " \\\\\n");
        od;
        AppendTo(out, "\\hline\n");
        AppendTo(out, "\\end{tabular}\n");
        AppendTo(out, Concatenation( "\\caption{Multiplicity table for $M_{", String(s), "}$.}\n" ));
        AppendTo(out, "\\end{table}\n\n");
    od;
    CloseStream(out);
end);

# -----------------------------------------------------------------------

InstallGlobalFunction(QGNAG_AllCharToShiftedVectorsLeft, function( record_data_decomp )
    local N,
          degrees,
          ell,
          min_degree,
          vector,
          shifted_vectors,
          j,
          d,
          index,
          degree,
          i;

    N       := Length(record_data_decomp);
    degrees := List(RecNames(record_data_decomp[1]), x -> Int(x));
    Sort(degrees);
    ell := Maximum(degrees);

    # Find the smallest degree with a non-zero multiplicity.
    min_degree := First( degrees, d -> ForAny( [1..N], i -> record_data_decomp[i].(String(d)) <> 0 ) );
    shifted_vectors := [];
    # Compute all possible left shifts.
    for j in [0..min_degree] do
        vector := [];
        for d in [0..ell] do
            index  := (d + j) mod (ell + 1);
            degree := String(index);
            for i in [1..N] do
                Add(vector, record_data_decomp[i].(degree));
            od;
        od;
        Add(shifted_vectors, vector);
    od;
    return shifted_vectors;
end);

InstallGlobalFunction(QGNAG_AllShiftedVectorsLeft, function( data_record_data_decomp )
    local shifted_vectors,
          record_data_decomp,
          i;

    shifted_vectors := [];
    for i in [1..Length(data_record_data_decomp)] do
        record_data_decomp := data_record_data_decomp[i];
        Append( shifted_vectors, QGNAG_AllCharToShiftedVectorsLeft( record_data_decomp ) );
    od;
    return shifted_vectors;
end);


InstallGlobalFunction(QGNAG_CharToShiftedVectorLeft, function( record_data_decomp, j )
    local degrees,
              ell,
              N,
              vector,
              d,
              i,
              index,
              degree;

    N       := Length(record_data_decomp);
    degrees := List(RecNames(record_data_decomp[1]), x -> Int(x));
    Sort(degrees);
    ell    := Maximum(degrees);
    vector := [];
    for d in [0..ell] do
        index := ((d + j) mod (ell + 1));
        degree := String(index);
        for i in [1..N] do
            Add(vector, record_data_decomp[i].(degree));
        od;
    od;
    return vector;
end);


InstallGlobalFunction( QGNAG_NuVectorNames, function( data_record_data_decomp )
    local names,
          i,
          number_of_shifts,
          nu_ij,
          j;

    names := [];
    for i in [1..Length(data_record_data_decomp)] do
        nu_ij := QGNAG_AllCharToShiftedVectorsLeft( data_record_data_decomp[i] );
        number_of_shifts := Length( nu_ij );
        for j in [0..number_of_shifts-1] do
            Add(names, Concatenation("\\nu_{", String(i), String(j), "}" ));
        od;
    od;
    return names;
end );

# -----------------------------------------------------------------------