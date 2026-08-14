data_verma_char          := [];;
data_AllMatricesByDegree := [];;
data_record_data_decomp  := [];;
data_rec_info            := [];;


for index_s in [1..Length(SimplesMn)] do
    simpleM := SimplesMn[index_s ];;

    ## Matrices de $\mathfrak{B}(V)$ 
    X0_matrix := QGNAG_XiMatrixAction(X0_matrix_on_Nichols, simpleM);;
    X1_matrix := QGNAG_XiMatrixAction(X1_matrix_on_Nichols, simpleM);;
    X2_matrix := QGNAG_XiMatrixAction(X2_matrix_on_Nichols, simpleM);;
    all_matrix_rep_nichols := [ X0_matrix, X1_matrix, X2_matrix ];;
    
    ## Matrices de $G$
    # 
    Ms_matrix := QGNAG_GiMatrixAction(Ms_matrix_on_Nichols, simpleM.simple(G.1));;
    Mt_matrix := QGNAG_GiMatrixAction(Mt_matrix_on_Nichols, simpleM.simple(G.2));;
    all_matrix_rep_kG := [Ms_matrix, Mt_matrix];;
    
    ## Matrices de $\delta_h$ con $h\in G$.
    # 
    De_matrix   := QGNAG_DeltaMatrix(De_functions, simpleM);;
    D12_matrix  := QGNAG_DeltaMatrix(D12_functions, simpleM);;
    D123_matrix := QGNAG_DeltaMatrix(D123_functions, simpleM);;
    D13_matrix  := QGNAG_DeltaMatrix(D13_functions, simpleM);;
    D132_matrix := QGNAG_DeltaMatrix(D132_functions, simpleM);;
    D23_matrix  := QGNAG_DeltaMatrix(D23_functions, simpleM);;
    all_matrix_rep_kG_dual := [ De_matrix, D12_matrix, D123_matrix, D13_matrix, D132_matrix, D23_matrix ];;
    
    # Matrices de $Y_j$
    # 
    list_mat_in_DG := QGNAG_ConstructDGActionMatrices(simpleM, allPairsInG, Base_FK3);;
    Y0_matrix := MatrixActionYiOnNicholsBasis(Y12bis, simpleM, Base_FK3, list_mat_in_DG);;
    Y1_matrix := MatrixActionYiOnNicholsBasis(Y13bis, simpleM, Base_FK3, list_mat_in_DG);;
    Y2_matrix := MatrixActionYiOnNicholsBasis(Y23bis, simpleM, Base_FK3, list_mat_in_DG);;
    all_matrix_rep_nichols_dual := [ Y0_matrix, Y1_matrix, Y2_matrix ];;
    
    # 
    all_matrix_rep_DG := Concatenation( all_matrix_rep_kG, all_matrix_rep_kG_dual );
    all_matrix_rep    := Concatenation( all_matrix_rep_nichols, all_matrix_rep_DG, all_matrix_rep_nichols_dual );;
    
    # 
    QGNAG_CheckRelationsShift( relsxBos, all_matrix_rep , 0 );
    QGNAG_CheckRelationsShift( relsDx, all_matrix_rep , 0 );
    QGNAG_CheckRelationsShift( relsyBos, all_matrix_rep , 0 );
    QGNAG_CheckRelationsShift( relsDy, all_matrix_rep , 0 );
    QGNAG_CheckRelationsShift( relsQG, all_matrix_rep , 0 );
    
    # Verma Module
    # 
    F  := CF(6);;
    D  := AlgebraWithOne( F, all_matrix_rep );;
    Nm := Length(simpleM.base)*Length(Base_FK3);;
    L  := LeftAlgebraModule(D, \*, F^Nm ); 
    
    verma_char := QGNAG_Character( L, simpleM, Base_FK3, NicholsGradingData );;
    Add(data_verma_char, verma_char);;
    
    AllMatricesByDegree := QGNAG_AllMatricesByDegree( verma_char, all_matrix_rep_DG );;
    Add(data_AllMatricesByDegree, AllMatricesByDegree);;

    record_data_decomp := QGNAG_SimpleVermaModuleDecomposition( SimplesMn, allPairsInG, Base_FK3, AllMatricesByDegree );
    Add(data_record_data_decomp , record_data_decomp );;
    
    rec_info := QGNAG_Decomposition(record_data_decomp);
    Add(data_rec_info, rec_info);;
od;



QGNAG_MatrixOfSimpleVermaActionByDegree := function( data_verma_char, data_reps_mats, index_simple, index_generator, degree)
    local generator_matrix,
          simple_subalg,
          FieldS,
          degrees,
          ell,
          degree_vects,
          B_degree,
          verma_char,
          mat;
    # Validate simple index
    if not IsInt(index_simple) then
        Error("index_simple must be an integer");
    fi;

    if index_simple < 1 or index_simple > Length(data_verma_char) then
        Error( "index_simple must be between 1 and ", Length(data_verma_char), ", but got ", index_simple );
    fi;
    
    # Extract the corresponding Verma module
    verma_char := data_verma_char[index_simple];
    # Validate generator index
    if not IsInt(index_generator) then
        Error("index_generator must be an integer");
    fi;

    if index_generator < 1
       or index_generator > verma_char.n_gens_simple_DG then
        Error( "index_generator must be between 1 and ", verma_char.n_gens_simple_DG, " for simple ", index_simple, ", but got ", index_generator
        );
    fi;
    # Determine the maximal degree
    degrees := List( RecNames(verma_char.GradedBasis), x -> Int(x) );
    ell     := Maximum(degrees);
    # Validate degree
    if not IsInt(degree) then
        Error("degree must be an integer");
    fi;
    if degree < 0 or degree > ell then
        Error( "degree must be between 0 and ", ell, " for simple ", index_simple, ", but got ", degree );
    fi;
    # Matrix corresponding to the requested generator
    generator_matrix := data_reps_mats[index_simple][index_generator];
    # Simple subalgebra
    simple_subalg := verma_char.Socle;
    FieldS := LeftActingDomain(simple_subalg);
    # Basis vectors of the requested homogeneous component
    degree_vects := verma_char.GradedBasis.(String(degree));
    B_degree := Basis(VectorSpace(FieldS, degree_vects),degree_vects);
    # Matrix of the action on the homogeneous component
    mat := MatrixOfAction( B_degree, generator_matrix );
    return mat;
end;

QGNAG_MatrixOfSimpleVermaAction := function( data_verma_char, data_reps_mats, index_simple, index_generator )
    local generator_matrix,
          simple_subalg,
          basis_simple,
          FieldS,
          degrees,
          ell,
          all_degree_vects,
          B_all_deg,
          verma_char,
          mat;

    # Validar índice del simple
    if not IsInt(index_simple) then
        Error("index_simple debe ser un entero");
    fi;
    if index_simple < 1 or index_simple > Length(data_verma_char) then
        Error( "index_simple debe estar entre 1 y ", Length(data_verma_char), ", pero se obtuvo ", index_simple );
    fi;
    # Extraer el Verma correspondiente
    verma_char := data_verma_char[index_simple];
    # Validar índice del generador
    if not IsInt(index_generator) then
        Error("index_generator debe ser un entero");
    fi;
    if index_generator < 1 or index_generator > verma_char.n_gens_simple_DG then
        Error( "index_generator debe estar entre 1 y ", verma_char.n_gens_simple_DG, " para el simple ", index_simple, ", pero se obtuvo ", index_generator);
    fi;
    # Matriz correspondiente al generador solicitado
    generator_matrix := data_reps_mats[index_simple][index_generator];
    # Álgebra simple contenida en el Verma
    simple_subalg    := verma_char.Socle;
    basis_simple     := Basis(simple_subalg);
    FieldS           := LeftActingDomain(simple_subalg);
    # Grados del Verma
    degrees          := List( RecNames(verma_char.GradedBasis), x -> Int(x) );
    ell              := Maximum(degrees);
    # Base total, ordenada por grado
    all_degree_vects := Concatenation(List( [0 .. ell], d -> verma_char.GradedBasis.(String(d))));
    B_all_deg        := Basis( VectorSpace(FieldS, all_degree_vects), all_degree_vects );
    #B_all_deg        := Basis( VectorSpace(FieldS, basis_simple), basis_simple );
    # Matriz de la acción sobre el Verma
    mat              := MatrixOfAction( B_all_deg, generator_matrix );
    #mat              := MatrixOfAction( basis_simple , generator_matrix );
    return mat;
end;