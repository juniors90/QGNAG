#ifndef RECORD_CONVERTERS_H
#define RECORD_CONVERTERS_H

extern "C" {
#include <gap_all.h>
#include <precord.h>
}
#include <string>
#include <vector>

// Extrae todas las claves (RNam) de un Record y las devuelve como vector de strings
std::vector<std::string> ObjToRecordNames(Obj gap_rec);


// Operaciones sobre campos
bool HasRecordField(Obj rec, const std::string& name);
Obj GetRecordField(Obj rec, const std::string& name);
void SetRecordField(Obj rec, const std::string& name, Obj value);

#endif