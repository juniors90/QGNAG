#############################################################################
##
#W  checkpaper.gd                            QGNAG
##
##  Check of SimplesMn against Section 5 of the paper (specific to the 56 simples).
##
#############################################################################

#! @Description
#!  Prints one line per module of <A>simples</A> that disagrees with the data of
#!  Section 5 of the paper and the final count; returns true if all 56 agree.
#! @Arguments simples, names
#! @Returns true or false
DeclareGlobalFunction("QGNAG_CheckSimplesAgainstPaper");
DeclareGlobalFunction("QGNAG_CheckPaper_ExpectedData");
DeclareGlobalFunction("QGNAG_CheckPaper_ActualSupport");
