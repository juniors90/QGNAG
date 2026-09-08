#ifndef CYCLOTOMIC_CONVERTERS_H
#define CYCLOTOMIC_CONVERTERS_H

extern "C" {
#include <gap_all.h>
}
#include <complex>
#include <vector>

struct CyclotomicTerm {
    long exponent;
    double coefficient;
};

struct Cyclotomic {
    long conductor;
    std::vector<CyclotomicTerm> terms;
};

// Comprobaciones
bool IsCyclotomic(Obj gap_cyc);

// Generar la raíz primitiva E(N) = e^(2*pi*i/N)
Obj CreateE(long n);

// Conversión exacta (algebraica)
Cyclotomic ObjToCyclotomic(Obj gap_cyc);
Obj CyclotomicToObj(const Cyclotomic& cyc);

// Conversión a std::complex<double> para cálculos numéricos
std::complex<double> ObjToComplex(Obj gap_cyc);

#endif