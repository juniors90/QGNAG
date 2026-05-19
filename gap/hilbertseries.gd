#! @Chapter Utilities
#!
#! @Section Hilbet Series
#!
#! @Arguments BasisMod, BasisSubMod, BasisNichols, NicholsGradingData
#!
#! @Returns
#! A list of grading records encoding the Hilbert series coefficients.
#!
#! @Description
#! Given a basis of a module, a basis of a submodule, a basis of a Nichols
#! algebra, and grading data associated to the Nichols algebra, this function
#! computes the graded multiplicities of the submodule elements with respect
#! to the grading induced by the Nichols algebra basis.
#!
#! More precisely, for each element in <A>BasisSubMod</A>, the function:
#! <List>
#!   <Item>
#!     decomposes the element in the basis <A>BasisMod</A>;
#!   </Item>
#!   <Item>
#!     determines the first nonzero basis component;
#!   </Item>
#!   <Item>
#!     identifies the corresponding basis element in
#!     <A>BasisNichols</A>;
#!   </Item>
#!   <Item>
#!     computes its degree;
#!   </Item>
#!   <Item>
#!     matches this degree with the corresponding grading record in
#!     <A>NicholsGradingData</A>.
#!   </Item>
#! </List>
#!
#! The output is a list of records of the form
#! <C>rec( graded_i := i, count := n )</C>,
#! where <C>count</C> is the number of basis elements of the submodule
#! having degree <C>i</C>.
#!
#! @BeginExample
#! gap> HS := QGNAG_HSData(
#! >     Basis(L),
#! >     Basis(S),
#! >     BasisNichols,
#! >     NicholsGradingData
#! > );
#! [ rec( graded_i := 0, count := 1 ),
#!   rec( graded_i := 1, count := 4 ),
#!   rec( graded_i := 2, count := 6 ) ]
#!
#! @EndExample
DeclareGlobalFunction( "QGNAG_HSData" );
#!
#! @Arguments HScoeffs
#!
#! @Returns
#! Nothing. The function only prints the Hilbert series.
#!
#! @Description
#! Prints the Hilbert series associated to a graded object from a list
#! of grading coefficients.
#!
#! The input <A>HScoeffs</A> must be a list of records of the form
#! <C>rec( graded_i := i, count := n )</C>, where:
#! <List>
#!   <Item>
#!     <C>graded_i</C> denotes the degree;
#!   </Item>
#!   <Item>
#!     <C>count</C> denotes the multiplicity in that degree.
#!   </Item>
#! </List>
#!
#! The function constructs a polynomial expression
#! <M>H(t) = \sum_i a_i t^i</M>
#! and prints it in a human-readable form.
#!
#! Terms with zero coefficient are omitted.
#! If the coefficient is equal to <C>1</C>, the coefficient is not printed.
#!
#! @BeginExample
#! gap> HS := [
#! >     rec( graded_i := 0, count := 1 ),
#! >     rec( graded_i := 1, count := 4 ),
#! >     rec( graded_i := 2, count := 6 )
#! > ];
#! gap> QGNAG_PrintHS(HS);
#! Hilbert Serie: H(t) = t^0 + 4t^1 + 6t^2.
#!
#! @EndExample
DeclareGlobalFunction( "QGNAG_PrintHS" );