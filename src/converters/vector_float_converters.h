#ifndef VECTOR_FLOAT_CONVERTERS_H
#define VECTOR_FLOAT_CONVERTERS_H

extern "C" {
#include <gap_all.h>
}
#include <vector>

std::vector<double> ObjToVectorDouble(Obj gap_list);
Obj VectorDoubleToObj(const std::vector<double>& cpp_vec);

#endif