#include "matrix_complex.h"
#include <stdexcept>
#include <algorithm>
#include <cmath>

MatrixComplex::MatrixComplex(size_t rows, size_t cols)
    : data(rows, std::vector<Complex>(cols, Complex(0.0, 0.0)))
{
}

MatrixComplex::MatrixComplex(const std::vector<std::vector<Complex>>& data)
    : data(data)
{
}

size_t MatrixComplex::Rows() const { return data.size(); }
size_t MatrixComplex::Cols() const { return data.empty() ? 0 : data.front().size(); }

Complex& MatrixComplex::operator()(size_t i, size_t j) { return data[i][j]; }
Complex MatrixComplex::operator()(size_t i, size_t j) const { return data[i][j]; }

const std::vector<std::vector<Complex>>& MatrixComplex::Data() const { return data; }

MatrixComplex MatrixComplex::Transpose() const
{
    MatrixComplex T(Cols(), Rows());
    for (size_t i = 0; i < Rows(); ++i)
        for (size_t j = 0; j < Cols(); ++j)
            T(j, i) = (*this)(i, j);
    return T;
}

bool MatrixComplex::IsZero(double tol) const
{
    for (size_t i = 0; i < Rows(); ++i)
        for (size_t j = 0; j < Cols(); ++j)
            if (std::abs((*this)(i, j)) > tol) return false;
    return true;
}

MatrixComplex MatrixComplex::Identity(size_t n)
{
    MatrixComplex I(n, n);
    for (size_t i = 0; i < n; ++i) I(i, i) = Complex(1.0, 0.0);
    return I;
}

MatrixComplex Kronecker(const MatrixComplex& A, const MatrixComplex& B)
{
    size_t m = A.Rows(), n = A.Cols();
    size_t p = B.Rows(), q = B.Cols();

    MatrixComplex K(p * m, q * n);

    for (size_t v = 0; v < p; ++v)
        for (size_t w = 0; w < q; ++w) {
            Complex b_vw = B(v, w);
            for (size_t i = 0; i < m; ++i)
                for (size_t j = 0; j < n; ++j)
                    K(v * m + i, w * n + j) = b_vw * A(i, j);
        }

    return K;
}

MatrixComplex MatrixSubtract(const MatrixComplex& A, const MatrixComplex& B)
{
    if (A.Rows() != B.Rows() || A.Cols() != B.Cols()) {
        throw std::invalid_argument("MatrixSubtract: dimensiones incompatibles.");
    }
    MatrixComplex R(A.Rows(), A.Cols());
    for (size_t i = 0; i < A.Rows(); ++i)
        for (size_t j = 0; j < A.Cols(); ++j)
            R(i, j) = A(i, j) - B(i, j);
    return R;
}

MatrixComplex VerticalStack(const std::vector<MatrixComplex>& blocks)
{
    if (blocks.empty()) return MatrixComplex(0, 0);

    size_t cols = blocks.front().Cols();
    size_t total_rows = 0;
    for (const auto& b : blocks) {
        if (b.Cols() != cols) {
            throw std::invalid_argument("VerticalStack: todas las matrices deben tener la misma cantidad de columnas.");
        }
        total_rows += b.Rows();
    }

    MatrixComplex R(total_rows, cols);
    size_t offset = 0;
    for (const auto& b : blocks) {
        for (size_t i = 0; i < b.Rows(); ++i)
            for (size_t j = 0; j < cols; ++j)
                R(offset + i, j) = b(i, j);
        offset += b.Rows();
    }
    return R;
}

// Eliminación gaussiana con pivoteo parcial (por módulo). No es exacta:
// depende de 'tol' para decidir cuándo un pivote es "cero". Para matrices
// bien condicionadas (como las que salen de representaciones de grupos
// finitos con entradas ciclotómicas de conductor moderado) esto es robusto
// en la práctica.
long MatrixRank(const MatrixComplex& M, double tol)
{
    size_t rows = M.Rows();
    size_t cols = M.Cols();
    if (rows == 0 || cols == 0) return 0;

    std::vector<std::vector<Complex>> A(rows, std::vector<Complex>(cols));
    for (size_t i = 0; i < rows; ++i)
        for (size_t j = 0; j < cols; ++j)
            A[i][j] = M(i, j);

    size_t rank = 0;

    for (size_t col = 0; col < cols && rank < rows; ++col) {
        size_t pivot_row = rank;
        double best = std::abs(A[rank][col]);
        for (size_t i = rank + 1; i < rows; ++i) {
            double v = std::abs(A[i][col]);
            if (v > best) { best = v; pivot_row = i; }
        }
        if (best < tol) continue; // columna efectivamente nula bajo la fila actual

        std::swap(A[rank], A[pivot_row]);

        Complex pivot = A[rank][col];
        for (size_t i = rank + 1; i < rows; ++i) {
            Complex factor = A[i][col] / pivot;
            for (size_t j = col; j < cols; ++j) {
                A[i][j] -= factor * A[rank][j];
            }
        }
        ++rank;
    }
    return static_cast<long>(rank);
}