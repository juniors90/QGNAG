#ifndef STRUCTURE_MATRIX_H
#define STRUCTURE_MATRIX_H

extern "C" {
#include <gap_all.h>
}

// Builds the structure matrix of x_i on the Nichols algebra monomial
// basis, mirroring StructureMatrixForXi (pure GAP). Returns an Obj
// (a GAP list of lists) directly: entries are exact GAP rationals and
// are copied as-is, with no intermediate C++ numeric representation,
// so no precision is ever lost.
Obj QGNAG_CppStructureMatrixForXi(Obj XiActionOnBasisNichols, Obj BaseNichols);

// Builds the block-diagonal direct sum of k copies of XiMatrixOnNichols,
// where k is the degree of the given simple module (the size of its
// first generator matrix, i.e. Length(simple[1])). Mirrors
// QGNAG_XiMatrixAction (pure GAP), but computes the block layout at
// the kernel level instead of building an intermediate GAP list and
// calling DirectSumMat on it.
Obj QGNAG_CppXiMatrixAction(Obj XiMatrixOnNichols, Obj simple);

#endif