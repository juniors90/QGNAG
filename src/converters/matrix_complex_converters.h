#ifndef MATRIX_COMPLEX_CONVERTERS_H
#define MATRIX_COMPLEX_CONVERTERS_H

extern "C" {
#include <gap_all.h>
}
#include "matrix_complex.h"
#include <vector>

MatrixComplex ObjToMatrixComplex(Obj gap_matrix);
Obj MatrixComplexToObj(const MatrixComplex& M);

std::vector<MatrixComplex> ObjToVectorMatrixComplex(Obj gap_list_of_matrices);
std::vector<std::vector<MatrixComplex>> ObjToVectorVectorMatrixComplex(Obj obj);

#endif