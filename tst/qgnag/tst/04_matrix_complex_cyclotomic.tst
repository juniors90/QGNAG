gap> START_TEST("qgnag: matrices complejas y ciclotómicos");
gap> # --- Round-trip sobre enteros puros (sin parte compleja) ---
gap> CppDimHomAModulesComplex([[[1]]], [[[1]]]) = CppDimHomAModules([[[1]]], [[[1]]]);
true
gap> # --- Un generador con entradas ciclotómicas: rotación de orden 3
gap> # actuando sobre sí misma como escalar 1x1. End_Gamma(V) para una
gap> # representación irreducible de grado 1 sobre C es siempre 1
gap> # (Schur: Hom_Gamma(V,V) = C para V irreducible).
gap> w := E(3);;
gap> CppDimHomAModulesComplex([[[w]]], [[[w]]]);
1
gap> # --- Dos representaciones NO isomorfas de grado 1 con ciclotómicos
gap> # distintos (E(3) vs E(3)^2, ambas irreducibles y no equivalentes
gap> # sobre C ya que son escalares distintos) => Hom = 0.
gap> w2 := E(3)^2;;
gap> CppDimHomAModulesComplex([[[w]]], [[[w2]]]);
0
gap> STOP_TEST("matrix_complex_cyclotomic.tst");