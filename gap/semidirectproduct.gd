
#! @Chapter Elements of Semidirect Product
#!
#! @Section Definition of  ElementSDP Object
#!
#! @BeginExampleSession
#! gap> w := Elements(GF(4))[3];;
#! gap> w2 := Elements(GF(4))[4];;
#! gap> r := ElementSDP( w, 5 );
#! ( Z(2^2) , 5 )
#! gap> s := ElementSDP( w2, 1 );
#( Z(2^2)^2 , 1 )
#! gap> IsElementSDPObj(r);
#! true
#! gap> IsElementSDPObj(s);
#! true
#! gap> Print(r);
#! ( ω , 5 )
#! gap> Print(s);
#! ( ω^2 , 1 )
#! gap> rs:=r*s;
#( 0*Z(2) , 0 )
#! gap> Print(rs);
#! ( 0 , 0 )
#! gap> IsElementSDPObj(rs);
#! true
#! @EndExampleSession
#! @EndGroup
#!
DeclareRepresentation("IsElementSDPRep", IsAttributeStoringRep, []);
#!
DeclareCategory("IsElementSDPObj", IsElementSDPRep and IsMultiplicativeElementWithInverse);
#!
TypeElementSDP := NewType(NewFamily("SDPFamily"), IsElementSDPObj);
#! @BeginGroup ElementSDPGroup
#! 
#! @Arguments ElementSDPObj
#!
DeclareAttribute("FieldPart", IsElementSDPObj);
#! 
#! @Arguments ElementSDPObj
#!
DeclareAttribute("CyclicPart", IsElementSDPObj);
#! 
#! @Arguments ElementSDPObj
#!
DeclareAttribute("Alias", IsElementSDPObj);
#! 
DeclareProperty("IsDistinguishedElement", IsElementSDPObj);
#!
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
#! "( ω , 5 )"
#! @EndExampleSession
#! @EndGroup
#! 
DeclareGlobalFunction( "ChiForSemidirectProduct" );
#! 
#! @BeginExampleSession
#! gap> w := Elements( GF(4) )[3];;
#! gap> r := ElementSDP( w, 5 );
#! ( Z(2^2) , 5 )
#! gap> ChiForSemidirectProduct( r );
#! -1
#! @EndExampleSession