gap> LoadPackage( "QGNAG", false );
true
gap> w := Elements(GF(4))[3];;
gap> r:=ElementSDP(w, 5);
( Z(2^2) , 5 )
gap> IsElementSDPObj(r);
true
gap> FieldPart(r);
Z(2^2)
gap> CyclicPart(r);
5
gap> Alias(r);
"( ω , 5 )"
gap> IsDistinguishedElement(r);
false
gap> w2 := Elements(GF(4))[4];;
gap> s:=ElementSDP(w2,1);
( Z(2^2)^2 , 1 )
gap> IsDistinguishedElement(s);
true
gap> rs:=r*s;
( 0*Z(2) , 0 )
gap> FieldPart(rs);
0*Z(2)
gap> CyclicPart(rs);
0
gap> Alias(rs);
"( 0 , 0 )"
gap> IsDistinguishedElement(rs);
false
gap> ChiForSemidirectProduct(r);
-1
gap> ChiForSemidirectProduct(s);
-1
gap> ChiForSemidirectProduct(rs);
1
gap> quit;
