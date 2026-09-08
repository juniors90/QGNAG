#include "gap_bindings.h"
#include "../converters/converters.h" 
#include "../core/cpp_logic.h"
#include "../core/homomorphisms.h"
#include "../core/structure_matrix.h"
#include <vector>
#include <stdexcept>
#include <exception>


extern "C" Obj FuncCppQuoInt(Obj self, Obj arg1, Obj arg2) {
    long a = ObjToInt(arg1);
    long b = ObjToInt(arg2);

    try {
        // Intentamos ejecutar la matemática
        long result = CppDivide(a, b);
        return IntToObj(result);
    } 
    catch (const std::exception& e) {
        // Si C++ falla, atajamos el error y le avisamos a GAP
        // ErrorMayQuit interrumpe la ejecución de GAP limpiamente y muestra el mensaje
        ErrorMayQuit("%s", (Int)e.what(), 0);
        return (Obj)0; // GAP no llega a ejecutar esto, pero el compilador lo exige
    }
}


extern "C" Obj FuncCppSumVector(Obj self, Obj arg1) {
    try {
        std::vector<long> vec = ObjToVector(arg1);
        long result = CppSumVector(vec);
        return IntToObj(result);
    } catch (const std::exception& e) {
        ErrorMayQuit("%s", (Int)e.what(), 0);
        return (Obj)0;
    }
}

extern "C" Obj FuncCppSortStrings(Obj self, Obj arg1) {
    try {
        std::vector<std::string> vec = ObjToVectorString(arg1);
        std::vector<std::string> result = CppSortStrings(vec);
        return VectorStringToObj(result);
    } catch (const std::exception& e) {
        ErrorMayQuit("%s", (Int)e.what(), 0);
        return (Obj)0;
    }
}


extern "C" Obj FuncCppRecNames(Obj self, Obj arg1) {
    try {
        // 1. Extraemos los nombres desde el Record de GAP
        std::vector<std::string> names = ObjToRecordNames(arg1);
        
        // 2. Convertimos el vector de C++ a una lista de strings de GAP
        return VectorStringToObj(names);
    } catch (const std::exception& e) {
        ErrorMayQuit("%s", (Int)e.what(), 0);
        return (Obj)0;
    }
}

extern "C" Obj FuncCppRemoveCharacters(Obj self, Obj arg1, Obj arg2) {
    try {
        // 1. Extraemos los strings de la memoria de GAP
        std::string text = ObjToString(arg1);
        std::string chars = ObjToString(arg2);
        
        // 2. Procesamos en C++ a máxima velocidad
        std::string result = CppRemoveCharacters(text, chars);
        
        // 3. Devolvemos el nuevo string a GAP
        return StringToObj(result);
    } catch (const std::exception& e) {
        ErrorMayQuit("%s", (Int)e.what(), 0);
        return (Obj)0;
    }
}

extern "C" Obj FuncCppSumVectorDouble(Obj self, Obj arg1) {
    try {
        std::vector<double> vec = ObjToVectorDouble(arg1);
        double result = CppSumVectorDouble(vec);
        return DoubleToObj(result);
    } catch (const std::exception& e) {
        ErrorMayQuit("%s", (Int)e.what(), 0);
        return (Obj)0;
    }
}

extern "C" Obj FuncHasRecordField(Obj self, Obj rec, Obj name) {
    try {
        std::string field_name = ObjToString(name);
        bool has = HasRecordField(rec, field_name);
        return has ? True : False;
    } catch (const std::exception& e) {
        ErrorMayQuit("%s", (Int)e.what(), 0);
        return (Obj)0;
    }
}

extern "C" Obj FuncGetRecordField(Obj self, Obj rec, Obj name) {
    try {
        std::string field_name = ObjToString(name);
        return GetRecordField(rec, field_name);
    } catch (const std::exception& e) {
        ErrorMayQuit("%s", (Int)e.what(), 0);
        return (Obj)0;
    }
}

extern "C" Obj FuncSetRecordField(Obj self, Obj rec, Obj name, Obj value) {
    try {
        std::string field_name = ObjToString(name);
        SetRecordField(rec, field_name, value);
        return rec; // GAP funcs siempre deben devolver un Obj
    } catch (const std::exception& e) {
        ErrorMayQuit("%s", (Int)e.what(), 0);
        return (Obj)0;
    }
}

extern "C" Obj FuncCppMatrixTranspose(Obj self, Obj arg1) {
    try {
        Matrix M = ObjToMatrix(arg1);
        Matrix T = M.Transpose();
        return MatrixToObj(T);
    } catch (const std::exception& e) {
        ErrorMayQuit("%s", (Int)e.what(), 0);
        return (Obj)0;
    }
}

extern "C" Obj FuncCppKronecker(Obj self, Obj arg1, Obj arg2) {
    try {
        Matrix A = ObjToMatrix(arg1);
        Matrix B = ObjToMatrix(arg2);
        Matrix K = Kronecker(A, B);
        return MatrixToObj(K);
    } catch (const std::exception& e) {
        ErrorMayQuit("%s", (Int)e.what(), 0);
        return (Obj)0;
    }
}

extern "C" Obj FuncCppDimHomAModules(Obj self, Obj arg1, Obj arg2) {
    try {
        std::vector<Matrix> Nrep = ObjToVectorMatrix(arg1);
        std::vector<Matrix> Mrep = ObjToVectorMatrix(arg2);
        long dim = DimHomAModules(Nrep, Mrep);
        return LongToObj(dim);
    } catch (const std::exception& e) {
        ErrorMayQuit("%s", (Int)e.what(), 0);
        return (Obj)0;
    }
}


extern "C" Obj FuncCppDimHomAModulesParallel(Obj self, Obj arg1, Obj arg2) {
    try {
        std::vector<Matrix> Nrep = ObjToVectorMatrix(arg1);
        std::vector<Matrix> Mrep = ObjToVectorMatrix(arg2);
        long dim = DimHomAModulesParallel(Nrep, Mrep);
        return LongToObj(dim);
    } catch (const std::exception& e) {
        ErrorMayQuit("%s", (Int)e.what(), 0);
        return (Obj)0;
    }
}


extern "C" Obj FuncTestDimHomAllIntegerParallel(
    Obj self,
    Obj arg1,
    Obj arg2)
{
    try {
        std::vector<std::vector<Matrix>> allT =
            ObjToVectorVectorMatrix(arg1);

        std::vector<std::vector<Matrix>> allS =
            ObjToVectorVectorMatrix(arg2);

        std::vector<long> results =
            TestDimHomAllIntegerParallel(allT, allS);

        Obj result = NEW_PLIST(T_PLIST, results.size());

        for (size_t i = 0; i < results.size(); ++i)
        {
            SET_ELM_PLIST(
                result,
                i + 1,
                LongToObj(results[i])
            );
        }

        SET_LEN_PLIST(result, results.size());

        return result;
    }
    catch (const std::exception& e) {
        ErrorMayQuit("%s", (Int)e.what(), 0);
        return (Obj)0;
    }
}





Obj FuncTestE(Obj self, Obj gap_n) {
    try {
        long n = ObjToLong(gap_n);
        return CreateE(n);
    } catch (const std::exception& e) {
        ErrorQuit(e.what(), 0L, 0L);
        return Fail;
    }
}

Obj FuncTestComplex(Obj self, Obj gap_cyc) {
    try {
        std::complex<double> z = ObjToComplex(gap_cyc);

        Obj res = NEW_PLIST(T_PLIST, 2);
        SET_LEN_PLIST(res, 2);
        SET_ELM_PLIST(res, 1, DoubleToObj(z.real()));
        SET_ELM_PLIST(res, 2, DoubleToObj(z.imag()));
        CHANGED_BAG(res);

        return res;
    } catch (const std::exception& e) {
        ErrorQuit(e.what(), 0L, 0L);
        return Fail;
    }
}

Obj FuncTestRoundTrip(Obj self, Obj gap_cyc) {
    try {
        Cyclotomic cyc = ObjToCyclotomic(gap_cyc);
        return CyclotomicToObj(cyc);
    } catch (const std::exception& e) {
        ErrorQuit(e.what(), 0L, 0L);
        return Fail;
    }
}

extern "C" Obj FuncCppDimHomAModulesComplex(Obj self, Obj arg1, Obj arg2) {
    try {
        std::vector<MatrixComplex> Nrep = ObjToVectorMatrixComplex(arg1);
        std::vector<MatrixComplex> Mrep = ObjToVectorMatrixComplex(arg2);
        long dim = DimHomAModulesComplex(Nrep, Mrep);
        return LongToObj(dim);
    } catch (const std::exception& e) {
        ErrorMayQuit("%s", (Int)e.what(), 0);
        return (Obj)0;
    }
}

extern "C" Obj FuncCppTestDimHomAllComplexParallel(Obj self, Obj arg1, Obj arg2) {
    try {
        // Toda la conversión Obj -> C++ pasa ANTES de la región paralela.
        std::vector<std::vector<MatrixComplex>> allT = ObjToVectorVectorMatrixComplex(arg1);
        std::vector<std::vector<MatrixComplex>> allS = ObjToVectorVectorMatrixComplex(arg2);

        std::vector<long> results = TestDimHomAllComplexParallel(allT, allS);

        // La reconversión a Obj también pasa DESPUÉS, en el hilo principal.
        return VectorLongToObj(results);
    } catch (const std::exception& e) {
        ErrorMayQuit("%s", (Int)e.what(), 0);
        return (Obj)0;
    }
}


extern "C" Obj FuncQGNAG_FusionRulesAsVectorsParallel(Obj self, Obj arg1, Obj arg2) {
    try {
        // Conversión Obj -> C++, en el hilo principal.
        std::vector<TensorEntry> allTensors = ObjToTensorEntries(arg1);
        std::vector<std::vector<MatrixComplex>> allSimples = ObjToVectorVectorMatrixComplex(arg2);

        std::vector<DecompositionResult> results =
            QGNAGDecomposeParallel(allTensors, allSimples);

        // Reconstrucción Obj, también en el hilo principal.
        return VectorDecompositionResultToObj(results);
    } catch (const std::exception& e) {
        ErrorMayQuit("%s", (Int)e.what(), 0);
        return (Obj)0;
    }
}

// GAP binding for QGNAG_StructureMatrixForXi.
// Wraps the pure C++ implementation (structure_matrix.cc) and converts
// any C++ exception into a GAP-level error via ErrorMayQuit.
extern "C" Obj FuncCppStructureMatrixForXi(Obj self, Obj arg1, Obj arg2) {
    try {
        return QGNAG_CppStructureMatrixForXi(arg1, arg2);
    } catch (const std::exception& e) {
        ErrorMayQuit("%s", (Int)e.what(), 0);
        return (Obj)0;
    }
}

Obj QGNAG_CppXiMatrixAction(Obj XiMatrixOnNichols, Obj simple)
{
    if (!IS_LIST(XiMatrixOnNichols)) {
        throw std::invalid_argument("XiMatrixAction: XiMatrixOnNichols must be a list.");
    }
    if (!IS_LIST(simple) || LEN_LIST(simple) < 1) {
        throw std::invalid_argument("XiMatrixAction: simple must be a non-empty list of matrices.");
    }

    // k := Length(simple[1])  -- the degree of the simple module,
    // taken from the size of its first generator matrix.
    Obj first_gen = ELM_LIST(simple, 1);
    if (!IS_LIST(first_gen)) {
        throw std::invalid_argument("XiMatrixAction: simple[1] must be a (square) matrix.");
    }
    Int k = LEN_LIST(first_gen);
    if (k <= 0) {
        throw std::invalid_argument("XiMatrixAction: simple[1] must be a non-empty square matrix.");
    }

    // n := size of the block to be repeated (XiMatrixOnNichols is
    // assumed square, as produced by QGNAG_CppStructureMatrixForXi).
    Int n = LEN_LIST(XiMatrixOnNichols);
    if (n == 0) {
        // DirectSumMat of k copies of a 0x0 matrix is still 0x0.
        Obj empty = NEW_PLIST(T_PLIST, 0);
        SET_LEN_PLIST(empty, 0);
        return empty;
    }

    for (Int r = 1; r <= n; ++r) {
        Obj row = ELM_LIST(XiMatrixOnNichols, r);
        if (!IS_LIST(row) || LEN_LIST(row) != n) {
            throw std::invalid_argument("XiMatrixAction: XiMatrixOnNichols must be a square matrix.");
        }
    }

    // Result size: (k*n) x (k*n), block-diagonal with k copies of
    // XiMatrixOnNichols along the diagonal, zeros elsewhere.
    Int total = k * n;

    Obj result = NEW_PLIST(T_PLIST, total);
    SET_LEN_PLIST(result, total);

    for (Int b = 0; b < k; ++b) {
        for (Int i = 1; i <= n; ++i) {
            Obj out_row = NEW_PLIST(T_PLIST, total);
            SET_LEN_PLIST(out_row, total);

            // Fill the whole row with zeros first...
            for (Int c = 1; c <= total; ++c) {
                SET_ELM_PLIST(out_row, c, INTOBJ_INT(0));
            }
            // ...then overwrite the diagonal block with the source
            // matrix's row i, shifted to columns [b*n+1, b*n+n].
            Obj src_row = ELM_LIST(XiMatrixOnNichols, i);
            for (Int j = 1; j <= n; ++j) {
                Obj entry = ELM_LIST(src_row, j);
                SET_ELM_PLIST(out_row, b * n + j, entry);
            }
            CHANGED_BAG(out_row);

            SET_ELM_PLIST(result, b * n + i, out_row);
            CHANGED_BAG(result);
        }
    }

    return result;
}

// GAP binding for QGNAG_XiMatrixAction.
// Wraps QGNAG_CppXiMatrixAction and converts any C++ exception into a
// GAP-level error via ErrorMayQuit.
extern "C" Obj FuncCppXiMatrixAction(Obj self, Obj arg1, Obj arg2) {
    try {
        return QGNAG_CppXiMatrixAction(arg1, arg2);
    } catch (const std::exception& e) {
        ErrorMayQuit("%s", (Int)e.what(), 0);
        return (Obj)0;
    }
}