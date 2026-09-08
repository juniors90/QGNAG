gap> START_TEST("qgnag: consistencia paralelo vs. secuencial (dataset sintético)");
gap> # Dataset chico y autocontenido: representación regular de C3 (orden 3)
gap> # consigo misma y contra la trivial, repetido varias veces para forzar
gap> # que el paralelismo realmente reparta trabajo entre varios casos.
gap> g := [[0,0,1],[1,0,0],[0,1,0]];;
gap> trivial := [[1]];;
gap> allT := List([1..8], i -> [g]);;
gap> allS := List([1..8], i -> [g]);;
gap> allS[1] := [trivial];;
gap> par := CppTestDimHomAllComplexParallel(allT, allS);;
gap> seq := List(Cartesian(allT, allS), p -> QGNAG_DimHomAModules(p[1], p[2]));;
gap> # El orden de CppTestDimHomAllComplexParallel es (i,j) con i variando
gap> # más lento -- igual que un doble for anidado T-externo/S-interno, así
gap> # que comparamos contra un armado equivalente en GAP puro:
gap> seq2 := [];;
gap> for t in allT do
>       for s in allS do
>           Add(seq2, QGNAG_DimHomAModules(t, s));
>       od;
>    od;
gap> par = seq2;
true
gap> -1 in par;
false
gap> STOP_TEST("dimhom_complex_parallel.tst");