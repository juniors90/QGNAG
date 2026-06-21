#############################################################################
##
##  nicholssmash.gi              QGNAG                   Ferreira, Juan David
##
#############################################################################

#############################################################################
InstallGlobalFunction( RelationsGivenByNicholsSmashkG, function(j, groupElems)
    local relsxBos, g, pos_g, g_index, pos_j, action, chi_j_g,
          pos_action, leftMon, rightMon;

    relsxBos := [];;
    # Iterate over all elements g in the group structure
    for g in groupElems do
        action    := g * ElementFq( j ); # Compute the action of the group element on the field component of j
        pos_action := Position( QGNAG.Config.gensA, action!.FieldPart );
        pos_j     := Position( QGNAG.Config.gensA, j );
        chi_j_g   := ChiForSemidirectProduct( g ); # Compute the $\chi_{j}(g)$ factor for the semidirect product
        pos_g     := Position( QGNAG.Config.elmsG, g );
        g_index   := QGNAG.Config.groupIndex[pos_g];
        #Print("QGNAG.Config.groupIndex: ", QGNAG.Config.groupIndex[pos_g], "\n" );
        if pos_action <> fail then
            leftMon  := Concatenation( g_index, [ QGNAG.Config.xIndex[pos_j] ] );     # Construct the monomials: g * x_j           
            rightMon := Concatenation( [ QGNAG.Config.xIndex[pos_action] ], g_index ); # Construct the transformed monomials: x_{g * j} * g
            Add(relsxBos, [ [ leftMon, rightMon ], [1, -chi_j_g] ] );    # Add the relation in the form: leftMon - chi_j_g * rightMon = 0
        fi;
    od;
    return relsxBos;
end);

#############################################################################
InstallGlobalFunction( RelationsGivenByNicholsDualSmashkG, function(j, groupElems)
    local relsyBos, g, pos_g, g_index, ginv, pos_j,
          action, chi_j_g, pos_action, leftMon, rightMon;
    
    relsyBos := [];;
    # Iterate over all elements g in the group structure
    for g in groupElems do
        action    := g^-1 * ElementFq( j ); # Compute the dual action using the inverse of the group element
        chi_j_g   := ChiForSemidirectProduct( g );
        pos_action := Position( QGNAG.Config.gensA, action!.FieldPart );
        pos_j     := Position( QGNAG.Config.gensA, j );
        pos_g     := Position( QGNAG.Config.elmsG, g );
        g_index   := QGNAG.Config.groupIndex[pos_g];
        if pos_action <> fail then
            leftMon  := Concatenation( [ QGNAG.Config.yIndex[pos_j] ], g_index );     # Construct the monomials: y_j * g
            rightMon := Concatenation( g_index, [ QGNAG.Config.yIndex[pos_action] ] ); # Construct the transformed monomials: g * y_{g^-1 * j}
            Add(relsyBos, [ [ leftMon, rightMon ], [ 1, -chi_j_g ] ]);   # Add the relation in the form: leftMon - chi_j_g * rightMon = 0
        fi;
    od;
    return relsyBos;
end);

#############################################################################
InstallGlobalFunction( RelationsGivenByNicholsSmashkGDual, function( j, groupElems )
    local relsDx, x_j, h, pos_h, delta_h, g_j, prod, pos_prod, delta_prod, m1, m2;
    
    # Get the index representation of the Nichols generator x_j
    x_j    := QGNAG.Config.xIndex[Position( QGNAG.Config.gensA, j )];
    g_j    := ElementSDP( j, 1 );  # Get the homogeneous degree g_j of the generator x_j 
    relsDx := [];;
    # Iterate over all h in the group
    for h in groupElems do 
        pos_h      := Position( QGNAG.Config.elmsG, h ); # Find the Kronecker delta index for \delta_h
        delta_h    := QGNAG.Config.deltaIndex[pos_h];
        prod       := g_j^(-1) * h;        # Compute the shifted group element g_j^-1 * h
        pos_prod   := Position( QGNAG.Config.elmsG, prod ); # Find the Kronecker delta index for \delta_{g_j^-1 * h}
        delta_prod := QGNAG.Config.deltaIndex[pos_prod];
        m1         := Concatenation( [delta_h], [x_j] );    # Construct the monomials: m1 = \delta_h * x_j    
        m2         := Concatenation( [x_j], [delta_prod] ); # Construct the monomials: m2 = x_j * \delta_{g_j^-1 * h}
        Add( relsDx, [ [ m1, m2 ], [ 1, -1 ] ] );           # Save the relation: m1 - m2 = 0
    od;
    return relsDx;
end);

#############################################################################
InstallGlobalFunction( RelationsGivenByNicholsDualSmashkGDual, function(j, groupElems)
    local relsDy, y_j, h, pos_h, delta_h, g_j, prod, pos_prod, delta_prod, m1, m2;
    
    # Get the index representation of the dual Nichols generator y_j
    y_j    := QGNAG.Config.yIndex[Position(QGNAG.Config.gensA, j)];
    g_j    := ElementSDP(j, 1);; # Get the homogeneous degree g_j associated to the field element j
    relsDy := [];;
    # Iterate over all h in the group structure
    for h in groupElems do 
        pos_h      := Position( QGNAG.Config.elmsG, h ); # Find the Kronecker delta index for \delta_h
        delta_h    := QGNAG.Config.deltaIndex[pos_h];
        prod       := g_j * h; # Compute the shifted group element g_j * h for the dual action
        pos_prod   := Position( QGNAG.Config.elmsG, prod ); # Find the Kronecker delta index for \delta_{g_j * h}
        delta_prod := QGNAG.Config.deltaIndex[pos_prod];
        m1         := Concatenation( [delta_h], [y_j] );    # Construct the monomials: m1 = \delta_h * y_j,    
        m2         := Concatenation( [y_j], [delta_prod] ); # Construct the monomials: m2 = y_j * \delta_{g_j * h}.    
        # Save the relation representing: \delta_h * y_j - y_j * \delta_{g_j * h} = 0
        Add( relsDy, [ [m1, m2], [1, -1] ] );
    od;
    return relsDy;
end);
