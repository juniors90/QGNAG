gap> START_TEST("qgnag: StructureMatrixForXi (C++ vs GAP puro)");
gap> # Caso sintético: 3 monomios básicos (identificados con enteros 1,2,3
gap> # por simplicidad -- la función es agnóstica al tipo real de "monomio").
gap> BaseNichols := [ [[1,1]], [[2,1]], [[3,1]] ];;
gap> # x_i actúa como:
gap> #   x_i . b1 = 2*b2 + 3*b3
gap> #   x_i . b2 = 0
gap> #   x_i . b3 = 5*b1
gap> XiAction := [ [ [2,3], [2,3] ], [ [], [] ], [ [1], [5] ] ];;
gap> M_gap := StructureMatrixForXi(XiAction, BaseNichols);;
gap> M_cpp := CppStructureMatrixForXi(XiAction, BaseNichols);;
gap> M_gap = M_cpp;
true
gap> M_cpp;
[ [ 0, 0, 5 ], [ 2, 0, 0 ], [ 3, 0, 0 ] ]
gap> STOP_TEST("structure_matrix.tst");