#
# QGNAG: Computations with quantum groups at a non-abelian group, including Drinfeld doubles, simple modules, characters, and Hilbert series.
#
# This file runs package tests. It is also referenced in the package
# metadata in PackageInfo.g.
#
LoadPackage( "QGNAG" );

TestDirectory(DirectoriesPackageLibrary( "QGNAG", "tst" ),
  rec(exitGAP := true));

FORCE_QUIT_GAP(1); # if we ever get here, there was an error
