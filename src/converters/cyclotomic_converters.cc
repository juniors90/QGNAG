#include "cyclotomic_converters.h"
#include "scalar.h"
#include <stdexcept>
#include <cmath>

static Obj CallGAPFunc1(const char* name, Obj arg1) {
    UInt gvar = GVarName(name);
    Obj func = VAL_GVAR(gvar);
    if (!func) {
        throw std::runtime_error(std::string("GAP function '") + name + "' is not bound.");
    }
    return CALL_1ARGS(func, arg1);
}

bool IsCyclotomic(Obj gap_cyc) {
    if (IS_INTOBJ(gap_cyc) || IS_MACFLOAT(gap_cyc) || IS_CYC(gap_cyc)) {
        return true;
    }
    return CallGAPFunc1("IsCyclotomic", gap_cyc) == True;
}

Obj CreateE(long n) {
    if (n <= 0) {
        throw std::invalid_argument("Conductor N must be positive.");
    }
    return CallGAPFunc1("E", LongToObj(n));
}

Cyclotomic ObjToCyclotomic(Obj gap_cyc) {
    if (!IsCyclotomic(gap_cyc)) {
        throw std::invalid_argument("Type Error: Expected a GAP cyclotomic number.");
    }

    Cyclotomic cyc;

    if (IS_INTOBJ(gap_cyc)) {
        cyc.conductor = 1;
        cyc.terms.push_back({0, static_cast<double>(INT_INTOBJ(gap_cyc))});
        return cyc;
    }

    if (IS_MACFLOAT(gap_cyc)) {
        cyc.conductor = 1;
        cyc.terms.push_back({0, VAL_MACFLOAT(gap_cyc)});
        return cyc;
    }

    // Obtener el conductor N
    Obj cond_obj = CallGAPFunc1("Conductor", gap_cyc);
    cyc.conductor = ObjToLong(cond_obj);

    // ExtRepOfObj es una lista densa [c_0, c_1, ..., c_{N-1}]
    Obj ext_rep = CallGAPFunc1("ExtRepOfObj", gap_cyc);

    UInt len = LEN_LIST(ext_rep);
    for (UInt i = 1; i <= len; ++i) {
        Obj coeff_obj = ELM_LIST(ext_rep, i);
        if (coeff_obj == INTOBJ_INT(0)) {
            continue;
        }

        double coeff = 0.0;
        if (IS_INTOBJ(coeff_obj) || IS_MACFLOAT(coeff_obj)) {
            coeff = ObjToDouble(coeff_obj);
        } else {
            Obj float_coeff = CallGAPFunc1("Float", coeff_obj);
            coeff = ObjToDouble(float_coeff);
        }

        long exponent = static_cast<long>(i - 1);
        cyc.terms.push_back({exponent, coeff});
    }

    return cyc;
}

Obj CyclotomicToObj(const Cyclotomic& cyc) {
    if (cyc.conductor <= 0) {
        throw std::invalid_argument("Conductor must be greater than zero.");
    }

    Obj base_e = CreateE(cyc.conductor);
    Obj sum = INTOBJ_INT(0);

    for (const auto& term : cyc.terms) {
        Obj e_pow = POW(base_e, LongToObj(term.exponent));
        
        // Si el coeficiente es entero, mantenemos exactitud algebraicamente
        Obj coeff_obj = (std::floor(term.coefficient) == term.coefficient)
                            ? LongToObj(static_cast<long>(term.coefficient))
                            : DoubleToObj(term.coefficient);

        Obj term_obj = PROD(coeff_obj, e_pow);
        sum = SUM(sum, term_obj);
    }

    return sum;
}

std::complex<double> ObjToComplex(Obj gap_cyc) {
    if (IS_INTOBJ(gap_cyc)) {
        return {static_cast<double>(INT_INTOBJ(gap_cyc)), 0.0};
    }
    if (IS_MACFLOAT(gap_cyc)) {
        return {VAL_MACFLOAT(gap_cyc), 0.0};
    }

    Cyclotomic cyc = ObjToCyclotomic(gap_cyc);

    double real_part = 0.0;
    double imag_part = 0.0;
    const double two_pi = 2.0 * std::acos(-1.0);

    for (const auto& term : cyc.terms) {
        double angle = two_pi * static_cast<double>(term.exponent) / static_cast<double>(cyc.conductor);
        real_part += term.coefficient * std::cos(angle);
        imag_part += term.coefficient * std::sin(angle);
    }

    return {real_part, imag_part};
}