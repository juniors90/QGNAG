#############################################################################
# Definición de representación, categoría y tipo
#############################################################################

DeclareRepresentation("IsElementSDPRep", IsAttributeStoringRep, []);
DeclareCategory("IsElementSDPObj", IsElementSDPRep and IsMultiplicativeElementWithInverse);
TypeElementSDP := NewType(NewFamily("SDPFamily"), IsElementSDPObj);

#############################################################################
# Atributos
#############################################################################

DeclareAttribute("FieldPart", IsElementSDPObj);
DeclareAttribute("CyclicPart", IsElementSDPObj);
DeclareAttribute("Alias", IsElementSDPObj);

#############################################################################
# Propiedades
#############################################################################

DeclareProperty("IsDistinguishedElement", IsElementSDPObj);

#############################################################################
# Operaciones
#############################################################################

#! @Section Example Methods
#!
#! This section will describe the example
#! methods of QGNAG

#! @Description
#!   Insert documentation for your function here
DeclareGlobalFunction( "ChiForSemidirectProduct" );