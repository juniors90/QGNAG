#############################################################################
#!
#! @Chapter Quantum Groups and Bicrossproduct Structures
#!
#! @Section Commutation Rules
#!
#! Let <M>G</M> be a finite group and <M>\Bbbk</M> a field. Consider the group 
#! algebra <M>\Bbbk G</M> and its dual algebra <M>\Bbbk^G</M>, which is spanned by the 
#! Kronecker delta elements <M>\{\delta_h \mid h \in G\}</M> satisfying 
#! <M>\delta_h(g) = \delta_{h,g}</M>. 
#!
#! The group <M>G</M> acts on <M>\Bbbk^G</M> from the right via the conjugation 
#! action. This interaction allows us to define a crossed product algebra 
#! structure (or a smash product) <M>\Bbbk G \sharp \Bbbk^G</M>. The fundamental 
#! rewriting rule required to straighten any element in this algebra into a 
#! canonical basis is governed by the commutation relation:
#!
#! <Display>
#!   \delta_h g = g \delta_{g^{-1}hg}
#! </Display>
#!
#! for all <M>g, h \in G</M>. This section provides the computational tools to 
#! automatically generate these reordering relations as a set of rewriting rules, 
#! which can then be used to define rewriting systems or finitely presented algebras 
#! in GAP.
#!
#!  @Arguments allPairsInG, groupIndex, deltaIndex
#!
#!  @Returns
#!    A list of relations in the format <C>[ [m1, m2], [1, -1] ]</C>, representing 
#!    the commutation relation: $\delta_h  g = g  \delta_{g^{-1}  h  g}$
#!
#!  @Description
#! 
#!  This function automatically generates the defining relations for the 
#!  interaction between the group algebra $\Bbbk G$ and the dual algebra $\Bbbk^G$.
#!  It computes the action of $G$ on the Kronecker deltas via conjugation.
#! 
# - <C>allPairsInG</C>: List of all elements of the group $G$ (ordered).
# - <C>groupIndex</C>:  List of word/algebra representations corresponding to allPairsInG.
# - <C>deltaIndex</C>:  List of generator indices representing the $\delta_h$ elements.
#! The arguments are:
#! <List>
#!   <Item>
#!     <C>allPairsInG</C>: The list of all elements of the group <M>G</M>, 
#!     properly ordered.
#!   </Item>
#!   <Item>
#!     <C>groupIndex</C>: A list containing the word or algebra representation 
#!     of each element in <C>allPairsInG</C>.
#!   </Item>
#!   <Item>
#!     <C>deltaIndex</C>: A list containing the indices or generators that 
#!     represent the Kronecker deltas <M>\delta_h</M>.
#!   </Item>
#! </List>  
#!
#! Each relation in the output is stored in the standard &GAP; format 
#! <C>[ [m1, m2], [1, -1] ]</C>, which represents the equation <M>m_1 - m_2 = 0</M>.
#!
#! @BeginExample
#! gap> elements   := [];;
#! gap> groupIndex := [4, 5];;;
#! gap> deltaIndex := [6..11];;
#! gap> CommutationRelationsGroupAndDeltas( elements, groupIndex, deltaIndex );
#! [ [ [ [ 1 ], [ 2 ] ], [ [ 2 ], [ 3 ] ] ], [ 1, -1 ] ], ... ]
#! @EndExample
#!
DeclareGlobalFunction( "CommutationRelationsGroupAndDeltas" );