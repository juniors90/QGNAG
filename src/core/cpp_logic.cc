#include "cpp_logic.h"
#include <stdexcept>
#include <numeric> // Necesario para std::accumulate
#include <algorithm> // Para std::sort std::remove_if

long CppDivide(long a, long b) {
    if (b == 0) throw std::invalid_argument("Division by zero is undefined.");
    return a / b;
}

// Agregamos la lógica real de negocio
long CppSumVector(const std::vector<long>& vec) {
    // std::accumulate suma todos los elementos del vector desde el principio hasta el final
    return std::accumulate(vec.begin(), vec.end(), 0L);
}

std::vector<std::string> CppSortStrings(std::vector<std::string> names) {
    // Ordenamiento nativo de C++ (mucho más rápido que en GAP)
    std::sort(names.begin(), names.end());
    return names;
}

std::string CppRemoveCharacters(std::string text, const std::string& chars_to_remove) {
    // std::remove_if mueve los caracteres a borrar al final del string, 
    // y erase corta el string desde ahí hasta el final. Es el famoso patrón "Erase-Remove".
    text.erase(
        std::remove_if(text.begin(), text.end(),
            [&chars_to_remove](char c) {
                // Devuelve true si el caracter 'c' está en 'chars_to_remove'
                return chars_to_remove.find(c) != std::string::npos;
            }),
        text.end()
    );
    return text;
}

double CppSumVectorDouble(const std::vector<double>& vec) {
    return std::accumulate(vec.begin(), vec.end(), 0.0);
}