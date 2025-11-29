DeclareRepresentation("IsElementSDPRep", IsAttributeStoringRep, []);
DeclareCategory("IsElementSDPObj", IsElementSDPRep and IsMultiplicativeElementWithInverse);
TypeElementSDP := NewType(NewFamily("SDPFamily"), IsElementSDPObj);
DeclareAttribute("FieldPart", IsElementSDPObj);
DeclareAttribute("CyclicPart", IsElementSDPObj);
DeclareAttribute("Alias", IsElementSDPObj);
DeclareProperty("IsDistinguishedElement", IsElementSDPObj);
DeclareGlobalFunction( "ChiForSemidirectProduct" );