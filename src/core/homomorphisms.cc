#include "homomorphisms.h"
#include <stdexcept>
#include <omp.h>
#include <iostream>

long DimHomAModules(const std::vector<Matrix>& Nrep, const std::vector<Matrix>& Mrep)
{
    if (Nrep.size() != Mrep.size()) {
        throw std::invalid_argument("Las representaciones deben tener la misma cantidad de generadores.");
    }
    if (Nrep.empty()) {
        throw std::invalid_argument("Se necesita al menos un generador.");
    }

    size_t n = Nrep[0].Cols();
    size_t m = Mrep[0].Cols();

    Matrix Im = Matrix::Identity(m);
    Matrix In = Matrix::Identity(n);

    std::vector<Matrix> blocks;
    blocks.reserve(Nrep.size());

    for (size_t i = 0; i < Nrep.size(); ++i) {
        if (Nrep[i].Rows() != n || Nrep[i].Cols() != n) {
            throw std::invalid_argument("Nrep tiene una matriz de generador con dimensiones inconsistentes.");
        }
        if (Mrep[i].Rows() != m || Mrep[i].Cols() != m) {
            throw std::invalid_argument("Mrep tiene una matriz de generador con dimensiones inconsistentes.");
        }

        if (Nrep[i].IsZero() && Mrep[i].IsZero()) {
            continue;
        }

        // I_m ⊗ N_i^T  =  Kronecker(N_i^T, I_m)
        Matrix term1 = Kronecker(Nrep[i].Transpose(), Im);
        // M_i ⊗ I_n    =  Kronecker(I_n, M_i)
        Matrix term2 = Kronecker(In, Mrep[i]);

        blocks.push_back(MatrixSubtract(term1, term2));
    }

    if (blocks.empty()) {
        // Todos los generadores actúan trivialmente en ambas representaciones.
        return static_cast<long>(m * n);
    }

    Matrix C = VerticalStack(blocks);
    long rank = MatrixRank(C);

    return static_cast<long>(m * n) - rank;
}


long DimHomAModulesParallel(const std::vector<Matrix>& Nrep,
                            const std::vector<Matrix>& Mrep)
{
    if (Nrep.size() != Mrep.size()) {
        throw std::invalid_argument(
            "Las representaciones deben tener la misma cantidad de generadores.");
    }

    if (Nrep.empty()) {
        throw std::invalid_argument(
            "Se necesita al menos un generador.");
    }

    size_t n = Nrep[0].Cols();
    size_t m = Mrep[0].Cols();

    Matrix Im = Matrix::Identity(m);
    Matrix In = Matrix::Identity(n);

    const size_t num_generators = Nrep.size();

    std::vector<Matrix> blocks(num_generators);
    std::vector<int> thread_ids(num_generators);
    #pragma omp parallel for
    for (long i = 0; i < static_cast<long>(num_generators); ++i)
    {
        thread_ids[i] = omp_get_thread_num();
        if (Nrep[i].Rows() != n || Nrep[i].Cols() != n) {
            throw std::invalid_argument(
                "Nrep tiene una matriz de generador con dimensiones inconsistentes.");
        }

        if (Mrep[i].Rows() != m || Mrep[i].Cols() != m) {
            throw std::invalid_argument(
                "Mrep tiene una matriz de generador con dimensiones inconsistentes.");
        }

        if (Nrep[i].IsZero() && Mrep[i].IsZero()) {
            blocks[i] = Matrix(m * n, m * n);
            continue;
        }

        Matrix term1 = Kronecker(Nrep[i].Transpose(), Im);
        Matrix term2 = Kronecker(In, Mrep[i]);
        blocks[i]    = MatrixSubtract(term1, term2);
    }

    for (size_t i = 0; i < num_generators; ++i)
    {
    std::cout
        << "i = " << i
        << " -> Thread " << thread_ids[i]
        << std::endl;
    }

    bool all_zero = true;

    for (const Matrix& block : blocks) {
        if (!block.IsZero()) {
            all_zero = false;
            break;
        }
    }

    if (all_zero) {
        return static_cast<long>(m * n);
    }

    Matrix C = VerticalStack(blocks);

    long rank = MatrixRank(C);

    return static_cast<long>(m * n) - rank;
}


std::vector<long> TestDimHomAllIntegerParallel(
    const std::vector<std::vector<Matrix>>& allT,
    const std::vector<std::vector<Matrix>>& allS)
{
    const size_t numT = allT.size();
    const size_t numS = allS.size();
    const size_t total = numT * numS;

    std::cout
        << "Testing " << total
        << " cases (" << numT << " T x "
        << numS << " S)"
        << std::endl;

    #pragma omp parallel
    {
        #pragma omp single
        {
            std::cout
                << "OpenMP usando "
                << omp_get_num_threads()
                << " threads"
                << std::endl;
        }
    }

    std::vector<long> results(total);

    #pragma omp parallel for
    for (long k = 0; k < static_cast<long>(total); ++k)
    {
        const size_t i = k / numS;
        const size_t j = k % numS;

        results[k] = DimHomAModules(allT[i], allS[j]);
    }

    return results;
}


long DimHomAModulesComplex(
    const std::vector<MatrixComplex>& Nrep,
    const std::vector<MatrixComplex>& Mrep,
    double tol)
{
    if (Nrep.size() != Mrep.size()) {
        throw std::invalid_argument("Las representaciones deben tener la misma cantidad de generadores.");
    }
    if (Nrep.empty()) {
        throw std::invalid_argument("Se necesita al menos un generador.");
    }

    size_t n = Nrep[0].Cols();
    size_t m = Mrep[0].Cols();

    MatrixComplex Im = MatrixComplex::Identity(m);
    MatrixComplex In = MatrixComplex::Identity(n);

    std::vector<MatrixComplex> blocks;
    blocks.reserve(Nrep.size());

    for (size_t i = 0; i < Nrep.size(); ++i) {
        if (Nrep[i].Rows() != n || Nrep[i].Cols() != n) {
            throw std::invalid_argument("Nrep tiene una matriz de generador con dimensiones inconsistentes.");
        }
        if (Mrep[i].Rows() != m || Mrep[i].Cols() != m) {
            throw std::invalid_argument("Mrep tiene una matriz de generador con dimensiones inconsistentes.");
        }

        if (Nrep[i].IsZero(tol) && Mrep[i].IsZero(tol)) {
            continue;
        }

        MatrixComplex term1 = Kronecker(Nrep[i].Transpose(), Im);
        MatrixComplex term2 = Kronecker(In, Mrep[i]);

        blocks.push_back(MatrixSubtract(term1, term2));
    }

    if (blocks.empty()) {
        return static_cast<long>(m * n);
    }

    MatrixComplex C = VerticalStack(blocks);
    long rank = MatrixRank(C, tol);

    return static_cast<long>(m * n) - rank;
}


std::vector<long> TestDimHomAllComplexParallel(
    const std::vector<std::vector<MatrixComplex>>& allT,
    const std::vector<std::vector<MatrixComplex>>& allS,
    double tol)   // <-- sin default acá
{
    const size_t numT = allT.size();
    const size_t numS = allS.size();
    const size_t total = numT * numS;

    std::cout
        << "Testing " << total
        << " cases (" << numT << " T x "
        << numS << " S)"
        << std::endl;

    #pragma omp parallel
    {
        #pragma omp single
        {
            std::cout
                << "OpenMP usando "
                << omp_get_num_threads()
                << " threads"
                << std::endl;
        }
    }

    std::vector<long> results(total);

    // Bandera de error compartida: si algún hilo falla, guardamos el
    // primer mensaje y dejamos que el resto termine sin más cómputo útil
    // (no se puede lanzar una excepción a través de un pragma omp).
    bool has_error = false;
    std::string error_message;

    #pragma omp parallel for schedule(dynamic)
    for (long k = 0; k < static_cast<long>(total); ++k)
    {
        const size_t i = k / numS;
        const size_t j = k % numS;

        try {
            results[k] = DimHomAModulesComplex(allT[i], allS[j], tol);
        } catch (const std::exception& e) {
            #pragma omp critical
            {
                if (!has_error) {
                    has_error = true;
                    error_message = "Caso (T=" + std::to_string(i) +
                                     ", S=" + std::to_string(j) +
                                     "): " + e.what();
                }
            }
            results[k] = -1; // valor centinela para casos fallidos
        }
    }

    if (has_error) {
        throw std::runtime_error(
            "TestDimHomAllComplexParallel: al menos un caso falló. " + error_message);
    }

    return results;
}

std::vector<DecompositionResult> QGNAGDecomposeParallel(
    const std::vector<TensorEntry>& allTensors,
    const std::vector<std::vector<MatrixComplex>>& allSimples,
    double tol)
{
    const size_t numTensors = allTensors.size();
    const size_t theta = allSimples.size();

    std::vector<DecompositionResult> results(numTensors);

    bool has_error = false;
    std::string error_message;

    #pragma omp parallel for schedule(dynamic)
    for (long t = 0; t < static_cast<long>(numTensors); ++t)
    {
        const TensorEntry& entry = allTensors[t];

        std::vector<long> vec(theta, 0);

        try {
            // Sin early break: calculamos TODAS las multiplicidades.
            // Matemáticamente equivalente al loop con corte de GAP, porque
            // una vez cubierto el grado total, el resto es necesariamente 0
            // (unicidad de la descomposición en irreducibles).
            for (size_t s = 0; s < theta; ++s) {
                vec[s] = DimHomAModulesComplex(entry.tensor, allSimples[s], tol);
            }
        } catch (const std::exception& e) {
            #pragma omp critical
            {
                if (!has_error) {
                    has_error = true;
                    error_message = "Tensor (first=" + std::to_string(entry.first) +
                                     ", second=" + std::to_string(entry.second) +
                                     "): " + e.what();
                }
            }
            continue; // deja vec en ceros para este caso fallido
        }

        results[t].first  = entry.first;
        results[t].second = entry.second;
        results[t].vector = std::move(vec);
    }

    if (has_error) {
        throw std::runtime_error(
            "QGNAGDecomposeParallel: al menos un caso falló. " + error_message);
    }

    return results;
}