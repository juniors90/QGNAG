# %%
LoadPackage("GBNP");;

# %%
GBNP.ConfigPrint(
    "X0",    # 1 "X_0 = X_0"
    "X1",    # 2 "X_1 = X_1"
    "X2",    # 3 "X_2 = X_w"
    "X3"     # 4 "X_3 = X_{w^2}"
);

# %%
# =====================================================
# 1. Álgebra libre sobre Q con generadores σ y τ
# =====================================================
F := FreeAssociativeAlgebraWithOne(Rationals, 4);;
gens := GeneratorsOfAlgebra(F);;
e:=gens[1];;
X0:=gens[2];;
X1:=gens[3];;
X2:=gens[4];;
X3:=gens[5];;

# %%
###############################################################################
# x_(ij)^2 = 0, x_(ij)x_(jk)+x_(jk)x_(ik)+x_(ik)x_(ij)=0, etc. 
# (álgebra Fomin-Kirillov n=3,
###############################################################################
# Generadores x_(ij)
gensT4 := Elements(GF(4));;
xIndex := [1, 2, 3, 4];;
# Inicializar lista de relaciones
relationsT4 := [];;

# Paso 1: Relaciones cuadráticas x_(ij)^2 = 0
# Paso 2: Relaciones cuadráticas
# Paso 2: Relaciones cuadráticas
for i in [1..Length(gensT4)] do
    Add(relationsT4, gens[i+1]^2);;
od;
# Paso 2: Relaciones cúbicas de tres índices distintos


# %%
PrintNPList(List(relationsT4, el-> GP2NP(el)));

# %%
## x3x2 + x2x1 + x1x3 = 0,
Add(relationsT4, X3*X2 + X2*X1 + X1*X3 );;
## x3x1 + x1x0 + x0x3 = 0,
Add(relationsT4, X3*X1 + X1*X0 + X0*X3 );;
## x3x0 + x0x2 + x2x3 = 0,
Add(relationsT4, X3*X0 + X0*X2 + X2*X3 );;
## x2x0 + x0x1 + x1x2 = 0,
Add(relationsT4, X2*X0 + X0*X1 + X1*X2 );;
## x2x1x0x2x1x0 +x1x0x2x1x0x2 +x0x2x1x0x2x1 = 0.
Add(relationsT4, X2*X1*X0*X2*X1*X0 + X1*X0*X2*X1*X0*X2 + X0*X2*X1*X0*X2*X1 );;

# %%
# Imprimir las relaciones
relsT4:=GP2NPList(relationsT4);;
PrintNPList(relsT4);

# %%
# =====================================================
# Paso 5: Calcular la base de Gröbner
# =====================================================
J := SGrobner(relsT4);;

PrintNPList( J );

# %%
# Paso 6: Calcular la base vectorial (PBW)
Base_T4 := BaseQA(J, 4, 0);;

# %%
PrintNPList(Base_T4);;

# %%
DimQA(J, 4);

# %%
T4gens := [X0, X1, X2, X3 ];

# %%
StrongNormalFormNP(MulNP(GP2NP(X2), Base_T4[8]), J)[1][1];

# %%
Position(Base_T4, GP2NP(X1*X2*X3));

# %%
Base_T4[22][1];

# %%
monos:=List(Base_T4, x -> x[1][1]);

# %%


# %%
StrongNormalFormNP(MulNP(GP2NP(X2), Base_T4[8]), J)[1][1] in monos;

# %%
mon:=StrongNormalFormNP(MulNP(GP2NP(X2), Base_T4[8]), J)[1];
coef:=StrongNormalFormNP(MulNP(GP2NP(X2), Base_T4[8]), J)[2];

# %%
List(mon, x->Position(monos, x));

# %%
monos:=List(Base_T4, x -> x[1][1]);
DimNichols:=Length(Base_T4);
M := NullMat(DimNichols, DimNichols, Rationals);
for bi in Base_T4 do
     #PrintNP(StrongNormalFormNP(MulNP(GP2NP(X2), bi), J));
     mon := StrongNormalFormNP(MulNP(GP2NP(X2),  bi), J)[1];
     coeff := StrongNormalFormNP(MulNP(GP2NP(X2), bi), J)[2];
     pos_mon := List(mon, x-> Position(monos, x));
     j := Position(Base_T4, bi);
    
     if mon <> [] then
          Print("j: ", j, " mon: ", mon, ", coeff: ", coeff, " pos_mon: ", pos_mon, "\n");
          for m in [1..Length(mon)] do
               i := Position(monos, mon[m]);
               M[i][j]:=coeff[m];
          od;
     fi;
od;

# %%
Display(M);

# %%
PrintNPList(List(Base_T4, x -> StrongNormalFormNP(MulNP(GP2NP(X0) ,  x), J)));

# %%
PrintNPList(List(Base_T4, x -> StrongNormalFormNP(MulNP(GP2NP(X1) ,  x), J)));

# %%
PrintNPList(List(Base_T4, x -> StrongNormalFormNP(MulNP(GP2NP(X2) ,  x), J)));

# %%
PrintNPList(List(Base_T4, x -> StrongNormalFormNP(MulNP(GP2NP(X3) ,  x), J)));

# %%
StructureMatrix := function( genX, Base_Nichols )
    local monos, bi, M, coeff, mon, pos_mon, j, m, i, DimNichols;
    monos := List( Base_Nichols, x -> x[1][1] );
    DimNichols := Length( Base_Nichols );
    M := NullMat( DimNichols, DimNichols, Rationals );
    for bi in Base_Nichols do
        mon := StrongNormalFormNP( MulNP( GP2NP( genX ),  bi ), J)[1];
        coeff := StrongNormalFormNP( MulNP( GP2NP( genX ), bi ), J)[2];
        pos_mon := List( mon, x-> Position( monos, x ) );
        j := Position( Base_Nichols, bi );
    
        if mon <> [] then
            for m in [ 1..Length( mon ) ] do
                i := Position( monos, mon[m] );
                M[i][j] := coeff[m];
            od;
        fi;
    od;
    return M;
end;

# %%
M0:=StructureMatrix(X0, Base_T4);;
Display(M);

# %%
M1:=StructureMatrix(X1, Base_T4);;
Display(M1);

# %%
M2:=StructureMatrix(X2, Base_T4);;
Display(M2);

# %%
M3:=StructureMatrix(X3, Base_T4);;
Display(M3);

# %%
# Creamos una lista de 4 elementos, donde cada elemento es M4.
M0_Verma := DirectSumMat( List([1..3], i -> M0) );; 

# Para verificar el resultado
#Display(M0_Verma);;
Length(M0_Verma);


