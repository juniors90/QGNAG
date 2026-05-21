#! @Chapter Introducción
#!
#! @Chapter Elements of <M>\mathbb{F}\textsubscript{4}</M>
#!
#! This chapter implements objects representing elements of the finite
#! field
#! <M>\mathbb{F}_4</M>.
#!
#! The implementation provides:
#! <List>
#!   <Item>
#!     an object-oriented wrapper around GAP finite field elements;
#!   </Item>
#!   <Item>
#!     printable aliases using the symbols
#!     <M>0</M>, <M>1</M>, <M>\omega</M>, and
#!     <M>\omega^2</M>;
#!   </Item>
#!   <Item>
#!     multiplicative structure and inversion;
#!   </Item>
#!   <Item>
#!     actions induced by semidirect product elements.
#!   </Item>
#! </List>
#!
#! Internally, every object stores the corresponding GAP finite field
#! element through the attribute <C>FieldPart</C>.
#!
#! @Section Definition of <C>ElementF4</C> Objects
#!
#!
#! This section defines the representation, category, type,
#! and attributes associated to objects representing elements of
#! <M>\mathbb{F}_4</M>.
#!
#! @BeginExampleSession
#! gap> zero := ElementF4(0*Z(2));
#! 0*Z(2)
#! gap> one := ElementF4(Z(2)^0);
#! Z(2)^0
#! gap> w := ElementF4(Z(2^2));
#! Z(2^2)
#! gap> w2 := ElementF4(Z(2^2)^2);
#! Z(2^2)^2
#! gap> Print(zero);
#! 0
#! gap> Print(one);
#! 1
#! gap> Print(w);
#! omega
#! gap> Print(w2);
#! omega^2
#! gap> w * w2;
#! 1
#! gap> w^-1;
#! omega^2
#! gap> IsElementF4Obj(w);
#! true
#! @EndExampleSession
#!
#! @Description
#! Internal representation for objects corresponding to elements of
#! <M>\mathbb{F}_4</M>.
#!
#! The implementation uses GAP's
#! <C>IsAttributeStoringRep</C>
#! representation mechanism.
#!
#! The field element and its printable alias are stored as attributes.
#!
#! @Arguments ElementF4Obj
DeclareRepresentation("IsElementF4Rep", IsAttributeStoringRep, []);
#! @Description
#!
#! Category of objects representing elements of
#! <M>\mathbb{F}_4</M>.
#!
#! Objects in this category:
#! <List>
#!   <Item>
#!     belong to the representation
#!     <C>IsElementF4Rep</C>;
#!   </Item>
#!   <Item>
#!     are multiplicative elements with inverses.
#!   </Item>
#! </List>
#!
#! @Arguments ElementF4Obj
DeclareCategory("IsElementF4Obj", IsElementF4Rep and IsMultiplicativeElementWithInverse);
#! @Description
#! GAP type associated to objects representing elements of
#! <M>\mathbb{F}_4</M>.
#!
#! Every object created by the constructor
#! <C>ElementF4</C>
#! belongs to this type.
#!
TypeElementF4 := NewType(NewFamily("F4Family"), IsElementF4Obj);
#!
# @BeginGroup ElementF4Group
# @Arguments ElementF4Obj
#! @BeginGroup ElementF4Group
#!
#! This group collects the basic attributes associated to objects
#! representing elements of
#! <M>\mathbb{F}_4</M>.
#!
#! @Arguments IsElementF4Obj
#!
#! @Description
#! Returns the underlying GAP finite field element associated to an
#! object of type <C>IsElementF4Obj</C>.
#!
#! If
#! <M>x \in \mathbb{F}_4</M>,
#! then:
#! <P/>
#! <C>FieldPart(x)</C>
#! returns the corresponding GAP object in
#! <C>GF(4)</C>.
#!
#! @BeginExample
#! gap> w := ElementF4(Z(2^2));
#! Z(2^2)
#! gap> FieldPart(w);
#! Z(2^2)
#! @EndExample
DeclareAttribute( "FieldPart", IsElementF4Obj );
#! @Arguments IsElementF4Obj
#!
#! @Description
#! Returns the printable alias associated to an element of
#! <M>\mathbb{F}_4</M>.
#!
#! The aliases are:
#! <List>
#!   <Item>
#!     <C>"0"</C>;
#!   </Item>
#!   <Item>
#!     <C>"1"</C>;
#!   </Item>
#!   <Item>
#!     <C>"ω"</C>;
#!   </Item>
#!   <Item>
#!     <C>"ω^2"</C>.
#!   </Item>
#! </List>
#!
#! These aliases are intended for readable output and formatted printing.
#!
#! @BeginExample
#! gap> w := ElementF4(Z(2^2));
#! Z(2^2)
#! gap> Alias(w);
#! "omega"
#! gap> Print(w);
#! omega
#! @EndExample
DeclareAttribute( "Alias", IsElementF4Obj );
#! @EndGroup
#!
#! @Section Algebraic Operations on <M>\mathbb{F}_4</M>
#!
#! Objects of type <C>IsElementF4Obj</C> support:
#! <List>
#!   <Item>
#!     multiplication;
#!   </Item>
#!   <Item>
#!     inversion;
#!   </Item>
#!   <Item>
#!     equality testing;
#!   </Item>
#!   <Item>
#!     identity element computation.
#!   </Item>
#! </List>
#!
#! These operations are implemented through GAP methods.
#!
#! @BeginExampleSession
#! gap> w := ElementF4(Z(2^2));
#! Z(2^2)
#! gap> w2 := ElementF4(Z(2^2)^2);
#! Z(2^2)^2
#! gap> w * w;
#! omega^2
#! gap> w * w2;
#! 1
#! gap> w^-1;
#! omega^2
#! gap> One(w);
#! 1
#! gap> w = w2;
#! false
#! @EndExampleSession
#!
