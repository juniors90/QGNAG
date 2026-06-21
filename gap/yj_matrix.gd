
#! @Chapter Decomposition of Monomials by Index Range
#!
#! This chapter provides auxiliary functions for decomposing monomials
#! according to the size of their generator indices.
#!
#! Given a monomial encoded as a pair
#! <M>[ [w], [c] ]</M>,
#! where:
#! <List>
#!   <Item>
#!     <M>w</M> is a word in generator indices;
#!   </Item>
#!   <Item>
#!     <M>c</M> is its coefficient;
#!   </Item>
#! </List>
#! the functions in this chapter extract:
#! <List>
#!   <Item>
#!     the part involving indices in
#!     <M>\{1,\dots,n_X\}</M>;
#!   </Item>
#!   <Item>
#!     the part involving indices strictly larger than
#!     <M>n_X</M>.
#!   </Item>
#! </List>
#!
#! @Section Extraction of Small Indices
#!
#! @Arguments mono, nX
#! @Returns A monomial containing only indices in <M>\{1,\dots,n_X\}</M>.
#!
#! @Description
#! Extracts the subword consisting only of indices belonging to
#! <M>\{1,\dots,n_X\}</M>.
#!
#! The order of the indices is preserved.
#!
#! The input monomial must have the form
#! <M>[ [w], [c] ]</M>,
#! where:
#! <List>
#!   <Item>
#!     <M>w</M> is a list of generator indices;
#!   </Item>
#!   <Item>
#!     <M>c</M> is the associated coefficient.
#!   </Item>
#! </List>
#!
#! The output has coefficient
#! <M>1</M>,
#! independently of the original coefficient.
#!
#! Explicitly, if
#! <M>w=(i_1,\dots,i_r)</M>,
#! the function returns the ordered subword formed by all indices
#! satisfying
#! <M>i_k \le n_X</M>.
#!
#! @BeginExampleSession
#! gap> mono := [ [ [1,7,2,9,4] ], [ -3 ] ];
#! gap> MonomialForSmallIndex(mono, 4);
#! [ [ [ 1, 2, 4 ] ], [ 1 ] ]
#! @EndExampleSession
#!
DeclareGlobalFunction( "MonomialForSmallIndex" );
#! @Section Extraction of Large Indices
#!
#! @Arguments mono, nX
#! @Returns A monomial containing only indices strictly larger than <A>nX</A>.
#!
#! @Description
#! Extracts the subword consisting only of indices strictly larger than
#! <A>nX</A>.
#!
#! The order of the indices is preserved.
#!
#! The input monomial must have the form
#! <M>[ [w], [c] ]</M>,
#! where:
#! <List>
#!   <Item>
#!     <M>w</M> is a list of generator indices;
#!   </Item>
#!   <Item>
#!     <M>c</M> is the associated coefficient.
#!   </Item>
#! </List>
#!
#! The output preserves the original coefficient.
#!
#! Explicitly, if
#! <M>w=(i_1,\dots,i_r)</M>,
#! the function returns the ordered subword formed by all indices
#! satisfying
#! <M>i_k > n_X</M>.
#!
#! @BeginExampleSession
#! gap> mono := [ [ [1,7,2,9,4] ], [ -3 ] ];
#! gap> MonomialForLargeIndex(mono, 4);
#! [ [ [ 7, 9 ] ], [ -3 ] ]
#! @EndExampleSession
#!
DeclareGlobalFunction( "MonomialForLargeIndex" );
#!
#! @Chapter Actions of <M>\Bbbk^G</M> on Yetter-Drinfeld Modules
#!
#! This chapter contains functions for computing the action of elements
#! of the dual group algebra
#! <M>\Bbbk^G</M>
#! on Yetter-Drinfeld modules and for constructing the corresponding
#! structure matrices.
#!
#! The action is determined through conjugation inside the semidirect
#! product group.
#!
#! @Section Action of Delta Functions
#!
#! @Arguments delta_h, simple, elmofB
#! @Returns Either the basis element <A>elmofB</A> or <K>0</K>.
#!
#! @Description
#! Computes the action of a delta function
#! <M>\delta_h \in kG^\ast</M>
#! on a basis element of a Yetter--Drinfeld module.
#!
#! The input:
#! <List>
#!   <Item>
#!     <A>delta_h</A> is a characteristic function on the group;
#!   </Item>
#!   <Item>
#!     <A>simple</A> is a simple Yetter--Drinfeld module;
#!   </Item>
#!   <Item>
#!     <A>elmofB</A> is a basis element of the module.
#!   </Item>
#! </List>
#!
#! Let:
#! <List>
#!   <Item>
#!     <M>x</M> be the group component of <A>elmofB</A>;
#!   </Item>
#!   <Item>
#!     <M>g</M> be the distinguished group element associated to the
#!     weight of the module.
#!   </Item>
#! </List>
#!
#! The function computes the conjugate
#! <M>xgx^{-1}</M>.
#!
#! If
#! <M>\delta_h(xgx^{-1}) \neq 0</M>,
#! then the basis element is fixed and returned.
#! Otherwise, the action is zero.
#!
#! Therefore, the action implemented here is the diagonal action
#! induced by evaluation of delta functions on conjugacy data.
#!
#! @BeginExampleSession
#! gap> ActionkGdualOnYDModule(delta_h, simple, b);
#! (x) \otimes v
#! @EndExampleSession
#!
DeclareGlobalFunction( "ActionkGdualOnYDModule" );
#!
#! @Section Structure Matrices of Simple Modules
#!
#! @Arguments delta_h, simple
#! @Returns A record containing the weight and the structure matrix of the action.
#!
#! @Description
#! Computes the matrix describing the action of
#! <M>\delta_h \in kG^\ast</M>
#! on a simple Yetter--Drinfeld module.
#!
#! The basis of the module is given by
#! <C>simple.base</C>.
#!
#! For each basis element
#! <M>b_i</M>,
#! the function computes:
#!
#! <List>
#!   <Item>
#!     the action of
#!     <M>\delta_h</M>
#!     using
#!     <C>ActionkGdualOnYDModule</C>;
#!   </Item>
#!   <Item>
#!     the corresponding image basis element, if nonzero;
#!   </Item>
#!   <Item>
#!     the associated matrix coefficient.
#!   </Item>
#! </List>
#!
#! Since the action is diagonal in the chosen basis, the resulting
#! matrix contains entries equal to either
#! <M>0</M>
#! or
#! <M>1</M>.
#!
#! The function returns a record:
#! <List>
#!   <Item>
#!     <C>weight</C>: the weight of the simple module;
#!   </Item>
#!   <Item>
#!     <C>matrix</C>: the matrix describing the action.
#!   </Item>
#! </List>
#!
#! @BeginExampleSession
#! gap> StructureMatrixSimpleModule(delta_h, simple);
#! rec(
#!   weight := ...,
#!   matrix := [ ... ]
#! )
#! @EndExampleSession
#!
DeclareGlobalFunction( "StructureMatrixSimpleModule" );

DeclareGlobalFunction( "NonZeroEntriesForMatrix" );
#!
#! @Section Matrices Associated to Drinfeld Double Elements
#!
#! @Arguments mon, simple, nX, nElemOfG
#!
#! @Returns The matrix associated to the monomial <A>mon</A> acting on the simple module <A>simple</A>.
#!
#! @Description
#! Computes the matrix corresponding to a monomial element of the
#! Drinfeld double acting on a simple module.
#!
#! The input monomial must have the form
#! <M>[ [w], [c] ]</M>,
#! where:
#! <List>
#!   <Item>
#!     <M>w=(i_1,\dots,i_r)</M>
#!     is a word in generator indices;
#!   </Item>
#!   <Item>
#!     <M>c</M>
#!     is the scalar coefficient of the monomial.
#!   </Item>
#! </List>
#!
#! The indices are interpreted as follows:
#! <List>
#!   <Item>
#!     indices corresponding to group generators are represented using
#!     the matrices obtained from
#!     <C>simple.simple</C>;
#!   </Item>
#!   <Item>
#!     indices corresponding to delta functions
#!     <M>\delta_h</M>
#!     are represented through
#!     <C>StructureMatrixSimpleModule</C>.
#!   </Item>
#! </List>
#!
#! The function evaluates the monomial by multiplying the associated
#! matrices in the same order as the indices appearing in the word.
#!
#! More precisely, if
#! <M>w=(i_1,\dots,i_r)</M>,
#! then the function computes
#! <M>c\,M_{i_1}\cdots M_{i_r}</M>,
#! where each matrix
#! <M>M_{i_k}</M>
#! is determined according to the type of generator represented by
#! the index
#! <M>i_k</M>.
#!
#! The final result is multiplied by the coefficient of the monomial.
#!
#! At the moment, the function only supports single monomials and not
#! arbitrary linear combinations.
#!
#! @BeginExampleSession
#! gap> MatrixForDrinfeldDoubleElement(mon, simple, nX, nElemOfG);
#! [ [ ... ], [ ... ] ]
#! @EndExampleSession
#!
DeclareGlobalFunction( "MatrixForDrinfeldDoubleElement" );
#!
#! @Section Conjugation Associated to Basis Elements
#!
#! @Arguments simple, elm_base
#!
#! @Returns The conjugated element <M>xgx^{-1}</M> associated to <A>elm_base</A>.
#!
#! @Description
#! Computes the conjugation of the distinguished group element
#! associated to the simple module by a fixed basis element.
#!
#! Let:
#! <List>
#!   <Item>
#!     <M>g</M> be the group element associated to the weight of the
#!     simple module;
#!   </Item>
#!   <Item>
#!     <M>x</M> be the group component of the basis element
#!     <A>elm_base</A>.
#!   </Item>
#! </List>
#!
#! The function returns the conjugated element
#! <M>xgx^{-1}</M>.
#!
#! The input basis element must belong to
#! <C>simple.base</C>.
#! Otherwise, an error is raised.
#!
#! This function is useful for describing the orbit structure of the
#! conjugacy class associated to the Yetter--Drinfeld module.
#!
#! @BeginExampleSession
#! gap> K           := CyclicGroup(3);;
#! gap> H           := CyclicGroup(2);;
#! gap> AutK        := AutomorphismGroup(K);;
#! gap> gensAutK    := GeneratorsOfGroup(AutK);;
#! gap> T           := GroupHomomorphismByImages(H, AutK, [H.1], gensAutK);;
#! gap> G           := SemidirectProduct(H, T, K);;
#! gap> embK        := Embedding(G, 2);;
#! gap> embH        := Embedding(G, 1);;
#! gap> HinG        := List([0 .. Size(H) - 1], x -> embH(H.1^x));;
#! gap> allPairsInG := Concatenation(List(K, x -> List(HinG, y -> embK(x) * y)));;
#! gap> simple      := 0;;
#! gap> elm         := 0;;
#! gap> Conj4BasisElement(simple, elm, allPairsInG );
#! ( \omega , 3 )
#! @EndExampleSession
#!
DeclareGlobalFunction( "Conj4BasisElement" );
#!
#! @Arguments simple
#!
#! @Returns A list containing the conjugated elements associated to all basis elements.
#!
#! @Description
#! Computes the conjugation data associated to all basis elements of a
#! simple Yetter--Drinfeld module.
#!
#! Let:
#! <List>
#!   <Item>
#!     <M>g</M> be the distinguished group element associated to the
#!     weight of the module;
#!   </Item>
#!   <Item>
#!     <M>x_i</M> be the group component of the basis element
#!     <M>b_i</M>.
#!   </Item>
#! </List>
#!
#! For every basis element, the function computes
#! <M>x_i g x_i^{-1}</M>.
#!
#! The output is therefore the list
#! <M>[x_1gx_1^{-1},\dots,x_rgx_r^{-1}]</M>,
#! where
#! <M>r</M>
#! is the dimension of the module.
#!
#! This information is frequently used in computations involving:
#! <List>
#!   <Item>
#!     delta actions;
#!   </Item>
#!   <Item>
#!     conjugacy classes;
#!   </Item>
#!   <Item>
#!     Yetter--Drinfeld structures.
#!   </Item>
#! </List>
#!
#! @BeginExampleSession
#! gap> Conj4Basis(simple);
#! [ (0,0), (\omega,1), (\omega^2,3) ]
#! @EndExampleSession
#!
DeclareGlobalFunction( "Conj4Basis" );

DeclareGlobalFunction( "DeltaActionsFiltered4Basis" );

DeclareGlobalFunction( "ReducedDeltaAction" );

DeclareGlobalFunction( "RemoveYterms" );

DeclareGlobalFunction( "CommuteYBeforeX" );

DeclareGlobalFunction( "RemoveAndCommuteYInYjBis" );

DeclareGlobalFunction( "CollectLinearCombination" );

DeclareGlobalFunction( "GetInfoList" );

DeclareGlobalFunction( "IiqToMatrix" );

DeclareGlobalFunction( "MatrixActionYiOnNicholsBasis" );


