InstallGlobalFunction(QGNAG_PermutationFromRecInfo, function( data_rec_info )
    local ModuleData,
          i,
          rec_info,
          degrees,
          top_degree,
          bottom_degree,
          top_modules,
          bottom_modules,
          j,
          perm_list;

    ModuleData := List([1..Length(data_rec_info)], i -> rec( top := i, bottom := fail));
    for i in [1..Length(data_rec_info)] do
        rec_info      := data_rec_info[i];
        degrees       := List(RecNames(rec_info), Int);
        top_degree    := Maximum(degrees);
        bottom_degree := Minimum(degrees);
        top_modules   := Filtered( rec_info.(String(top_degree)), x -> x[2] = i ); # M_i debe aparecer en el top degree
        if Length(top_modules) <> 1 then
            Error( "M", i, " does not appear uniquely in the top degree of data_rec_info[", i, "]" );
        fi;
        bottom_modules       := rec_info.(String(bottom_degree)); # El módulo que aparece en el bottom degree
        j                    := First(bottom_modules, x -> x[1] >= 1)[2];
        ModuleData[i].bottom := j;
    od;
    perm_list := List(ModuleData, x -> x.bottom);
    return PermList(perm_list);
end);


InstallGlobalFunction(QGNAG_PermutationFusion, function( sigma, Simples )
    local a,               # index for the first simple
          b,               # index for the second simple
          c,               # index for a simple
          simples_a,       # first simple
          simples_b,       # second simple
          simples_c,       # simple used for the decomposition
          tensor_ab,       # tensor product Simples[a] tensor Simples[b]
          tensor_sigma,    # tensor product after applying sigma
          mats_ab,         # representation matrices of tensor_ab
          mats_sigma,      # representation matrices of tensor_sigma
          mats_c,          # representation matrices of simples_c
          c_sigma,         # index c transformed by sigma^-1
          simples_c_sigma, # simple Simples[c^(sigma^-1)]
          mats_c_sigma,    # representation matrices of simples_c_sigma
          mult_c,          # multiplicity of simples_c in tensor_sigma
          mult_c_sigma,    # multiplicity of simples_c_sigma in tensor_ab
          degree_c,        # dimension of simples_c
          remaining,       # dimension still unexplained
          failures;        # list of records containing the failures

    failures := [];
    for a in [2..Length(Simples)] do
        for b in [a..Length(Simples)] do
            simples_a    := Simples[a]; # Simple module
            simples_b    := Simples[b]; # Simple module
            tensor_ab    := QGNAG_TensorProductOfSimples( simples_a, simples_b );  # Tensor products
            tensor_sigma := QGNAG_TensorProductOfSimples( Simples[a^sigma], Simples[b^sigma] );
            
            if DegreeOfRepresentation(tensor_ab.rho) <> 
               DegreeOfRepresentation(tensor_sigma.rho) then # Check dimensions of the two tensor products
                Print( StringFormatted( "Dimension mismatch: a = {}, b = {}.\n", a, b ) );
                Add(failures, rec( type := "dimension", a := a, b := b ));
                continue;
            fi;
            
            mats_ab    := QGNAG_RepresentationMatrices(tensor_ab);                  # Representation matrices of the tensor products
            mats_sigma := QGNAG_RepresentationMatrices(tensor_sigma);
            remaining  := DegreeOfRepresentation(tensor_ab.rho);                    # Dimension still to be accounted for
            for c in [1..Length(Simples)] do
                simples_c       := Simples[c];                                      # Simple module used in the decomposition
                mats_c          := QGNAG_RepresentationMatrices(simples_c);         # Representation matrices of the simple
                mult_c          := QGNAG_DimHomAModules(mats_sigma, mats_c);        # Multiplicity of M_c in M_{a^sigma} tensor M_{b^sigma}
                c_sigma         := c^(sigma^-1);                                    # Index of M_{c^(sigma^-1)}
                simples_c_sigma := Simples[c_sigma];                                # Simple M_{c^(sigma^-1)}
                mats_c_sigma    := QGNAG_RepresentationMatrices( simples_c_sigma ); # Representation matrices of M_{c^(sigma^-1)}
                mult_c_sigma    := QGNAG_DimHomAModules( mats_ab, mats_c_sigma );   # Multiplicity of M_{c^(sigma^-1)} in M_a tensor M_b
                degree_c        := DegreeOfRepresentation(simples_c.simple);        # Dimension of M_c
                if mult_c <> mult_c_sigma then                                      # Compare multiplicities
                    Print( StringFormatted("Mismatch: a = {}, b = {}, c = {}, {} <> {} \n", a, b, c, mult_c, mult_c_sigma) );
                    Add(failures, rec(
                        type       := "multiplicity",
                        a          := a,
                        b          := b,
                        c          := c,
                        mult_sigma := mult_c,
                        mult       := mult_c_sigma
                    ));
                    break;
                fi;
                
                if mult_c > 0 then        # Subtract the contribution of this simple
                    remaining := remaining - mult_c * degree_c;
                    if remaining = 0 then # Decomposition completely accounted for
                        break;
                    fi;
                fi;
            od;
        od;
    od;
    return failures;
end);

InstallGlobalFunction(QGNAG_TestPermutationFusion, function( sigma, Simples )
    local failures, failure;
    failures := QGNAG_PermutationFusion( sigma, Simples );
    if IsEmpty(failures) then
        Print(
            "\n",
            "========================================\n",
            "  Permutation fusion test: PASSED\n",
            "========================================\n",
            "The permutation preserves all fusion rules.\n",
            "\n"
        );

        return true;
    fi;
    Print(
        "\n",
        "========================================\n",
        "  Permutation fusion test: FAILED\n",
        "========================================\n",
        "Number of failures: ", Length(failures), "\n",
        "\n"
    );
    for failure in failures do
        if failure.type = "dimension" then
            Print(
                "Dimension mismatch:\n",
                "  (a,b) = (", failure.a, ", ", failure.b, ")\n",
                "  M_a tensor M_b has dimension ",
                failure.dimension_ab,
                "\n",
                "  M_{a^sigma} tensor M_{b^sigma} has dimension ",
                failure.dimension_sigma,
                "\n",
                "\n"
            );
        elif failure.type = "multiplicity" then
            Print(
                "Multiplicity mismatch:\n",
                "  (a,b,c) = (",
                failure.a, ", ",
                failure.b, ", ",
                failure.c, ")\n",
                "  m_{a^sigma,b^sigma}^c = ",
                failure.mult_sigma,
                "\n",
                "  m_{a,b}^{c^sigma^-1} = ",
                failure.mult,
                "\n",
                "\n"
            );

        fi;
    od;
    return false;
end);