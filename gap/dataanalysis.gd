#############################################################################
##
#W  dataanalysis.gd
##
#############################################################################
#! @Chapter Data Analysis
#! Tools for collecting, processing and visualizing numerical data
#! obtained from computations in QGNAG.
#!
#! @Section Data Gradeed
#!
#! @BeginGroup Data analysis
#! Functions for collecting and processing numerical data arising from
#! computations in QGNAG.
#! @EndGroup

#! @Description
#! Given a list of DG-action matrices and a list of records indexed by
#! degree, this function computes, for each degree, the value returned by
#! <C>QGNAG_DimHomAModules</C>.
#!
#! The output is a record whose entries are indexed by degree.
#!
#! If all entries associated with a given degree are empty lists, then the
#! corresponding value is set to <C>0</C>.
#!
#! @Arguments AllMatricesDG, AllMatricesByDegree
#! @Returns a record indexed by degree
DeclareGlobalFunction("QGNAG_VermaModuleSocleDecomposition");
DeclareGlobalFunction( "QGNAG_RecordToHTMLTable" );
DeclareGlobalFunction( "QGNAG_RecordOfListsToHTMLTable" );
DeclareGlobalFunction( "QGNAG_GradedRecordToColumns" );
DeclareGlobalFunction( "QGNAG_RecordListToHTMLTable" );
DeclareGlobalFunction( "QGNAG_FilterZeroRows" );
DeclareGlobalFunction( "QGNAG_DecompositionSummary" );
DeclareGlobalFunction( "QGNAG_Decomposition" );
DeclareGlobalFunction( "QGNAG_PrintDecomposition" );
DeclareGlobalFunction( "QGNAG_DisplayDecomposition" );
DeclareGlobalFunction( "QGNAG_DisplayDecompositionByDegree" );
DeclareGlobalFunction( "QGNAG_PrintDecompositionSimples" );
DeclareGlobalFunction( "QGNAG_PrintDecompositionSimplesByDegree" );
#! 
#! rec_info := QGNAG_Decomposition(record_data_decomp);
#! QGNAG_PrintDecompositionSimples(rec_info_simples);
#! degree:=0;;
#! QGNAG_PrintDecompositionSimplesByDegree(rec_info_simples, degree);
#!
DeclareGlobalFunction( "QGNAG_CharacterSummary" );