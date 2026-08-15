# %% [markdown]
# 

# %%
LoadPackage("SCSCP");

# %%
t0 := NanosecondsSinceEpoch();;

# %%
LoadPackage("GBNP");

# %%
GBNP.ConfigPrint(
    "X0",    # 1 "X_0 = X_0"
    "X1",    # 2 "X_1 = X_1"
    "X2",    # 3 "X_2 = X_w"
    "X3",    # 4 "X_3 = X_{w^2}"
    "t",     # 5 "t = (0, g)"
    "x",     # 6 "x = (0, g^2)"
    "y",     # 7 "y = (w, 0)"
    "z",     # 8 "z = (1, 0)"
    "De",
    "D_(0,1)",
    "D_(0,2)",
    "D_(0,3)",
    "D_(0,4)",
    "D_(0,5)",
    "D_(1,0)",
    "D_(1,1)",
    "D_(1,2)",
    "D_(1,3)",
    "D_(1,4)",
    "D_(1,5)",
    "D_(w,0)",
    "D_(w,1)",
    "D_(w,2)",
    "D_(w,3)",
    "D_(w,4)",
    "D_(w,5)",
    "D_(w^2,0)",
    "D_(w^2,1)",
    "D_(w^2,2)",
    "D_(w^2,3)",
    "D_(w^2,4)",
    "D_(w^2,5)",
    "Y0",        # 1 "Y_0 = Y_0"
    "Y1",        # 2 "Y_1 = Y_1"
    "Y2",        # 3 "Y_2 = Y_w"
    "Y3"         # 4 "Y_3 = Y_{w^2}"
);

# %% [markdown]
# ## Free Algebra over $\mathbb{Q}$

# %%
nX       := 4;;
nGensOfG := 4;;
nDelta   := 24;;
nY       := 4;;
nTotal   := nX + nGensOfG +  nDelta + nY;;
F        := FreeAssociativeAlgebraWithOne(Rationals, nTotal);;
gens     := GeneratorsOfAlgebra(F);;
e        := gens[1];;


# %% [markdown]
# ### $X_j's$ Generators

# %%
X0 := gens[2];;
X1 := gens[3];;
X2 := gens[4];;
X3 := gens[5];;

# %% [markdown]
# ### Generadores of Group G

# %%
F1 := gens[6];;
F2 := gens[7];;
F3 := gens[8];;
F4 := gens[9];;

# %% [markdown]
# ### Generatos of $\Bbbk^{G}$

# %%
De          := gens[10];;  #1 e           (0, 0)
DF1         := gens[11];;  #2 F1          (0, g)
DF2         := gens[12];;  #3 F2          (0, g^2)
DF1F2       := gens[13];;  #6 F1F2        (0, g^3) 
DF2F2       := gens[14];;  #9 F2^2        (0, g^4)
DF1F2F2     := gens[15];;  #13 F1F2^2     (0, g^5) 
DF4         := gens[16];;  #5 F4          (1, 0)
DF4F1       := gens[17];;  #16 F4F1       (1, g)
DF2F3       := gens[18];;  #10 F2F3       (1, g^2)
DF1F2F4     := gens[19];;  #15 F1F2F4     (1, g^3)
DF2F3F2     := gens[20];;  #23 F2F3F2     (1, g^4) 
DF1F2F2F3   := gens[21];;  #20 F1F2^2F3   (1, g^5)
DF3         := gens[22];;  #4 F3          (w, 0)
DF1F4       := gens[23];;  #8 F1F4        (w, g)
DF3F2       := gens[24];;  #19 F3F2       (w, g^2)
DF1F2F3     := gens[25];;  #14 F1F2F3     (w, g^3)
DF2F2F4     := gens[26];;  #18 F2^2F4     (w, g^4)
DF1F2F3F2   := gens[27];;  #24 F1F2F3F2   (w, g^5)
DF3F4       := gens[28];;  #12 F3F4       (w^2, 0)
DF1F3       := gens[29];;  #7 F1F3        (w^2, g)
DF2F4       := gens[30];;  #11 F2F4       (w^2, g^2)
DF1F3F2     := gens[31];;  #22 F1F3F2     (w^2, g^3) 
DF2F2F3     := gens[32];;  #17 F2^2F3     (w^2, g^4)
DF1F2F2F4   := gens[33];;  #23 F1F2^2F4   (w^2, g^5) 

# %% [markdown]
# ### Generatos of $\mathfrak{B}(\overline{V})$

# %%
Y0 := gens[34];;
Y1 := gens[35];;
Y2 := gens[36];;
Y3 := gens[37];;

# %% [markdown]
# - Generators lists

# %%
gensX      := GP2NPList(gens{[2..5]});;
gensG      := GP2NPList(gens{[6..9]});;
gensDeltas := GP2NPList(gens{[10..33]});;
gensY      := GP2NPList(gens{[34..37]});;

# %%
xIndex        := [1..4];;
groupElemsInF:=[
    e,               #1 1           (0, 0)
    F1,              #2 F1          (0, g)
    F2,              #3 F2          (0, g^2)
    F1*F2,           #6 F1F2        (0, g^3)
    F2^2,            #9 F2^2        (0, g^4)
    F1*F2^2,         #13 F1F2^2     (0, g^5) 
    F4,              #5 F4          (1, 0)
    F4*F1,           #16 F4F1       (1, g)
    F2*F3,           #10 F2F3       (1, g^2)
    F1*F2*F4,        #15 F1F2F4     (1, g^3)
    F2*F3*F2,        #23 F2F3F2     (1, g^4)
    F1*F2^2*F3,      #20 F1F2^2F3   (1, g^5)  
    F3,              #4 F3          (w, 0)
    F1*F4,           #8 F1F4        (w, g)
    F3*F2,           #19 F3F2       (w, g^2)
    F1*F2*F3,        #14 F1F2F3     (w, g^3)
    F2^2*F4,         #18 F2^2F4     (w, g^4)
    F1*F2^2*F3*F4,   #24 F1F2F3F2   (w, g^5)
    F3*F4,           #12 F3F4       (w^2, 0)
    F1*F3,           #7 F1F3        (w^2, g)
    F2*F4,           #11 F2F4       (w^2, g^2)
    F1*F3*F2,        #22 F1F3F2     (w^2, g^3) 
    F2^2*F3,         #17 F2^2F3     (w^2, g^4)
    F1*F2^2*F4       #23 F1F2^2F4   (w^2, g^5)  
];;
groupIndex     := List(groupElemsInF, elm -> GP2NP(elm)[1][1]);;
deltaIndex     := [9..32];;
yIndex         := [33..36];;

# %% [markdown]
# ## Tetraedro $\mathcal{T}_{4}$ ($\dim V = 4$).
# 
# Sea el quandle $X = \{0,1,2,3\}$, que representa
# los vértices de un tetraedro.  
# La acción está dada por $i \triangleright j$, donde
# $i$ fija $i$ y rota los otros tres elementos por un
# tercio de vuelta siguiendo la regla de la mano
# izquierda (o derecha, pero con la izquierda resulta
# más progresiva).  
# 
# El cociclo es $q = -1$.
# El álgebra resultante tiene dimensión $72$.  
# Está generada por $x_0, x_1, x_2, x_3$ y
# satisface las siguientes relaciones:
# 
# \begin{align}
# x_0^2 = x_1^2 = x_2^2 = x_3^2 &= 0, \\
# x_3x_2 + x_2x_1 + x_1x_3 &= 0, \\
# x_3x_1 + x_1x_0 + x_0x_3 &= 0, \\
# x_3x_0 + x_0x_2 + x_2x_3 &= 0, \\
# x_2x_0 + x_0x_1 + x_1x_2 &= 0, \\
# x_2x_1x_0x_2x_1x_0 + x_1x_0x_2x_1x_0x_2 + x_0x_2x_1x_0x_2x_1 &= 0.
# \end{align}
# 
# Una base de esta álgebra se obtiene multiplicando
# un elemento de cada fila de arriba hacia abajo en
# todas las formas posibles:
# 
# \begin{align}
# & 1, \; x_0, \\
# & 1, \; x_1, \; x_1x_0, \\
# & 1, \; x_2, \; x_2x_1x_0, \\
# & 1, \; x_2, \; x_2x_1, \\
# & 1, \; x_3.
# \end{align}
# 
# El polinomio de Hilbert de esta álgebra es
# $$
# (1+t)^2(1+t+t^2)(1+t^3) \;=\; 
# t^9 + 4t^8 + 8t^7 + 11t^6 + 12t^5 + 12t^4 + 11t^3 + 8t^2 + 4t + 1.
# $$
# 

# %% [markdown]
# # Calculo $\Bbbk G$
# 
# ## El grupo $\mathbb{F}_4 \rtimes_{\omega} C_6$
# 
# Let $G$ be a group generated by the elements
# $$
# G = \langle f_1, f_2, f_3, f_4 \rangle,
# $$
# subject to the following relationships:
# \begin{align*}
# & f_3^2 = e, \quad f_4^2 = e, \quad f_2^3 = e, \\
# & f_1^2 = f_2, \\
# & f_1 f_4 f_1^{-1} = f_3, \\
# & (f_3 f_4)^2 = e, \\
# & f_1 f_3 f_1^{-1} = f_3 f_4.
# \end{align*}
# The group's presentation can be written as
# $$
# G = \left\langle
# f_1, f_2, f_3, f_4 \;\middle|\;
# \begin{array}{l}
# f_3^2 = f_4^2 = f_2^3 = (f_3 f_4)^2 = e, \quad f_1^2 = f_2, \\[0.3em]
# f_1 f_4 f_1^{-1} = f_3, \quad f_1 f_3 f_1^{-1} = f_3 f_4
# \end{array}
# \right\rangle.
# $$
# This group has a size of $|G| = 24$, and can be interpreted as a semi-direct product
# $$
# G \simeq \mathbb{F}_4 \rtimes C_6,
# $$
# where the subgroup
# $$
# \mathbb{F}_4 = \langle f_3, f_4 \rangle
# $$
# is generated by two commutative involutions, and
# $$
# C_6 = \langle f_1 \rangle
# $$
# is a cyclic group of order $6$.
# 
# The action
# $$
# T : C_6 \longrightarrow \operatorname{Aut}(\mathbb{F}_4)
# $$
# is  given by
# $$
# T(f_1)(a) = \omega(a),
# $$
# where $\omega$ is the automorphism of the group $\mathbb{F}_4$
# induced by $f_1$. In general, for an exponent $s \in \mathbb{Z}$,
# the following holds
# $$
# T(f_1^s)(a) = \omega^s(a),
# $$
# so that the action of the generator of $C_6$ on $\mathbb{F}_4$ is
# described by the iteration of the automorphism $\omega$.
# 

# %%
relsGroup := [
    F3^2-e,            # 1
    F4^2-e,            # 2
    F2^3-e,            # 3
    F1^2*F2^2-e,       # 4
    F1*F4*F1^5*F3-e,   # 5
    (F3*F4)^2-e,       # 6
    F3*F1*F3*F1^5*F4-e # 7
];;

# %%
relsGroup := GP2NPList( relsGroup );;
PrintNPList( relsGroup );

# %%
J := SGrobner(Concatenation(
    relsGroup,
    gensX,
    # gensG,
    gensDeltas,
    gensY
    )
);;

# %%
PrintNPList( J );

# %%
DimQA(J, 36);

# %%
PrintNPList(BaseQA(J, 36, 0));

# %% [markdown]
# ## Relaciones dadas por $\Bbbk^{G}$.

# %%
LoadPackage( "QGNAG" );

# %%
config := rec(
    m            := 6,                   # Valor para m
    q            := 4,                   # Valor para q := p^n
    xIndex       := xIndex,
    groupIndex   := groupIndex,
    deltaIndex   := deltaIndex,
    yIndex       := yIndex,
    nX           := nX,
    nGensOfG     := nGensOfG,
    nDelta       := nDelta,
    nY           := nY,
    DEFAULT      := false,
    TEST         := false,
    PROD         := false,
    DEV          := true,
);;

# %%
QGNAGSetConfig(config);

# %%
QGNAGShowConfig();

# %%


# %% [markdown]
# ## The Algebra $\Bbbk^G$
# 
# We define the structure of the algebra $\Bbbk^G$ over the field $\Bbbk$.

# %% [markdown]
# ## Relaciones dadas por $\Bbbk^{G}$.
# 
# ### Álgebra de funciones sobre el grupo $G$
# 
# Sea $\Bbbk$ un cuerpo (por ejemplo $\Bbbk = \mathbb{Q}$). 
# Se define el álgebra de funciones sobre el grupo
# simétrico $G$ como
# $$
# \Bbbk^{G} = \{ f : G \to \Bbbk \},
# $$
# con la multiplicación puntual dada por
# $$
# (fg)(x) = f(x) g(x), \quad \text{para todo } x \in G.
# $$
# 
# El álgebra $\Bbbk^G$ es el \emph{dual algebraico}
# del álgebra de grupo $kG$, es decir, $\Bbbk^{G}
# = (\Bbbk G)^{*}$.
# 
# #### Base y relaciones de $\Bbbk^{G}$
# 
# El álgebra $\Bbbk^{G}$ tiene una base natural dada
# por las funciones delta
# $$
# \{ \delta_g \mid g \in G \},
# $$
# donde cada $\delta_g$ se define como
# $$
# \delta_g(h) =
# \begin{cases}
# 1, & \text{si } h = g, \\[4pt]
# 0, & \text{si } h \ne g.
# \end{cases}
# $$
# Estas funciones satisfacen las siguientes relaciones:
# 
# 1. Idempotencia:
# $$
# \delta_g^2 = \delta_g.
# $$
# 2. Ortogonalidad:
# $$
# \delta_g \delta_h = 0, \quad \text{si } g \ne h.
# $$
# 3. Conmutatividad:
# $$
# \delta_g \delta_h = \delta_h \delta_g.
# $$
# Esta propiedad se deduce automáticamente de las anteriores, 
# pues si $g = h$ ambos productos son $\delta_g$, y si $g \ne h$
# ambos son cero.
# 
# 4. _Relación de unidad_:
# $$
# \sum_{g \in G} \delta_g = 1.
# $$
# 
# Las relaciones anteriores implican que los elementos $\delta_g$
# son *idempotentes ortogonales*. En particular,
# $\Bbbk^{G}$ es un álgebra conmutativa y semisimple,
# isomorfa a una suma directa de copias del cuerpo:
# $$
# \Bbbk^{G} \cong \Bbbk^{|G|}.
# $$

# %%
relskG     := RelationsOfkGdual(deltaIndex);;
Print("Generated ", Length(relskG), " relations in k^G.\n");
PrintNPList(relskG);

# %%
relskG;

# %%
J := SGrobner(Concatenation(
    relskG,
    gensX,
    gensG,
    # gensDeltas,
    gensY
    )
);;
DimQA(J, 36);

# %%
PrintNPList(BaseQA(J, 36, 0));

# %% [markdown]
# ## Relaciones de Doble de Drinfeld de G

# %%
K           := DirectProduct(CyclicGroup(2), CyclicGroup(2));;
H           := CyclicGroup(6);;
AutK        := AutomorphismGroup(K);
T           := GroupHomomorphismByImages(H, AutK, [H.1], [List(AutK)[2]]);;
G           := SemidirectProduct(H, T, K);;
embK        := Embedding(G, 2);;
embH        := Embedding(G, 1);;
HinG        := List([0 .. Size(H) - 1], x -> embH(H.1^x));;
allPairsInG := Concatenation(List(K, x -> List(HinG, y -> embK(x) * y)));;



# %%
RecNames(GetSimplesModAttachedToElement(G, G.1*G.2, allPairsInG)[1]);

# %%
relsDG := CommutationRelationsGroupAndDeltas(allPairsInG, groupIndex, deltaIndex);

# %%
Print("Se generaron ", Length(relsDG), " relaciones δ_h g = g δ_{g^-1*h*g}.\n");
PrintNPList(relsDG);

# %%
J := SGrobner(Concatenation(
    relsGroup,
    relskG,
    relsDG,
    gensX,
    gensY
    )
);;
DimQA(J, 36);

# %%
PrintNPList(BaseQA(J, 36, 0));

# %%
UpdateSimpleBase := function(simple)
    local m, new_base, elems;

    m := Length(simple.base);
    elems := Elements(GF(4));

    if m = 3 then
        new_base := List([1..m], i ->
            TensorElement(ElementSDP(elems[1], i-1), [1])
        );

        simple.base := new_base;
        return simple;

    elif m = 4 then
        new_base := List([1..m], i ->
            TensorElement(ElementSDP(elems[i], 0), [1])
        );

        simple.base := new_base;
        return simple;

    else
        return simple;
    fi;
end;

# %%
SimplesMn := [];;

# %% [markdown]
# ## $1$-dimensional modules attached to $(0, s)$.
# 

# %%
SimplesModAttachedToOne  := GetSimplesModAttachedToElement(G, One(G),allPairsInG){[1..6]};;
for s in SimplesModAttachedToOne do
    s := AttachDeltaStructureMatrices(s);
    Add(SimplesMn, s);
od;

# %%
SimplesModAttachedToF1F2 := GetSimplesModAttachedToElement(G, G.1*G.2, allPairsInG){[1..6]};;
for s in SimplesModAttachedToF1F2 do
    s := AttachDeltaStructureMatrices(s);
    Add(SimplesMn, s);
od;

# %% [markdown]
# ## $3$-dimensional modules attached to $(0, s)$ with $s=0,3$.

# %%
RepresentationMdim3bis := function(G, i)
    local A1, A2, A3, A4, gens, mgens, rho;

    if not (i in [0,1]) then
        Error("The parameter i must belong to {0,1}.");
    fi;

    A1 := (-1)^i*[ [ 0, 0, 1 ],
                   [ 1, 0, 0 ],
                   [ 0, 1, 0 ] ];
    
    A2 := A1^2;

    A3 := [ [ -1, -1, -1 ],
            [  0,  0,  1 ],
            [  0,  1,  0 ] ];
    
    A4 := [ [  0,  1,  0 ],
            [  1,  0,  0 ],
            [ -1, -1, -1 ] ];

    gens  := GeneratorsOfGroup(G);
    
    mgens := [A1, A2, A3, A4];

    rho := GroupHomomorphismByImages(
        G,
        Group(mgens),
        gens,
        mgens
    );
    return rho;
end;

# %%
index_i := [
#   i      [(0,1)|(0,2)|(w,0)|(1,0)]->
    1,  #7 [ f1, f2, f3, f4 ] -> [ [ [ 0, 0, -1 ], [ -1, 0, 0 ], [ 0, -1, 0 ] ],   [ [ 0, 1, 0 ], [ 0, 0, 1 ], [ 1, 0, 0 ] ],   [ [ -1, 0, 0 ], [ 0, -1, 0 ], [ 0, 0, 1 ] ],   [ [ -1, 0, 0 ], [ 0, 1, 0 ], [ 0, 0, -1 ] ] ]
    0   #8 [ f1, f2, f3, f4 ] -> [ [ [ 0, 0, 1 ], [ 1, 0, 0 ], [ 0, 1, 0 ] ],   [ [ 0, 1, 0 ], [ 0, 0, 1 ], [ 1, 0, 0 ] ],   [ [ -1, 0, 0 ], [ 0, -1, 0 ], [ 0, 0, 1 ] ],   [ [ -1, 0, 0 ], [ 0, 1, 0 ], [ 0, 0, -1 ] ] ]
];

# %%
repsdim3bis := List(index_i, i -> RepresentationMdim3bis(G, i));

# %%
SimplesModAttachedToOneDim3  := GetSimplesModAttachedToElement(G, One(G),allPairsInG){[7,8]};;
for s in SimplesModAttachedToOneDim3 do
    #s               := UpdateSimpleBase(s);
    s.simple        := repsdim3bis[Position(SimplesModAttachedToOneDim3, s)];
    s.weight.rho    := repsdim3bis[Position(SimplesModAttachedToOneDim3, s)];
    s.weightSDP.rho := repsdim3bis[Position(SimplesModAttachedToOneDim3, s)];
    s.gensimages    := List(s.generatorsofgroup, x-> s.simple(x) );
    s               := AttachDeltaStructureMatrices(s);
    Add(SimplesMn, s);
od;

# %%
SimplesModAttachedToF1F2Dim3 := GetSimplesModAttachedToElement(G, G.1*G.2, allPairsInG){[7,8]};;
for s in SimplesModAttachedToF1F2Dim3 do
    #s               := UpdateSimpleBase(s);
    s.simple        := repsdim3bis[Position(SimplesModAttachedToF1F2Dim3, s)];
    s.weight.rho    := repsdim3bis[Position(SimplesModAttachedToF1F2Dim3, s)];
    s.weightSDP.rho := repsdim3bis[Position(SimplesModAttachedToF1F2Dim3, s)];
    s.gensimages    := List(s.generatorsofgroup, x-> s.simple(x) );
    s               := AttachDeltaStructureMatrices(s);
    Add(SimplesMn, s);
od;

# %% [markdown]
# ## $3$-dimensional modules attached to $(1, s)$.
# 

# %%
SimplesModAttachedToF4 := GetSimplesModAttachedToElement(G, G.4, allPairsInG);;
for s in SimplesModAttachedToF4 do
    s             := UpdateSimpleBase(s);
    s             := AttachDeltaStructureMatrices(s);
    Add(SimplesMn, s);
od;

# %%
SimplesModAttachedToF1F2F4 := GetSimplesModAttachedToElement(G, G.1*G.2*G.4, allPairsInG);;
for s in SimplesModAttachedToF1F2F4 do
    s             := UpdateSimpleBase(s);
    s             := AttachDeltaStructureMatrices(s);
    Add(SimplesMn, s);
od;

# %% [markdown]
# ## $4$-dimensional modules attached to $(0, s)$.

# %%
SimplesModAttachedToF1 := GetSimplesModAttachedToElement(G, G.1, allPairsInG);;
for s in SimplesModAttachedToF1 do
    s := AttachDeltaStructureMatrices(s);
    Add(SimplesMn, s);
od;

# %%
SimplesModAttachedToF2 := GetSimplesModAttachedToElement(G, G.2, allPairsInG);;
for s in SimplesModAttachedToF2 do
    s := AttachDeltaStructureMatrices(s);
    Add(SimplesMn, s);
od;

# %%
SimplesModAttachedToF2F2 := GetSimplesModAttachedToElement(G, G.2*G.2, allPairsInG);;
for s in SimplesModAttachedToF2F2 do
    s := AttachDeltaStructureMatrices(s);
    Add(SimplesMn, s);
od;

# %%
SimplesModAttachedToF1F2F2 := GetSimplesModAttachedToElement(G, G.1*G.2*G.2, allPairsInG);;
for s in SimplesModAttachedToF1F2F2 do
    s := AttachDeltaStructureMatrices(s);
    Add(SimplesMn, s);
od;

# %% [markdown]
# ## check relations

# %%
QGNAG_TestRelationsForDGModSimples(SimplesMn, relsGroup, relskG, relsDG);

# %%
for i in [2..Length(SimplesMn)] do
    Print("--------------------------------------------------------------\n");
    for j in [i..Length(SimplesMn)] do
        MtensorN := QGNAG_TensorProductOfSimples(SimplesMn[i], SimplesMn[j]);
        Print(QGNAG_FusionRuleToIndex( MtensorN, SimplesMn), "\n");
    od;
od;

# %% [markdown]
# 

# %% [markdown]
# ## 1-dimensional modules attached to $(0, s)$.
# 
# Here $s= 0,3$.
# 
# Let 
# $G_{(0,s)} = G = \mathbb{F}_{4}\rtimes_{\omega} C_{6}
# \cong \langle (0,3)\rangle \times \big(\langle (1,0),(\omega,0)\rangle \rtimes_{\omega} \langle (0,2)\rangle\big)
# \cong C_2 \times \mathbb{A}_4.$
# 
# Since $G$ is not abelian, its irreducible complex representations are not all one-dimensional. 
# There are exactly six one-dimensional representations. These characters are given by
# \begin{align*}
# 	\tau_{i,j}(t) &= (-1)^i\omega^{j},&\text{ and } &&\tau_{i,j}(y) &=\tau_{i,j}(z)=1,
# \end{align*}
# with $i \in \{0,1\}$, $j\in \{0,1,2\}$.
# 
# We fix the basis: $\{ ( 0 , 0 ) \otimes 1 \}$. Here, for each $(s,i,j)$, the matrices are
# \begin{align*}
# [t]&=(-1)^i\omega^{j}, & [z]&=1,
# \end{align*}
# while the only nonzero matrix for $\Bbbk^G$ is $\delta_{(0,s)}=1$.

# %%
idx_s    := 1;;
simpleM1 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM1);;

# %%
idx_s    := 2;;
simpleM2 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM2);;

# %%
idx_s    := 3;;
simpleM3 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM3);;

# %%
idx_s    := 4;;
simpleM4 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM4);;

# %%
idx_s    := 5;;
simpleM5 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM5);;

# %%
idx_s    := 6;;
simpleM6 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM6);;

# %% [markdown]
# \begin{array}{c|c|cc}
# \text{position} & s & i & j\\\hline
# 1 & 0 & 0 & 0\\
# 2 & 0 & 1 & 0\\
# 3 & 0 & 1 & 1\\
# 4 & 0 & 1 & 2\\
# 5 & 0 & 0 & 2\\
# 6 & 0 & 0 & 1\\
# \end{array}

# %%
SimpleNames:=[];;

# %%
SimpleNames[1] := "M(0,\\tau_{00})";;
SimpleNames[2] := "M(0,\\tau_{10})";;
SimpleNames[3] := "M(0,\\tau_{11})";;
SimpleNames[4] := "M(0,\\tau_{12})";;
SimpleNames[5] := "M(0,\\tau_{02})";;
SimpleNames[6] := "M(0,\\tau_{01})";;

# %%
idx_s    := 7;;
simpleM7 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM7);;

# %%
idx_s    := 8;;
simpleM8 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM8);;

# %%
idx_s    := 9;;
simpleM9 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM9);;

# %%
idx_s     := 10;;
simpleM10 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM10);;

# %%
idx_s     := 11;;
simpleM11 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM11);;

# %%
idx_s     := 12;;
simpleM12 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM12);;

# %% [markdown]
# \begin{array}{c|c|cc}
# \text{position} & s & i & j\\\hline
# 1 & 3 & 0 & 0\\
# 2 & 3 & 1 & 0\\
# 3 & 3 & 1 & 1\\
# 4 & 3 & 1 & 2\\
# 5 & 3 & 0 & 2\\
# 6 & 3 & 0 & 1\\
# \end{array}

# %%
SimpleNames[7]  := "M(3,\\tau_{00})";;
SimpleNames[8]  := "M(3,\\tau_{10})";;
SimpleNames[9]  := "M(3,\\tau_{11})";;
SimpleNames[10] := "M(3,\\tau_{12})";;
SimpleNames[11] := "M(3,\\tau_{02})";;
SimpleNames[12] := "M(3,\\tau_{01})";;

# %% [markdown]
# ## $3$-dimensional modules attached to $(0, s)$ with $s=0,3$.

# %% [markdown]
# Here $s= 0,3$. It is straightforward to check the following matrices provide two irreducible representations $\rho_0$ and $\rho_1$ of $G$, of dimension 3. These two modules, together with the six 1-dimensional modules described above, exhaust all possible irreducible representations, as $24=6\times 1+2\cdot 3^2$.
# 
# For  $(s,i)$, $i\in\{0,1\}$, the matrices that characterize the action of $\rho_i$, on a given basis $\{v_1,v_2,v_3\}$, are
# \begin{align*}
# 	[t]&=(-1)^i\begin{pmatrix}
# 		0 & 0 & 1 \\
# 		1 & 0 & 0 \\
# 		0 & 1 & 0
# 	\end{pmatrix}, &
# 	[z]&=\begin{pmatrix}
# 		    0  & 1  & 0 \\
# 		    1  & 0  & 0 \\
# 		    -1 & -1 & -1
# 	     \end{pmatrix}.
# \end{align*}
# The basis for the induced module is: $\{ ( 0 , 0 ) \otimes v_1, ( 0 , 0 ) \otimes v_2, 
# ( 0 , 0 ) \otimes  v_3 \}$. Thus, when we induce over $G$, the only nonzero matrix is $\delta_{(0,s)}=\operatorname{id}_3$.
# 
# We denote these $\mathcal{D}(G)$-modules as $M(s,\rho_i)$. 

# %% [markdown]
# ### $s=0$

# %%
idx_s     := 13;;
simpleM13 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM13);;

# %%
idx_s     := 14;;
simpleM14 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM14);;

# %% [markdown]
# \begin{array}{c|c|c}
# \text{position}&s & i \\\hline
# 7 & 0 & 1 \\
# 8 & 0 & 0
# \end{array}

# %%
SimpleNames[13]:="M(0,\\rho_{1})";;
SimpleNames[14]:="M(0,\\rho_{0})";;

# %% [markdown]
# ### $s=3$

# %%
idx_s     := 15;;
simpleM15 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM15);;

# %%
idx_s     := 16;;
simpleM16 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM16);;

# %% [markdown]
# \begin{array}{c|c|c}
# \text{position}&s & i \\\hline
# 7 & 3 & 1 \\
# 8 & 3 & 0
# \end{array}

# %%
SimpleNames[15] := "M(3,\\rho_{1})";;
SimpleNames[16] := "M(3,\\rho_{0})";;

# %% [markdown]
# ## $3$-dimensional modules attached to $(1, s)$. 
# 
# Here $s=0,3$.
# 
# Let $G_{(1, s)} = \{(b,j): b\in \mathbb{F}_4, j=0,3\} = \langle (1, 0) \rangle\times \langle (\omega^2,0) \rangle\times \langle (0,3) \rangle \cong C_{2}^3 = \langle a \rangle \times \langle b \rangle \times \langle c \rangle$, with $s = 0, 3 $. where $a^2 = b^2 = c^2 = e$. All complex irreducible representations of $G_{(1, s)}$ are one-dimensional, and there are exactly eight of them, given by the characters
# $$
# \chi_{i,j,k}(a^\alpha b^\beta c^\gamma) = (-1)^{i\alpha + j\beta + k\gamma}, ~ (i,j,k)\in \{0,1\}^3,
# $$
# where $\alpha$, $\beta$, $\gamma \in \{0,1\}$.
# 
# 
# We obtain the $\mathcal{D}(G)$-modules $M(s,(i,j,k))\coloneq M((1,s),(i,j,k)) $ as
# \begin{align*}
# 	M((1,s),(i,j,k)) 
# 	&= \Bbbk G \otimes_{\Bbbk G_{(0,s)}} \Bbbk,~\text{with } s \in \{0,3\} \text{ and } i,j,k \in \{0,1\}.
# \end{align*}
# We consider the basis: $\{ ( 0 , 0 ) \otimes  1 , ( 0 , 1 ) \otimes 1, ( 0 , 2 ) \otimes 1 \} $.
# 
# For the group elements, the matrices are:
# \begin{align*}
# 	[t] &= 
# 	\begin{pmatrix}
# 		0 & 0 & (-1)^{k} \\
# 		1 & 0 & 0 \\
# 		0 & 1 & 0
# 	\end{pmatrix},
# 	&
# 		[z] &=\operatorname{diag}\big( (-1)^i,\, (-1)^j,\, (-1)^{i+j} \big).
# \end{align*}
# 
# 
# In turn, for $\Bbbk^G$ the only nonzero matrices are:
# \begin{align*}
#  \delta_{( 1 , s )} &=E_{11} , & \delta_{( \omega , s )}&=E_{22}, & \delta_{( \omega^2 , s )} &=E_{33}.
# \end{align*}

# %%
idx_s     := 17;;
simpleM17 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM17);;

# %%
idx_s     := 18;;
simpleM18 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM18);;

# %%
idx_s     := 19;;
simpleM19 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM19);;

# %%
idx_s     := 20;;
simpleM20 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM20);;

# %%
idx_s     := 21;;
simpleM21 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM21);;

# %%
idx_s     := 22;;
simpleM22 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM22);;

# %%
idx_s     := 23;;
simpleM23 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM23);;

# %%
idx_s     := 24;;
simpleM24 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM24);;

# %% [markdown]
# \begin{array}{c|c|ccc}
# \text{position} & s & i & j & k \\\hline
# 1 & 0 & 0 & 0 & 0 \\
# 2 & 0 & 1 & 0 & 1 \\
# 3 & 0 & 1 & 0 & 0 \\
# 4 & 0 & 0 & 1 & 1 \\
# 5 & 0 & 0 & 1 & 0 \\
# 6 & 0 & 1 & 1 & 1 \\
# 7 & 0 & 1 & 1 & 0 \\
# 8 & 0 & 0 & 0 & 1
# \end{array}

# %%
SimpleNames[17]:="M(0,\\chi_{(0,0,0)})";;
SimpleNames[18]:="M(0,\\chi_{(1,0,1)})";;
SimpleNames[19]:="M(0,\\chi_{(1,0,0)})";;
SimpleNames[20]:="M(0,\\chi_{(0,1,1)})";;
SimpleNames[21]:="M(0,\\chi_{(0,1,0)})";;
SimpleNames[22]:="M(0,\\chi_{(1,1,1)})";;
SimpleNames[23]:="M(0,\\chi_{(1,1,0)})";;
SimpleNames[24]:="M(0,\\chi_{(0,0,1)})";;

# %% [markdown]
# ### $s=3$

# %%
idx_s     := 25;;
simpleM25 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM25);;

# %%
idx_s     := 26;;
simpleM26 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM26);;

# %%
idx_s     := 27;;
simpleM27 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM27);;

# %%
idx_s     := 28;;
simpleM28 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM28);;

# %%
idx_s     := 29;;
simpleM29 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM29);;

# %%
idx_s     := 30;;
simpleM30 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM30);;

# %%
idx_s     := 31;;
simpleM31 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM31);;

# %%
idx_s     := 32;;
simpleM32 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM32);;

# %% [markdown]
# \begin{array}{c|c|ccc}
# \text{position} & s & i & j & k \\\hline
# 1 & 3 & 0 & 0 & 0 \\
# 2 & 3 & 1 & 0 & 1 \\
# 3 & 3 & 1 & 0 & 0 \\
# 4 & 3 & 0 & 1 & 1 \\
# 5 & 3 & 0 & 1 & 0 \\
# 6 & 3 & 1 & 1 & 1 \\
# 7 & 3 & 1 & 1 & 0 \\
# 8 & 3 & 0 & 0 & 1
# \end{array}

# %%
SimpleNames[25]:="M(3,\\chi_{(0,0,0)})";;
SimpleNames[26]:="M(3,\\chi_{(1,0,1)})";;
SimpleNames[27]:="M(3,\\chi_{(1,0,0)})";;
SimpleNames[28]:="M(3,\\chi_{(0,1,1)})";;
SimpleNames[29]:="M(3,\\chi_{(0,1,0)})";;
SimpleNames[30]:="M(3,\\chi_{(1,1,1)})";;
SimpleNames[31]:="M(3,\\chi_{(1,1,0)})";;
SimpleNames[32]:="M(3,\\chi_{(0,0,1)})";;

# %% [markdown]
# ## $4$-dimensional modules attached to $(0, s)$.

# %% [markdown]
# Here $s\neq 0,3$.
# 
# In this case, $G_{(0, s)} = \{(0,j): j=1,\dots, 5\} = \langle (0,1) \rangle \cong C_{6} = \langle a| a^6=1 \rangle$, with $s = 1, 2, 4, 5 $. All complex irreducible representations of $G_{(0, s)}$ are one-dimensional, and there are exactly six of them, given by the characters
# $$
# \eta_{\ell}(a) = (-1)^\ell \omega^{\ell},~\ell\in \{0,1, \dots, 5\}.
# $$
# 
# We will denote the $\mathcal{D}(G)$-modules by $M(s,\ell) := M\big((0,s), \eta_\ell \big)$.
# \begin{align*}
# 	M((0,s),(\eta_\ell)) 
# 	&= \Bbbk G \otimes_{\Bbbk G_{(0,s)}} \Bbbk,~\text{with } s \in \{1,2, 4, 5\} \text{ and } \ell \in \{0,1,\dots,5\}.
# \end{align*}
# Here, we fix the basis:
# $\{
# ( 0 , 0 )\otimes 1 ,
# ( \omega , 0 )\otimes  1,
# ( 1 , 0 )\otimes 1,
# ( \omega^2 , 0 ) \otimes 1
# \}$.
# 
# In this basis, the matrices are, for each $(s, \ell)$:
# \begin{align*}
# [t]&=(-1)^\ell\omega^{\ell}\begin{pmatrix}
# 	1& 0& 0& 0 \\
# 	0& 0& 1& 0 \\
# 	0& 0& 0& 1 \\
# 	0& 1& 0& 0 
# \end{pmatrix}, &
# [z]&=\begin{pmatrix}
#     0& 0& 1& 0 \\
#     1& 0& 0& 0 \\
#     0& 0& 0& 1 \\
#     0& 1& 0& 0 
# \end{pmatrix}.
# \end{align*}
# 
# As for the elements of $\Bbbk^G$, the only nonzero matrices are
# 
# - When $s\in\{1,4\}$: $\delta_{( 0 , s )}=E_{11}$, $\delta_{( \omega^2 , s )}=E_{22}$, $\delta_{( 1 , s )}=E_{33}$ and $\delta_{( \omega , s )}=E_{44}$.
# - When $s\in\{2,5\}$: $\delta_{( 0 , s )}=E_{11}$, $\delta_{( \omega , s )}=E_{22}$, $\delta_{( \omega^2 , s )}=E_{33}$ and $\delta_{( 1, s )}=E_{44}$.

# %%
idx_s     := 33;;
simpleM33 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM33);;

# %%
idx_s     := 34;;
simpleM34 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM34);;

# %%
idx_s     := 35;;
simpleM35 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM35);;

# %%
idx_s     := 36;;
simpleM36 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM36);;

# %%
idx_s     := 37;;
simpleM37 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM37);;

# %%
idx_s     := 38;;
simpleM38 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM38);;

# %% [markdown]
# \begin{array}{c|c|c}
# \text{position} & s & \ell\\\hline  
# 1 & 1 & 0 \\
# 2 & 1 & 3 \\
# 3 & 1 & 1 \\
# 4 & 1 & 5 \\
# 5 & 1 & 2 \\
# 6 & 1 & 4
# \end{array}

# %%
SimpleNames[33]:="M(1,\\eta_{0})";;
SimpleNames[34]:="M(1,\\eta_{3})";;
SimpleNames[35]:="M(1,\\eta_{1})";;
SimpleNames[36]:="M(1,\\eta_{5})";;
SimpleNames[37]:="M(1,\\eta_{2})";;
SimpleNames[38]:="M(1,\\eta_{4})";;

# %% [markdown]
# ### $s=2$

# %%
idx_s     := 39;;
simpleM39 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM39);;

# %%
idx_s     := 40;;
simpleM40 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM40);;

# %%
idx_s     := 41;;
simpleM41 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM41);;

# %%
idx_s     := 42;;
simpleM42 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM42);;

# %%
idx_s     := 43;;
simpleM43 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM43);;

# %%
idx_s     := 44;;
simpleM44 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM44);;

# %% [markdown]
# \begin{array}{c|c|c}
# \text{position} & s & \ell\\\hline  
# 1 & 2 & 0 \\
# 2 & 2 & 3 \\
# 3 & 2 & 1 \\
# 4 & 2 & 5 \\
# 5 & 2 & 2 \\
# 6 & 2 & 4
# \end{array}

# %%
SimpleNames[39]:="M(2,\\eta_{0})";;
SimpleNames[40]:="M(2,\\eta_{3})";;
SimpleNames[41]:="M(2,\\eta_{1})";;
SimpleNames[42]:="M(2,\\eta_{5})";;
SimpleNames[43]:="M(2,\\eta_{2})";;
SimpleNames[44]:="M(2,\\eta_{4})";;

# %% [markdown]
# ### $s=4$

# %%
idx_s     := 45;;
simpleM45 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM45);;

# %%
idx_s     := 46;;
simpleM46 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM46);;

# %%
idx_s     := 47;;
simpleM47 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM47);;

# %%
idx_s     := 48;;
simpleM48 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM48);;

# %%
idx_s     := 49;;
simpleM49 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM49);;

# %%
idx_s     := 50;;
simpleM50 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM50);;

# %% [markdown]
# \begin{array}{c|c|c}
# \text{position} & s & \ell\\\hline  
# 1 & 4 & 0 \\
# 2 & 4 & 3 \\
# 3 & 4 & 1 \\
# 4 & 4 & 5 \\
# 5 & 4 & 2 \\
# 6 & 4 & 4
# \end{array}

# %%
SimpleNames[45]:="M(4,\\eta_{0})";;
SimpleNames[46]:="M(4,\\eta_{3})";;
SimpleNames[47]:="M(4,\\eta_{1})";;
SimpleNames[48]:="M(4,\\eta_{5})";;
SimpleNames[49]:="M(4,\\eta_{2})";;
SimpleNames[50]:="M(4,\\eta_{4})";;

# %% [markdown]
# ### $s=5$

# %%
idx_s     := 51;;
simpleM51 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM51);;

# %%
idx_s     := 52;;
simpleM52 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM52);;

# %%
idx_s     := 53;;
simpleM53 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM53);;

# %%
idx_s     := 54;;
simpleM54 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM54);;

# %%
idx_s     := 55;;
simpleM55 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM55);;

# %%
idx_s     := 56;;
simpleM56 := SimplesMn[idx_s];;
QGNAG_PrintDGStructureMatrices(simpleM56);;

# %% [markdown]
# \begin{array}{c|c|c}
# \text{position} & s & \ell\\\hline  
# 1 & 5 & 0 \\
# 2 & 5 & 3 \\
# 3 & 5 & 1 \\
# 4 & 5 & 5 \\
# 5 & 5 & 2 \\
# 6 & 5 & 4
# \end{array}

# %%
SimpleNames[51]:="M(5,\\eta_{0})";;
SimpleNames[52]:="M(5,\\eta_{3})";;
SimpleNames[53]:="M(5,\\eta_{1})";;
SimpleNames[54]:="M(5,\\eta_{5})";;
SimpleNames[55]:="M(5,\\eta_{2})";;
SimpleNames[56]:="M(5,\\eta_{4})";;

# %%
for i in [2..Length(SimplesMn)] do
    Print("--------------------------------------------------------------\n");
    for j in [i..Length(SimplesMn)] do
        MtensorN := QGNAG_TensorProductOfSimples(SimplesMn[i], SimplesMn[j]);
        Print(QGNAG_FusionRuleToLaTeX( MtensorN, SimplesMn, SimpleNames), "\n");
    od;
od;

# %% [markdown]
# Si cada módulo tiene exactamente un *bottom*, entonces lo que tenemos es una aplicación
# $$
# f:\{1,\dots,n\}\to\{1,\dots,n\},
# $$
# donde
# $$
# f(i)=j \text{ si y solo si } bottom(M_{i})=M_{j}.
# $$
# 
# Como además cada módulo aparece exactamente una vez como bottom, entonces $f$ es una permutación y **GAP** la construye muy fácilmente.
# 
# Supongamos que guardamos

# %%
n := Length(SimplesMn);;

# %% [markdown]
# 

# %%
ModuleData := List([1..n], i -> rec(
    top := i,
    bottom := fail
));;

# %%
ModuleData[1].bottom := 1;;   #F1F2    10
ModuleData[2].bottom := 7;;   #F1F2    00
ModuleData[3].bottom := 11;;  #F1F2    01
ModuleData[4].bottom := 12;;  #F1F2    02
ModuleData[5].bottom := 6;;   #F1F2    12
ModuleData[6].bottom := 5;;   #F1F2    11
ModuleData[7].bottom := 2;;   #e       10
ModuleData[8].bottom := 8;;   #e       00
ModuleData[9].bottom := 10;;  #e       01
ModuleData[10].bottom := 9;;  #e       02
ModuleData[11].bottom := 3;;  #e       12
ModuleData[12].bottom := 4;;  #e       11
ModuleData[13].bottom := 16;; #F1F2     0
ModuleData[14].bottom := 14;; #F1F2     1
ModuleData[15].bottom := 15;; #e        0
ModuleData[16].bottom := 13;; #e        1
ModuleData[17].bottom := 17;; #F1F2F4 001
ModuleData[18].bottom := 31;; #F1F2F4 100
ModuleData[19].bottom := 23;; #F1F2F4 101
ModuleData[20].bottom := 29;; #F1F2F4 010
ModuleData[21].bottom := 21;; #F1F2F4 011
ModuleData[22].bottom := 27;; #F1F2F4 110
ModuleData[23].bottom := 19;; #F1F2F4 111
ModuleData[24].bottom := 25;; #F1F2F4 000
ModuleData[25].bottom := 24;; #F4     001
ModuleData[26].bottom := 30;; #F4     100
ModuleData[27].bottom := 22;; #F4     101
ModuleData[28].bottom := 28;; #F4     010
ModuleData[29].bottom := 20;; #F4     011
ModuleData[30].bottom := 26;; #F4     110
ModuleData[31].bottom := 18;; #F4     111
ModuleData[32].bottom := 32;; #F4     000
ModuleData[33].bottom := 40;; #F2F2     3
ModuleData[34].bottom := 52;; #F2F2     0
ModuleData[35].bottom := 54;; #F2F2     4
ModuleData[36].bottom := 53;; #F2F2     2
ModuleData[37].bottom := 41;; #F2F2     5
ModuleData[38].bottom := 42;; #F2F2     1
ModuleData[39].bottom := 45;; #F1F2F2   3
ModuleData[40].bottom := 33;; #F1F2F2   0
ModuleData[41].bottom := 37;; #F1F2F2   4
ModuleData[42].bottom := 38;; #F1F2F2   2
ModuleData[43].bottom := 50;; #F1F2F2   5
ModuleData[44].bottom := 49;; #F1F2F2   1
ModuleData[45].bottom := 39;; #F1       3
ModuleData[46].bottom := 51;; #F1       0
ModuleData[47].bottom := 55;; #F1       4
ModuleData[48].bottom := 56;  #F1       2
ModuleData[49].bottom := 44;; #F1       5
ModuleData[50].bottom := 43;; #F1       1
ModuleData[51].bottom := 46;; #F2       3
ModuleData[52].bottom := 34;; #F2       0
ModuleData[53].bottom := 36;; #F2       4
ModuleData[54].bottom := 35;; #F2       2
ModuleData[55].bottom := 47;; #F2       5
ModuleData[56].bottom := 48;; #F2       1

# %%
perm_list := List(ModuleData, x -> x.bottom);

# %%
perm_list; # [5,3,1,4,2]

# %%
sigma := PermList(perm_list);

# %% [markdown]
# ## $\sigma$-twisted tensor product
# 
# Let $\{M_1,\dots,M_n\}$ be a complete set of representatives of the simple
# $D(G)$-modules.
# 
# For every $i,j,k\in\{1,\dots,n\}$ define the fusion coefficients by
# $$
# N_k^{\,i,j}
# =
# \dim
# \operatorname{Hom}_{D(G)}
# \!\left(
# M_i\otimes M_j,\,
# M_k
# \right).
# $$
# 
# Equivalently, the tensor product decomposes as
# $$
# M_i\otimes M_j
# \simeq
# \bigoplus_{k=1}^{n}
# M_k^{\,N_k^{\,i,j}},
# $$
# where $M_k^{\,N_k^{\,i,j}}$ denotes the direct sum of
# $N_k^{\,i,j}$ copies of $M_k$.
# 
# Now let $\sigma\in\mathbb{S}_n$
# be a permutation of the simple modules. We define the
# $\sigma$-twisted tensor product by permuting the simple summands:
# $$
# M_i\otimes_{\sigma} M_j
# :=
# \bigoplus_{k=1}^{n}
# M_{\sigma(k)}^{\,N_k^{\,i,j}}.
# $$
# 
# Equivalently, after the change of variable $\ell=\sigma(k)$,
# $$
# M_i\otimes_{\sigma} M_j
# =
# \bigoplus_{\ell=1}^{n}
# M_{\ell}^{\,N_{\sigma^{-1}(\ell)}^{\,i,j}}.
# $$
# 
# Hence the multiplicity of $M_{\ell}$ in
# $M_i\otimes_{\sigma}M_j$ is
# $$
# N_{\sigma^{-1}(\ell)}^{\,i,j}
# =
# \dim
# \operatorname{Hom}_{D(G)}
# \!\left(
# M_i\otimes_{\sigma}M_j,\,
# M_{\ell}
# \right).
# $$
# 
# ### Braided equivalence
# 
# Suppose that the permutation $\sigma$ is induced by a braided
# autoequivalence of $D(G)\text{-}\mathrm{mod}$.
# Then one expects the compatibility
# $$
# M_{\sigma(i)}\otimes M_{\sigma(j)}
# \cong
# M_i\otimes_{\sigma} M_j.
# $$
# 
# Indeed,
# $$
# M_{\sigma(i)}\otimes M_{\sigma(j)}
# =
# \bigoplus_{k=1}^{n}
# M_k^{\,N_k^{\,\sigma(i),\sigma(j)}},
# $$
# while
# $$
# M_i\otimes_{\sigma}M_j
# =
# \bigoplus_{k=1}^{n}
# M_k^{\,N_{\sigma^{-1}(k)}^{\,i,j}}.
# $$
# 
# Therefore, the above isomorphism is equivalent to the equality of
# multiplicities of every simple module:
# $$
# N_k^{\,\sigma(i),\sigma(j)}
# =
# N_{\sigma^{-1}(k)}^{\,i,j},
# \qquad
# \text{for all } i,j,k.
# $$
# 
# Consequently, verifying that $\sigma$ defines a braided autoequivalence
# reduces to checking the identity
# $$
# \boxed{
# N_k^{\,\sigma(i),\sigma(j)}
# =
# N_{\sigma^{-1}(k)}^{\,i,j}
# }
# \qquad
# \forall\, i,j,k.
# $$

# %%
for i in [2..Length(SimplesMn)] do
    for j in [i..Length(SimplesMn)] do
        MtensorN      := QGNAG_TensorProductOfSimples(SimplesMn[i], SimplesMn[j]);
        MtensorsigmaN := QGNAG_TensorProductOfSimples(SimplesMn[i^sigma], SimplesMn[j^sigma]);
        if DegreeOfRepresentation(MtensorN.rho) <> DegreeOfRepresentation(MtensorsigmaN.rho) then
            Print(StringFormatted("Dimension mismatch: i = {}, j = {}.\n", i, j));
            continue;
        fi;
        mats_MtensorN      := QGNAG_RepresentationMatrices(MtensorN);
        mats_MtensorsigmaN := QGNAG_RepresentationMatrices(MtensorsigmaN);
        remaining          := DegreeOfRepresentation(MtensorN.rho);
        for k in [1..Length(SimplesMn)] do
            Mk       := SimplesMn[k];
            mats_Mk  := QGNAG_RepresentationMatrices(Mk);
            mult_k   := QGNAG_DimHomAModules( mats_MtensorsigmaN, mats_Mk );

            Msk      := SimplesMn[k^(sigma^-1)];
            mats_Msk := QGNAG_RepresentationMatrices(Msk);
            mult_sk  := QGNAG_DimHomAModules( mats_MtensorN, mats_Msk );

            degree_k := DegreeOfRepresentation(Mk.simple);

            if mult_k <> mult_sk then
                Print( "Mismatch: i=", i, " j=", j, " k=", k, "  ", mult_k, " <> ", mult_sk, "\n" );
                break;
            fi;

            if mult_k > 0 then
                remaining := remaining - mult_k * degree_k;
                if remaining = 0 then
                    break;
                fi;
            fi;
        od;
    od;
od;

# %%



