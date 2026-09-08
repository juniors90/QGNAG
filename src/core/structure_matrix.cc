#include "structure_matrix.h"
#include <algorithm>
#include <vector>
#include <stdexcept>

namespace {

// Un monomio, junto con su posición original (1-indexada) en BaseNichols.
struct MonomialEntry {
    Obj monomial;
    Int index;
};

// Orden total de GAP (el mismo que usa Sort/Position internamente),
// llamado directamente a nivel de kernel -- sin pasar por el intérprete.
bool MonomialLess(const MonomialEntry& a, const MonomialEntry& b) {
    return LT(a.monomial, b.monomial) != 0;
}

} // namespace

Obj QGNAG_CppStructureMatrixForXi(Obj XiActionOnBasisNichols, Obj BaseNichols)
{
    if (!IS_LIST(BaseNichols)) {
        throw std::invalid_argument("StructureMatrixForXi: BaseNichols debe ser una lista.");
    }
    if (!IS_LIST(XiActionOnBasisNichols)) {
        throw std::invalid_argument("StructureMatrixForXi: XiActionOnBasisNichols debe ser una lista.");
    }

    Int DimNichols = LEN_LIST(BaseNichols);

    // --- 1. monos := List(BaseNichols, x -> x[1][1]), ordenados para
    //     permitir búsqueda binaria en vez de la búsqueda lineal de
    //     Position.
    std::vector<MonomialEntry> monos;
    monos.reserve(DimNichols);

    for (Int k = 1; k <= DimNichols; ++k) {
        Obj x = ELM_LIST(BaseNichols, k);
        if (!IS_LIST(x) || LEN_LIST(x) < 1) {
            throw std::invalid_argument("StructureMatrixForXi: elemento de BaseNichols con formato inesperado.");
        }
        Obj x1 = ELM_LIST(x, 1);
        if (!IS_LIST(x1) || LEN_LIST(x1) < 1) {
            throw std::invalid_argument("StructureMatrixForXi: elemento de BaseNichols con formato inesperado (x[1]).");
        }
        Obj mono_k = ELM_LIST(x1, 1); // x[1][1]
        monos.push_back({mono_k, k});
    }

    std::vector<MonomialEntry> sorted_monos = monos;
    std::stable_sort(sorted_monos.begin(), sorted_monos.end(), MonomialLess);

    // Position(monos, target), pero O(log N) en vez de O(N).
    // Si target no está, devuelve 0 (misma semántica que Position de GAP).
    auto FindPosition = [&sorted_monos](Obj target) -> Int {
        auto range = std::equal_range(
            sorted_monos.begin(), sorted_monos.end(),
            MonomialEntry{target, 0},
            MonomialLess);

        Int best = 0;
        for (auto it = range.first; it != range.second; ++it) {
            if (EQ(it->monomial, target)) {
                if (best == 0 || it->index < best) {
                    best = it->index;
                }
            }
        }
        return best;
    };

    // --- 2. M := NullMat(DimNichols, DimNichols, Rationals)
    Obj M = NEW_PLIST(T_PLIST, DimNichols);
    SET_LEN_PLIST(M, DimNichols);
    for (Int i = 1; i <= DimNichols; ++i) {
        Obj row = NEW_PLIST(T_PLIST, DimNichols);
        SET_LEN_PLIST(row, DimNichols);
        for (Int j = 1; j <= DimNichols; ++j) {
            SET_ELM_PLIST(row, j, INTOBJ_INT(0));
        }
        SET_ELM_PLIST(M, i, row);
        CHANGED_BAG(M);
    }

    // --- 3. Volcar XiActionOnBasisNichols en M, columna a columna.
    Int len_action = LEN_LIST(XiActionOnBasisNichols);

    for (Int bi = 1; bi <= len_action; ++bi) {
        Obj entry = ELM_LIST(XiActionOnBasisNichols, bi);
        if (!IS_LIST(entry) || LEN_LIST(entry) < 2) {
            throw std::invalid_argument("StructureMatrixForXi: entrada de XiActionOnBasisNichols con formato inesperado.");
        }

        Obj mon   = ELM_LIST(entry, 1);
        Obj coeff = ELM_LIST(entry, 2);

        if (!IS_LIST(mon) || !IS_LIST(coeff)) {
            throw std::invalid_argument("StructureMatrixForXi: 'mon'/'coeff' deben ser listas.");
        }

        Int len_mon = LEN_LIST(mon);
        if (len_mon == 0) continue; // == "if mon <> [] then" en el original

        if (LEN_LIST(coeff) != len_mon) {
            throw std::invalid_argument("StructureMatrixForXi: 'mon' y 'coeff' deben tener la misma longitud.");
        }

        for (Int m = 1; m <= len_mon; ++m) {
            Obj mon_m = ELM_LIST(mon, m);
            Int i = FindPosition(mon_m);
            if (i == 0) {
                throw std::invalid_argument("StructureMatrixForXi: monomio no encontrado en BaseNichols.");
            }

            Obj coeff_m = ELM_LIST(coeff, m);   // M[i][bi] := coeff[m]
            Obj row_i = ELM_LIST(M, i);
            SET_ELM_PLIST(row_i, bi, coeff_m);
            CHANGED_BAG(row_i);
        }
    }

    return M;
}