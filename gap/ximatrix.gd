#############################################################################
##
#! @Chapter Structure Matrices for Actions on Nichols Algebras
#!
#! This chapter provides functions for computing matrix representations
#! of operators acting on Nichols algebras and on modules induced from
#! simple <M>\mathcal{D}(G)</M>-modules.
#!
#! Given the action of an element <M>Xi</M> on an ordered basis of a
#! Nichols algebra, these routines construct the corresponding structure
#! matrix and extend it to the module
#! <M>\mathfrak{B}(V)\otimes S</M>
#! by means of block diagonal matrices.
#!
#! The resulting matrices can be used to study representations,
#! compute module homomorphisms, and perform explicit calculations in
#! finite-dimensional Nichols algebras.
#!
#! @Section Structure Matrices Associated to Nichols Algebra Actions
#!
#! This section provides routines for computing structure matrices of
#! endomorphisms of Nichols algebras.
#!
#! Let <M>\mathfrak{B}(V)</M> be a Nichols algebra with ordered basis
#! <M>\{b_1,\ldots,b_n\}</M>. If an element <M>Xi</M> acts on the basis
#! elements according to
#! <M>Xi\cdot b_j=\sum_i a_{ij} b_i</M>,
#! the associated structure matrix is the matrix
#! <M>(a_{ij})</M>.
#!
#! The functions in this section recover these coefficients from normal
#! form computations and assemble the corresponding matrix. They also
#! provide the extension of this action to modules of the form
#! <M>\mathfrak{B}(V)\otimes S</M>, where <M>S</M> is a simple
#! <M>\mathcal{D}(G)</M>-module, by constructing the appropriate block diagonal
#! matrix.
#!
#! @Arguments XiActionOnBasisNichols, simple, BaseNichols
#!
#! @Returns a matrix over the coefficient field.
#!
#! Computes the matrix describing the action of an element
#! <M>Xi</M> on a Nichols algebra basis and extends this action to the
#! tensor product of the Nichols algebra with a simple <M>\mathcal{D}(G)</M>-module.
#!
#! The first argument <A>XiActionOnBasisNichols</A> is a list encoding the
#! action of <M>Xi</M> on each basis element of the Nichols algebra after
#! reduction to normal form. Each entry is expected to be of the form
#! <Example>
#! [ monomials, coefficients ]
#! </Example>
#! where <C>monomials</C> is a list of basis monomials and
#! <C>coefficients</C> is the corresponding list of coefficients.
#!
#! The argument <A>simple</A> is a simple <M>\mathcal{D}(G)</M>-module. Its basis is
#! accessed through <C>simple.base</C>.
#!
#! The argument <A>BaseNichols</A> is the ordered basis of the Nichols algebra.
#!
#! The function first constructs the structure matrix of the action of
#! <M>Xi</M> on the Nichols algebra basis. It then forms the block diagonal
#! matrix consisting of one copy of this matrix for each basis element of
#! the simple module.
#!
#! The returned matrix represents the action of <M>Xi</M> on
#! <M>\mathfrak{B}(V)\otimes S</M>, where <M>S</M> is the given simple module.
#!
DeclareGlobalFunction( "StructureMatrixForXi" );