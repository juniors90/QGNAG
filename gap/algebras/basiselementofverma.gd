#! @Chapter Basis Element Of Verma Module
#!
#! @Section Definition of Basis Element Of Verma Module
#!
DeclareRepresentation("IsBasisElementOfVermaModuleRep", IsAttributeStoringRep, []);
#!
DeclareCategory("IsBasisElementOfVermaModuleObj", IsBasisElementOfVermaModuleRep and IsAdditiveElement);
#!
BasisElementOfVermaModuleType := NewType(NewFamily("BasisElementOfVermaModuleFamily"), IsBasisElementOfVermaModuleObj);
#!
#! @BeginGroup IsBasisElementOfVermaModuleGroup
#! 
#! @Arguments IsBasisElementOfVermaModuleObj
#!
DeclareAttribute("NicholsAlgebraElement", IsBasisElementOfVermaModuleObj);
#! 
#! @Arguments IsBasisElementOfVermaModuleObj
#!
DeclareAttribute("GroupElement", IsBasisElementOfVermaModuleObj);
#!
#! @Arguments IsBasisElementOfVermaModuleObj
#!
DeclareAttribute("VectorSpaceElement", IsBasisElementOfVermaModuleObj);
#!
#! @EndGroup