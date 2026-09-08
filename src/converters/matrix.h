#ifndef MATRIX_H
#define MATRIX_H

#include <string>
#include <map>
#include <memory>
#include <vector>
#include <cstddef>

class Matrix
{
public:
    Matrix() = default;
    Matrix(size_t rows, size_t cols);
    Matrix(const std::vector<std::vector<int>>& data);

    size_t Rows() const;
    size_t Cols() const;

    int& operator()(size_t i, size_t j);
    int operator()(size_t i, size_t j) const;

    const std::vector<std::vector<int>>& Data() const;
    Matrix Transpose() const;

    bool IsZero() const;              // <-- faltaba esta

    static Matrix Identity(size_t n); // <-- y esta

private:
    std::vector<std::vector<int>> data;
};

// Producto de Kronecker con convención: bloque(v,w) = A * b_vw,
// ordenado según la forma de B (equivale a B⊗A en la definición de Wikipedia).
Matrix Kronecker(const Matrix& A, const Matrix& B);

// Resta elemento a elemento; A y B deben tener la misma forma.
Matrix MatrixSubtract(const Matrix& A, const Matrix& B);

// Apila verticalmente una lista de matrices con la misma cantidad de columnas.
Matrix VerticalStack(const std::vector<Matrix>& blocks);

// Rango exacto (algoritmo de Bareiss, sin fracciones, sin punto flotante).
long MatrixRank(const Matrix& M);

#endif