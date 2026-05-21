#! @Chapter Precomputed Rewriting Data
#!
#! This chapter contains global variables and auxiliary constructors
#! used to store precomputed rewriting data associated to ordered
#! monomials of the form
#! <M>Y_{\mathrm{top}}X_{\mathrm{top}}</M>.
#!
#! These objects are intended to be used internally by rewriting
#! procedures and PBW-type computations appearing in the package.
#!
#! The naming convention reflects the ordered monomial associated to
#! each dataset.
#!
#! For example:
#! <List>
#!   <Item>
#!     <C>Y3Xtop</C> corresponds to the rewriting data associated to
#!     the monomial
#!     <M>Y_3 X_{\mathrm{top}}</M>;
#!   </Item>
#!   <Item>
#!     <C>Y0Y3Xtop</C> corresponds to the monomial
#!     <M>Y_0Y_3X_{\mathrm{top}}</M>;
#!   </Item>
#!   <Item>
#!     and similarly for the remaining variables.
#!   </Item>
#! </List>
#!
#! @Section Constructor of Rewriting Data
#!
#! @Arguments
#!
#! @Returns
#! A list containing all rewriting-data containers.
#!
#! @Description
#! Creates the collection of global containers storing rewriting data
#! associated to ordered monomials involving
#! <M>Y_i</M>-generators and the distinguished monomial
#! <M>X_{\mathrm{top}}</M>.
#!
#! The function returns a list containing the global variables:
#! <List>
#!   <Item>
#!     <C>Y3Xtop</C>;
#!   </Item>
#!   <Item>
#!     <C>Y0Y3Xtop</C>;
#!   </Item>
#!   <Item>
#!     <C>Y2Y0Y3Xtop</C>;
#!   </Item>
#!   <Item>
#!     <C>Y1Y2Y0Y3Xtop</C>;
#!   </Item>
#!   <Item>
#!     <C>Y0Y1Y2Y0Y3Xtop</C>;
#!   </Item>
#!   <Item>
#!     <C>Y2Y0Y1Y2Y0Y3Xtop</C>;
#!   </Item>
#!   <Item>
#!     <C>Y0Y2Y0Y1Y2Y0Y3Xtop</C>;
#!   </Item>
#!   <Item>
#!     <C>Y1Y0Y2Y0Y1Y2Y0Y3Xtop</C>.
#!   </Item>
#! </List>
#!
#! These variables are initialized globally using
#! <C>InstallValue</C>.
#!
#! @BeginExample
#! gap> data := CreateDataSemiYtopXtop();
#! [ Y3Xtop, Y0Y3Xtop, ..., Y1Y0Y2Y0Y1Y2Y0Y3Xtop ]
#! @EndExample
#!
DeclareGlobalFunction( "CreateDataSemiYtopXtop" );
#! @Section Global Rewriting Data Containers
#!
#! The following global variables store rewriting data associated to
#! specific ordered monomials.
#!
#! They are initialized during package loading through
#! <C>CreateDataSemiYtopXtop</C>.
#!
#! @Description
#! Rewriting data associated to the monomial
#! <M>Y_3X_{\mathrm{top}}</M>.
#!
DeclareGlobalVariable( "Y3Xtop" );
#! @Description
#! Rewriting data associated to the monomial
#! <M>Y_0Y_3X_{\mathrm{top}}</M>.
#!
DeclareGlobalVariable( "Y0Y3Xtop" );
#! @Description
#! Rewriting data associated to the monomial
#! <M>Y_2Y_0Y_3X_{\mathrm{top}}</M>.
#!
DeclareGlobalVariable( "Y2Y0Y3Xtop" );
#! @Description
#! Rewriting data associated to the monomial
#! <M>Y_1Y_2Y_0Y_3X_{\mathrm{top}}</M>.
#!
DeclareGlobalVariable( "Y1Y2Y0Y3Xtop" );
#! @Description
#! Rewriting data associated to the monomial
#! <M>Y_0Y_1Y_2Y_0Y_3X_{\mathrm{top}}</M>.
#!
DeclareGlobalVariable( "Y0Y1Y2Y0Y3Xtop" );
#! @Description
#! Rewriting data associated to the monomial
#! <M>Y_2Y_0Y_1Y_2Y_0Y_3X_{\mathrm{top}}</M>.
#!
DeclareGlobalVariable( "Y2Y0Y1Y2Y0Y3Xtop" );
#! @Description
#! Rewriting data associated to the monomial
#! <M>Y_0Y_2Y_0Y_1Y_2Y_0Y_3X_{\mathrm{top}}</M>.
#!
DeclareGlobalVariable( "Y0Y2Y0Y1Y2Y0Y3Xtop" );
#! @Description
#! Rewriting data associated to the monomial
#! <M>Y_1Y_0Y_2Y_0Y_1Y_2Y_0Y_3X_{\mathrm{top}}</M>.
#!
DeclareGlobalVariable( "Y1Y0Y2Y0Y1Y2Y0Y3Xtop" );