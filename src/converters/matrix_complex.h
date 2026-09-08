#ifndef MATRIX_COMPLEX_H
#define MATRIX_COMPLEX_H

#include <vector>
#include <complex>
#include <cstddef>

using Complex = std::complex<double>;

class MatrixComplex
{
public:
    MatrixComplex() = default;
    MatrixComplex(size_t rows, size_t cols);
    MatrixComplex(const std::vector<std::vector<Complex>>& data);

    size_t Rows() const;
    size_t Cols() const;

    Complex& operator()(size_t i, size_t j);
    Complex operator()(size_t i, size_t j) const;

    const std::vector<std::vector<Complex>>& Data() const;
    MatrixComplex Transpose() const;

    bool IsZero(double tol = 1e-9) const;

    static MatrixComplex Identity(size_t n);

private:
    std::vector<std::vector<Complex>> data;
};

// Misma convención que la versión entera: Kronecker(A,B) = B ⊗ A (estándar).
MatrixComplex Kronecker(const MatrixComplex& A, const MatrixComplex& B);

MatrixComplex MatrixSubtract(const MatrixComplex& A, const MatrixComplex& B);

MatrixComplex VerticalStack(const std::vector<MatrixComplex>& blocks);

// Rango NUMÉRICO (no exacto): eliminación gaussiana con pivoteo parcial.
// tol es el umbral bajo el cual un pivote se considera cero.
long MatrixRank(const MatrixComplex& M, double tol = 1e-9);

#endif