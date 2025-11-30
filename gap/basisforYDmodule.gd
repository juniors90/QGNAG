#! @Chapter Basis for Yetter-Drinfeld module
#!
#! @Section Finding a Simples Modules attached to Element
#!
#! @Arguments G, g, rho, allPairsInG, allElementSDP
#! @Returns the basis of the tensor $\Bbbk G \otimes V$ as formal pairs.
#! @Description
#! Calcula la Base de un módulo simple $M(g, \rho)$, donde
#! (<A>g</A>, <A>rho</A>) es el peso asociado este módulo. A partir del peso, calcula
#! una lista de cosets derechos de $\Gamma_g$ en <A>G</A> y luego
#! la base del tensor $\Bbbk G \otimes V$ como una lista de pares
#! formales.
DeclareGlobalFunction( "TensorBasisForSimples" );

#! @Arguments G
#! @Returns una lista de $\Gamma_g = \{x \in \Gamma \mid xg = gx\}$
#! el subgrupo de sotropía de $g$, con $g$ un representante de una de
#! las clases de conjugación de $\Gamma$.
#! @Description
#! Consideramos las clases de conjugación de $\Gamma$, y elegimos un
#! elemento en cada clase, lo que nos da un subconjunto $\mathcal{Q}$
#! de $\Gamma$. Para cualquier $g \in \Gamma$ denotamos por
#! $\mathcal{O}_g = \{xgx^{-1} \mid x \in \Gamma\}$ la clase de
#! conjugación de $g$, y por $\Gamma_g = \{x \in \Gamma \mid xg = gx\}$
#! el subgrupo de sotropía de $g$.
DeclareGlobalFunction( "GetCentralizers" );

#! @Arguments G
#! @Returns una lista de $\Gamma_g = \{x \in \Gamma \mid xg = gx\}$
#! el subgrupo de sotropía de $g$, con $g$ un representante de una de
#! las clases de conjugación de $\Gamma$.
#! @Description
#! Consideramos las clases de conjugación de $\Gamma$, y elegimos un
#! elemento en cada clase, lo que nos da un subconjunto $\mathcal{Q}$
#! de $\Gamma$. Para cualquier $g \in \Gamma$ denotamos por
#! $\mathcal{O}_g = \{xgx^{-1} \mid x \in \Gamma\}$ la clase de
#! conjugación de $g$, y por $\Gamma_g = \{x \in \Gamma \mid xg = gx\}$
#! el subgrupo de sotropía de $g$.
DeclareGlobalFunction( "GetCentralizerOfElement" );

DeclareGlobalFunction( "GetSimplesMod" );

DeclareGlobalFunction( "GetSimplesModAttachedToElement" );
