#! @Chapter Introducción
#!
#! @Chapter Elements of <M>\mathbb{F}\textsubscript{4}</M>
#!
#! @Section Definition of ElementF4 Object
#! @Arguments ElementF4Obj
DeclareRepresentation("IsElementF4Rep", IsAttributeStoringRep, []);
#! @Arguments ElementF4Obj
DeclareCategory("IsElementF4Obj", IsElementF4Rep and IsMultiplicativeElementWithInverse);
TypeElementF4 := NewType(NewFamily("F4Family"), IsElementF4Obj);
#!
#! @BeginGroup ElementF4Group
#! @Arguments ElementF4Obj
DeclareAttribute("FieldPart", IsElementF4Obj);
#! @Arguments ElementF4Obj
DeclareAttribute("Alias", IsElementF4Obj);
#! @EndGroup 
