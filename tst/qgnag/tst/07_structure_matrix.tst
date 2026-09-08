gap> START_TEST("qgnag: XiMatrixAction (C++ vs pure GAP)");
gap> # Reuse the same XiMatrixOnNichols from the StructureMatrixForXi test.
gap> BaseNichols := [ [[1,1]], [[2,1]], [[3,1]] ];;
gap> XiAction := [ [ [2,3], [2,3] ], [ [], [] ], [ [1], [5] ] ];;
gap> XiMatrix := CppStructureMatrixForXi(XiAction, BaseNichols);;
gap> # A synthetic degree-2 "simple module": any list whose first entry is
gap> # a 2x2 matrix is enough, since only its size (k=2) is used.
gap> simple := [ IdentityMat(2), IdentityMat(2) ];;
gap> gap_result := DirectSumMat( List([1..Length(simple[1])], i -> XiMatrix) );;
gap> cpp_result := CppXiMatrixAction(XiMatrix, simple);;
gap> gap_result = cpp_result;
true
gap> cpp_result;
[ [ 0, 0, 5, 0, 0, 0 ], [ 2, 0, 0, 0, 0, 0 ], [ 3, 0, 0, 0, 0, 0 ], 
  [ 0, 0, 0, 0, 0, 5 ], [ 0, 0, 0, 2, 0, 0 ], [ 0, 0, 0, 3, 0, 0 ] ]
gap> STOP_TEST("structure_matrix.tst");