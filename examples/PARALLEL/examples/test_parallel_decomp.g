LogTo("/home/juandavid/Descargas/gap-4.13.1/pkg/qgnag/examples/PARALLEL/examples/test_parallel_4.log");
LoadPackage("qgnag", false);
t0 := NanosecondsSinceEpoch();;
data_parallel := QGNAG_FusionRulesAsVectorsParallel(all_mat_s_tensor_t, data_mats_simples);;
t1 := NanosecondsSinceEpoch();;

dur := (t1 - t0) / 1000000000.0;;
Print("Paralelo (decomposición completa): ", dur, " segundos\n");


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
Print("¿data = data_parallel? ", data = data_parallel, "\n");

if data <> data_parallel then
    diffs := Filtered([1..Length(data)], k -> data[k] <> data_parallel[k]);
    Print("Cantidad de discrepancias: ", Length(diffs), "\n");
    Print("Primeros índices: ", diffs{[1..Minimum(10,Length(diffs))]}, "\n");
fi;