#############################################################################
##
#W  checkpaper.gi                            QGNAG
##
##  SPECIFIC to G = F_4 x|_omega C_6 (the 56 simple modules of the paper): compares
##  SimplesMn with the data of Section 5 (corrected as in Appendix C of the review).
##
#############################################################################

# Data of Section 5 for the module in position k of the enumeration.
# support = list of [a, s, diagonal positions] with a in "0", "1", "w" (omega), "w2" (omega^2).
InstallGlobalFunction(QGNAG_CheckPaper_ExpectedData, function(k)
    local P3, Z3, Pt, Z4, tau, s, i, j, l, c, T, Z, sup;
    P3  := [[0,0,1],[1,0,0],[0,1,0]];
    Z3  := [[0,1,0],[1,0,0],[-1,-1,-1]];
    Pt  := [[1,0,0,0],[0,0,1,0],[0,0,0,1],[0,1,0,0]];
    Z4  := [[0,0,1,0],[0,0,0,1],[1,0,0,0],[0,1,0,0]];
    tau := [[0,0],[1,2],[0,1],[1,0],[0,2],[1,1]];
    if k in [1 .. 12] then                      # M(s, tau_ij): [t] = (-1)^i zeta^j, [z] = 1
        s := 0;
        if k > 6 then s := 3; fi;
        i := tau[((k - 1) mod 6) + 1][1];
        j := tau[((k - 1) mod 6) + 1][2];
        return rec(T := [[(-1)^i * E(3)^j]], Z := [[1]], support := [["0", s, [1]]]);
    elif k in [13 .. 16] then                   # M(s, rho_i)
        s := 0;
        if k > 14 then s := 3; fi;
        i := (k - 13) mod 2;
        return rec(T := (-1)^i * P3, Z := Z3, support := [["0", s, [1, 2, 3]]]);
    elif k in [17 .. 32] then                   # M(s, chi_(i,j,l))
        s := 0;
        if k > 24 then s := 3; fi;
        c := (k - 17) mod 8;
        i := QuoInt(c, 4);
        j := QuoInt(c mod 4, 2);
        l := c mod 2;
        T := [[0, 0, (-1)^l], [1, 0, 0], [0, 1, 0]];
        Z := DiagonalMat([(-1)^i, (-1)^j, (-1)^(i + j)]);
        return rec(T := T, Z := Z,
                   support := [["1", s, [1]], ["w", s, [2]], ["w2", s, [3]]]);
    else                                        # M(s, eta_l), s in 1, 2, 4, 5
        s := [1, 2, 4, 5][QuoInt(k - 33, 6) + 1];
        l := (k - 33) mod 6;
        T := (-1)^l * E(3)^l * Pt;
        if s in [1, 4] then
            sup := [["0", s, [1]], ["1", s, [2]], ["w2", s, [3]], ["w", s, [4]]];
        else
            sup := [["0", s, [1]], ["w2", s, [2]], ["w", s, [3]], ["1", s, [4]]];
        fi;
        return rec(T := T, Z := Z4, support := sup);
    fi;
end);

# Nonzero delta_h of a simple module as a sorted list of [a, s, diagonal positions].
InstallGlobalFunction(QGNAG_CheckPaper_ActualSupport, function(simple, dm)
    local out, d, pair, diag, idx;
    out := [];
    for d in simple.DeltaStructureMatrices do
        if not IsZero(d.matrix) then
            pair := QGNAG_SimplesSummary_ElementToPair(d.element);
            diag := List([1 .. dm], r -> d.matrix[r][r]);
            idx  := Filtered([1 .. dm], r -> diag[r] <> 0);
            if d.matrix <> DiagonalMat(diag) or ForAny(diag, x -> not x in [0, 1]) then
                idx := "not a diagonal 0/1 matrix";
            fi;
            Add(out, [pair.a, Int(pair.s), idx]);
        fi;
    od;
    Sort(out);
    return out;
end);

InstallGlobalFunction(QGNAG_CheckSimplesAgainstPaper, function(simples, names)
    local k, gens, ex, dm, okT, okZ, okS, bad, good, msg, label;
    if Length(simples) <> 56 then
        Error("QGNAG_CheckSimplesAgainstPaper: expected the 56 simple modules of the paper");
    fi;
    good := 0;
    bad  := [];
    for k in [1 .. 56] do
        gens := List(simples[k].generatorsofgroup, g -> simples[k].simple(g));
        ex   := QGNAG_CheckPaper_ExpectedData(k);
        dm   := Length(gens[1]);
        okT  := gens[1] = ex.T;
        okZ  := gens[4] = ex.Z;
        okS  := QGNAG_CheckPaper_ActualSupport(simples[k], dm) = SortedList(ex.support);
        if okT and okZ and okS then
            good := good + 1;
        else
            if k <= Length(names) then label := names[k]; else label := ""; fi;
            msg := Concatenation("#W module ", String(k), " ", label, ":");
            if not okT then msg := Concatenation(msg, " [t] differs;"); fi;
            if not okZ then msg := Concatenation(msg, " [z] differs;"); fi;
            if not okS then msg := Concatenation(msg, " supports differ;"); fi;
            Add(bad, msg);
        fi;
    od;
    for msg in bad do
        Print(msg, "\n");
    od;
    Print("Agreement with Section 5 of the paper: ", good, "/56 modules.\n");
    return Length(bad) = 0;
end);
