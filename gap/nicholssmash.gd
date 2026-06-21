#############################################################################
##
##  nicholssmash.gd              MyPackage                   Your Name
##
#############################################################################

#! @Chapter Nichols Smash Products
#! 
#! @Section Commutation Relations in Smash Products
#!
#! Let <M>\mathfrak{B}(V)</M> be the Nichols algebra of a braided vector 
#! space <M>V</M> over a semidirect product group <M>G</M>, and let <M>\Bbbk G</M> 
#! be its group algebra. The smash product algebra <M>\mathfrak{B}(V) \# \Bbbk G</M> 
#! is defined via the action of <M>G</M> on <M>\mathfrak{B}(V)</M>. 
#!
#! This section provides functions to compute the commutation (or rewriting) 
#! rules between the group elements and the generators of the Nichols algebra 
#! (or its dual <M>\mathfrak{B}(\bar{V})</M>).

#! @Arguments j, gensA, xIndex, groupElems
#! @Returns A list of relations in the standard &GAP; rewriting format.
#! @Description
#!   Returns the commutation relations between the group elements of <M>G</M> 
#!   and a specific generator of the Nichols algebra <M>\mathfrak{B}(V)</M> 
#!   indexed by the field element <A>j</A>.
#!
#!   For each element <M>g \in G</M>, it computes the action on the field part 
#!   of <A>j</A> and determines the corresponding scalar factor given by the 
#!   character <M>\chi_j(g)</M>. The resulting relation is stored as:
#!   <Display>
#!     g x_j = \chi_j(g) \, x_{ g\cdot j} g
#!   </Display>
#!   where <M>x_j</M> is the generator associated to <A>j</A>.
#!
#! @BeginExample
#! # Example of use will be generated here upon package testing
#! @EndExample
DeclareGlobalFunction( "RelationsGivenByNicholsSmashkG" );
#############################################################################
#!
#! @Arguments j, gensA, yIndex, groupElems
#! @Returns A list of relations in the standard &GAP; rewriting format.
#! @Description
#!   Returns the commutation relations between the group elements of <M>G</M> 
#!   and a specific generator of the dual Nichols algebra <M>\mathfrak{B}(\bar{V})</M> 
#!   indexed by the field element <A>j</A>.
#!
#!   For each element <M>g \in G</M>, it computes the dual action using the inverse 
#!   element <M>g^{-1}</M> on the field part of <A>j</A> and determines the corresponding 
#!   scalar factor given by the character <M>\chi(g)</M>. 
#!   The resulting relation is stored as:
#!   <Display>
#!     y_j g = \chi_j(g) \, g  y_{g^{-1} \cdot j}
#!   </Display>
#!   where <M>y_j</M> is the dual generator associated to <A>j</A>.
#!
#! @BeginExample
#! # Example of use will be generated here upon package testing
#! @EndExample
DeclareGlobalFunction( "RelationsGivenByNicholsDualSmashkG" );
#############################################################################
#! @Arguments j, gensA, xIndex, groupElems, deltaIndex, allPairsInG
#! @Returns A list of relations in the standard &GAP; rewriting format.
#! @Description
#!   Returns the commutation relations between the Kronecker deltas <M>\delta_h</M> 
#!   of <M>\Bbbk^G</M> and a specific generator <M>x_j</M> of the Nichols algebra 
#!   <M>\mathfrak{B}(V)</M> indexed by the field element <A>j</A>.
#!
#!   Since <M>\mathfrak{B}(V)</M> is a <M>G</M>-graded algebra, each generator 
#!   <M>x_j</M> has a homogeneous degree <M>g_j \in G</M>. The interaction 
#!   with the dual algebra <M>\Bbbk^G</M> satisfies the following reordering rule:
#!   <Display>
#!     \delta_h \cdot x_j = x_j \cdot \delta_{g_j^{-1}h}
#!   </Display>
#!   for all <M>h \in G</M>.
#!
#! @BeginExample
#! # Example of use will be generated here upon package testing
#! @EndExample
DeclareGlobalFunction( "RelationsGivenByNicholsSmashkGDual" );
#############################################################################
#! @Arguments j, gensA, yIndex, deltaIndex, groupElems
#! @Returns A list of relations in the standard &GAP; rewriting format.
#! @Description
#!   Returns the commutation relations between the Kronecker deltas <M>\delta_h</M> 
#!   of <M>\Bbbk^G</M> and a specific generator <M>y_j</M> of the dual Nichols 
#!   algebra <M>\mathfrak{B}(\bar{V})</M> indexed by the field element <A>j</A>.
#!
#!   Since <M>\mathfrak{B}(\bar{V})</M> inherits a dual grading from the 
#!   braided vector space, each dual generator <M>y_j</M> interacts with 
#!   the dual group algebra satisfying the following reordering rule:
#!   <Display>
#!     \delta_h \cdot y_j = y_j \cdot \delta_{g_j h}
#!   </Display>
#!   for all <M>h \in G</M>, where <M>g_j</M> is the group element associated to <A>j</A>.
#!
#! @BeginExample
#! # Example of use will be generated here upon package testing
#! @EndExample
DeclareGlobalFunction( "RelationsGivenByNicholsDualSmashkGDual" );