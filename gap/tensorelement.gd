#! @Chapter Elements of Tensor Product
#!
#! @Section Definition of Tensor Product
#!
DeclareRepresentation("IsTensorRep", IsAttributeStoringRep, []);
#!
DeclareCategory("IsTensorObj", IsTensorRep and IsAdditiveElement);
#!
TensorType := NewType(NewFamily("TensorFamily"), IsTensorObj);
#!
#! @BeginGroup IsTensorGroup
#! 
#! @Arguments IsTensorObj
#!
DeclareAttribute("GroupElement", IsTensorObj);
#!
#! @Arguments IsTensorObj
#!
DeclareAttribute("VectorSpaceElement", IsTensorObj);
#!
#! @EndGroup