
#! @Chapter Precomputed Rewriting Data
#!
#! @Section Rewriting Data for Products <M>Y_j b_i</M>
#!
#! This section defines global containers storing rewriting data
#! associated to products of the form
#!
#!
#! where:
#! <List>
#!   <Item>
#!     <M>Y_j</M> denotes one of the generators
#!     <M>Y_0,Y_1,Y_2,Y_3</M>;
#!   </Item>
#!   <Item>
#!     <M>b_i</M> belongs to the ordered PBW basis
#!     <M>\{b_j\}_{j=1}^N</M>.
#!   </Item>
#! </List>
#!
#! These global variables are intended to store precomputed rewriting
#! information used in commutation and reduction procedures.
#!
#! @Arguments
#!
#! @Returns
#! A list containing all rewriting-data containers associated to
#! products
#! <M>Y_j b_i</M>.
#!
#! @Description
#! Creates the collection of global containers associated to rewriting
#! data for products
#! <M>Y_j b_i</M>.
#!
#! The function returns a list containing:
#! <List>
#!   <Item>
#!     <C>Y0bis</C>;
#!   </Item>
#!   <Item>
#!     <C>Y1bis</C>;
#!   </Item>
#!   <Item>
#!     <C>Y2bis</C>;
#!   </Item>
#!   <Item>
#!     <C>Y3bis</C>.
#!   </Item>
#! </List>
#!
#! Each variable is intended to store rewriting data corresponding to
#! multiplication by a fixed generator
#! <M>Y_j</M>.
#!
#! @BeginExample
#! gap> data := CreateDataYjbis();
#! [ Y0bis, Y1bis, Y2bis, Y3bis ]
#! @EndExample
#!
DeclareGlobalFunction( "CreateDataYjbis" );
#! @Description
#! Global container storing rewriting data associated to products
#! <M>Y_0 b_i</M>.
#!
DeclareGlobalVariable( "Y0bis" );
#! @Description
#! Global container storing rewriting data associated to products
#! <M>Y_1 b_i</M>.
#!
DeclareGlobalVariable( "Y1bis" );
#! @Description
#! Global container storing rewriting data associated to products
#! <M>Y_2 b_i</M>.
#!
DeclareGlobalVariable( "Y2bis" );
#! @Description
#! Global container storing rewriting data associated to products
#! <M>Y_3 b_i</M>.
#!
DeclareGlobalVariable( "Y3bis" );
