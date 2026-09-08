#
# QGNAG: Computations with quantum groups at a non-abelian group, including Drinfeld doubles, simple modules, characters, and Hilbert series.
#
# Reading the declaration part of the package.
#
_PATH_SO:=Filename(DirectoriesPackagePrograms("qgnag"), "qgnag.so");
if _PATH_SO <> fail then
    LoadDynamicModule(_PATH_SO);
fi;
Unbind(_PATH_SO);
ReadPackage( "QGNAG", "gap/QGNAG.gd" );
ReadPackage( "QGNAG", "gap/semidirectproduct.gd" );
ReadPackage( "QGNAG", "gap/fqelement.gd" );
ReadPackage( "QGNAG", "gap/transporter.gd" );
ReadPackage( "QGNAG", "gap/conmutationsrulesxy.gd" );
ReadPackage( "QGNAG", "gap/tensorelement.gd" );
ReadPackage( "QGNAG", "gap/deltafunctionforsemidirectproduct.gd" );
ReadPackage( "QGNAG", "gap/basisforYDmodule.gd" );
ReadPackage( "QGNAG", "gap/tensorproductmatrix.gd" );
ReadPackage( "QGNAG", "gap/yj_matrix.gd" );
ReadPackage( "QGNAG", "gap/algebras/basiselementofverma.gd" );
ReadPackage( "QGNAG", "gap/checksimples.gd" );
ReadPackage( "QGNAG", "gap/matrix_data.gd" );
ReadPackage( "QGNAG", "gap/semi_ytop_xtop_ascending_words.gd" );
ReadPackage( "QGNAG", "gap/hilbertseries.gd" );
ReadPackage( "QGNAG", "gap/drinfelddoubleofG.gd" );
ReadPackage( "QGNAG", "gap/nicholssmash.gd" );
ReadPackage( "QGNAG", "gap/printing.gd" );
ReadPackage( "QGNAG", "gap/deltamatix.gd" );
ReadPackage( "QGNAG", "gap/ximatrix.gd" );
ReadPackage( "QGNAG", "gap/gmatrix.gd" );
ReadPackage( "QGNAG", "gap/homspace.gd");
ReadPackage( "QGNAG", "gap/dataanalysis.gd" );
ReadPackage( "QGNAG", "gap/visualization.gd" );
ReadPackage( "QGNAG", "gap/fusionrules.gd" );
ReadPackage( "QGNAG", "gap/quantumcharacters.gd" );
ReadPackage( "QGNAG", "gap/braided.gd" );
ReadPackage( "QGNAG", "gap/block_classification.gd");
ReadPackage( "QGNAG", "gap/neg_notation.gd" );
ReadPackage( "QGNAG", "gap/graph.gd");