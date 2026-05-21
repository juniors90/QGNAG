#! @Chapter Utilities 
#! 
#! @Section Conmutation Rules.
#!
#! @Arguments
#!
#! @Returns
#! A list containing all elements of the semidirect product group.
#!
#! @Description
#! Returns the complete list of elements of the semidirect product
#! <M>\mathbb{F}_{p^2} \rtimes C_m</M> associated to the global
#! configuration record <C>ConfigSDP</C>.
#!
#! The elements are constructed using the function
#! <C>ElementSDP(l, k)</C>, where:
#! <List>
#!   <Item>
#!     <C>l</C> runs through all elements of the finite field
#!     <M>\mathbb{F}_{p^2}</M>;
#!   </Item>
#!   <Item>
#!     <C>k</C> runs through the integers
#!     <M>0, \dots, m-1</M>.
#!   </Item>
#! </List>
#!
#! The output is ordered first by the field component and then by the
#! cyclic component.
#!
#! @BeginExample
#! gap> GetElementsOfG();
#! [ (0,0), (0,1), ..., (w^2,5) ]
#! @EndExample
DeclareGlobalFunction( "GetElementsOfG" );
DeclareGlobalVariable( "QGNAG_ElementsInSDP" );
#! @Arguments i, j, xIndex, groupIndex, deltaIndex, yIndex
#!
#! @Returns
#! A list of the form
#! <C>[ monomials, coefficients ]</C>.
#!
#! @Description
#! Computes the commutation rule
#! <M>Y_j X_i</M>
#! in the algebra associated to the semidirect product construction.
#!
#! The function determines the rewriting relation expressing the product
#! <M>Y_j X_i</M> as a linear combination involving:
#! <List>
#!   <Item>
#!     reordered monomials of the form <M>X_i Y_k</M>;
#!   </Item>
#!   <Item>
#!     transporter terms involving group-like generators;
#!   </Item>
#!   <Item>
#!     a scalar correction term when <M>i=j</M>.
#!   </Item>
#! </List>
#!
#! The output is a pair:
#! <List>
#!   <Item>
#!     a list of monomials encoded as lists of generator indices;
#!   </Item>
#!   <Item>
#!     the corresponding list of coefficients.
#!   </Item>
#! </List>
#!
#! The transporter contributions are computed using
#! <C>TransporterOfG</C> and the character
#! <C>ChiForSemidirectProduct</C>.
#!
#! @BeginExample
#! gap> GetConmutationRuleOnB4w(i, j,
#! >     xIndex,
#! >     groupIndex,
#! >     deltaIndex,
#! >     yIndex);
#! [ [ ... ], [ ... ] ]
#! @EndExample
DeclareGlobalFunction( "GetConmutationRuleOnB4w" );
#!
#! @Arguments prod
#!
#! @Returns
#! A pair
#! <C>[ monomials, coefficients ]</C>
#! representing the rewritten expression.
#!
#! @Description
#! Applies a single commutation step to monomials containing a factor
#! of the form <M>Y_j X_i</M>.
#!
#! The input <A>prod</A> must be a pair:
#! <List>
#!   <Item>
#!     a list of monomials encoded as lists of generator indices;
#!   </Item>
#!   <Item>
#!     a list of coefficients.
#!   </Item>
#! </List>
#!
#! For each monomial, the function searches from left to right for the
#! first occurrence of a subword <M>Y_j X_i</M>. If such a pair is found,
#! the corresponding commutation rule obtained from
#! <C>GetConmutationRuleOnB4w</C> is applied exactly once.
#!
#! Only one commutation is performed per monomial in a single call.
#! Monomials with no applicable commutation rule remain unchanged.
#!
#! The function is intended for iterative rewriting procedures leading
#! to PBW-type ordered monomials.
#!
#! @BeginExample
#! gap> ApplyYXCommutationOnce(prod);
#! [ [ ... ], [ ... ] ]
#! @EndExample
DeclareGlobalFunction( "ApplyYXCommutationOnce" );