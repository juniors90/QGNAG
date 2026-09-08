#ifndef CPP_LOGIC_H
#define CPP_LOGIC_H

#include <vector> // Necesario para que el header entienda qué es std::vector
#include <string>

long CppDivide(long a, long b);
long CppSumVector(const std::vector<long>& vec);
std::vector<std::string> CppSortStrings(std::vector<std::string> names);
std::string CppRemoveCharacters(std::string text, const std::string& chars_to_remove);
double CppSumVectorDouble(const std::vector<double>& vec);

#endif