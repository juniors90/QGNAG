#include "decomposition_converters.h"
#include "scalar.h"

Obj DecompositionResultToObj(const DecompositionResult& r)
{
    Obj rec = NEW_PREC(0);

    UInt rnam_first  = RNamName("first");
    UInt rnam_second = RNamName("second");
    UInt rnam_vector = RNamName("vector");

    AssPRec(rec, rnam_first,  LongToObj(r.first));
    AssPRec(rec, rnam_second, LongToObj(r.second));
    AssPRec(rec, rnam_vector, VectorLongToObj(r.vector));

    // Mantener el record ordenado por nombre de campo (buena práctica GAP).
    SortPRecRNam(rec, 0);

    return rec;
}

Obj VectorDecompositionResultToObj(const std::vector<DecompositionResult>& results)
{
    Int len = static_cast<Int>(results.size());
    Obj gap_list = NEW_PLIST(T_PLIST, len);
    SET_LEN_PLIST(gap_list, len);

    for (Int i = 0; i < len; ++i) {
        SET_ELM_PLIST(gap_list, i + 1, DecompositionResultToObj(results[i]));
        CHANGED_BAG(gap_list);
    }

    return gap_list;
}