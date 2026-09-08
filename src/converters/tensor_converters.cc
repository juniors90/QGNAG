#include "tensor_converters.h"
#include "matrix_complex_converters.h"
#include "scalar.h"
#include <stdexcept>

std::vector<TensorEntry> ObjToTensorEntries(Obj gap_list)
{
    if (!IS_LIST(gap_list)) {
        throw std::invalid_argument("Type Error: Expected a list of tensor records.");
    }

    UInt rnam_first  = RNamName("first");
    UInt rnam_second = RNamName("second");
    UInt rnam_tensor = RNamName("tensor");

    Int len = LEN_LIST(gap_list);
    std::vector<TensorEntry> result;
    result.reserve(len);

    for (Int i = 1; i <= len; ++i) {
        Obj rec = ELM_LIST(gap_list, i);

        if (!IS_REC(rec)) {
            throw std::invalid_argument("Type Error: expected a record with 'first', 'second', 'tensor'.");
        }
        if (!ISB_REC(rec, rnam_first) || !ISB_REC(rec, rnam_second) || !ISB_REC(rec, rnam_tensor)) {
            throw std::invalid_argument("Type Error: record is missing 'first', 'second', or 'tensor'.");
        }

        TensorEntry e;
        e.first  = ObjToLong(ELM_REC(rec, rnam_first));
        e.second = ObjToLong(ELM_REC(rec, rnam_second));
        e.tensor = ObjToVectorMatrixComplex(ELM_REC(rec, rnam_tensor));

        result.push_back(std::move(e));
    }

    return result;
}