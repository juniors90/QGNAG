#include "vector_float_converters.h"
#include "scalar.h" // Incluye solo los conversores escalares necesarios
#include <stdexcept>

std::vector<double> ObjToVectorDouble(Obj gap_list) {
    if (!IS_LIST(gap_list)) {
        throw std::invalid_argument("Expected a list.");
    }
    
    long len = LEN_LIST(gap_list);
    std::vector<double> result(len);
    
    for (long i = 1; i <= len; ++i) {
        Obj elem = ELM_LIST(gap_list, i);
        result[i - 1] = ObjToDouble(elem);
    }
    
    return result;
}

Obj VectorDoubleToObj(const std::vector<double>& cpp_vec) {
    long len = cpp_vec.size();
    Obj gap_list = NEW_PLIST(T_PLIST, len);
    SET_LEN_PLIST(gap_list, len);
    
    for (long i = 0; i < len; ++i) {
        SET_ELM_PLIST(gap_list, i + 1, DoubleToObj(cpp_vec[i]));
    }

    return gap_list;
}