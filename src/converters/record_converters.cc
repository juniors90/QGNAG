#include "record_converters.h"
#include <stdexcept>

std::vector<std::string> ObjToRecordNames(Obj gap_rec) {
    if (!IS_REC(gap_rec)) {
        throw std::invalid_argument("Type Error: Expected a GAP record.");
    }

    std::vector<std::string> names;

    if (TNUM_OBJ(gap_rec) == T_PREC) {
        UInt len = LEN_PREC(gap_rec);
        names.reserve(len);

        for (UInt i = 1; i <= len; ++i) {
            UInt rnam = GET_RNAM_PREC(gap_rec, i);
            if (rnam != 0) {
                Obj name_obj = NAME_RNAM(rnam);
                if (name_obj) {
                    names.push_back(std::string(CSTR_STRING(name_obj)));
                }
            }
        }
    } else {
        throw std::invalid_argument("Error: Unsupported record type.");
    }

    return names;
}

bool HasRecordField(Obj rec, const std::string& name) {
    if (!IS_REC(rec)) {
        throw std::invalid_argument("Type Error: Expected a GAP record.");
    }

    // RNamName devuelve el identificador numérico interno de la clave
    UInt rnam = RNamName(name.c_str());
    
    // ISB_REC (Is Bound Record) verifica si la clave está definida en el record
    return ISB_REC(rec, rnam) != 0;
}

Obj GetRecordField(Obj rec, const std::string& name) {
    if (!HasRecordField(rec, name)) {
        throw std::runtime_error("Key Error: Record field '" + name + "' does not exist.");
    }

    UInt rnam = RNamName(name.c_str());
    return ELM_REC(rec, rnam);
}

void SetRecordField(Obj rec, const std::string& name, Obj value) {
    if (!IS_REC(rec)) {
        throw std::invalid_argument("Type Error: Expected a GAP record.");
    }

    UInt rnam = RNamName(name.c_str());
    ASS_REC(rec, rnam, value);
}
