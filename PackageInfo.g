#
# QGNAG: Computations with quantum groups at a non-abelian group, including Drinfeld doubles, simple modules, characters, and Hilbert series.
#
# This file contains package meta data. For additional information on
# the meaning and correct usage of these fields, please consult the
# manual of the "Example" package as well as the comments in its
# PackageInfo.g file.
#
SetPackageInfo( rec(

PackageName := "QGNAG",
Subtitle := "Computations with quantum groups at a non-abelian group, including Drinfeld doubles, simple modules, characters, and Hilbert series.",
Version := "0.1",
Date := "16/11/2025", # dd/mm/yyyy format
License := "GPL-2.0-or-later",

Persons := [
  rec(
    FirstNames := "Juan David",
    LastName := "Ferreira",
    WWWHome := "https://github.com/juniors90",
    Email := "juandavid9a0@gmail.com",
    IsAuthor := true,
    IsMaintainer := true,
    PostalAddress := "5000",
    Place := "Cordoba - Argentina",
    Institution := "CIEM (Center of Research and Studies in Mathematics) - National University of Córdoba",
  ),
],

SourceRepository := rec( Type := "github", URL := "https://github.com/juniors90/QGNAG" ),
IssueTrackerURL := "https://github.com/juniors90/QGNAG/issues",
PackageWWWHome := "https://TODO/",
PackageInfoURL := Concatenation( ~.PackageWWWHome, "PackageInfo.g" ),
README_URL     := Concatenation( ~.PackageWWWHome, "README.md" ),
ArchiveURL     := Concatenation( ~.PackageWWWHome,
                                 "/", ~.PackageName, "-", ~.Version ),

ArchiveFormats := ".tar.gz",

##  Status information. Currently the following cases are recognized:
##    "accepted"      for successfully refereed packages
##    "submitted"     for packages submitted for the refereeing
##    "deposited"     for packages for which the GAP developers agreed
##                    to distribute them with the core GAP system
##    "dev"           for development versions of packages
##    "other"         for all other packages
##
Status := "dev",

AbstractHTML := "Computations with quantum groups at a non-abelian group, including Drinfeld doubles, simple modules, characters, and Hilbert series.",


PackageDoc := rec(
  BookName  := "QGNAG",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0_mj.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "Computations with quantum groups at a non-abelian group, including Drinfeld doubles, simple modules, characters, and Hilbert series.",
),

Dependencies := rec(
  GAP := ">= 4.11",
  NeededOtherPackages := [ [ "GAPDoc", ">= 1.6.1" ],
                           [ "RepnDecomp", ">= 1.3.0" ] ],
  SuggestedOtherPackages := [ [ "Repsn", ">= 3.1.2" ] ],
  ExternalConditions := [ ],
),

AvailabilityTest := ReturnTrue,

TestFile := "tst/testall.g",

Keywords := [
    "quantum groups",
    "non-abelian groups",
    "Drinfeld double",
    "Nichols algebras",
    "bosonization",
    "simple modules",
    "characters",
    "Hilbert series",
    "Hopf algebras",
    "Yetter-Drinfeld modules"
],

));


