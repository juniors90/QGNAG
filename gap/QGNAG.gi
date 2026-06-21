#############################################################################
##
#W  QGNAG.gi
##
#############################################################################

# --------------------------------------------------------------------------
#   Main package record
# --------------------------------------------------------------------------

# --------------------------------------------------------------------------
#   Configuration record
# --------------------------------------------------------------------------


BindGlobal( "QGNAG_MiFuncion", function()
    # Tu función lee el valor actual que configuró el usuario
    Print( "El valor actual de m es: ", QGNAG.Config.m, "\n" );
    
    # Aquí va el resto de la lógica de tu paquete...
    return QGNAG.Config.m ^ 2;
end );

InstallGlobalFunction( QGNAGSetModulus, function( q, m )
    if not IsPosInt( m ) then
        Error("m must be a positive integer");
    fi;
    QGNAG.Config.m            := m;                   # Valor para m
    QGNAG.Config.q            := q;                   # Valor para q := p^n
    QGNAG.Config.CyclicRing   := ZmodnZ(m);
    QGNAG.Config.CyclicFamily := ElementsFamily( FamilyObj( ZmodnZ( m ) ) );
    return;
end);

InstallGlobalFunction( QGNAGSetConfig, function( config )
    if not IsPosInt( config.m ) then
        Error("m must be a positive integer");
    fi;

    if not IsPosInt( config.q ) then
        Error("q must be a positive integer");
    fi;

    QGNAGSetModulus( config.q, config.m );
    QGNAG.Config.xIndex       := config.xIndex;
    QGNAG.Config.groupIndex   := config.groupIndex;
    QGNAG.Config.deltaIndex   := config.deltaIndex;
    QGNAG.Config.yIndex       := config.yIndex;
    QGNAG.Config.nX           := config.nX;;
    QGNAG.Config.nGensOfG     := config.nGensOfG;;
    QGNAG.Config.nDelta       := config.nDelta;;
    QGNAG.Config.nY           := config.nY;;
    QGNAG.Config.gensA        := Elements(GF(config.q));;
    QGNAG.Config.elmsG        := GetElementsOfG();;
    QGNAG.Config.DEFAULT      := config.DEFAULT;;
    QGNAG.Config.TEST         := config.TEST;;
    QGNAG.Config.PROD         := config.PROD;;
    QGNAG.Config.DEV          := config.DEV;;
    return;
end);
