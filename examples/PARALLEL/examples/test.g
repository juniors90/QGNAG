LogTo("/home/juandavid/Descargas/gap-4.13.1/pkg/gapcxx/examples/test.log");
LoadPackage("gapcxx");
allT               := List(CXX_data_tensor_int, r -> r.1_tensor_2);;
allS               := List( CXX_mat_s_int, r -> r.(Position(CXX_mat_s, r)) );;
t0 := NanosecondsSinceEpoch();;
parallel_results   := TestDimHomAllIntegerParallel(allT, allS);;
# ================================
#   Fin del código principal
# ================================
t1 := NanosecondsSinceEpoch();;
# Calcular duración en segundos
dur := (t1 - t0) / 1000000000.0;;
# Convertir a horas, minutos y segundos
horas := Int(dur / 3600);;
minutos := Int((dur - horas * 3600) / 60);;
segundos := Round(dur - horas * 3600 - minutos * 60);;
# Mostrar resultado
Print("\n=====================================\n");
Print("Tiempo total de ejecución:\n");
Print(String(horas), " horas, ", String(minutos), " minutos, ", String(segundos), " segundos.\n");
Print("=====================================\n");
sequential_results := [];;
t2 := NanosecondsSinceEpoch();;
for t in allT do
    for s in allS do
        Add( sequential_results, CXX_DimHomAModules(t, s) );
    od;
od;
# ================================
#   Fin del código principal
# ================================
t3 := NanosecondsSinceEpoch();;
# Calcular duración en segundos
dur := (t3 - t2) / 1000000000.0;;
# Convertir a horas, minutos y segundos
horas := Int(dur / 3600);;
minutos := Int((dur - horas * 3600) / 60);;
segundos := Round(dur - horas * 3600 - minutos * 60);;
# Mostrar resultado
Print("\n=====================================\n");
Print("Tiempo total de ejecución:\n");
Print(String(horas), " horas, ", String(minutos), " minutos, ", String(segundos), " segundos.\n");
Print("=====================================\n");
parallel_results = sequential_results;
