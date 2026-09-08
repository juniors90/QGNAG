#ifndef MATRIX_CONVERTERS_H
#define MATRIX_CONVERTERS_H

extern "C" {
#include <gap_all.h>
}
#include "matrix.h"

// Conversión de matriz
Matrix ObjToMatrix(Obj gap_matrix);
Obj MatrixToObj(const Matrix& M);
std::vector<Matrix> ObjToVectorMatrix(Obj gap_list_of_matrices);
std::vector<std::vector<Matrix>> ObjToVectorVectorMatrix(Obj obj);

#endif