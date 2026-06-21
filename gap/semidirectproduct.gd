#! @Chapter Elements of Semidirect Product
#!
#! This chapter defines the elements of the semidirect product
#! <M>\mathbb{F}_{p^2} \rtimes C_m</M>
#! used throughout the package.
#!
#! Elements are represented as pairs
#! <M>(a,i)</M>,
#! where:
#! <List>
#!   <Item>
#!     <M>a \in \mathbb{F}_{p^2}</M>;
#!   </Item>
#!   <Item>
#!     <M>i \in C_m</M>.
#!   </Item>
#! </List>
#!
#! The multiplication is determined by the semidirect product action
#! implemented in the corresponding <C>.gi</C> file.
#!
#! @Section Definition of ElementSDP Objects
#!
#! This section introduces the representation, category, and attributes
#! associated to semidirect product elements.
#!
#! Elements are internally implemented using &GAP; attribute-storing
#! representations.
#!
#! @BeginExampleSession
#! gap> w := Elements(GF(4))[3];;
#! gap> w2 := Elements(GF(4))[4];;
#! gap> r := ElementSDP(w, 5);
#! ( Z(2^2) , 5 )
#! gap> s := ElementSDP(w2, 1);
#! ( Z(2^2)^2 , 1 )
#! gap> IsElementSDPObj(r);
#! true
#! gap> IsElementSDPObj(s);
#! true
#! gap> Print(r);
#! ( omega , 5 )
#! gap> Print(s);
#! ( omega^2 , 1 )
#! gap> rs := r * s;
#! ( 0*Z(2) , 0 )
#! gap> Print(rs);
#! ( 0 , 0 )
#! gap> IsElementSDPObj(rs);
#! true
#! @EndExampleSession
#!
#! @Description
#! Internal representation for semidirect product elements.
#!
#! This representation is based on
#! <C>IsAttributeStoringRep</C>,
#! allowing the field component, cyclic component, and alias
#! to be stored as attributes.
#!
DeclareRepresentation( "IsElementSDPRep", IsAttributeStoringRep, [] );
#! @Description
#! Category of semidirect product elements.
#!
#! Objects in this category:
#! <List>
#!   <Item>
#!     belong to the representation
#!     <C>IsElementSDPRep</C>;
#!   </Item>
#!   <Item>
#!     are multiplicative elements with inverses.
#!   </Item>
#! </List>
#!
DeclareCategory( "IsElementSDPObj", IsElementSDPRep and IsMultiplicativeElementWithInverse );
#! @Description
#! &GAP; type associated to semidirect product elements.
#!
#! Objects created by the constructor
#! <C>ElementSDP</C>
#! belong to this type.
#!
TypeElementSDP := NewType( NewFamily("SDPFamily"), IsElementSDPObj );
#! @BeginGroup ElementSDPGroup
#!
#! This group collects the fundamental attributes associated to
#! elements of the semidirect product.
#!
#! @Arguments IsElementSDPObj
#!
#! @Description
#! Returns the field component of a semidirect product element.
#!
#! If
#! <M>x = (a,i)</M>,
#! then
#! <C>FieldPart(x)</C>
#! returns <M>a</M>.
#!
DeclareAttribute( "FieldPart", IsElementSDPObj );
#! @Arguments IsElementSDPObj
#!
#! @Description
#! Returns the cyclic component of a semidirect product element.
#!
#! If
#! <M>x = (a,i)</M>,
#! then
#! <C>CyclicPart(x)</C>
#! returns <M>i</M>.
#!
DeclareAttribute( "CyclicPart", IsElementSDPObj );
#! @Arguments IsElementSDPObj
#!
#! @Description
#! Returns the printable alias associated to a semidirect product
#! element.
#!
#! The alias is intended for readable output and printing.
#!
#! Example:
#! <P/>
#! <C>"( omega , 5 )"</C>.
#!
DeclareAttribute( "Alias", IsElementSDPObj );
#! @Arguments IsElementSDPObj
#!
#! @Description
#! Property detecting distinguished elements in the semidirect product.
#!
#! In the current implementation, an element
#! <M>(a,i)</M>
#! is distinguished if and only if
#! <M>i = 1</M>.
#!
DeclareProperty( "IsDistinguishedElement", IsElementSDPObj );
#! @BeginExampleSession
#! gap> FieldPart(rs);
#! 0*Z(2)
#! gap> CyclicPart(rs);
#! 0
#! gap> Alias(rs);
#! "( 0 , 0 )"
#! gap> FieldPart(r);
#! Z(2^2)
#! gap> CyclicPart(r);
#! 5
#! gap> Alias(r);
#! "( omega , 5 )"
#! @EndExampleSession
#!
#! @EndGroup
#! @Section Character Associated to the Semidirect Product
#!
#! @Description
#! Character associated to semidirect product elements.
#!
#! For an element
#! <M>(a,i)</M>,
#! the function
#! <C>ChiForSemidirectProduct</C>
#! returns
#! <M>(-1)^i</M>.
#!
DeclareGlobalFunction( "ChiForSemidirectProduct" );
#! @BeginExampleSession
#! gap> w := Elements(GF(4))[3];;
#! gap> r := ElementSDP(w, 5);
#! ( Z(2^2) , 5 )
#! gap> ChiForSemidirectProduct(r);
#! -1
#! @EndExampleSession
DeclareGlobalFunction( "AddModM" );