LogTo("/home/juandavid/Descargas/gap-4.13.1/pkg/qgnag/examples/PARALLEL/examples/test_parallel_4.log");
LoadPackage("qgnag", false);

# Ya NO hace falta filtrar por CXX_data_tensor_int / CXX_mat_s_int:
# ObjToComplex maneja enteros, floats y ciclotómicos de cualquier
# conductor de forma transparente.
allT := List(all_mat_s_tensor_t, r -> r.tensor);;
allS := data_mats_simples;

Print("Total de casos: ", Length(allT) * Length(allS), "\n");

# ---- Versión paralela (C++) ----
t0 := NanosecondsSinceEpoch();;
parallel_results := CppTestDimHomAllComplexParallel(allT, allS);;
t1 := NanosecondsSinceEpoch();;

dur := (t1 - t0) / 1000000000.0;;
Print("Paralelo (complejo): ", dur, " segundos\n");

# ---- Versión secuencial (GAP puro, referencia exacta) ----
sequential_results := [];;
t2 := NanosecondsSinceEpoch();;
for t in allT do
    for s in allS do
        Add(sequential_results, QGNAG_DimHomAModules(t, s));
    od;
od;
t3 := NanosecondsSinceEpoch();;

dur2 := (t3 - t2) / 1000000000.0;;
Print("Secuencial (GAP puro): ", dur2, " segundos\n");

# ---- Comparación ----
Print("¿Coinciden todos los resultados? ", parallel_results = sequential_results, "\n");

# Si da 'false', identificá dónde difieren:
if parallel_results <> sequential_results then
    diffs := Filtered([1..Length(parallel_results)],
                       k -> parallel_results[k] <> sequential_results[k]);
    Print("Cantidad de discrepancias: ", Length(diffs), "\n");
    Print("Primeros índices con diferencia: ", diffs{[1..Minimum(10,Length(diffs))]}, "\n");
fi;
m := Minimum(parallel_results);;
M := Maximum(parallel_results);;
Print("¿Algún resultado centinela (-1)? ", -1 in parallel_results, "\n");
Print("Mínimo: ", m, "  Máximo: ", M, "\n");



# ---- Versión GAP ----
theta := Length(data_mats_simples);
data  := [];
t2 := NanosecondsSinceEpoch();;
for i in [2..theta] do
    for j in [i..theta] do
        tensor        := First(all_mat_s_tensor_t, r -> r.first = i and r.second = j).tensor;
        decomposition := [];
        remaining     := Length(tensor[1]);
        for mats_s in data_mats_simples do
            degree_s := Length(mats_s[1]);
            if degree_s > remaining then
                continue;
            fi;
            mult_s := QGNAG_DimHomAModules(tensor, mats_s);
            if mult_s > 0 then
                Add(decomposition, [ mult_s, Position(data_mats_simples, mats_s) ]);
                remaining := remaining - mult_s * degree_s;
                if remaining = 0 then
                    break;
                fi;
            fi;
        od;
        vector := List([1..theta], k -> 0);
        for term in decomposition do
            k         := term[2];
            vector[k] := term[1];
        od;
        Add( data, rec( first := i, second := j, vector := vector) );
    od;
od;
t3 := NanosecondsSinceEpoch();;
dur := (t3 - t2) / 1000000000.0;;
Print("GAP version loop: ", dur, " segundos\n");
data;
Print("termino data: ");