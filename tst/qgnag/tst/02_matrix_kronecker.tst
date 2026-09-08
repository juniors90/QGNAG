gap> START_TEST("qgnag: matrix and Kronecker product");
gap> # --- Transpuesta ---
gap> CppMatrixTranspose([[1,2,3],[4,5,6]]);
[ [ 1, 4 ], [ 2, 5 ], [ 3, 6 ] ]
gap> # --- Kronecker: verificado a mano contra el ejemplo de Wikipedia,
gap> # usando la convención propia Kronecker(A,B) := B (estándar) otomes A.
gap> A := [[1,2],[3,4]];;
gap> B := [[0,5],[6,7]];;
gap> CppKronecker(A, B);
[ [ 0, 0, 5, 10 ], [ 0, 0, 15, 20 ], [ 6, 12, 7, 14 ], [ 18, 24, 21, 28 ] ]
gap> # --- Kronecker con identidad: caso degenerado, debe devolver bloques
gap> # escalados sin mezcla ---
gap> I2 := IdentityMat(2);;
gap> CppKronecker(A, I2);
[ [ 1, 2, 0, 0 ], [ 3, 4, 0, 0 ], [ 0, 0, 1, 2 ], [ 0, 0, 3, 4 ] ]
gap> STOP_TEST("matrix_kronecker.tst");