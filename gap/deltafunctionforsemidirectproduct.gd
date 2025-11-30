#! @Chapter Nichols algebras attached to affine racks
#!
#! @Section Transporter Of <M>\Gamma</M> for all <M>i, j\in \mathbb{F}\textsubscript{4}</M>.
#!
#!
#! @Arguments elm1
#! @Returns una función que actúa como la Delta de Kronecker, fijando 
#! el valor de referencia <A>elm1</A> en $\Gamma$.
#! @Description
#! La función devuelta (<A>delta_elm1</A>) toma un argumento <A>elm2</A> y
#! retorna $1$ si <A>elm2</A> es igual al valor de <A>elm1</A> proporcionado,
#! y $0$ en caso contrario. 
#! Formalmente: <A>delta_elm1(elm2)</A> es $1$ si <A>elm1 = elm2</A>,
#! y $0$ caso contrario.
DeclareGlobalFunction( "DeltaFunctionForSDP" );