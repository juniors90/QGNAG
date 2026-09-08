#ifndef DECOMPOSITION_CONVERTERS_H
#define DECOMPOSITION_CONVERTERS_H

extern "C" {
#include <gap_all.h>
#include <records.h>
#include <precord.h>
}
#include <vector>

// Espeja el record de salida rec(first:=i, second:=j, vector:=[...]).
struct DecompositionResult {
    long first;
    long second;
    std::vector<long> vector;
};

// Construye UN record GAP a partir de un DecompositionResult.
// Solo llamar desde el hilo principal (fuera de #pragma omp parallel):
// construir Obj no es thread-safe.
Obj DecompositionResultToObj(const DecompositionResult& r);

// Construye la lista completa de records.
Obj VectorDecompositionResultToObj(const std::vector<DecompositionResult>& results);

#endif