#! @Chapter Evaluation and Verma Module Tests
#!
#! This chapter provides auxiliary functions for:
#! <List>
#!   <Item>
#!     evaluating words in generators;
#!   </Item>
#!   <Item>
#!     evaluating linear combinations of monomials;
#!   </Item>
#!   <Item>
#!     testing nontriviality conditions related to simple Verma modules.
#!   </Item>
#! </List>
#!
#! @Section Evaluation of Words
#!
#! @Arguments w, A
#! @Returns An element obtained by evaluating the word <A>w</A> on the list of generators <A>A</A>.
#!
#! @Description
#! Evaluates a word encoded as a list of indices.
#!
#! The input:
#! <List>
#!   <Item>
#!     <A>w</A> is a list of integers representing a word in generators;
#!   </Item>
#!   <Item>
#!     <A>A</A> is a list of algebra elements.
#!   </Item>
#! </List>
#!
#! The function interprets
#! <A>w</A>
#! as the ordered product
#! <M>A_{w_1}A_{w_2}\cdots A_{w_n}</M>
#! and returns its evaluation.
#! 
#!
#! If the word is empty, the identity element
#! <C>One(A[1])</C>
#! is returned.
#!
#! @BeginExampleSession
#! gap> A := [ a, b, c ];
#! gap> EvalWord([1,2,3], A);
#! a*b*c
#! gap> EvalWord([], A);
#! One(a)
#! @EndExampleSession
#!
DeclareGlobalFunction( "EvalWord" );
#!
#! @Section Evaluation of Linear Combinations
#!
#! @Arguments B, A
#! @Returns The evaluation of the linear combination encoded by <A>B</A>.
#!
#! @Description
#! Evaluates a linear combination of words in generators.
#!
#! The argument <A>B</A> must be a pair:
#! <List>
#!   <Item>
#!     <C>B[1]</C>: a list of words;
#!   </Item>
#!   <Item>
#!     <C>B[2]</C>: the corresponding list of coefficients.
#!   </Item>
#! </List>
#!
#! Each word is evaluated using
#! <C>EvalWord</C>,
#! and the resulting values are summed with the corresponding
#! coefficients.
#!
#! Explicitly, if
#! <M>B = ([w_1,\dots,w_r],[c_1,\dots,c_r])</M>,
#! then the function computes
#! <M>\sum_{i=1}^r c_i\,\mathrm{EvalWord}(w_i,A)</M>.
#!
#! @BeginExampleSession
#! gap> B := [ [ [1,2], [2,1] ], [ 1, -1 ] ];
#! gap> EvalLinearCombination(B, A);
#! a*b - b*a
#! @EndExampleSession
#!
DeclareGlobalFunction( "EvalLinearCombination" );
#!
#! @Section Tests for Simple Verma Modules
#!
#! @Arguments simple, nX, nElemOfG, mat_in_DG
#!
#! @Returns <K>true</K> if the evaluated operator is nonzero, and <K>false</K> otherwise.
#!
#! @Description
#!
#! Tests whether a distinguished element associated to the top-degree
#! monomial acts nontrivially on a simple module.
#!
#! The function internally constructs a fixed linear combination
#! corresponding to the element
#! <M>Y_{\mathrm{top}}X_{\mathrm{top}}</M>,
#! computes the filtered delta action using
#! <C>DeltaActionsFiltered4Basis</C>,
#! evaluates the resulting linear combination inside the Drinfeld
#! double representation, and determines whether the resulting matrix
#! is nonzero.
#!
#! More precisely, the procedure:
#! <List>
#!   <Item>
#!     computes filtered delta actions on the basis of the simple module;
#!   </Item>
#!   <Item>
#!     evaluates the resulting expression using
#!     <C>EvalLinearCombination</C>;
#!   </Item>
#!   <Item>
#!     checks whether the resulting matrix is zero.
#!   </Item>
#! </List>
#!
#! The output is therefore a criterion detecting whether the action of
#! the top-degree operator is nontrivial on the given simple module.
#!
#! @BeginExampleSession
#! gap> CheckSimplesVermas(simple, nX, nElemOfG, mat_in_DG);
#! true
#! @EndExampleSession
#!
DeclareGlobalFunction( "CheckSimplesVermas" );