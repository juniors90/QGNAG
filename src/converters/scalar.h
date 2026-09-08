#ifndef SCALAR_H
#define SCALAR_H

extern "C" {
#include <gap_all.h>
}
#include <string>
#include <vector>

// Enteros (long y int)
long ObjToLong(Obj gap_int);
Obj LongToObj(long cpp_long);
int ObjToInt(Obj gap_int);
Obj IntToObj(int cpp_int);

// Flotantes
double ObjToDouble(Obj gap_float);
Obj DoubleToObj(double cpp_double);

// Cadenas de texto
std::string ObjToString(Obj gap_str);
Obj StringToObj(const std::string& cpp_str);

// agregar a scalar.h, junto a las otras firmas
std::vector<long> ObjToVectorLong(Obj gap_list);
Obj VectorLongToObj(const std::vector<long>& cpp_vec);

#endif