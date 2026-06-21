#! @Chapter Elements of Tensor Product
#!
#! This chapter introduces the implementation of tensor product elements
#! used throughout the package.
#!
#! Tensor elements are formal expressions of the form
#! <M>g \otimes v</M>,
#! where:
#! <List>
#!   <Item>
#!     <M>g</M> belongs to a group or algebraic structure;
#!   </Item>
#!   <Item>
#!     <M>v</M> belongs to a vector space, module, or representation.
#!   </Item>
#! </List>
#!
#! The implementation is based on &GAP; object representations and
#! attribute-storing representations.
#!
#! @Section Definition of Tensor Product
#!
#! This section defines the representation, category, and basic
#! attributes associated to tensor product elements.
#!
#! @Description
#!
#! Internal representation for tensor elements.
#!
#! The representation uses GAP's
#! <C>IsAttributeStoringRep</C> mechanism in order to store the
#! corresponding tensor components as attributes.
#!
DeclareRepresentation( "IsTensorRep", IsAttributeStoringRep, [] );
#! @Description
#! Category of tensor product elements.
#!
#! Objects in this category:
#! <List>
#!   <Item>
#!     belong to the representation <C>IsTensorRep</C>;
#!   </Item>
#!   <Item>
#!     are additive elements.
#!   </Item>
#! </List>
#!
DeclareCategory( "IsTensorObj", IsTensorRep and IsAdditiveElement );
#! @Description
#! Object type associated to tensor product elements.
#!
#! All tensor elements created by the constructor
#! <C>TensorElement</C>
#! belong to this type.
#!
TensorType := NewType( NewFamily("TensorFamily"), IsTensorObj );
#! @BeginGroup IsTensorGroup
#!
#! This group collects the fundamental attributes associated to
#! tensor product elements.
#!
#! @Arguments IsTensorObj
#!
#! @Description
#! Returns the group component of a tensor element.
#!
#! If
#! <M>t = g \otimes v</M>,
#! then
#! <C>GroupElement(t)</C>
#! returns <M>g</M>.
#!
DeclareAttribute( "GroupElement", IsTensorObj );
#! @Arguments IsTensorObj
#!
#! @Description
#! Returns the vector-space component of a tensor element.
#!
#! If
#! <M>t = g \otimes v</M>,
#! then
#! <C>VectorSpaceElement(t)</C>
#! returns <M>v</M>.
#!
DeclareAttribute(
    "VectorSpaceElement",
    IsTensorObj
);
#! @EndGroup