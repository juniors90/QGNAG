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