DeclareRepresentation("IsElementF4Rep", IsAttributeStoringRep, []);
DeclareCategory("IsElementF4Obj", IsElementF4Rep and IsMultiplicativeElementWithInverse);
TypeElementF4 := NewType(NewFamily("F4Family"), IsElementF4Obj);

DeclareAttribute("FieldPart", IsElementF4Obj);
DeclareAttribute("Alias", IsElementF4Obj);
