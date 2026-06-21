#############################################################################
##
#W  structurematrices.gd
##
#############################################################################

#! @Chapter Structure Matrices for Group Actions on Nichols Algebras
#!
#! This chapter provides routines for constructing matrix
#! representations of group actions on Nichols algebras.
#!
#! Given an ordered basis of a Nichols algebra and the action of a group
#! element by conjugation on its basis elements, the functions in this
#! chapter compute the corresponding structure matrices.
#!
#! These matrices describe the linear action induced by conjugation and
#! can be used in the construction of representations, module actions,
#! and explicit computations involving Nichols algebras and Drinfeld
#! doubles.
#!
#! @Section Structure Matrices Associated with Conjugation Actions
#!
#! This section contains functions for constructing structure matrices
#! from the action of group elements on a Nichols algebra basis.
#!
#! Let
#! <M>\mathcal{B}(V)=\langle b_1,\ldots,b_n\rangle</M>
#! be a Nichols algebra with a fixed ordered basis. Suppose that an
#! element <M>g</M> acts on the basis elements by conjugation and that
#! each image is expressed in normal form as
#! <M>
#! g b_j g^{-1}
#! =
#! \sum_i a_{ij} b_i.
#! </M>
#!
#! The functions in this section recover the coefficients
#! <M>a_{ij}</M>
#! and assemble the corresponding structure matrix
#! <M>(a_{ij})</M>.
#!
#! The resulting matrix represents the action of the chosen group
#! element on the Nichols algebra basis.
#!
#! @Arguments Conjugation, BaseNichols
#!
#! @Returns A square matrix over the coefficient field whose columns are
#! the coordinate vectors of the conjugated basis elements.
#! Computes the structure matrix associated with the action of a group
#! element on a Nichols algebra basis.
#!
#! @Description
#! The first argument <A>Conjugation</A> is a list describing the images
#! of the basis elements under conjugation by a fixed group element.
#! Each entry is expected to be the normal form decomposition of the
#! image of a basis element and should have the form
#! <Example>
#! [ monomials, coefficients ]
#! </Example>
#! where <C>monomials</C> is a list of basis monomials and
#! <C>coefficients</C> contains the corresponding coefficients.
#!
#! The second argument <A>BaseNichols</A> is the ordered basis of the
#! Nichols algebra.
#!
#! If
#! <M>
#! g b_j g^{-1}
#! =
#! \sum_i a_{ij} b_i,
#! </M>
#! then the returned matrix is the matrix
#! <M>(a_{ij})</M>.
#!
#! Thus, the <C>j</C>-th column of the matrix contains the coordinates
#! of the conjugated basis element
#! <M>g b_j g^{-1}</M>
#! with respect to the chosen Nichols algebra basis.
#!
#! Typical inputs are obtained from computations such as
#!
#! @BeginExample
#! gap> gensG     := GP2NPList([ F1, F2 ]);
#! gap> inv_gensG := GP2NPList([ F1, F2^2 ]);
#! gap> F1ConjugationOnNicholsBasis :=
#! >    List(
#! >        BaseNichols,
#! >       bi -> StrongNormalFormNP(
#! >           MulNP(
#! >                MulNP(gensG[1], bi),
#! >                inv_gensG[1]
#! >            ),
#! >            J_D_ge_0
#! >        )
#! >    );
#! gap> M := StructureMatrixOfG(
#! >          F1ConjugationOnNicholsBasis,
#! >          BaseNichols
#! >      );
#! @EndExample
#!
DeclareGlobalFunction( "StructureMatrixOfG" );