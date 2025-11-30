#! @Chapter Utilities
#!
#! @Section Kronecker Product
#!
#! @Arguments A, B
#!
#! @Returns matrix
#!
#! @Description
#!
#! Computes the tensor (Kronecker) product of two matrices <A>A</A> and <A>B</A>.
#! The implementation is optimized for speed and has been observed to
#! outperform GAP's <A>KroneckerProduct</A> in tests with moderately large matrices.
#! 
DeclareGlobalFunction( "TensorProductMatrix" );
