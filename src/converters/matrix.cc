#include <stdexcept>
#include <algorithm>
#include "matrix.h"

Matrix::Matrix(size_t rows, size_t cols)
    : data(rows, std::vector<int>(cols))
{
}

Matrix::Matrix(const std::vector<std::vector<int>>& data)
    : data(data)
{
}

size_t Matrix::Rows() const
{
    return data.size();
}

size_t Matrix::Cols() const
{
    return data.empty() ? 0 : data.front().size();
}

int& Matrix::operator()(size_t i, size_t j)
{
    return data[i][j];
}

int Matrix::operator()(size_t i, size_t j) const
{
    return data[i][j];
}

const std::vector<std::vector<int>>& Matrix::Data() const
{
    return data;
}

// ======================================================
// Matrix operations
// ======================================================

Matrix Matrix::Transpose() const
{
    Matrix T(Cols(), Rows());

    for (size_t i = 0; i < Rows(); ++i)
    {
        for (size_t j = 0; j < Cols(); ++j)
        {
            T(j, i) = (*this)(i, j);
        }
    }

    return T;
}

// ======================================================
// Kronecker product
// ======================================================

Matrix Kronecker(const Matrix& A, const Matrix& B)
{
    size_t m = A.Rows(), n = A.Cols();   // dimensiones de A (el bloque)
    size_t p = B.Rows(), q = B.Cols();   // dimensiones de B (la grilla)

    Matrix K(p * m, q * n);

    for (size_t v = 0; v < p; ++v)
    {
        for (size_t w = 0; w < q; ++w)
        {
            int b_vw = B(v, w);

            for (size_t i = 0; i < m; ++i)
            {
                for (size_t j = 0; j < n; ++j)
                {
                    K(v * m + i, w * n + j) = b_vw * A(i, j);
                }
            }
        }
    }

    return K;
}




bool Matrix::IsZero() const
{
    for (size_t i = 0; i < Rows(); ++i)
        for (size_t j = 0; j < Cols(); ++j)
            if ((*this)(i, j) != 0) return false;
    return true;
}

Matrix Matrix::Identity(size_t n)
{
    Matrix I(n, n);
    for (size_t i = 0; i < n; ++i) I(i, i) = 1;
    return I;
}

Matrix MatrixSubtract(const Matrix& A, const Matrix& B)
{
    if (A.Rows() != B.Rows() || A.Cols() != B.Cols()) {
        throw std::invalid_argument("MatrixSubtract: dimensiones incompatibles.");
    }
    Matrix R(A.Rows(), A.Cols());
    for (size_t i = 0; i < A.Rows(); ++i)
        for (size_t j = 0; j < A.Cols(); ++j)
            R(i, j) = A(i, j) - B(i, j);
    return R;
}

Matrix VerticalStack(const std::vector<Matrix>& blocks)
{
    if (blocks.empty()) return Matrix(0, 0);

    size_t cols = blocks.front().Cols();
    size_t total_rows = 0;
    for (const auto& b : blocks) {
        if (b.Cols() != cols) {
            throw std::invalid_argument("VerticalStack: todas las matrices deben tener la misma cantidad de columnas.");
        }
        total_rows += b.Rows();
    }

    Matrix R(total_rows, cols);
    size_t offset = 0;
    for (const auto& b : blocks) {
        for (size_t i = 0; i < b.Rows(); ++i)
            for (size_t j = 0; j < cols; ++j)
                R(offset + i, j) = b(i, j);
        offset += b.Rows();
    }
    return R;
}

// Algoritmo de Bareiss: elimina fracciones manteniendo aritmética entera exacta.
// Referencia: Bareiss, E.H. (1968), "Sylvester's Identity and Multistep
// Integer-Preserving Gaussian Elimination".
long MatrixRank(const Matrix& M)
{
    size_t rows = M.Rows();
    size_t cols = M.Cols();
    if (rows == 0 || cols == 0) return 0;

    std::vector<std::vector<long long>> A(rows, std::vector<long long>(cols));
    for (size_t i = 0; i < rows; ++i)
        for (size_t j = 0; j < cols; ++j)
            A[i][j] = M(i, j);

    size_t rank = 0;
    long long prev_pivot = 1;

    for (size_t col = 0; col < cols && rank < rows; ++col) {
        size_t pivot_row = rank;
        while (pivot_row < rows && A[pivot_row][col] == 0) ++pivot_row;
        if (pivot_row == rows) continue; // columna nula bajo la fila actual

        std::swap(A[rank], A[pivot_row]);

        for (size_t i = rank + 1; i < rows; ++i) {
            for (size_t j = col + 1; j < cols; ++j) {
                A[i][j] = (A[i][j] * A[rank][col] - A[i][col] * A[rank][j]) / prev_pivot;
            }
            A[i][col] = 0;
        }
        prev_pivot = A[rank][col];
        ++rank;
    }
    return static_cast<long>(rank);
}