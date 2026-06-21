#! @Chapter Utilities
#!
#! @Section Kronecker Product
#!
#! @Description
#! Returns the Kronecker product of two matrices.
#!
#! @Arguments A, B
#!
#! @Returns
#! The matrix <M>A\otimes B</M>.
#!
#! @Description
#! Let
#! <M>
#! A=(a_{ij})\in M_{m\times n}(k),
#! \qquad
#! B=(b_{uv})\in M_{p\times q}(k).
#! </M>
#!
#! In this package we use the convention opposite to the one adopted by
#! GAP's built-in function <C>KroneckerProduct</C>.
#!
#! The tensor product matrix
#! <M>
#! A\otimes B
#! </M>
#! is defined by
#! <M>
#! A\otimes B := \operatorname{KroneckerProduct}(B,A).
#! </M>
#!
#! Equivalently,
#! <M>
#! A\otimes B=
#! \begin{pmatrix}
#! b_{11}A &amp; \cdots &amp; b_{1q}A\\
#! \vdots  &amp; \ddots &amp; \vdots\\
#! b_{p1}A &amp; \cdots &amp; b_{pq}A
#! \end{pmatrix}.
#! </M>
#!
#! Thus the entries satisfy
#! <M>
#! (A\otimes B)_{\,m(u-1)+i,\; n(v-1)+j}
#! =
#! a_{ij}\,b_{uv},
#! </M>
#! where
#! <M>
#! 1\le i\le m,\quad
#! 1\le j\le n,\quad
#! 1\le u\le p,\quad
#! 1\le v\le q.
#! </M>
#!
#! With this convention,
#! <M>
#! \operatorname{vec}(AXB)
#! =
#! (A\otimes B^{T})
#! \operatorname{vec}(X),
#! </M>
#! where <M>\operatorname{vec}</M> denotes column-wise vectorization.
#!
#! Consequently,
#! <M>
#! \texttt{TensorProductMatrix}(A,B)
#! =
#! \texttt{KroneckerProduct}(B,A).
#! </M>
#!
#! @BeginExample
#! gap> A := [ [1,2], [3,4] ];
#! [ [ 1, 2 ], [ 3, 4 ] ]
#! gap> B := [ [0,5], [6,7] ];
#! [ [ 0, 5 ], [ 6, 7 ] ]
#! gap> TensorProductMatrix( A, B );
#! [  [ 0, 0, 5, 10 ],
#!   [ 0, 0, 15, 20 ], 
#!   [ 6, 12, 7, 14 ], 
#!   [ 18, 24, 21, 28 ] ]
#! @EndExample
#! 
DeclareGlobalFunction( "TensorProductMatrix" );
#! @Description
#! Returns the dimensions of a matrix.
#!
#! @Arguments M
#!
#! @Returns
#! A list <C>[m,n]</C> where <C>m</C> is the number of rows of
#! <A>M</A> and <C>n</C> is the number of columns.
#!
#! @Description
#! Let
#! <M>
#! M=(m_{ij})
#! </M>
#! be an
#! <M>
#! m\times n
#! </M>
#! matrix.
#!
#! This function returns the pair
#! <M>
#! (m,n),
#! </M>
#! encoded as the &GAP; list
#! <C>[m,n]</C>.
#!
#! The matrix is assumed to be represented as a list of rows.
#!
#! If <A>M</A> is the empty list, the function returns
#! <C>[0,0]</C>.
#!
#! @BeginExample
#! gap> M := [ [1,2,3], [4,5,6] ];
#! [ [ 1, 2, 3 ], [ 4, 5, 6 ] ]
#! gap> GetDimensions( M );
#! [ 2, 3 ]
#! gap> GetDimensions( IdentityMat(4) );
#! [ 4, 4 ]
#! gap> GetDimensions( [] );
#! [ 0, 0 ]
#! @EndExample
DeclareGlobalFunction( "GetDimensions" );
#! @Description
#! Returns the vectorization of a matrix.
#!
#! @Arguments mat
#!
#! @Returns
#! A list containing the entries of <A>mat</A> stacked column by column.
#!
#! @Description
#! Let
#! <M>
#! A=(a_{ij})\in M_{m\times n}(k).
#! </M>
#!
#! The vectorization of <M>A</M>, denoted by
#! <M>\operatorname{vec}(A)</M>,
#! is the vector obtained by stacking the columns of
#! <M>A</M> from left to right:
#!
#! <M>
#! \operatorname{vec}(A)=
#! (a_{11},\ldots,a_{m1},
#! a_{12},\ldots,a_{m2},
#! \ldots,
#! a_{1n},\ldots,a_{mn}).
#! </M>
#!
#! Equivalently, if
#! <M>
#! A=
#! \begin{pmatrix}
#! a_{11} &amp; \cdots &amp; a_{1n}\\
#! \vdots &amp;        &amp; \vdots\\
#! a_{m1} &amp; \cdots &amp; a_{mn}
#! \end{pmatrix},
#! </M>
#! then
#! <M>
#! \operatorname{vec}(A)
#! =
#! \begin{pmatrix}
#! a_{11}\\
#! \vdots\\
#! a_{m1}\\
#! a_{12}\\
#! \vdots\\
#! a_{mn}
#! \end{pmatrix}.
#! </M>
#!
#! This realizes the standard vector-space isomorphism
#! <M>
#! M_{m\times n}(k)\cong k^{mn}.
#! </M>
#!
#! @BeginExample
#! gap> A := [ [1,2], [3,4] ];
#! [ [ 1, 2 ], [ 3, 4 ] ]
#! gap> VecMat( A );
#! [ 1, 3, 2, 4 ]
#! @EndExample
#! since
#! <M>
#! \begin{pmatrix}
#! 1 &amp; 2\\
#! 3 &amp; 4
#! \end{pmatrix}
#! \mapsto
#! (1,3,2,4).
#! </M>
#!
DeclareGlobalFunction( "VecMat" );
#! The choice of convention is motivated by vectorization formulas.
#! In the standard literature one usually has
#! <M>
#! \operatorname{vec}(AXB)
#! =
#! (B^{T}\otimes A)\operatorname{vec}(X),
#! </M>
#! where <M>\otimes</M> denotes the usual Kronecker product.
#!
#! Since this package defines
#! <M>
#! A\otimes B
#! :=
#! \mathtt{KroneckerProduct}(B,A),
#! </M>
#! the same identity becomes
#! <M>
#! \operatorname{vec}(AXB)
#! =
#! (A\otimes B^{T})\operatorname{vec}(X).
#! </M>
#!
#! Thus the tensor product convention adopted here is chosen so that
#! tensor product matrices appearing in vectorization formulas are written
#! in the natural left-to-right order of the factors.
#!
#! Users familiar with the standard Kronecker product should keep in mind
#! that the symbol <M>\otimes</M> used throughout this package corresponds
#! to the matrix that would be written as
#! <M>
#! B\otimes A
#! </M>
#! in the conventional notation.