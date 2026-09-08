#ifndef GAP_BINDINGS_H
#define GAP_BINDINGS_H

extern "C" {
#include <gap_all.h>
}

extern "C" Obj FuncCppQuoInt(Obj self, Obj arg1, Obj arg2);
extern "C" Obj FuncCppSumVector(Obj self, Obj arg1); 
extern "C" Obj FuncCppSortStrings(Obj self, Obj arg1);
extern "C" Obj FuncCppRecNames(Obj self, Obj arg1);
// Declaración de los wrappers
extern "C" Obj FuncHasRecordField(Obj self, Obj rec, Obj gap_name);
extern "C" Obj FuncGetRecordField(Obj self, Obj rec, Obj gap_name);
extern "C" Obj FuncSetRecordField(Obj self, Obj rec, Obj gap_name, Obj value);
extern "C" Obj FuncCppRemoveCharacters(Obj self, Obj arg1, Obj arg2);
extern "C" Obj FuncCppSumVectorDouble(Obj self, Obj arg1);
extern "C" Obj FuncCppMatrixTranspose(Obj self, Obj arg1);
extern "C" Obj FuncCppKronecker(Obj self, Obj arg1, Obj arg2);
extern "C" Obj FuncCppDimHomAModules(Obj self, Obj arg1, Obj arg2);
extern "C" Obj FuncCppDimHomAModulesParallel(Obj self, Obj arg1, Obj arg2);
extern "C" Obj FuncTestDimHomAllIntegerParallel( Obj self, Obj arg1, Obj arg2 );
extern "C" Obj FuncTestE(Obj self, Obj gap_n);
extern "C" Obj FuncTestComplex(Obj self, Obj gap_cyc);
extern "C" Obj FuncTestRoundTrip(Obj self, Obj gap_cyc);
extern "C" Obj FuncCppDimHomAModulesComplex(Obj self, Obj arg1, Obj arg2);
extern "C" Obj FuncCppTestDimHomAllComplexParallel(Obj self, Obj arg1, Obj arg2);
extern "C" Obj FuncQGNAG_FusionRulesAsVectorsParallel(Obj self, Obj arg1, Obj arg2);
extern "C" Obj FuncCppStructureMatrixForXi(Obj self, Obj arg1, Obj arg2);
extern "C" Obj FuncCppXiMatrixAction(Obj self, Obj arg1, Obj arg2);

#endif