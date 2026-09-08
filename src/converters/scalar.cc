#include "scalar.h"
#include <stdexcept>
#include <cstring>

// --- Enteros ---

long ObjToLong(Obj gap_int) {
    if (!IS_INTOBJ(gap_int)) {
        throw std::invalid_argument("Type Error: Expected a GAP integer.");
    }
    return INT_INTOBJ(gap_int);
}

Obj LongToObj(long cpp_long) {
    return INTOBJ_INT(cpp_long);
}

int ObjToInt(Obj gap_int) {
    return static_cast<int>(ObjToLong(gap_int));
}

Obj IntToObj(int cpp_int) {
    return INTOBJ_INT(static_cast<long>(cpp_int));
}

// --- Flotantes ---

double ObjToDouble(Obj gap_float) {
    if (IS_MACFLOAT(gap_float)) {
        return VAL_MACFLOAT(gap_float);
    } else if (IS_INTOBJ(gap_float)) {
        return static_cast<double>(INT_INTOBJ(gap_float));
    }
    throw std::invalid_argument("Type Error: Expected a GAP float or integer.");
}

Obj DoubleToObj(double cpp_double) {
    return NEW_MACFLOAT(cpp_double);
}

// --- Strings ---

std::string ObjToString(Obj gap_str) {
    if (!IS_STRING(gap_str)) {
        throw std::invalid_argument("Type Error: Expected a GAP string.");
    }
    return std::string(CSTR_STRING(gap_str));
}

Obj StringToObj(const std::string& cpp_str) {
    Obj gap_str = NEW_STRING(cpp_str.length());
    memcpy(CSTR_STRING(gap_str), cpp_str.c_str(), cpp_str.length());
    CSTR_STRING(gap_str)[cpp_str.length()] = '\0';
    return gap_str;
}


std::vector<long> ObjToVectorLong(Obj gap_list) {
    if (!IS_LIST(gap_list)) {
        throw std::invalid_argument("Type Error: Expected a list.");
    }
    Int len = LEN_LIST(gap_list);
    std::vector<long> result;
    result.reserve(len);
    for (Int i = 1; i <= len; ++i) {
        result.push_back(ObjToLong(ELM_LIST(gap_list, i)));
    }
    return result;
}

Obj VectorLongToObj(const std::vector<long>& cpp_vec) {
    Int len = static_cast<Int>(cpp_vec.size());
    Obj gap_list = NEW_PLIST(T_PLIST, len);
    SET_LEN_PLIST(gap_list, len);
    for (Int i = 0; i < len; ++i) {
        SET_ELM_PLIST(gap_list, i + 1, LongToObj(cpp_vec[i]));
        CHANGED_BAG(gap_list);
    }
    return gap_list;
}