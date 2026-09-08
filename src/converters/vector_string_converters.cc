#include "vector_string_converters.h"
#include "scalar.h"
#include <stdexcept>

std::vector<std::string> ObjToVectorString(Obj gap_list) {
    if (!IS_LIST(gap_list)) {
        throw std::invalid_argument("Expected a list.");
    }
    long len = LEN_LIST(gap_list);
    std::vector<std::string> result(len);
    
    for (long i = 1; i <= len; ++i) {
        result[i - 1] = ObjToString(ELM_LIST(gap_list, i));
    }
    return result;
}

Obj VectorStringToObj(const std::vector<std::string>& cpp_vec) {
    long len = cpp_vec.size();
    Obj gap_list = NEW_PLIST(T_PLIST, len);
    SET_LEN_PLIST(gap_list, len);
    
    for (long i = 0; i < len; ++i) {
        SET_ELM_PLIST(gap_list, i + 1, StringToObj(cpp_vec[i]));
    }
    return gap_list;
}