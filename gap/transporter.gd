#! @Chapter Nichols algebras attached to affine racks
#!
#! @Section Transporter Of <M>\Gamma</M> for all <M>i, j\in \mathbb{F}\textsubscript{4}</M>.
#!
#! @Arguments G, i, j
#! @Returns una lista de todos los $g\in G$ tales que
#! $g\cdot i=j$, con $i, j\in \mathbb{F}_{4}$.
#! @Description
#! Consideramos los elementos de $\Gamma$ y un par $i, j\in \mathbb{F}_{4}$,
#! entonces esta funcion devuelve una lista de todos los elementos $g\in \Gamma$
#! tales que $g\cdot i=j$.
#!
DeclareGlobalFunction( "TransporterOfG" );
#!
#!
#! @Arguments trsp, i
#!
#! @Returns A list whose elements are the conjugates of each element of <A>trsp</A>
#!          by the element <A>ElementSDP(i,1)</A>, that is: <M>g_i^{-1}*g*g_i</M>
#!          for each <M>g \in \texttt{trsp}</M>.
#!
#! @Description
#! This function takes as input:
#!  - <A>trsp</A>: a list of group elements.
#!  - <A>i</A>: an index used to construct the element <A>g_i = ElementSDP(i,1)</A>.
#!
#! The function computes the conjugation of each element <A>g</A> in <A>trsp</A>
#! by the element <A>g_i</A>, that is, it computes <M>g_i^{-1} * g * g_i</M>
#! for every element in the list, storing the results in a new list.
#! The purpose of this function is to obtain the corresponding indices of elements
#! in the commutation rules from the conjugation action in the SDP (Semidirect Product)
#! structure.
#!
#! The resulting list contains the transformed elements after conjugation, and it is
#! used in the context of commutation rules within a semidirect product.
#!
DeclareGlobalFunction( "IndexForDeltaInConmutationRules" );