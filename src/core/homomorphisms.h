#ifndef HOMOMORPHISMS_H
#define HOMOMORPHISMS_H

#include "converters/matrix.h"
#include "converters/matrix_complex_converters.h"
#include "converters/tensor_converters.h"
#include "converters/decomposition_converters.h"
#include <vector>

// Calcula dim Hom_Gamma(V, W) para dos representaciones matriciales de un
// grupo finito Gamma, dadas por las imágenes de sus generadores.
// Nrep[i], Mrep[i] son las matrices de rho(g_i) y tau(g_i) respectivamente.
long DimHomAModules(
    const std::vector<Matrix>& Nrep, 
    const std::vector<Matrix>& Mrep
);
long DimHomAModulesParallel(
    const std::vector<Matrix>& Nrep, 
    const std::vector<Matrix>& Mrep
);
std::vector<long> TestDimHomAllIntegerParallel(
    const std::vector<std::vector<Matrix>>& allT,
    const std::vector<std::vector<Matrix>>& allS
);

// Versión con entradas complejas (ciclotómicos de cualquier conductor).
// Sin paralelismo por ahora.
// homomorphisms.h (BIEN — con default)
long DimHomAModulesComplex(
    const std::vector<MatrixComplex>& Nrep,
    const std::vector<MatrixComplex>& Mrep,
    double tol = 1e-9
);

std::vector<long> TestDimHomAllComplexParallel(
    const std::vector<std::vector<MatrixComplex>>& allT,
    const std::vector<std::vector<MatrixComplex>>& allS,
    double tol = 1e-9   // <-- esto tiene que estar en el .h
);



std::vector<DecompositionResult> QGNAGDecomposeParallel(
    const std::vector<TensorEntry>& allTensors,
    const std::vector<std::vector<MatrixComplex>>& allSimples,
    double tol
);

inline std::vector<DecompositionResult> QGNAGDecomposeParallel(
    const std::vector<TensorEntry>& allTensors,
    const std::vector<std::vector<MatrixComplex>>& allSimples)
{
    return QGNAGDecomposeParallel(allTensors, allSimples, 1e-9);
}

#endif