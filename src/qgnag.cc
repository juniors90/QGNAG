/*
 * QGNAG: Computations with quantum groups at a non-abelian group, including Drinfeld doubles, simple modules, characters, and Hilbert series.
 */

extern "C" {
#include <gap_all.h>    // GAP headers
}
#include "kernel/gap_bindings.h" // Importamos nuestras declaraciones


// Table of functions to export
static StructGVarFunc GVarFuncs [] = {
    GVAR_FUNC(CppQuoInt, 2, "a, b"),
    GVAR_FUNC(CppSumVector, 1, "list"),
    GVAR_FUNC(CppSortStrings, 1, "list_of_strings"),
    GVAR_FUNC(CppRecNames, 1, "rec"),
    GVAR_FUNC(CppRemoveCharacters, 2, "string, chars_to_remove"),
    GVAR_FUNC(CppSumVectorDouble, 1, "float_list"),
    GVAR_FUNC(HasRecordField, 2, "rec, name"),
    GVAR_FUNC(GetRecordField, 2, "rec, name"),
    GVAR_FUNC(SetRecordField, 3, "rec, name, value"),
    GVAR_FUNC(CppMatrixTranspose, 1, "matrix"),
    GVAR_FUNC(CppKronecker, 2, "A, B"),
    GVAR_FUNC(CppDimHomAModules, 2, "Nrep, Mrep"),
    GVAR_FUNC(CppDimHomAModulesParallel, 2, "Nrep, Mrep"),
    GVAR_FUNC(TestDimHomAllIntegerParallel, 2, "allT, allS"),
    GVAR_FUNC(TestE, 1, "n"),
    GVAR_FUNC(TestComplex, 1, "cyc"),
    GVAR_FUNC(TestRoundTrip, 1, "cyc"),
    GVAR_FUNC(CppDimHomAModulesComplex, 2, "Nrep, Mrep"),
    GVAR_FUNC(CppTestDimHomAllComplexParallel, 2, "allT, allS"),
    GVAR_FUNC(QGNAG_FusionRulesAsVectorsParallel, 2, "allT, allS"),
    GVAR_FUNC(CppStructureMatrixForXi, 2, "XiActionOnBasisNichols, BaseNichols"),
    GVAR_FUNC(CppXiMatrixAction, 2, "XiMatrixOnNichols, simple"),
    { 0 } /* Finish with an empty entry */
};

/****************************************************************************
**
*F  InitKernel( <module> ) . . . . . . . .  initialise kernel data structures
*/
static Int InitKernel( StructInitInfo *module )
{
    /* init filters and functions */
    InitHdlrFuncsFromTable( GVarFuncs );

    /* return success */
    return 0;
}

/****************************************************************************
**
*F  InitLibrary( <module> ) . . . . . . .  initialise library data structures
*/
static Int InitLibrary( StructInitInfo *module )
{
    /* init filters and functions */
    InitGVarFuncsFromTable( GVarFuncs );

    /* return success */
    return 0;
}

/****************************************************************************
**
*F  Init__Dynamic() . . . . . . . . . . . . . . . . . table of init functions
*/
static StructInitInfo module = {
 /* type        = */ MODULE_DYNAMIC,
 /* name        = */ "qgnag",
 /* revision_c  = */ 0,
 /* revision_h  = */ 0,
 /* version     = */ 0,
 /* crc         = */ 0,
 /* initKernel  = */ InitKernel,
 /* initLibrary = */ InitLibrary,
 /* checkInit   = */ 0,
 /* preSave     = */ 0,
 /* postSave    = */ 0,
 /* postRestore = */ 0,
};

extern "C"
StructInitInfo *Init__Dynamic( void )
{
    return &module;
}
