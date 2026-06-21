
InstallGlobalFunction( TensorBasisForSimples, function(G, g, rho, allPairsInG )
    local rec_rho, Vbase, cosets, Gbase, SDPBase, TensorBase, idxs, Gamma_g;
    rec_rho    := REPN_ComputeUsingSerre(rho); # Computamos la representación usando Serre
    Vbase      := rec_rho.basis;               # Base de la representación irreducible
    Gamma_g    := Centralizer(G, g);           # Lista de cosets derechos de Gamma_g en G
    cosets     := RightCosets(G, Gamma_g);
    Gbase      := List( cosets, c -> Representative( c ) ); # Tomamos un representante de cada coset
    idxs       := List( Gbase, x -> Position( allPairsInG, x ) );
    SDPBase    := List( idxs, x -> QGNAG.Config.elmsG[x] );
    TensorBase := List( Cartesian( SDPBase, Vbase ), x -> TensorElement( x[1], x[2] )); # Armamos la base del tensor kG ⊗ V como pares formales
    return TensorBase;
end);


InstallGlobalFunction( GetCentralizers, function( G )
    local c, conjClasses, rep, size, ratio, centralizer, centralizers;
    
    centralizers := [];
    conjClasses  := ConjugacyClasses(G);
    
    for c in conjClasses do
        rep         := Representative(c);
        size        := Size(c);
        centralizer := Centralizer(G, rep);
        # Verificación de la fórmula |clase| = |G| / |centralizador|
        ratio       := Size(G) / Size(centralizer);
        if ratio = size then
            Add(centralizers, rec(centralizer:=centralizer, rep:=rep));;
        else
            Print("¡Error en la verificación!\n");
        fi;
    od;
    return centralizers;
end);


InstallGlobalFunction( GetCentralizerOfElement, function(G, g )
    local centralizer, sizeG, sizeC, classSize, check, idx, repElementSDP;

    if not (g in List(ConjugacyClasses(G), Representative)) then
        Error("⚠️ The element g is not a representative of the conjugation class of G.\n");
    fi;
    centralizer := Centralizer(G, g);
    # (opcional) verificamos la fórmula |clase| = |G| / |centralizador|
    sizeG         := Size(G);
    sizeC         := Size(centralizer);
    classSize     := sizeG / sizeC;
    #idx           := Position(allPairsInG, g);
    #repElementSDP := QGNAG.Config.elmsG[idx];
    
    # (opcional) chequeo de consistencia con la clase de conjugación real
    check         := Size(ConjugacyClass(G, g));
    if check <> classSize then
        Error("⚠️ Error: la verificación no coincide.\n");
    fi;
    
    # Devolvemos un registro con la info
    return rec(
        rep             := g,
        centralizer     := centralizer,
        classSize       := classSize,
        centralizerSize := sizeC,
        structure       := StructureDescription( centralizer ),
        #repElementSDP   := repElementSDP
    );
    return 0;
end);


InstallGlobalFunction( GetSimplesMod, function( G, allPairsInG)
    local base, c, i, irrepsGamma_g, simples, rho, chi, M_g_rho, centralizers;

    simples      := [];;
    centralizers := GetCentralizers( G );

    for c in centralizers do
        irrepsGamma_g := Irr( c.centralizer );
        for i in [ 1 .. Length( irrepsGamma_g ) ] do
            chi     := irrepsGamma_g[ i ];;
            rho     := IrreducibleAffordingRepresentation( chi );;
            M_g_rho := InducedSubgroupRepresentation( G, rho );;
            base    := TensorBasisForSimples( G, c.rep, rho, allPairsInG );;
            Add( simples, rec(
                    simple := M_g_rho,
                    weight := rec( g := c.rep, rho := rho ),
                    base   := base
                )
            );
        od;
    od;
    return simples;
end);


InstallGlobalFunction( GetSimplesModAttachedToElement, function(G, g, allPairsInG )
    local base, c, i, irrepsGamma_g, simples, rho, chi, M_g_rho, g_idx;
    simples       := [];;
    irrepsGamma_g := Irr(  Centralizer(G, g) );
    for i in [ 1 .. Length( irrepsGamma_g ) ] do
        chi       := irrepsGamma_g[ i ];;
        rho       := IrreducibleAffordingRepresentation( chi );;
        M_g_rho   := InducedSubgroupRepresentation( G, rho );;
        base      := TensorBasisForSimples( G, g, rho, allPairsInG );;
        g_idx     := Position( allPairsInG, g );
        Add( simples, rec(
            simple            := M_g_rho,
            weight            := rec( g := g, rho := rho ),
            weightSDP         := rec( g := QGNAG.Config.elmsG[ g_idx ], rho := rho ),
            base              := base,
            generatorsofgroup := GeneratorsOfGroup(Source(M_g_rho)),
            genimages         := GeneratorsOfGroup(Image(M_g_rho)),
            G                 := StructureDescription(Source(M_g_rho)),
            group             := Source(M_g_rho),
            Gamma_g           := StructureDescription(Source(rho))
        ) );
    od;
    return simples;
end );
