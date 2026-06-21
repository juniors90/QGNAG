#############################################################################
##
##  QGNAG.gd
##
#############################################################################

# Declaramos el registro principal del paquete si no existe
if not IsBound( QGNAG ) then
    BindGlobal( "QGNAG", rec() );
fi;

# Creamos el sub-registro de configuración con sus valores por defecto
QGNAG.Config := rec(
    m       := 2,     # Valor por defecto para m
    q       := 3,     # Valor por defecto para q := p^n
    DEFAULT := true,
    verbose := false  # Otro ejemplo de configuración
);

DeclareGlobalFunction( "QGNAGSetModulus" );

DeclareGlobalFunction( "QGNAGSetConfig" );
