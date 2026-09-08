// src/converters/list_converters.h
#ifndef LIST_CONVERTERS_H
#define LIST_CONVERTERS_H

extern "C" {
#include <gap_all.h>
}
#include <vector>

std::vector<long> ObjToVector(Obj gap_list);
Obj VectorToObj(const std::vector<long>& cpp_vec);

#endif