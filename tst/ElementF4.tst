gap> LoadPackage( "QGNAG", false );
true
gap> w := Elements(GF(4))[3];;
gap> r:=ElementF4(w);
Z(2^2)
gap> FieldPart(r);
Z(2^2)
gap> Alias(r);
"ω"
gap> w2 := Elements(GF(4))[4];;
gap> s:=ElementF4(w2);
Z(2^2)^2
gap> rs:=r*s;
Z(2)^0
gap> FieldPart(rs);
Z(2)^0
gap> Alias(rs);
"1"