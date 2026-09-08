#ifndef TENSOR_CONVERTERS_H
#define TENSOR_CONVERTERS_H

extern "C" {
#include <gap_all.h>
#include <records.h>
#include <precord.h>
}
#include "matrix_complex.h"
#include <vector>

// Espeja un record GAP rec(first:=i, second:=j, tensor:=[...]).
struct TensorEntry {
    long first;
    long second;
    std::vector<MatrixComplex> tensor;
};

// Convierte una lista GAP de records {first, second, tensor} a C++.
std::vector<TensorEntry> ObjToTensorEntries(Obj gap_list);

#endif