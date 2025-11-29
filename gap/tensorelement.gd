DeclareRepresentation("IsTensorRep", IsAttributeStoringRep, []);

DeclareCategory("IsTensorObj", IsTensorRep and IsAdditiveElement);


TensorType := NewType(NewFamily("TensorFamily"), IsTensorObj);

DeclareAttribute("GroupElement", IsTensorObj);

DeclareAttribute("VectorSpaceElement", IsTensorObj);
