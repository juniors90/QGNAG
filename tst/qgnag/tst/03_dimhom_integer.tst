gap> START_TEST("qgnag: DimHomAModules (enteros, exacto)");
gap> # --- Caso 1: End_Gamma(V) para C2 actuando con autovalores +-1 en R^2.
gap> # Autovalores distintos => centralizador de dimensión 2 (span{I, A}).
gap> A := [[0,1],[1,0]];;
gap> CppDimHomAModules([A], [A]);
2
gap> # --- Caso 2: Hom entre trivial y signo de C2 (representaciones NO
gap> # isomorfas de grado 1) => 0, por Schur.
gap> N := [[1]];;
gap> M := [[-1]];;
gap> CppDimHomAModules([N], [M]);
0
gap> # --- Caso 3: End_Gamma(regular rep de C3) = |C3| = 3 (fórmula general,
gap> # válida para cualquier grupo finito y cualquier cuerpo).
gap> g := [[0,0,1],[1,0,0],[0,1,0]];;
gap> CppDimHomAModules([g], [g]);
3
gap> # --- Caso 3b: multiplicidad de la componente trivial dentro de la
gap> # regular de C3 => autoespacio de autovalor 1 de una permutación
gap> # cíclica 3x3, dimensión 1.
gap> trivial := [[1]];;
gap> CppDimHomAModules([g], [trivial]);
1
gap> # --- Caso 4: representación trivial (ambos generadores = identidad)
gap> # en dimensiones distintas => Hom = m*n sin restricción.
gap> I3 := IdentityMat(3);;
gap> I2 := IdentityMat(2);;
gap> CppDimHomAModules([I3, I3], [I2, I2]);
6
gap> STOP_TEST("dimhom_integer.tst");