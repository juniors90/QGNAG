#include "matrix_converters.h"
#include "scalar.h"
#include <stdexcept>

Matrix ObjToMatrix(Obj obj)
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

    Matrix M(rows, cols);

    for (Int i = 1; i <= rows; ++i)
    {
        Obj row = ELM_LIST(obj, i);

        if (!IS_LIST(row)) {
            throw std::invalid_argument("Type Error: Expected each row to be a list.");
        }
        if (LEN_LIST(row) != cols) {
            throw std::invalid_argument("Type Error: Matrix rows have different lengths.");
        }

        for (Int j = 1; j <= cols; ++j)
        {
            M(i - 1, j - 1) = ObjToInt(ELM_LIST(row, j));
        }
    }

    return M;
}

Obj MatrixToObj(const Matrix& M)
{
    Obj result = NEW_PLIST(T_PLIST, (Int)M.Rows());
    SET_LEN_PLIST(result, (Int)M.Rows());

    for (size_t i = 0; i < M.Rows(); ++i)
    {
        Obj row = NEW_PLIST(T_PLIST, (Int)M.Cols());
        SET_LEN_PLIST(row, (Int)M.Cols());

        for (size_t j = 0; j < M.Cols(); ++j)
        {
            SET_ELM_PLIST(row, (Int)(j + 1), IntToObj(M(i, j)));
            CHANGED_BAG(row);
        }

        SET_ELM_PLIST(result, (Int)(i + 1), row);
        CHANGED_BAG(result);
    }

    return result;
}

std::vector<Matrix> ObjToVectorMatrix(Obj gap_list)
{
    if (!IS_LIST(gap_list)) {
        throw std::invalid_argument("Type Error: Expected a list of matrices.");
    }
    Int len = LEN_LIST(gap_list);
    std::vector<Matrix> result;
    result.reserve(len);
    for (Int i = 1; i <= len; ++i) {
        result.push_back(ObjToMatrix(ELM_LIST(gap_list, i)));
    }
    return result;
}

std::vector<std::vector<Matrix>> ObjToVectorVectorMatrix(Obj obj)
{
    std::vector<std::vector<Matrix>> result;

    const Int len = LEN_LIST(obj);

    result.reserve(len);

    for (Int i = 1; i <= len; ++i)
    {
        Obj list = ELM_LIST(obj, i);

        result.push_back(ObjToVectorMatrix(list));
    }

    return result;
}