#include "scalar.h"
#include "matrix_complex_converters.h"
#include "cyclotomic_converters.h"
#include <stdexcept>
#include <cmath>

MatrixComplex ObjToMatrixComplex(Obj obj)
{
    if (!IS_LIST(obj)) {
        throw std::invalid_argument("Type Error: Expected a list of lists (matrix).");
    }

    Int rows = LEN_LIST(obj);
    Int cols = 0;

    if (rows > 0) {
        Obj first_row = ELM_LIST(obj, 1);
        if (!IS_LIST(first_row)) {
            throw std::invalid_argument("Type Error: Expected each row to be a list.");
        }
        cols = LEN_LIST(first_row);
    }

    MatrixComplex M(rows, cols);

    for (Int i = 1; i <= rows; ++i) {
        Obj row = ELM_LIST(obj, i);

        if (!IS_LIST(row)) {
            throw std::invalid_argument("Type Error: Expected each row to be a list.");
        }
        if (LEN_LIST(row) != cols) {
            throw std::invalid_argument("Type Error: Matrix rows have different lengths.");
        }

        for (Int j = 1; j <= cols; ++j) {
            // ObjToComplex ya soporta enteros, floats y ciclotómicos
            // (cualquier raíz de la unidad, cualquier conductor).
            M(i - 1, j - 1) = ObjToComplex(ELM_LIST(row, j));
        }
    }

    return M;
}

Obj MatrixComplexToObj(const MatrixComplex& M)
{
    Obj result = NEW_PLIST(T_PLIST, (Int)M.Rows());
    SET_LEN_PLIST(result, (Int)M.Rows());

    for (size_t i = 0; i < M.Rows(); ++i) {
        Obj row = NEW_PLIST(T_PLIST, (Int)M.Cols());
        SET_LEN_PLIST(row, (Int)M.Cols());

        for (size_t j = 0; j < M.Cols(); ++j) {
            Complex z = M(i, j);
            // Reconstrucción vía E(4)=i: a + b*E(4). No es "canónica" si la
            // entrada venía de un conductor mayor a 4, pero es correcta
            // numéricamente y GAP la entiende como ciclotómico válido.
            Obj re = (std::floor(z.real()) == z.real())
                        ? LongToObj(static_cast<long>(z.real()))
                        : DoubleToObj(z.real());
            Obj im = (std::floor(z.imag()) == z.imag())
                        ? LongToObj(static_cast<long>(z.imag()))
                        : DoubleToObj(z.imag());

            Obj entry;
            if (z.imag() == 0.0) {
                entry = re;
            } else {
                Obj i_gap = CreateE(4);
                entry = SUM(re, PROD(im, i_gap));
            }

            SET_ELM_PLIST(row, (Int)(j + 1), entry);
            CHANGED_BAG(row);
        }

        SET_ELM_PLIST(result, (Int)(i + 1), row);
        CHANGED_BAG(result);
    }

    return result;
}

std::vector<MatrixComplex> ObjToVectorMatrixComplex(Obj gap_list)
{
    if (!IS_LIST(gap_list)) {
        throw std::invalid_argument("Type Error: Expected a list of matrices.");
    }
    Int len = LEN_LIST(gap_list);
    std::vector<MatrixComplex> result;
    result.reserve(len);
    for (Int i = 1; i <= len; ++i) {
        result.push_back(ObjToMatrixComplex(ELM_LIST(gap_list, i)));
    }
    return result;
}

std::vector<std::vector<MatrixComplex>> ObjToVectorVectorMatrixComplex(Obj obj)
{
    std::vector<std::vector<MatrixComplex>> result;
    const Int len = LEN_LIST(obj);
    result.reserve(len);
    for (Int i = 1; i <= len; ++i) {
        result.push_back(ObjToVectorMatrixComplex(ELM_LIST(obj, i)));
    }
    return result;
}