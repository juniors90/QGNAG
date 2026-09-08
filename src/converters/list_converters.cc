#include "scalar.h"
#include <stdexcept>
#include <vector>

std::vector<long> ObjToVector(Obj gap_list) {
    if (!IS_LIST(gap_list)) {
        throw std::invalid_argument("Expected a list.");
    }
    long len = LEN_LIST(gap_list);
    std::vector<long> result(len);
    for (long i = 1; i <= len; ++i) {
        Obj elem = ELM_LIST(gap_list, i);
        // ¡NUEVA VALIDACIÓN!: Chequeamos que el elemento sea realmente un entero de GAP
        if (!IS_INTOBJ(elem)) {
            throw std::invalid_argument("Type Error: All elements in the list must be integers.");
        }   
        result[i - 1] = INT_INTOBJ(elem); 
    }
    return result;
}

Obj VectorToObj(const std::vector<long>& cpp_vec) {
    long len = cpp_vec.size();
    Obj gap_list = NEW_PLIST(T_PLIST, len);
    SET_LEN_PLIST(gap_list, len);
    for (long i = 0; i < len; ++i) {
        SET_ELM_PLIST(gap_list, i + 1, INTOBJ_INT(cpp_vec[i]));
    }
    return gap_list;
}
