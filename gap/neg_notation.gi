# beta3 := PermList(List(List(data_record_data_decomp, QGNAG_Decomposition), r-> r.(9)[1][2]));
# beta2 := PermList(List(data_rec_info_to_zero, r-> r.(0)[1][2]));
# beta1 := PermList(List(data_rec_info_to_zero_negative, r-> r.(0)[1][2]));


InstallGlobalFunction(QGNAG_BottomWeightPermutation, function(data_record_data_decomp, data_fusion_rules)
    local record_data_decomp_beta_top,
          rec_info_beta_top, 
          n_top, 
          beta_top_keys, 
          index_beta_top, 
          theta, 
          action_list, 
          i, 
          k, 
          mult, 
          target_k;
          
    # 1. Extract the beta_top decomposition data
    record_data_decomp_beta_top := data_record_data_decomp[1];
    rec_info_beta_top           := QGNAG_Decomposition(record_data_decomp_beta_top);
    
    # 2. Find the top degree n_top
    n_top         := Maximum(List(RecNames(record_data_decomp_beta_top[1]), Int));
    beta_top_keys := RecNames(rec_info_beta_top);
    
    # 3. Sanity checks
    if Length(beta_top_keys) <> 1 then
        Print("Error: rec_info_beta_top has more than one key.\n");
        return fail;
    fi;
    if Int(beta_top_keys[1]) <> n_top then
        Print("Error: The key does not match n_top.\n");
        return fail;
    fi;
    
    # 4. Get the index of the 1-dimensional module beta_top
    index_beta_top := rec_info_beta_top.(String(n_top))[1][2];
    Print("index_beta_top: ", index_beta_top, "\n\n");
    
    # 5. Compute the action on the simple modules
    theta       := Maximum(List(data_fusion_rules, r -> r.second));
    action_list := [];
    
    for i in [1..theta] do
        if i = 1 then
            Print("M_", i, " \\otimes M_", index_beta_top, " \\simeq M_", index_beta_top, "\n");
            Add(action_list, index_beta_top);
        else 
            target_k := fail;
            for k in [1..theta] do
                mult := QGNAG_GetTensorVectorEntry(data_fusion_rules, i, index_beta_top, k);
                if mult > 0 then
                    target_k := k;
                    Add(action_list, k);
                    # Break the inner loop early: since beta_top is 1-dimensional,
                    # the tensor product is irreducible and has multiplicity 1.
                    break; 
                fi;
            od;
            
            if target_k <> fail then
                Print("M_", i, " \\otimes M_", index_beta_top, " \\simeq M_", target_k, "\n");
            else
                Print("Error: No fusion rule found for M_", i, " \\otimes M_", index_beta_top, "\n");
            fi;
        fi;
    od;
    
    # Return the permutation representing the action of beta_top
    return PermList(action_list);
end);


InstallGlobalFunction(QGNAG_ShiftKeysToZero, function( data_rec_info )
    local result, r, names, min_key, new_r, name, new_key;
    result := [];
    for r in data_rec_info do
        names := RecNames(r);
        # Manejo de seguridad por si hay algún registro vacío
        if IsEmpty(names) then
            Add(result, rec());
            continue;
        fi;
        # 1. Capturamos el mínimo de las claves del registro actual
        min_key := Minimum(List(names, Int));
        # 2. Creamos un nuevo registro vacío para guardar el desplazamiento
        new_r := rec();
        # 3. Restamos el mínimo a cada clave y copiamos el valor
        for name in names do
            new_key := String(Int(name) - min_key);
            new_r.(new_key) := r.(name);
        od;        
        Add(result, new_r);
    od;
    return result;
end);


InstallGlobalFunction(QGNAG_InvertKeySigns, function( record_list )
    local new_list, r, new_r, k, num_k;
    new_list := [];    
    for r in record_list do
        new_r := rec();
        for k in RecNames(r) do
            num_k := Int(k); # GAP returns keys as strings (e.g., "1", "2")
            if num_k <> fail then
                # Change the sign and use String() so GAP accepts it as a key
                new_r.(String(-num_k)) := r.(k);
            else
                # Fallback in case there is a non-numeric key
                new_r.(k) := r.(k);
            fi;
        od;
        Add(new_list, new_r);
    od;
    return new_list;
end);

#-------------------------------------------------------------------------#
InstallGlobalFunction(QGNAG_MultiplicitiesAtNegativeDegree, function( j, record_data_decomp )
    local bijs, 
          decomposition, 
          pair, 
          rec_bijs, 
          degrees, 
          theta, 
          rec_info;

    rec_info := QGNAG_Decomposition(record_data_decomp);
    degrees  := List( RecNames( rec_info ), Int );
    theta    := Maximum( degrees );

    # Check that the degree exists
    rec_bijs := rec();
    # Initialize all multiplicities to zero
    bijs := List( [1 .. Length(record_data_decomp)], x -> 0 );
    if not IsBound( rec_info.(String(j)) ) then
        #Error( StringFormatted("The degree {} is not present in rec_info.", j) );
        rec_bijs.(String(-j)) := bijs;
        return rec_bijs;
    fi;
    # Decomposition at degree j
    decomposition := rec_info.(String(j));
    # Fill the multiplicities
    for pair in decomposition do
        bijs[pair[2]] := pair[1];
    od;
    rec_bijs.(String(-j)) := bijs;
    return rec_bijs;
end);


InstallGlobalFunction(QGNAG_MultiplicitiesByNegativeDegreeOld, function( record_data_decomp )
    local theta,
          bijs,
          bijs_by_degree,
          j,
          degrees,
          rec_info;
    rec_info       := QGNAG_Decomposition(record_data_decomp);
    degrees        := List( RecNames( rec_info ), Int );
    theta          := Maximum( degrees );
    bijs_by_degree := [];
    for j in [0 .. theta] do
        bijs := QGNAG_MultiplicitiesAtNegativeDegree( j, record_data_decomp );
        Add( bijs_by_degree, bijs);
    od;
    return bijs_by_degree;
end);

InstallGlobalFunction(QGNAG_MultiplicitiesByNegativeDegree, function(record_data_decomp)
    local degrees, 
          n_top, 
          bijs_by_degree, 
          j, 
          bijs;

    degrees := List(RecNames(record_data_decomp[1]), Int);
    n_top   := Maximum(degrees);
    bijs_by_degree := rec();
    for j in [0 .. n_top] do
        bijs                        := QGNAG_MultiplicitiesAtNegativeDegree( j, record_data_decomp );
        bijs_by_degree.(String(-j)) := bijs.(String(-j));
    od;
    return bijs_by_degree;
end);;

InstallGlobalFunction(QGNAG_NegativeDecompositionFromMultiplicities, function( bijs_by_degree )
    local decomposition, 
          j, 
          i, 
          bijs, 
          bijs_idx, 
          degree_decomposition, 
          bijs_by_degree_list,
          nonzero,
          degrees_nonzero,
          dmax, 
          degrees;
          
    decomposition       := rec();
    bijs_by_degree_list := List( bijs_by_degree, r -> r.(RecNames(r)[1]) );
    nonzero             := Filtered(bijs_by_degree, r -> Sum(r.(RecNames(r)[1])) <> 0 );;
    degrees_nonzero     := List( nonzero, r -> Int(RecNames(r)[1]) );;
    dmax                := Maximum(degrees_nonzero);
    
    for j in [0 .. (Length(bijs_by_degree_list) - 1)] do
        bijs := bijs_by_degree_list[j + 1];
        degree_decomposition := [];
        for i in [1 .. Length(bijs)] do
            if bijs[i] <> 0 then
                Add(degree_decomposition, [ bijs[i], i ]);
            fi;
        od;
        if Sum(bijs) <> 0 then
            decomposition.(String(-j - dmax)) := degree_decomposition;
        #else
        #    decomposition.(String(-j + dmax - 1)) := degree_decomposition;
        fi;
        # decomposition.(String(-j-dmax)):=degree_decomposition;
    od;
    return decomposition;
end);


InstallGlobalFunction(QGNAG_GetShiftedBijs, function( record_data_decomp )
    local n_top,
          zero_vector,
          nonzero_keys,
          first_nonzero_degree,
          shift,
          shifted,
          bijs_by_degree,
          used_degrees,
          key,
          degree,
          value,
          new_degree,
          remaining_degrees,
          d;
    bijs_by_degree := QGNAG_MultiplicitiesByNegativeDegree( record_data_decomp );;
    n_top        := Length(RecNames(bijs_by_degree)) - 1;
    zero_vector  := List( bijs_by_degree.(RecNames(bijs_by_degree)[1]), x -> 0 );
    nonzero_keys := Filtered( RecNames(bijs_by_degree), key -> Sum(bijs_by_degree.(key)) <> 0 );
    if IsEmpty(nonzero_keys) then
        Error("all multiplicity vectors are zero");
    fi;
    first_nonzero_degree := Maximum( List(nonzero_keys, Int) );
    shift                := -first_nonzero_degree;
    shifted              := rec();
    used_degrees := [];
    for key in nonzero_keys do
        degree                       := Int(key);
        value                        := bijs_by_degree.(key);
        new_degree                   := degree + shift;
        shifted.(String(new_degree)) := value;
        Add(used_degrees, new_degree);
    od;
    Sort(used_degrees);
    remaining_degrees := Filtered( [-n_top .. 0], d -> not d in used_degrees );
    for d in remaining_degrees do
        shifted.(String(d)) := zero_vector;
    od;
    return shifted;
end);


InstallGlobalFunction(QGNAG_StructureTransform, function(bijs_shifted)
    local llaves, 
          len, 
          data_neg, 
          i, 
          r, 
          rec_orig, 
          k, 
          val;

    # 1. Recopilar todas las llaves/grados presentes en la lista original
    llaves := [];
    for r in bijs_shifted do
        for k in RecNames(r) do
            Add(llaves, k);
        od;
    od;
    # 2. Determinar la longitud de las listas de valores (asume que todas miden lo mismo, ej. 8)
    len      := Length(bijs_shifted[1].(llaves[1]));
    data_neg := [];
    # 3. Construir la nueva lista de registros
    for i in [1..len] do
        r := rec();
        for rec_orig in bijs_shifted do
            for k in RecNames(rec_orig) do
                val := rec_orig.(k)[i];
                # Intentar parsear las llaves que son strings como "-3" a enteros
                if Int(k) <> fail then
                    r.(Int(k)) := val;
                else
                    r.(k) := val;
                fi;
            od;
        od;
        Add(data_neg, r);
    od;
    return data_neg;
end);


#InstallGlobalFunction(QGNAG_MultiplicitiesToVector, function(bijs_shifted)
#    local degrees, ell;

#    degrees := List(bijs_shifted, r -> Int(RecNames(r)[1]));
#    ell     := -Minimum(degrees);
#    return List([-ell..0], d -> First(bijs_shifted, r -> Int(RecNames(r)[1]) = d).(String(d)));
#end);

InstallGlobalFunction(QGNAG_MultiplicitiesToVector, function(data_record_data_decomp)
    local bijs_by_degree,
          vector,
          bijs,
          degrees,
          n_top,
          vectors;

    bijs_by_degree := List( data_record_data_decomp, QGNAG_GetShiftedBijs );;
    vectors          := [];;
    for bijs in bijs_by_degree do
        degrees        := List( RecNames( bijs ), Int );;
        n_top          := -Minimum( degrees );;
        vector        := List( [-n_top .. 0], d -> bijs.( String(d) ) );;
        Add(vectors, vector);
    od;
    return vectors;
end);

#-------------------------------------------------------------------------#

InstallGlobalFunction( QGNAG_ShiftLeft, function(nu, d)
    local n, first_nonzero, d_min, shifted_nu;
    
    n := Length(nu);
    
    # Find the index of the first sublist whose sum is not zero
    first_nonzero := PositionProperty(nu, x -> Sum(x) <> 0);
    
    if first_nonzero = fail then
        Error("The list 'nu' contains no nonzero vector.\n");
    fi;
    
    d_min := first_nonzero - 1;
    
    if d < 0 or d > d_min then
        Error("Shift out of range: 'd' must satisfy 0 <= d <= ", d_min, ".\n");
    fi;
    
    # Perform the circular shift
    shifted_nu := Concatenation(nu{[d + 1 .. n]}, nu{[1 .. d]});
    
    # Return the flattened list
    return Flat(shifted_nu);
end);

InstallGlobalFunction( QGNAG_AllShiftLeft, function( data_record_data_decomp )
    local nu,
          shifted_vectors,
          n,
          tau,
          first_nonzero,
          d_min,
          j;

    tau := QGNAG_PermutationVarChars(data_record_data_decomp);;
    nu  := QGNAG_MultiplicitiesToVector(Permuted(data_record_data_decomp, tau));;
    shifted_vectors := [];
    for n in nu do
        first_nonzero := PositionProperty(n,x -> Sum(x) <> 0);;
        d_min := first_nonzero - 1;
        for j in [0 .. d_min] do
            Add(shifted_vectors,QGNAG_ShiftLeft(n, j));;
        od;
    od;
    return shifted_vectors;
end);


InstallGlobalFunction( QGNAG_AllShiftLeftAsVector, function(data_record_data_decomp)
    local all_vectors,
          all_bijs_by_degree,
          data_rec_info_neg,
          tau,
          theta,
          j,
          bijs_by_degree,
          bijs_shifted,
          nus,
          degrees,
          supportDegrees,
          dminDisplay,
          nshift,
          transf,
          rec_info,
          pair,
          lname;

    all_vectors := [];
    Print("\nComputing shifted vectors:\n");
    Print("----------------------------------------\n");
    all_bijs_by_degree := List( data_record_data_decomp, QGNAG_MultiplicitiesByNegativeDegree );;
    data_rec_info_neg  := List( all_bijs_by_degree, QGNAG_NegativeDecompositionFromMultiplicities );;
    tau                := QGNAG_PermutationVarChars(data_rec_info_neg);
    theta              := Length(data_record_data_decomp);

    for j in [1 .. theta] do
        Print( "j = ", j, " / ", theta, "\n" );
        bijs_by_degree := all_bijs_by_degree[j^tau];
        bijs_shifted   := QGNAG_GetShiftedBijs(bijs_by_degree);
        nus            := QGNAG_AllShiftLeft(bijs_shifted);
        degrees        := List( bijs_shifted, r -> Int(RecNames(r)[1]) );
        Sort(degrees);
        supportDegrees := Filtered( degrees, d -> ForAny( bijs_shifted, x -> IsBound(x.(String(d))) and Sum(x.(String(d))) <> 0 ) );

        if IsEmpty(supportDegrees) then
            dminDisplay := fail;
        else
            dminDisplay := Minimum(supportDegrees);
        fi;
        nshift   := Length(nus);
        transf   := QGNAG_StructureTransform(bijs_shifted);
        rec_info := QGNAG_Decomposition(transf);
        pair     := rec_info.(Last(degrees));
        lname    := Concatenation( "L", String(pair[1][2]) );
        Print("  L = ", lname, "\nd_min = ", dminDisplay, "\nshifts = ", nshift, "\n");
        Append(all_vectors, nus);
        Print("  total vectors = ", Length(all_vectors));
        Print("\n----------------------------------------\n");
    od;
    Print("Finished. Total number of vectors = ", Length(all_vectors), "\n" );
    return all_vectors;
end);

InstallGlobalFunction( QGNAG_NuNames, function( bijs_shifted )
    local names,
          i,
          theta, 
          number_of_shifts,
          nu_ij,
          j;

    names := [];
    theta := Length(bijs_shifted);;
    for i in [1..theta] do
        nu_ij            := QGNAG_AllShiftLeft( bijs_shifted[i] );
        number_of_shifts := Length( nu_ij );
        for j in [0..number_of_shifts-1] do
            if j = 0 then
                Add(names, Concatenation("\\nu_{", String(i), "}" ));
            else
                Add(names, Concatenation("\\boldsymbol{q}^{-", String(j),"}\\nu_{", String(i), "}" ));
            fi;
        od;
    od;
    return names;
end);

InstallGlobalFunction(QGNAG_NamesOfShiftedVectors, function( data_record_data_decomp )
    local names,
          n,
          d_min,
          tau,
          j,
          nu,
          nu_j;
    names := [];
    tau   := QGNAG_PermutationVarChars( data_record_data_decomp );;
    nu    := QGNAG_MultiplicitiesToVector(Permuted(data_record_data_decomp, tau));;
    for n in [1 .. Length(nu)] do
        d_min := PositionProperty(nu[n],x -> Sum(x) <> 0);
        for j in [0 .. d_min - 1] do
            if j = 0 then
                nu_j := Concatenation("\\nu_{", String(n), "}");
            else
                nu_j := Concatenation("\\boldsymbol{q}^{-",String(j),"}\\nu_{",String(n),"}");
            fi;
            Add(names, nu_j);
        od;
    od;
    return names;
end);;



InstallGlobalFunction(QGNAG_GetLName, function(data_record_data_decomp_permuted, SimpleNames)
    local bijs_by_degree,
          data_rec_info_neg,
          IndexVarChars,
          index_var_chars,
          sNamesL;

    bijs_by_degree    := List(data_record_data_decomp_permuted, QGNAG_GetShiftedBijs);;
    data_rec_info_neg := List( bijs_by_degree, QGNAG_MultiplicitiesToDecomposition );;
    IndexVarChars  := function(rec_info)
        local degrees, max_degree, pair;    
        degrees         := List(RecNames(rec_info), Int);
        max_degree      := Maximum( degrees );
        pair            := rec_info.(max_degree);
        return pair[1][2];
    end;;
    index_var_chars := List(data_rec_info_neg, IndexVarChars);;
    sNamesL         := List(SimpleNames, QGNAG_ExtractTuple);;
    return List(index_var_chars, j -> Concatenation("L", sNamesL[j]));
end);


InstallGlobalFunction(QGNAG_GetLNameOrdered, function(data_record_data_decomp, SimpleNames)
    local tau;
    tau := QGNAG_PermutationVarChars(data_record_data_decomp);
    return QGNAG_GetLName(Permuted(data_record_data_decomp, tau), SimpleNames);
end);


InstallGlobalFunction( QGNAG_GetRow, function( i, bijs_shifted, sNamesL )
    local degrees,
          supportDegrees,
          dmin,
          dminDisplay,
          d,
          nshift,
          transf,
          rec_info,
          lname,
          pair,
          shiftedEnd,
          rangeLow,
          rangeHigh;
          
        # Degree-key-agnostic d_min(L_i), computed on the ORIGINAL (positive)
        # degree keys -- this never depends on sign.
        degrees := List(bijs_shifted, r -> Int(RecNames(r)[1]));
        Sort(degrees);
        supportDegrees := Filtered(degrees, d -> ForAny( bijs_shifted, x -> IsBound(x.(String(d))) and Sum(x.(String(d))) <> 0));
        if IsEmpty(supportDegrees) then
            dmin := fail;
            dminDisplay := fail;
        else
            dmin := Minimum(supportDegrees);
            dminDisplay := dmin;
        fi;
        nshift   := Length(QGNAG_AllShiftLeft( bijs_shifted )); # Number of admissible shifts for L_i -- also computed on the
        transf   := QGNAG_StructureTransform( bijs_shifted );;  # original NuVectorNames, unaffected by sign.
        rec_info := QGNAG_Decomposition( transf );;
        pair     := rec_info.( Last( degrees ) );
        lname    := Concatenation( "L", sNamesL[pair[1][2]] );  # Name L_i
        if nshift = 1 then
            return [ lname, String(dminDisplay), Concatenation("\\nu_{", String(i), "}" ) ];
        else
            shiftedEnd :=  (nshift - 1);
            rangeLow   := Minimum( 0, shiftedEnd );  # always display low..high, never 0..negative
            rangeHigh  := Maximum( 0, shiftedEnd );
            return [
                    lname, 
                    String(dminDisplay),
                    Concatenation( "\\boldsymbol{q}^{-d}\\nu_{", String(i), "},\\,", "d=", String(rangeLow), ",\\dots,", String(rangeHigh) )
                ];
        fi;
end);


InstallGlobalFunction( QGNAG_LoadNuToLaTeX, function( filename, data_record_data_decomp, SimpleNames )
    local out,
          bijs_by_degree,
          bijs_shifted,
          sNamesL,
          total,
          n,
          half,
          j,
          left,
          data_rec_info,
          tau,
          right;

    out            := OutputTextFile( filename, false );
    bijs_by_degree := List( data_record_data_decomp, QGNAG_MultiplicitiesByNegativeDegree );
    bijs_shifted   := List( bijs_by_degree, QGNAG_GetShiftedBijs );
    data_rec_info  := List( bijs_by_degree, QGNAG_NegativeDecompositionFromMultiplicities );;
    tau            := QGNAG_PermutationVarChars(data_rec_info);
    sNamesL        := List( SimpleNames, QGNAG_ExtractTuple);
    total          := Length( QGNAG_NuNames( bijs_shifted ) ); # always on the ORIGINAL, unshifted data
    n              := Length( data_record_data_decomp );
    half           := Int( n / 2 );

    AppendTo( out, "\\[\n" );
    AppendTo( out, "\\begin{array}{c|c|c||c|c|c}\n" );
    AppendTo( out, "L_i & d_{\\min}(L_i) & \\text{Shift }(\\nu) & L_i & d_{\\min}(L_i) & \\text{Shift }(\\nu) \\\\ \\hline\n" );
    for j in [1 .. half] do
        left  := QGNAG_GetRow( j, bijs_shifted[j^tau], sNamesL );
        right := QGNAG_GetRow( j + half, bijs_shifted[(j + half)^tau], sNamesL );
        AppendTo( out, left[1], " & ", left[2], " & ", left[3], " & ", right[1], " & ", right[2], " & ", right[3], " \\\\ \n" );
    od;
    AppendTo( out, "\\hline\n" );
    AppendTo( out, "\\multicolumn{3}{c||}{\\text{Total}} & \\multicolumn{3}{c}{\\mathbf{", String(total), "}} \\\\ \n" );
    AppendTo( out, "\\end{array}\n" );
    AppendTo( out, "\\]\n" );
    CloseStream( out );
end );

# --------------------------------------------------------------------------------------- #
# 1. Function to extract the epsilon vector for a given index_s
InstallGlobalFunction( QGNAG_RepresentTheVermaModuleCharacter, function( index_s, data_graded )
    local epsilon,
          index_j,
          index_k,
          theta,
          n_top;

    theta   := Length( data_graded );
    n_top   := Maximum( List( RecNames( data_graded[1][1] ), Int ) );
    epsilon := [];
    for index_j in [n_top, n_top-1..0] do
        for index_k in [1 .. theta] do
            Add( epsilon, data_graded[index_s][index_k].(String(index_j)) );
        od;
    od;
    return epsilon;
end );

# 2. Function to validate linear independence and return the coefficient vector
InstallGlobalFunction( QGNAG_Coefficients, function( nu, epsilon_s )
    local rank_nu, 
          rank_augmented,
          coefficient_s;
    
    # Check dimension compatibility
    if Length( epsilon_s ) <> Length( nu[1] ) then
        Error( "Dimension Mismatch: Length(epsilon_s) is ", Length( epsilon_s ), 
              " but column dimension of nu is ", Length( nu[1] ) );
    fi;
    rank_nu        := RankMat( nu );
    rank_augmented := RankMat( Concatenation( nu, [ epsilon_s ] ) );
    # Technical error if epsilon_s is not in the row space of nu
    if rank_nu <> rank_augmented then
        Error( "Inconsistent Linear System: Target vector epsilon_s does not belong to RowSpace(nu)." );
    fi;
    coefficient_s := SolutionMat( nu, epsilon_s );

    return coefficient_s; 
end);


InstallGlobalFunction( QGNAG_VermaModuleCharactersAndCoefficients, function( data_graded, nu )
    local theta,
          results,
          index_i,
          epsilon_i,
          coeffs;
    
    theta   := Length( data_graded );
    results := [];
    for index_i in [1 .. theta] do
        epsilon_i := QGNAG_RepresentTheVermaModuleCharacter( index_i, data_graded );  # 1. Compute epsilon for the current index
        coeffs    := QGNAG_Coefficients( nu, epsilon_i );                             # 2. Solve the linear system (nu * coeffs = epsilon)
        Add( results, rec(                                                            # 3. Store in the list of records
             vector       := epsilon_i, 
             coefficients := coeffs                                                   # If no solution exists, SolutionMat returns 'fail'
        ));
    od;
    return results;
end );




InstallGlobalFunction( QGNAG_QuantumPolsToRecord, function( data_record_data_decomp, epsilon_and_coeffs )
    local epsilon,
          coefficients,
          data,
          polynomial,
          theta,
          numShifts,
          shiftData,
          shiftCounts,
          index_s,
          p,
          d,
          k,
          coeff;

    theta      := Length(epsilon_and_coeffs);    # Number of simples
    numShifts  := Length(epsilon_and_coeffs[1].coefficients);
    shiftData  := []; 
    for p in [1..theta] do     # Number of admissible shifts for each p.
        shiftData[p] := QGNAG_AllShiftedVectorsLeft( [ data_record_data_decomp[p] ] );
    od;
    shiftCounts := List( shiftData, Length );
    Print("Length(nu) = ", numShifts, "\n");
    Print("Shift counts = ", shiftCounts, "\n");
    # ============================================================
    # Initialize every polynomial directly as [0].
    #
    # data[j].p represents t_{j,p}(q).
    # ============================================================
    data := [];
    
    for index_s in [1..theta] do
        data[index_s] := rec();
        for p in [1..theta] do       # Every t_{j,p} starts as the zero polynomial.
            data[index_s].(String(p)) := [0];
        od;
    od;

    for index_s in [1..theta] do # Compute the coefficients f_{p,d}^j.
        epsilon      := epsilon_and_coeffs[index_s].vector;
        coefficients := epsilon_and_coeffs[index_s].coefficients;
        if Length(coefficients) <> numShifts then
             Error( "Unexpected number of coefficients: ", Length(coefficients), " instead of ", numShifts );
        fi;
        k := 0; # Map the flattened coefficient vector to (p,d).
        for p in [1..theta] do
            for d in [0..shiftCounts[p]-1] do
                k := k + 1;
                coeff := coefficients[k];
                if coeff <> 0 then
                    polynomial := data[index_s].(String(p));
                    # ------------------------------------------------
                    # Extend the coefficient vector only when
                    # the required degree is larger than its
                    # current length.
                    #
                    # For example:
                    #
                    #     [0] + coefficient at d=1
                    #          -> [0,coeff]
                    #
                    #     [0,coeff] + coefficient at d=3
                    #          -> [0,coeff,0,coeff]
                    # ------------------------------------------------
                    while Length(polynomial) < d + 1 do
                        Add(polynomial, 0);
                    od;
                    polynomial[d + 1] := polynomial[d + 1] + coeff;
                    data[index_s].(String(p)) := Reversed(polynomial);
                fi;
            od;
        od;
    od;
    return data;
end );

InstallGlobalFunction( QGNAG_ThePolynomialCoefficients, function( filename, data_record_data_decomp, epsilon_and_coeffs, SimpleNames )
    local out,
        NuVectorNames,
        epsilon,
        coefficients,
        T,
        p,
        j,
        d,
        k,
        name,
        brace,
        comma,
        pName,
        dName,
        coeff,
        terms,
        term,
        firstTerm,
        theta,
        numShifts,
        nonzero,
        shiftCounts,
        simpleName,
        shiftData,
        termsRight,
        closebrace;

    out        := OutputTextFile(filename, false);
    # ============================================================
    # The admissible shifted vectors
    # ============================================================
    NuVectorNames := QGNAG_NuVectorNames(data_record_data_decomp);
    shiftData     := []; 
    theta         := Length(epsilon_and_coeffs);    # Number of simples
    for p in [1..theta] do     # Number of admissible shifts for each p.
        shiftData[p] := QGNAG_AllShiftedVectorsLeft( [ data_record_data_decomp[p] ] );
    od;
    shiftCounts := List( shiftData, Length );
    numShifts   := Length(epsilon_and_coeffs[1].coefficients);
    Print("Length(nu) = ", numShifts, "\n"); # Number of shifts for each simple.
    Print("Shift counts = ", shiftCounts, "\n");
    # ============================================================
    # T[p][j][d+1] = f_{p,d}^j
    #
    # p = simple appearing in the shifted vectors
    # j = Verma character epsilon_j
    # d = shift
    # ============================================================
    T := [];
    for p in [1..theta] do
        T[p] := [];
        for j in [1..theta] do
            T[p][j] := [];
            # We only need the shifts which actually occur
            # for the simple p.
            for d in [0..shiftCounts[p]-1] do
                T[p][j][d+1] := 0;
            od;
        od;
    od;
    # ============================================================
    # Compute the coefficients for every epsilon_j
    # ============================================================
    for j in [1..theta] do
        epsilon      := epsilon_and_coeffs[j].vector;
        coefficients := epsilon_and_coeffs[j].coefficients;
        if Length(coefficients) <> numShifts then
            Error( "Unexpected number of coefficients: ", Length(coefficients),  " instead of ", numShifts );
        fi;
        # ----------------------------------------------------
        # Each coefficient corresponds to exactly one
        # shifted vector nu_{p,d}.
        # ----------------------------------------------------
        for k in [1..numShifts] do
            coeff := coefficients[k];
            if coeff <> 0 then
                name := NuVectorNames[k];
                # Expected format:
                #
                #     \nu_{p,d}
                #
                # Extract p and d.
                brace := Position(name, '{');
                comma := Position(name, ',');
                pName := Int( name{ [brace+1..comma-1] } );
                dName := Int( name{ [comma+1..Length(name)-1] } );
                T[pName][j][dName+1] := T[pName][j][dName+1] + coeff;
            fi;
        od;
    od;
        AppendTo( out, "\\section{Polynomials $t_{j,p}(\\boldsymbol{q})$}\n\n" );

    # ============================================================
    # One subsection for each simple j.
    # Only nonzero polynomials are displayed.
    # At most two nonzero polynomials are displayed per row.
    # ============================================================
    for j in [1..theta] do
        AppendTo( out, "\\subsubsection{$j=", String(j), ", M_{j}=", SimpleNames[j], "$}\n");
        # --------------------------------------------------------
        # Collect the nonzero polynomials for this j.
        # --------------------------------------------------------
        nonzero := [];
        for p in [1..theta] do
            terms := [];
            firstTerm := true;
            for d in [0..shiftCounts[p]-1] do
                coeff := T[p][j][d+1];
                if coeff <> 0 then
                    if d = 0 then
                        if coeff = 1 then
                            term := "1";
                        elif coeff = -1 then
                            term := "-1";
                        else
                            term := String(coeff);
                        fi;
                    elif d = 1 then
                        if coeff = 1 then
                            term := "\\boldsymbol{q}^{-1}";
                        elif coeff = -1 then
                            term := "-\\boldsymbol{q}^{-1}";
                        else
                            term := Concatenation( String(coeff), "\\,\\boldsymbol{q}^{-1}");
                        fi;
                    else
                        if coeff = 1 then
                            term := Concatenation( "\\boldsymbol{q}^{-", String(d), "}" );
                        elif coeff = -1 then
                            term := Concatenation( "-\\boldsymbol{q}^{-", String(d), "}" );
                        else
                            term := Concatenation( String(coeff), "\\,\\boldsymbol{q}^{-", String(d), "}" );
                        fi;
                    fi;

                    if not firstTerm and coeff > 0 then
                        term := Concatenation("+ ", term);
                    fi;

                    Add(terms, term);
                    firstTerm := false;
                fi;
            od;
            if Length(terms) > 0 then
                Add(nonzero, [p, JoinStringsWithSeparator(terms, " ")]);
            fi;
        od;
        # --------------------------------------------------------
        # Print at most two nonzero polynomials per row.
        # --------------------------------------------------------
        AppendTo( out, "\\begin{align*}\n" );
        p := 1;
        while p <= Length(nonzero) do
            # First polynomial
            AppendTo( out, "t_{j,", String(nonzero[p][1]), "}(\\boldsymbol{q})&=", nonzero[p][2] );
            # Second polynomial, if present
            if p + 1 <= Length(nonzero) then
                AppendTo( out, " &&& t_{j,", String(nonzero[p+1][1]),"}(\\boldsymbol{q})&=", nonzero[p+1][2] );
                AppendTo( out, " \\\\\n" );
            else
                AppendTo( out, "\n" );
            fi;
            p := p + 2;
        od;
        AppendTo( out, "\\end{align*}\n\n" );
    od;
    CloseStream(out);
end);


InstallGlobalFunction( QGNAG_EpsilonToLaTeX, function(index_s, epsilon_and_coeffs, nu_names)
    local terms, 
          coeffs, 
          i, 
          c, 
          s, 
          result;

    terms  := [];
    coeffs := epsilon_and_coeffs[index_s].coefficients;
    
    for i in [1 .. Length(coeffs)] do
        c := coeffs[i];
        if c <> 0 then
            if c = 1 then
                s := nu_names[i];
            elif c = -1 then
                s := Concatenation("-", nu_names[i]);
            else
                s := Concatenation(String(c), " ", nu_names[i]);
            fi;
            Add(terms, s);
        fi;
    od;
    
    if Length(terms) = 0 then
        result := StringFormatted("\\epsilon_{{{}}} = 0", index_s);
    else
        result := StringFormatted("\\epsilon_{{{}}} = ", index_s);
        for i in [1 .. Length(terms)] do
            if i = 1 then
                result := Concatenation(result, terms[i]);
            else
                if terms[i][1] = '-' then
                    result := Concatenation( result, " - ", terms[i]{[2 .. Length(terms[i])]} );
                else
                    result := Concatenation(result, " + ", terms[i]);
                fi;
            fi;
        od;
    fi;
    return result;
end);;