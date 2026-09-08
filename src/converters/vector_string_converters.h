#ifndef VECTOR_STRING_CONVERTERS_H
#define VECTOR_STRING_CONVERTERS_H

extern "C" {
#include <gap_all.h>
}
#include <string>
#include <vector>

std::vector<std::string> ObjToVectorString(Obj gap_list);
Obj VectorStringToObj(const std::vector<std::string>& cpp_vec);

#endif