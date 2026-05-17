t0 := NanosecondsSinceEpoch();;
LoadPackage("SCSCP", false);
log_path:=Concatenation("~/AFFINERACK/ytopxtop_", DateISO8601(), ".log");
# LogTo("/home/juandavid/Descargas/gap-4.13.1/pkg/qgnag/examples/YtopXtop/DURGA/gap_affine_rack.log");
LogTo(log_path);
LoadPackage("GBNP");;
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
# =====================================================
# 1. Álgebra libre sobre Q
# =====================================================
nX := 4;;
nElemOfG := 4;;
nDelta := 24;;
nY := 4;;
nTotal := nX + nElemOfG +  nDelta + nY;;
F := FreeAssociativeAlgebraWithOne(Rationals, nTotal);;
gens := GeneratorsOfAlgebra(F);;
e:=gens[1];;
# ==================================================
# 1. Generadores X_j's
# ==================================================
X0:=gens[2];;
X1:=gens[3];;
X2:=gens[4];;
X3:=gens[5];;
# ==================================================
# 2. Generadores g's
# ==================================================
F1:=gens[6];;
F2:=gens[7];;
F3:=gens[8];;
F4:=gens[9];;
# ==================================================
# 3. Generadores \delta_g's
# ==================================================
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
# ==================================================
# 4. Generadores Y_j's
# ==================================================
Y0:=gens[34];;
Y1:=gens[35];;
Y2:=gens[36];;
Y3:=gens[37];;

allgens := [
    X0,
    X1,
    X2,
    X3,
    F1,
    F2,
    F3,
    F4,
    De,
    DF1,
    DF2,
    DF1F2,
    DF2F2,
    DF1F2F2, 
    DF4,
    DF4F1,
    DF2F3,
    DF1F2F4,
    DF2F3F2,
    DF1F2F2F3,
    DF3,
    DF1F4,
    DF3F2,
    DF1F2F3,
    DF2F2F4,
    DF1F2F3F2,
    DF3F4,
    DF1F3,
    DF2F4,
    DF1F3F2, 
    DF2F2F3,
    DF1F2F2F4,
    Y0,
    Y1,
    Y2,
    Y3
];;
gensX:=GP2NPList(allgens{[1..4]});
gensG:=GP2NPList(allgens{[5..8]});
gensDeltas:=GP2NPList(allgens{[9..32]});
gensY:=GP2NPList(allgens{[33..36]});

gensT4 := Elements(GF(4));;
xIndex := [1..4];;
relationsT4 := [];;

for i in [1..Length(gensT4)] do
    Add(relationsT4, gens[i+1]^2);;
od;

PrintNPList(List(relationsT4, el-> GP2NP(el)));

## x3x2 + x2x1 + x1x3 = 0,
Add(relationsT4, X3*X2 + X2*X1 + X1*X3 );;
## x3x1 + x1x0 + x0x3 = 0,
Add(relationsT4, X3*X1 + X1*X0 + X0*X3 );;
## x3x0 + x0x2 + x2x3 = 0,
Add(relationsT4, X3*X0 + X0*X2 + X2*X3 );;
## x2x0 + x0x1 + x1x2 = 0,
Add(relationsT4, X2*X0 + X0*X1 + X1*X2 );;
## x2x1x0x2x1x0 +x1x0x2x1x0x2 +x0x2x1x0x2x1 = 0.
Add(relationsT4, X2*X1*X0*X2*X1*X0+X1*X0*X2*X1*X0*X2+X0*X2*X1*X0*X2*X1 );;

relsT4:=GP2NPList(relationsT4);;
PrintNPList(relsT4);

J := SGrobner(relsT4);;

PrintNPList( J );

DimQA(J, 4);

yIndex := [34..37];;
relationsT4dual := [];;
for j in [1..Length(gensT4)] do
    Add(relationsT4dual, gens[yIndex[j]]^2);;
od;

PrintNPList(List(relationsT4dual, el-> GP2NP(el)));

## x3x2 + x2x1 + x1x3 = 0,
## Y2Y3 + Y1Y2 + Y3Y1 = 0,
Add(relationsT4dual, Y2*Y3 + Y1*Y2 + Y3*Y1 );;
## x3x1 + x1x0 + x0x3 = 0,
## Y1Y3 + Y0Y1 + Y3Y0 = 0,
Add(relationsT4dual, Y1*Y3 + Y0*Y1 + Y3*Y0 );;
## x3x0 + x0x2 + x2x3 = 0,
## Y0Y3+ Y2Y0 + Y3Y2 = 0,
Add(relationsT4dual, Y0*Y3 + Y2*Y0 + Y3*Y2 );;
## x2x0 + x0x1 + x1x2 = 0,
## Y0Y2 + Y1Y0 + Y2Y1 = 0,
Add(relationsT4dual, Y0*Y2 + Y1*Y0 + Y2*Y1 );;
## x2x1x0x2x1x0 + x1x0x2x1x0x2 +x0x2x1x0x2x1 = 0.
# Add(relationsT4dual, Y3*Y1*Y0*Y3*Y1*Y0 + Y1*Y0*Y3*Y1*Y0*Y3 + Y0*Y3*Y1*Y0*Y3*Y1 );;
## x2x1x0x2x1x0 + x1x0x2x1x0x2 +x0x2x1x0x2x1 = 0.
## Y0Y1Y2Y0Y1Y2 + Y2Y0Y1Y2Y0Y1 + Y1Y2Y0Y1Y2Y0 = 0.
Add(relationsT4dual, Y0*Y1*Y2*Y0*Y1*Y2 + Y2*Y0*Y1*Y2*Y0*Y1 + Y1*Y2*Y0*Y1*Y2*Y0 );;

relsT4dual:=GP2NPList(relationsT4dual);;
PrintNPList(relsT4dual);

I := Concatenation(
    gensX,
    gensG,
    gensDeltas,
    relsT4dual    # 9 rels
);;

J := SGrobner(I);;

DimQA(J, 36);

relsGroup := [
    F3^2-e,            # 1
    F4^2-e,            # 2
    F2^3-e,            # 3
    F1^2*F2^2-e,       # 4
    F1*F4*F1^5*F3-e,   # 5
    (F3*F4)^2-e,       # 6
    F3*F1*F3*F1^5*F4-e # 7
];;

relsGroup := GP2NPList( relsGroup );;
PrintNPList( relsGroup );

J := SGrobner(Concatenation(
    relsGroup,
    gensX,
    # gensG,
    gensDeltas,
    gensY
    )
);;

PrintNPList( J );

DimQA(J, 36);

genskG :=[
    De,                        #1 e           (0, 0)
    DF1,                       #2 F1          (0, g)       
    DF2,                       #3 F2          (0, g^2)
    DF1F2,                     #6 F1F2        (0, g^3) 
    DF2F2,                     #9 F2^2        (0, g^4)
    DF1F2F2,                   #13 F1F2^2     (0, g^5)
    
    DF4,                       #5 F4          (1, 0)
    DF4F1,                     #16 F4F1       (1, g)
    DF2F3,                     #10 F2F3       (1, g^2)
    DF1F2F4,                   #15 F1F2F4     (1, g^3)
    DF2F3F2,                   #23 F2F3F2     (1, g^4)
    DF1F2F2F3,                 #20 F1F2^2F3   (1, g^5)
    
    DF3,                       #4 F3          (w, 0)
    DF1F4,                     #8 F1F4        (w, g)
    DF3F2,                     #19 F3F2       (w, g^2)
    DF1F2F3,                   #14 F1F2F3     (w, g^3)
    DF2F2F4,                   #18 F2^2F4     (w, g^4)
    DF1F2F3F2,                 #24 F1F2F3F2   (w, g^5)
    
    DF3F4,                     #12 F3F4       (w^2, 0)
    DF1F3,                     #7 F1F3        (w^2, g) 
    DF2F4,                     #11 F2F4       (w^2, g^2)
    DF1F3F2,                   #22 F1F3F2     (w^2, g^3) 
    DF2F2F3,                   #17 F2^2F3     (w^2, g^4)
    DF1F2F2F4                  #23 F1F2^2F4   (w^2, g^5)
];;

relationskG := [];;
for i in [1..24] do
  for j in [1..24] do
    if i <> j then
      Add(relationskG, genskG[i]*genskG[j]);  # = 0
    else 
      Add(relationskG, genskG[i]*genskG[j]- genskG[i]);  # = 0 
    fi;
  od;
od;

Add(relationskG,
    De +
    DF1 +
    DF2 +
    DF3 +
    DF4 +
    DF1F2 +
    DF1F3 +
    DF1F4 +
    DF2F2 +
    DF2F3 +
    DF2F4 +
    DF3F2 +
    DF3F4 +
    DF4F1 +
    DF1F2F2 +
    DF1F2F3 +
    DF1F2F4 +
    DF1F3F2 +
    DF2F2F3 +
    DF2F2F4 +
    DF2F3F2 +
    DF1F2F2F3 +
    DF1F2F2F4 +
    DF1F2F3F2 -
    One(F)
);

Print("Se generaron ", Length(relationskG), " relaciones en k^G.\n");
relskG := GP2NPList(relationskG);;
PrintNPList(relskG);

J := SGrobner(Concatenation(
    relskG,
    gensX,
    gensG,
    gensY
    )
);;

DimQA(J, 36);
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
    F1*F2^2*F3*F4,    #24 F1F2F3F2   (w, g^5)
    F3*F4,           #12 F3F4       (w^2, 0)
    F1*F3,           #7 F1F3        (w^2, g)
    F2*F4,           #11 F2F4       (w^2, g^2)
    F1*F3*F2,        #22 F1F3F2     (w^2, g^3) 
    F2^2*F3,         #17 F2^2F3     (w^2, g^4)
    F1*F2^2*F4      #23 F1F2^2F4   (w^2, g^5)  
];;

groupIndex:=List(groupElemsInF, elm -> GP2NP(elm)[1][1]);;

K := SmallGroup(4,2);;
AutK := AutomorphismGroup( K );;
H := CyclicGroup(6);;
AllHoms := AllHomomorphisms(H, AutK);;
T := AllHoms[5];;
G := SemidirectProduct(H, T, K);;

allPairsInG:=[
    G.3^2,             #1 1           (0, 0)
    G.1,               #2 F1          (0, g)
    G.2,               #3 F2          (0, g^2)
    G.1*G.2,           #6 F1F2        (0, g^3)
    G.2^2,             #9 F2^2        (0, g^4)
    G.1*G.2^2,         #13 F1F2^2     (0, g^5) 
    G.4,               #5 F4          (1, 0)
    G.4*G.1,           #16 F4F1       (1, g)
    G.2*G.3,           #10 F2F3       (1, g^2)
    G.1*G.2*G.4,       #15 F1F2F4     (1, g^3)
    G.2*G.3*G.2,       #23 F2F3F2     (1, g^4)
    G.1*G.2^2*G.3,     #20 F1F2^2F3   (1, g^5)  
    G.3,               #4 F3          (w, 0)
    G.1*G.4,           #8 F1F4        (w, g)
    G.3*G.2,           #19 F3F2       (w, g^2)
    G.1*G.2*G.3,       #14 F1F2F3     (w, g^3)
    G.2^2*G.4,         #18 F2^2F4     (w, g^4)
    G.1*G.2^2*G.3*G.4, #24 F1F2F3F2   (w, g^5)
    G.3*G.4,           #12 F3F4       (w^2, 0)
    G.1*G.3,           #7 F1F3        (w^2, g)
    G.2*G.4,           #11 F2F4       (w^2, g^2)
    G.1*G.3*G.2,       #22 F1F3F2     (w^2, g^3) 
    G.2^2*G.3,         #17 F2^2F3     (w^2, g^4)
    G.1*G.2^2*G.4      #23 F1F2^2F4   (w^2, g^5)  
];;

deltaIndex := [9..32];;
relsDG := [];;

for g in allPairsInG do
    for h in allPairsInG do
        pos_g := Position(allPairsInG, g);
        pos_h := Position(allPairsInG, h);
        if pos_g = fail or pos_h = fail then
            Error("Elemento no encontrado en allPerms");
        fi;
        delta_h := deltaIndex[pos_h];

        conj := g^-1 * h * g;
        pos_conj := Position(allPairsInG, conj);
        if pos_conj = fail then
            Error("No se encontró conjugado");
        fi;

        delta_conj := deltaIndex[pos_conj];

        g_word := groupIndex[pos_g];

        m1 := Concatenation([delta_h], g_word);    # δ_h * g
        m2 := Concatenation(g_word, [delta_conj]); # g * δ_{g^-1*h*g }

        # Relación δ_h g - g δ_{g^-1*h*g} = 0
        Add(relsDG, [ [m1, m2], [1, -1] ]);
    od;
od;

Print("Se generaron ", Length(relsDG), " relaciones δ_h g = g δ_{g^-1*h*g}.\n");
PrintNPList(relsDG);

J := SGrobner(Concatenation(
    relsGroup,
    relskG,
    relsDG,
    gensX,
    gensY
    )
);;
DimQA(J, 36);

Read("~/AFFINERACK/affinerack.g");
# Read("/home/juandavid/Documentos/FAMAF/TRABAJO/DURGA/affinerack.g");

GetElementsOfG:=function(elms, m)
    local l, k, g, p, elmsofG;
    elmsofG:=[];;
    for l in [1..Length(elms)] do
        for k in [0..(m-1)] do
            g := ElementOfSemidirectProduct(elms[l], k);
            Add(elmsofG, g);
        od;
    od;
    return elmsofG;
end;

p:=4;;
m:=6;;
elms:=Elements(GF(p));;
groupElemsInSDP:=GetElementsOfG(elms, m);;

for idx in [1..Length(groupElemsInSDP)] do
    groupElemsInSDP[idx].index:=groupIndex[idx];
od;

Caso1:=Filtered(groupElemsInSDP, el->el.fieldPart = gensT4[1]);;
Caso2:=Filtered(groupElemsInSDP, el->el.fieldPart = gensT4[2]);;
Caso3:=Filtered(groupElemsInSDP, el->el.fieldPart = gensT4[3]);;
Caso4:=Filtered(groupElemsInSDP, el->el.fieldPart = gensT4[4]);;

RelationsGivenByT4smashkG := function(j, gensA, xIndex, groupElems)
    local relsxBosTest, g,k, action, chi_s, posAction, leftMon, rightMon;

    relsxBosTest := [];;
    for g in groupElems do
        action := ActionOfSemidirectProductOnF4(g, j); # acción de G sobre A
        chi_s := ChiForSemidirectProduct(g);           # Definciion de Chi
        posAction := Position(gensA, action.fieldPart);
        k := Position(gensA, j);
        if posAction <> fail then
            leftMon := Concatenation(g.index, [xIndex[k]]);
            rightMon := Concatenation([xIndex[posAction]], g.index);
            Add(relsxBosTest, [[ leftMon, rightMon], [1, -chi_s] ]);
        fi;
    od;
    return relsxBosTest;
end;
gensA := Elements(GF(4));;
xIndex := [1, 2, 3, 4];;
rels0Caso1:=RelationsGivenByT4smashkG(gensA[1], gensA, xIndex, Caso1);;
rels0Caso2:=RelationsGivenByT4smashkG(gensA[1], gensA, xIndex, Caso2);;
rels0Caso3:=RelationsGivenByT4smashkG(gensA[1], gensA, xIndex, Caso3);;
rels0Caso4:=RelationsGivenByT4smashkG(gensA[1], gensA, xIndex, Caso4);;
rels1Caso1:=RelationsGivenByT4smashkG(gensA[2], gensA, xIndex, Caso1);;
rels1Caso2:=RelationsGivenByT4smashkG(gensA[2], gensA, xIndex, Caso2);;
rels1Caso3:=RelationsGivenByT4smashkG(gensA[2], gensA, xIndex, Caso3);;
rels1Caso4:=RelationsGivenByT4smashkG(gensA[2], gensA, xIndex, Caso4);;
relsOmegaCaso1:=RelationsGivenByT4smashkG(gensA[3], gensA, xIndex, Caso1);;
relsOmegaCaso2:=RelationsGivenByT4smashkG(gensA[3], gensA, xIndex, Caso2);;
relsOmegaCaso3:=RelationsGivenByT4smashkG(gensA[3], gensA, xIndex, Caso3);;
relsOmegaCaso4:=RelationsGivenByT4smashkG(gensA[3], gensA, xIndex, Caso4);;
relsOmega2Caso1:=RelationsGivenByT4smashkG(gensA[4], gensA, xIndex, Caso1);;
relsOmega2Caso2:=RelationsGivenByT4smashkG(gensA[4], gensA, xIndex, Caso2);;
relsOmega2Caso3:=RelationsGivenByT4smashkG(gensA[4], gensA, xIndex, Caso3);;
relsOmega2Caso4:=RelationsGivenByT4smashkG(gensA[4], gensA, xIndex, Caso4);;

relsxBos:=Concatenation(
    rels0Caso1,
    rels0Caso2,
    rels0Caso3,
    rels0Caso4,
    rels1Caso1,
    rels1Caso2,
    rels1Caso3,
    rels1Caso4,
    relsOmegaCaso1,
    relsOmegaCaso2,
    relsOmegaCaso3,
    relsOmegaCaso4,
    relsOmega2Caso1,
    relsOmega2Caso2,
    relsOmega2Caso3,
    relsOmega2Caso4
);;

Print("Se generaron ", Length(relsxBos), " relaciones en total.\n");
PrintNPList(relsxBos);

J := SGrobner(Concatenation(
    relsT4,
    relsxBos,
    relsGroup,
    gensDeltas,
    gensY
    )
);;
DimQA(J, 36);

RelationsGivenByT4smashkGdual:=function(j, gensA, yIndex, groupElems)
    local relsyBosTest, g, ginv, k, action, chi_s, posAction, leftMon, rightMon;
    relsyBosTest := [];;
    for g in groupElems do
        ginv := InverseElementOfSemidirectProduct(g);
        action := ActionOfSemidirectProductOnF4(ginv, j); # acción de G sobre A
        chi_s := ChiForSemidirectProduct(g);              # Definciion de Chi
        posAction := Position(gensA, action.fieldPart);
        k := Position(gensA, j);
        if posAction <> fail then
            leftMon := Concatenation([yIndex[k]], g.index);
            rightMon := Concatenation(g.index, [yIndex[posAction]]);
            Add(relsyBosTest, [[ leftMon, rightMon], [1, -chi_s] ]);  # estructura válida para PrintNP
        fi;
    od;
    return relsyBosTest;
end;

yIndex := [33, 34, 35, 36];;
rels0Caso1:=RelationsGivenByT4smashkGdual(gensA[1], gensA, yIndex, Caso1);;
rels0Caso2:=RelationsGivenByT4smashkGdual(gensA[1], gensA, yIndex, Caso2);;
rels0Caso3:=RelationsGivenByT4smashkGdual(gensA[1], gensA, yIndex, Caso3);;
rels0Caso4:=RelationsGivenByT4smashkGdual(gensA[1], gensA, yIndex, Caso4);;
rels1Caso1:=RelationsGivenByT4smashkGdual(gensA[2], gensA, yIndex, Caso1);;
rels1Caso2:=RelationsGivenByT4smashkGdual(gensA[2], gensA, yIndex, Caso2);;
rels1Caso3:=RelationsGivenByT4smashkGdual(gensA[2], gensA, yIndex, Caso3);;
rels1Caso4:=RelationsGivenByT4smashkGdual(gensA[2], gensA, yIndex, Caso4);;
relsOmegaCaso1:=RelationsGivenByT4smashkGdual(gensA[3], gensA, yIndex, Caso1);;
relsOmegaCaso2:=RelationsGivenByT4smashkGdual(gensA[3], gensA, yIndex, Caso2);;
relsOmegaCaso3:=RelationsGivenByT4smashkGdual(gensA[3], gensA, yIndex, Caso3);;
relsOmegaCaso4:=RelationsGivenByT4smashkGdual(gensA[3], gensA, yIndex, Caso4);;
relsOmega2Caso1:=RelationsGivenByT4smashkGdual(gensA[4], gensA, yIndex, Caso1);;
relsOmega2Caso2:=RelationsGivenByT4smashkGdual(gensA[4], gensA, yIndex, Caso2);;
relsOmega2Caso3:=RelationsGivenByT4smashkGdual(gensA[4], gensA, yIndex, Caso3);;
relsOmega2Caso4:=RelationsGivenByT4smashkGdual(gensA[4], gensA, yIndex, Caso4);;

relsyBos:=Concatenation(
    rels0Caso1,
    rels0Caso2,
    rels0Caso3,
    rels0Caso4,
    rels1Caso1,
    rels1Caso2,
    rels1Caso3,
    rels1Caso4,
    relsOmegaCaso1,
    relsOmegaCaso2,
    relsOmegaCaso3,
    relsOmegaCaso4,
    relsOmega2Caso1,
    relsOmega2Caso2,
    relsOmega2Caso3,
    relsOmega2Caso4
);;

Print("Se generaron ", Length(relsyBos), " relaciones en total.\n");
PrintNPList(relsyBos);

I := Concatenation(
    gensX,
    gensDeltas,
    relsGroup,    # 7 rels
    relsyBos,     # 96 rels
    relsT4dual    # 9 rels
);;

J := SGrobner(I);;

DimQA(J, 36);

groupElemsInSDPBase:=[];;

for j in Elements(GF(4)) do
    for k in [1..6] do
        Add(groupElemsInSDPBase, ElementOfSemidirectProduct(j, k-1));;
    od;
od;

RelationsGivenByT4dualsmashkG:=function(j, gensA, xIndex, groupElems)
    local relsDx, x_j, elmToDelta, deltaIndex, h, pos_h, delta_h,
            g_j, g_jinv, prod,pos_prod, delta_prod, m1, m2;
    
    x_j := xIndex[Position( gensA, j)];
    deltaIndex := [9..32];;
    elmToDelta := [9..32];;
    relsDx := [];;
    for h in groupElems do
        if IsBound(h.index) then
            Unbind(h.index);
        fi;
        pos_h := Position(groupElemsInSDPBase, h);
        delta_h := elmToDelta[pos_h];
        g_j:=ElementOfSemidirectProduct(j, 1);
        g_jinv:=InverseElementOfSemidirectProduct(g_j);
        prod := SemidirectProductMultiply(g_jinv, h);
        pos_prod := Position(groupElemsInSDPBase, prod);
        delta_prod := elmToDelta[pos_prod];
        m1 := Concatenation([delta_h], [x_j]);
        m2 := Concatenation([x_j], [delta_prod]);
        Add(relsDx, [ [m1, m2], [1, -1] ]);
    od;
    
    return relsDx;

end;
rels0Caso1:=RelationsGivenByT4dualsmashkG(gensA[1], gensA, xIndex, Caso1);;
rels0Caso2:=RelationsGivenByT4dualsmashkG(gensA[1], gensA, xIndex, Caso2);;
rels0Caso3:=RelationsGivenByT4dualsmashkG(gensA[1], gensA, xIndex, Caso3);;
rels0Caso4:=RelationsGivenByT4dualsmashkG(gensA[1], gensA, xIndex, Caso4);;
rels1Caso1:=RelationsGivenByT4dualsmashkG(gensA[2], gensA, xIndex, Caso1);;
rels1Caso2:=RelationsGivenByT4dualsmashkG(gensA[2], gensA, xIndex, Caso2);;
rels1Caso3:=RelationsGivenByT4dualsmashkG(gensA[2], gensA, xIndex, Caso3);;
rels1Caso4:=RelationsGivenByT4dualsmashkG(gensA[2], gensA, xIndex, Caso4);;
relsOmegaCaso1:=RelationsGivenByT4dualsmashkG(gensA[3], gensA, xIndex, Caso1);;
relsOmegaCaso2:=RelationsGivenByT4dualsmashkG(gensA[3], gensA, xIndex, Caso2);;
relsOmegaCaso3:=RelationsGivenByT4dualsmashkG(gensA[3], gensA, xIndex, Caso3);;
relsOmegaCaso4:=RelationsGivenByT4dualsmashkG(gensA[3], gensA, xIndex, Caso4);;
relsOmega2Caso1:=RelationsGivenByT4dualsmashkG(gensA[4], gensA, xIndex, Caso1);;
relsOmega2Caso2:=RelationsGivenByT4dualsmashkG(gensA[4], gensA, xIndex, Caso2);;
relsOmega2Caso3:=RelationsGivenByT4dualsmashkG(gensA[4], gensA, xIndex, Caso3);;
relsOmega2Caso4:=RelationsGivenByT4dualsmashkG(gensA[4], gensA, xIndex, Caso4);;
relsDx:=Concatenation(
    rels0Caso1,
    rels0Caso2,
    rels0Caso3,
    rels0Caso4,
    rels1Caso1,
    rels1Caso2,
    rels1Caso3,
    rels1Caso4,
    relsOmegaCaso1,
    relsOmegaCaso2,
    relsOmegaCaso3,
    relsOmegaCaso4,
    relsOmega2Caso1,
    relsOmega2Caso2,
    relsOmega2Caso3,
    relsOmega2Caso4
);;

Print("Se generaron ", Length(relsDx), " relaciones en total.\n");
PrintNPList(relsDx);
J := SGrobner(Concatenation(
    relsT4,
    relskG,
    relsDx,
    gensG,
    gensY
    )
);;
DimQA(J, 36);

RelationsGivenByT4dualsmashkGdual:=function(j, gensA, yIndex, groupElems)
    local relsDx, y_j, elmToDelta, deltaIndex, h, pos_h, delta_h,
            g_j, g_jinv, prod,pos_prod, delta_prod, m1, m2;
    
    y_j := yIndex[Position( gensA, j)];
    deltaIndex := [9..32];;
    elmToDelta := [9..32];;
    relsDx := [];;

    for h in groupElems do
        pos_h := Position(groupElemsInSDPBase, h);
        delta_h := elmToDelta[pos_h];
        g_j:=ElementOfSemidirectProduct(j, 1);
        prod := SemidirectProductMultiply(g_j, h);
        pos_prod := Position(groupElemsInSDPBase, prod);
        delta_prod := elmToDelta[pos_prod];
        m1 := Concatenation([delta_h], [y_j]);    # δ_h * y_i
        m2 := Concatenation([y_j], [delta_prod]);
        Add(relsDx, [ [m1, m2], [1, -1] ]);
    od;
    
    return relsDx;

end;

rels0Caso1:=RelationsGivenByT4dualsmashkGdual(gensA[1], gensA, yIndex, Caso1);;
rels0Caso2:=RelationsGivenByT4dualsmashkGdual(gensA[1], gensA, yIndex, Caso2);;
rels0Caso3:=RelationsGivenByT4dualsmashkGdual(gensA[1], gensA, yIndex, Caso3);;
rels0Caso4:=RelationsGivenByT4dualsmashkGdual(gensA[1], gensA, yIndex, Caso4);;
rels1Caso1:=RelationsGivenByT4dualsmashkGdual(gensA[2], gensA, yIndex, Caso1);;
rels1Caso2:=RelationsGivenByT4dualsmashkGdual(gensA[2], gensA, yIndex, Caso2);;
rels1Caso3:=RelationsGivenByT4dualsmashkGdual(gensA[2], gensA, yIndex, Caso3);;
rels1Caso4:=RelationsGivenByT4dualsmashkGdual(gensA[2], gensA, yIndex, Caso4);;
relsOmegaCaso1:=RelationsGivenByT4dualsmashkGdual(gensA[3], gensA, yIndex, Caso1);;
relsOmegaCaso2:=RelationsGivenByT4dualsmashkGdual(gensA[3], gensA, yIndex, Caso2);;
relsOmegaCaso3:=RelationsGivenByT4dualsmashkGdual(gensA[3], gensA, yIndex, Caso3);;
relsOmegaCaso4:=RelationsGivenByT4dualsmashkGdual(gensA[3], gensA, yIndex, Caso4);;
relsOmega2Caso1:=RelationsGivenByT4dualsmashkGdual(gensA[4], gensA, yIndex, Caso1);;
relsOmega2Caso2:=RelationsGivenByT4dualsmashkGdual(gensA[4], gensA, yIndex, Caso2);;
relsOmega2Caso3:=RelationsGivenByT4dualsmashkGdual(gensA[4], gensA, yIndex, Caso3);;
relsOmega2Caso4:=RelationsGivenByT4dualsmashkGdual(gensA[4], gensA, yIndex, Caso4);;

relsDy:=Concatenation(
    rels0Caso1,
    rels0Caso2,
    rels0Caso3,
    rels0Caso4,
    rels1Caso1,
    rels1Caso2,
    rels1Caso3,
    rels1Caso4,
    relsOmegaCaso1,
    relsOmegaCaso2,
    relsOmegaCaso3,
    relsOmegaCaso4,
    relsOmega2Caso1,
    relsOmega2Caso2,
    relsOmega2Caso3,
    relsOmega2Caso4
);;
Print("Se generaron ", Length(relsDy), " relaciones en total.\n");
PrintNPList(relsDy);
I := Concatenation(
    gensX,
    gensG,
    relskG,
    relsDy,
    relsT4dual    # 9 rels
);;

J := SGrobner(I);;
DimQA(J, 36);

TransporterOfG := function( G, i, j )
    local ress, g, p, m, res;
    p:=4;;
    m:=6;;
    ress:=[];;
    for g in G do
        res := ActionOfSemidirectProductOnF4(g , i);
        if res.fieldPart = j then
            Add(ress, g);
        fi;
    od;
    return ress;
end;

ChiForSemidirectProduct := function(x)
    if not IsBound(x.fieldPart) or not IsBound(x.cyclicPart) then
        Error("El argumento no es un ElementOfSemidirectProduct");
    fi;
    return (-1)^x.cyclicPart;;
end;

IndexForDeltasInConmutationRules:= function(trsp, i)
    local g, g_i, g_i_inverse, delta_index, res;
    g_i := ElementOfSemidirectProduct(i, 1);;
    g_i_inverse := InverseElementOfSemidirectProduct(g_i);;
    
    delta_index:=[];;
    
    for g in trsp do 
        res := SemidirectProductMultiply(g_i_inverse , g);
        Add(delta_index, res);
    od;
    return delta_index;
end;

GetConmutationRuleOnD := function(i, j)
    local xIndex, yIndex, elmToDelta, gensA,
          deltaIndex, g_i, g_i_inverse, res, pos_x_i,
          pos_y_j, pos_g_i, pos_k, index_g_i, pos_res, elmsInSDP,
          trsp, mji, mij, coeff, relstrsp, index_delta;
          
    xIndex := [ 1..4 ];;
    deltaIndex := [ 9..32 ];;
    elmToDelta := [ 9..32 ];;
    yIndex := [ 33..36 ];;

    gensA := Elements( GF( 4 ) );;

    pos_x_i := xIndex[ Position( gensA, i ) ];;
    pos_y_j := yIndex[ Position( gensA, j ) ];;

    elmsInSDP := GetElementsOfG( gensA , 6 );;

    g_i := ElementOfSemidirectProduct( i, 1 );;               # elemento g en F4⋊C6
    g_i_inverse := InverseElementOfSemidirectProduct( g_i );; # elemento inverso de g en F4⋊C6
    res := ActionOfSemidirectProductOnF4( g_i_inverse , j );; # elemento en F4
    
    pos_g_i := Position( elmsInSDP, g_i );;
    index_g_i := groupIndex[ pos_g_i ];;
    pos_res := yIndex[ Position( gensA, res.fieldPart ) ];;

    mji := Concatenation( [ pos_y_j ], [ pos_x_i ] );;    # Y_j * X_i
    mij := Concatenation( [ pos_x_i ], [ pos_res ] );;    # X_i * Y_j
    
    
    relstrsp := [ ];;
    
    Add( relstrsp, mji );
    Add( relstrsp, mij );
    # Recorremos los transporters
    trsp := TransporterOfG( elmsInSDP, i, j);;
    coeff := [ 1, 1 ];;
    if i = j then
        Add( relstrsp, [ ] );;
        Add( coeff, -1 );;
    fi;
    
    for k in [ 1..Length( trsp ) ] do
        pos_k := Position( elmsInSDP, SemidirectProductMultiply(
            g_i_inverse ,
            SemidirectProductMultiply(trsp[ k ], g_i))
        );
        index_delta := deltaIndex[pos_k];
        Add( relstrsp, Concatenation( index_g_i, [ index_delta ] ));
        Add( coeff, ChiForSemidirectProduct( trsp[ k ] ) );
    od;
    return [ relstrsp, coeff ];
end;

relsQG:=[];;
for p in Elements(GF(4)) do
    for q in Elements(GF(4)) do
        Add(relsQG, GetConmutationRuleOnD(p, q));
    od;
od;
Print("Se generaron ", Length(relsQG), " relaciones en total.\n");
PrintNPList(relsQG);
I := Concatenation(
    relsT4,       # 9 rels
    # ------------------------
    relsGroup,    # 7 rels
    relskG,       # 577 rels
    relsDG,       # 576 rels
    # ------------------------
    relsxBos,     # 96 rels
    relsDx,       # 96 rels
    relsDy,       # 96 rels
    relsyBos,     # 96 rels
    # --------------------------
    relsQG,       # 16 rels
    # --------------------------
    relsT4dual    # 9 rels
);;

9*2 + 7 + 577 + 576 + 96*4 + 16;
Length(I);

Print("# =====================================================\n");
Print("- Paso 5: Calcular la base de Gröbner\n");
Print("# =====================================================\n");
J := SGrobner(I);;

t1 := NanosecondsSinceEpoch();;
dur := (t1 - t0) / 1000000000.0;;

horas := Int(dur / 3600);;
minutos := Int((dur - horas * 3600) / 60);;
segundos := Round(dur - horas * 3600 - minutos * 60);;

Print("\n=====================================\n");
Print("Tiempo total de ejecución:\n");
Print(String(horas), " horas, ", String(minutos), " minutos, ", String(segundos), " segundos.\n");
Print("=====================================\n");

Print("# =====================================================\n");
Print("- Paso 6: Calcular Dimensión la base de Gröbner\n");
Print("# =====================================================\n");

PrintNPList( J );

Print("# ================================\n");
Print("#              DimQA(J, 36);      \n");
Print("# ================================\n");

DimQA(J, 36);

Print("# ================================\n");
Print("#         72 *  24 * 24 * 72      \n");
Print("# ================================\n");
72 *  24 * 24 * 72;

Print("----------------------------------------------\n");
Print(Concatenation("                 - ", String(72 *  24 * 24 * 72) ," -\n"));
Print("----------------------------------------------\n");

Print("Xtop: \n");
Xtop:=GP2NP(X0*X1*X0*X2*X1*X0*X2*X1*X3);
PrintNP(Xtop);
Print("Ytop: \n");
Ytop:=GP2NP(Y0*Y1*Y0*Y2*Y0*Y1*Y2*Y0*Y3);
PrintNP(Ytop);
Print("YtopXtop: \n");
YtopXtop:=MulNP(Ytop, Xtop);
YtopXtopres:=StrongNormalFormNP(YtopXtop, J);


Print("Y0Xtop: \n");
Y0Xtop:=MulNP(GP2NP(Y0), Xtop);
PrintNP(StrongNormalFormNP(Y0Xtop, J));
Print("StrongNormalFormNP(Y0Xtop, J);\n");
Y0Xtopres:=StrongNormalFormNP(Y0Xtop, J);

Print("Y1Xtop: \n");
Y1Xtop:=MulNP(GP2NP(Y1), Xtop);
PrintNP(StrongNormalFormNP(Y1Xtop, J));
Print("StrongNormalFormNP(Y1Xtop, J);\n");
Y1Xtopres:=StrongNormalFormNP(Y1Xtop, J);

Print("Y2Xtop: ");
Y2Xtop:=MulNP(GP2NP(Y2), Xtop);
PrintNP(StrongNormalFormNP(Y2Xtop, J));
Print("StrongNormalFormNP(Y2Xtop, J);\n");
Y2Xtopres:=StrongNormalFormNP(Y2Xtop, J);

Print("Y3Xtop: ");
Y3Xtop:=MulNP(GP2NP(Y3), Xtop);
PrintNP(StrongNormalFormNP(Y3Xtop, J));
Print("StrongNormalFormNP(Y3Xtop, J);\n");
Y3Xtopres:=StrongNormalFormNP(Y3Xtop, J);

Print("------------ Memory Usage By GAP in Gbytes ----------------\n");
mem_kb := MemoryUsageByGAPinKbytes();;
mem_gb := mem_kb / (1024.0 * 1024.0);;
Print("Memoria usada por GAP: ", mem_gb, " GB\n");
#PrintNP(StrongNormalFormNP(MulNP(GP2NP(Y2), GP2NP(X1)), J));
