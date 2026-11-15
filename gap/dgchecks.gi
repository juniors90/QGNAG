#############################################################################
##
#W  dgchecks.gi                                  QGNAG
##
##  Checks of the simple D(G)-modules and comparison with the paper (new text).
##  Convention (the one of the notebook, relation delta_h g = g delta_{g^-1 h g}):
##      rho(g) delta_h rho(g)^-1 = delta_{g h g^-1},   matrices act on column vectors.
##  Conjugations are always written g*h*g^-1 (never h^g).
##
#############################################################################

# ------------------------------------------------------------------------- printing
InstallGlobalFunction(QGNAG_DGCHECKS_Line, function(ok, label)
    if ok then
        Print("[ OK ]  ", label, "\n");
    else
        Print("[FAIL]  ", label, "\n");
    fi;
    return ok;
end);

# ------------------------------------------------------------------------- linear algebra
# ------------------------------------------------------------------------- matching the elements stored in DeltaStructureMatrices
# The modules of SimplesMn store the elements h of DeltaStructureMatrices as objects of the package printed "( a , s )",
# which are not equal to the elements of G. They are matched through the pair (a, s): h = z^alpha y^beta t^s,
# with a = alpha + beta w ("0", "1", "w", "w2"), where [t, x, y, z] = generatorsofgroup.

# Key [a, s] of an element h of G.
InstallGlobalFunction(QGNAG_GroupElementKey, function(gens, h)
    local t, y, z, alpha, beta, s, names;
    t := gens[1]; y := gens[3]; z := gens[4];
    names := ["0", "1", "w", "w2"];
    for alpha in [0, 1] do
        for beta in [0, 1] do
            for s in [0 .. 5] do
                if z^alpha * y^beta * t^s = h then
                    return [names[1 + alpha + 2 * beta], s];
                fi;
            od;
        od;
    od;
    return fail;
end);

# Key [a, s] of a stored element printed "( a , s )" (same reading as QGNAG_SimplesSummaryToLaTeX).
InstallGlobalFunction(QGNAG_DeltaElementKey, function(e)
    local str, out, pos, a, s;
    str := "";
    out := OutputTextString(str, true);
    PrintTo(out, e);
    CloseStream(out);
    str := NormalizedWhitespace(str);
    if Length(str) >= 2 and str[1] = '(' and str[Length(str)] = ')' then
        str := str{[2 .. Length(str) - 1]};
    fi;
    pos := Position(str, ',');
    if pos = fail then
        return fail;
    fi;
    a := NormalizedWhitespace(str{[1 .. pos - 1]});
    s := Int(NormalizedWhitespace(str{[pos + 1 .. Length(str)]}));
    if s = fail then
        return fail;
    fi;
    if PositionSublist(a, "_3^2") <> fail or PositionSublist(a, "E(3)^2") <> fail or PositionSublist(a, "Z(2^2)^2") <> fail then
        a := "w2";
    elif PositionSublist(a, "_3") <> fail or PositionSublist(a, "E(3)") <> fail or PositionSublist(a, "Z(2^2)") <> fail then
        a := "w";
    elif a = "Z(2)^0" then
        a := "1";
    elif a = "0*Z(2)" then
        a := "0";
    fi;
    return [a, s];
end);

# Position in Elements(G) of the element e stored in a module (an element of G, or an object printed "( a , s )"); fail if none.
InstallGlobalFunction(QGNAG_ElementIndex, function(G, gens, e)
    local elms, pos, key;
    elms := Elements(G);
    pos := Position(elms, e);
    if pos <> fail then
        return pos;
    fi;
    key := QGNAG_DeltaElementKey(e);
    if key = fail then
        return fail;
    fi;
    return PositionProperty(elms, h -> QGNAG_GroupElementKey(gens, h) = key);
end);

# List of the matrices delta_h of the module s, in the order of Elements(s.group); an entry is fail if no stored element matches h.
InstallGlobalFunction(QGNAG_ModuleDeltas, function(s)
    local G, elms, gens, res, d, pos, hkeys, key;
    G := s.group;
    elms := Elements(G);
    gens := s.generatorsofgroup;
    res := List(elms, h -> fail);
    hkeys := fail;
    for d in s.DeltaStructureMatrices do
        pos := Position(elms, d.element);
        if pos = fail then
            if hkeys = fail then
                hkeys := List(elms, h -> QGNAG_GroupElementKey(gens, h));
            fi;
            key := QGNAG_DeltaElementKey(d.element);
            if key <> fail then
                pos := Position(hkeys, key);
            fi;
        fi;
        if pos <> fail then
            res[pos] := d.matrix;
        fi;
    od;
    return res;
end);

# The matrix delta_h stored in the module s (fail if h is not listed).
InstallGlobalFunction(QGNAG_ModuleDelta, function(s, h)
    local pos;
    pos := QGNAG_ElementIndex(s.group, s.generatorsofgroup, h);
    if pos = fail then
        return fail;
    fi;
    return QGNAG_ModuleDeltas(s)[pos];
end);

# Basis (list of n x n matrices X) of the space of intertwiners  X*A_i = B_i*X  for all i, with A = mats, B = mats2.
# X is flattened row by row:  vec(X A) = (I (x) A^T) vec(X),  vec(B X) = (B (x) I) vec(X).
InstallGlobalFunction(QGNAG_IntertwinerSpace, function(mats, mats2)
    local n, I, rows, i, basis;
    n := Length(mats[1]);
    I := IdentityMat(n);
    rows := [];
    for i in [1 .. Length(mats)] do
        Append(rows, KroneckerProduct(I, TransposedMat(mats[i])) - KroneckerProduct(mats2[i], I));
    od;
    basis := NullspaceMat(TransposedMat(rows));
    return List(basis, v -> List([1 .. n], r -> v{[(r - 1) * n + 1 .. r * n]}));
end);

# ------------------------------------------------------------------------- the group of the paper
InstallGlobalFunction(QGNAG_CheckGroupFacts, function(G, gens)
    local t, x, y, z, c,
          ok, all, F, rels, Q,
          hom, A4, class_z, class_x, class_x2,
          e;
    all := true;
    ok := function(label, cond)
        QGNAG_DGCHECKS_Line(cond, label);
        if not cond then
            all := false;
        fi;
    end;
    if Length(gens) <> 4 then
        Error("QGNAG_CheckGroupFacts: gens must be [t, x, y, z]");
    fi;
    t := gens[1]; x := gens[2]; y := gens[3]; z := gens[4];
    e := One(G);
    c := t^3;
    ok(Concatenation("|G| = ", String(Size(G)), " and the generators generate G"),
       Size(G) = 24 and Subgroup(G, gens) = G);
    ok("x = t^2 and y = t z t^-1", x = t^2 and y = t * z * t^-1);
    ok("relations of the presentation: t^6 = y^2 = z^2 = 1, t y = y z t, t z = y t, y z = z y",
       t^6 = e and y^2 = e and z^2 = e and t * y = y * z * t and t * z = y * t and y * z = z * y);
    F := FreeGroup("t", "y", "z");
    rels := [F.1^6, F.2^2, F.3^2, F.1 * F.2 * (F.2 * F.3 * F.1)^-1, F.1 * F.3 * (F.2 * F.1)^-1, F.2 * F.3 * (F.3 * F.2)^-1];
    Q := F / rels;
    hom := GroupHomomorphismByImages(Q, G, GeneratorsOfGroup(Q), [t, y, z]);
    ok(Concatenation("the presentation <t,y,z | ...> defines a group of order ", String(Size(Q)), " and maps isomorphically onto G"),
       hom <> fail and IsBijective(hom));
    ok("c = t^3 is central of order 2", c <> e and c^2 = e and ForAll(gens, g -> g * c = c * g));
    A4 := Subgroup(G, [x, y, z]);
    ok("A4 = <x, y, z> has order 12 and is not abelian; A4 meets <c> trivially, so G = A4 x C2",
       Size(A4) = 12 and not IsAbelian(A4) and Size(Intersection(A4, Subgroup(G, [c]))) = 1 and Size(A4) * 2 = Size(G));
    ok("A4 is isomorphic to the alternating group of degree 4, A4 and <c> are normal, so G = A4 x C2",
       IsomorphismGroups(A4, AlternatingGroup(4)) <> fail and IsNormal(G, A4) and IsNormal(G, Subgroup(G, [c])));
    ok("A4 has 4 conjugacy classes, of sizes 1, 3, 4, 4", SortedList(List(ConjugacyClasses(A4), Size)) = [1, 3, 4, 4]);
    class_z := Set(Elements(ConjugacyClass(A4, z)));
    class_x := Set(Elements(ConjugacyClass(A4, x)));
    class_x2 := Set(Elements(ConjugacyClass(A4, x^2)));
    ok("class of z = {z, y, yz};  class of x = {x, xy, xz, xyz};  class of x^2 = {x^2, x^2 y, x^2 z, x^2 yz}",
       class_z = Set([z, y, y * z]) and class_x = Set([x, x * y, x * z, x * y * z])
       and class_x2 = Set([x^2, x^2 * y, x^2 * z, x^2 * y * z]));
    ok("x acts on {z, y, yz} as a 3-cycle (x z x^-1 = yz, x yz x^-1 = y, x y x^-1 = z)",
       x * z * x^-1 = y * z and x * y * z * x^-1 = y and x * y * x^-1 = z);
    ok("centralizers in A4: A4 (order 12), V4 (order 4), <x> = <x^2> (order 3)",
       Size(Centralizer(A4, e)) = 12 and Set(Elements(Centralizer(A4, z))) = Set(Elements(Subgroup(G, [y, z])))
       and Set(Elements(Centralizer(A4, x))) = Set([e, x, x^2]) and Set(Elements(Centralizer(A4, x^2))) = Set([e, x, x^2]));
    return all;
end);

# ------------------------------------------------------------------------- one module
InstallGlobalFunction(QGNAG_CheckModuleDG, function(s)
    local G, elms, N, n, I, zero, rho, rhoinv, D, res, i, j, pos, mats, comm, supp, cls, ranks;
    G := s.group;
    elms := Elements(G);
    N := Length(elms);
    n := Length(s.simple(s.generatorsofgroup[1]));
    I := IdentityMat(n);
    zero := NullMat(n, n);
    res := rec(dim := n);
    rho := List(elms, g -> s.simple(g));
    D := QGNAG_ModuleDeltas(s);
    res.elementsListed := Length(s.DeltaStructureMatrices) = N and not fail in D;
    res.generatorsGenerate := Subgroup(G, s.generatorsofgroup) = G;
    res.homomorphism := false;
    res.deltasOK := false;
    res.compatibility := false;
    res.compatibilityOpposite := false;
    res.simple := false;
    res.supportIsOneClass := false;
    res.rankOK := false;
    res.support := [];
    res.character := [];
    if not res.elementsListed then
        res.ok := false;
        return res;
    fi;
    # (1a) rho is a homomorphism: rho(g h) = rho(g) rho(h) for all g, h
    res.homomorphism := true;
    for i in [1 .. N] do
        for j in [1 .. N] do
            pos := Position(elms, elms[i] * elms[j]);
            if rho[pos] <> rho[i] * rho[j] then
                res.homomorphism := false;
            fi;
        od;
    od;
    # (1b) the delta_h are orthogonal idempotents and add up to the identity
    res.deltasOK := Sum(D) = I;
    for i in [1 .. N] do
        if D[i] * D[i] <> D[i] then
            res.deltasOK := false;
        fi;
        for j in [i + 1 .. N] do
            if D[i] * D[j] <> zero then
                res.deltasOK := false;
            fi;
        od;
    od;
    # (1c) rho(g) delta_h rho(g)^-1 = delta_{g h g^-1}   (and, as a diagnostic, the opposite convention g^-1 h g)
    rhoinv := List(rho, Inverse);
    res.compatibility := true;
    res.compatibilityOpposite := true;
    for i in [1 .. N] do
        for j in [1 .. N] do
            if rho[i] * D[j] * rhoinv[i] <> D[Position(elms, elms[i] * elms[j] * elms[i]^-1)] then
                res.compatibility := false;
            fi;
            if rho[i] * D[j] * rhoinv[i] <> D[Position(elms, elms[i]^-1 * elms[j] * elms[i])] then
                res.compatibilityOpposite := false;
            fi;
        od;
    od;
    # (2) simple: the commutant of rho(generators) and of the nonzero delta_h has dimension 1
    mats := List(s.generatorsofgroup, g -> s.simple(g));
    Append(mats, Filtered(D, d -> d <> zero));
    comm := QGNAG_IntertwinerSpace(mats, mats);
    res.simple := Length(comm) = 1;
    # support: one conjugacy class C, and rank delta_h = n / |C| on it
    supp := Filtered([1 .. N], i -> D[i] <> zero);
    res.support := elms{supp};
    if not IsEmpty(supp) then
        cls := ConjugacyClass(G, res.support[1]);
        res.supportIsOneClass := Set(res.support) = Set(Elements(cls));
        ranks := Set(List(supp, i -> RankMat(D[i])));
        res.rankOK := Length(ranks) = 1 and n = ranks[1] * Size(cls);
        res.class := cls;
        res.irrepDimension := ranks[1];
    fi;
    # D(G)-character tr(rho(g) delta_h)
    res.character := Concatenation(List([1 .. N], i -> List([1 .. N], j -> Trace(rho[i] * D[j]))));
    res.ok := res.elementsListed and res.generatorsGenerate and res.homomorphism and res.deltasOK and res.compatibility
              and res.simple and res.supportIsOneClass and res.rankOK;
    return res;
end);

# ------------------------------------------------------------------------- all the modules
InstallGlobalFunction(QGNAG_CheckSimplesDG, function(simples)
    local G, n, results, r, k,
          bad, classes, c, C, degs,
          expectedDims, foundDims, classOK, classProblems, nonIso,
          sumsq, expectedNumber, unmatched, allDG, allSimple, complete,
          ok, dup, i, j, opposite;
    n := Length(simples);
    if n = 0 then
        Error("QGNAG_CheckSimplesDG: the list of modules is empty");
    fi;
    G := simples[1].group;
    Print("Group of order ", Size(G), "; ", n, " modules to check.\n");
    results := List(simples, QGNAG_CheckModuleDG);
    unmatched := Filtered([1 .. n], k -> fail in QGNAG_ModuleDeltas(simples[k]));
    if not IsEmpty(unmatched) then
        Print("[FAIL]  the elements stored in DeltaStructureMatrices could not be matched with the elements of G in ", Length(unmatched), " modules\n");
        Print("        first module: ", unmatched[1], ";  stored element example: ", simples[unmatched[1]].DeltaStructureMatrices[1].element,
              ";  number of stored elements: ", Length(simples[unmatched[1]].DeltaStructureMatrices), ";  |G| = ", Size(G), "\n");
    fi;
    # --- every module is a D(G)-module
    bad := Filtered([1 .. n], k -> not (results[k].elementsListed and results[k].generatorsGenerate and results[k].homomorphism
                                         and results[k].deltasOK and results[k].compatibility));
    allDG := IsEmpty(bad);
    QGNAG_DGCHECKS_Line(allDG, Concatenation(String(n - Length(bad)), "/", String(n),
        " are D(G)-modules (rho homomorphism; delta_h orthogonal idempotents adding up to 1; rho(g) delta_h rho(g)^-1 = delta_{g h g^-1})"));
    if not allDG then
        Print("        failing modules: ", bad, "\n");
        opposite := Filtered(bad, k -> results[k].compatibilityOpposite);
        if not IsEmpty(opposite) then
            Print("        note: modules ", opposite, " satisfy the OPPOSITE convention rho(g) delta_h rho(g)^-1 = delta_{g^-1 h g}\n");
        fi;
    fi;
    # --- every module is simple
    bad := Filtered([1 .. n], k -> not results[k].simple);
    allSimple := IsEmpty(bad);
    QGNAG_DGCHECKS_Line(allSimple, Concatenation(String(n - Length(bad)), "/", String(n), " are simple (commutant of dimension 1)"));
    if not allSimple then
        Print("        reducible modules: ", bad, "\n");
    fi;
    # --- pairwise non-isomorphic
    dup := [];
    for i in [1 .. n] do
        for j in [i + 1 .. n] do
            if results[i].character = results[j].character then
                Add(dup, [i, j]);
            fi;
        od;
    od;
    nonIso := IsEmpty(dup);
    QGNAG_DGCHECKS_Line(nonIso, Concatenation("the ", String(n), " D(G)-characters are pairwise different: pairwise non-isomorphic"));
    if not nonIso then
        Print("        isomorphic pairs: ", dup, "\n");
    fi;
    # --- completeness
    bad := Filtered([1 .. n], k -> not (results[k].supportIsOneClass and results[k].rankOK));
    QGNAG_DGCHECKS_Line(IsEmpty(bad), "the support of every module is one conjugacy class C of G, with rank delta_h = dim / |C|");
    if not IsEmpty(bad) then
        Print("        modules whose support is not a class: ", bad, "\n");
    fi;
    classes := ConjugacyClasses(G);
    expectedNumber := 0;
    classOK := true;
    classProblems := [];
    for c in classes do
        C := Centralizer(G, Representative(c));
        degs := Concatenation(List(CharacterDegrees(C), p -> ListWithIdenticalEntries(p[2], p[1])));
        expectedDims := SortedList(List(degs, d -> d * Size(c)));
        expectedNumber := expectedNumber + Length(degs);
        foundDims := SortedList(List(Filtered([1 .. n], k -> results[k].supportIsOneClass and Representative(c) in results[k].class
                                                                  and Set(Elements(results[k].class)) = Set(Elements(c))),
                                     k -> results[k].dim));
        if foundDims <> expectedDims then
            classOK := false;
            Add(classProblems, [Representative(c), Size(c), expectedDims, foundDims]);
        fi;
    od;
    QGNAG_DGCHECKS_Line(classOK, Concatenation("for each of the ", String(Length(classes)),
        " conjugacy classes C, the dimensions of the modules supported on C are |C| x (degrees of the irreducible characters of the centralizer of C)"));
    for k in classProblems do
        Print("        class of ", k[1], " (size ", k[2], "): expected dimensions ", k[3], ", found ", k[4], "\n");
    od;
    sumsq := Sum(List(results, r -> r.dim^2));
    QGNAG_DGCHECKS_Line(n = expectedNumber, Concatenation("number of modules ", String(n), " = number of pairs (class, irreducible character of the centralizer) = ", String(expectedNumber)));
    QGNAG_DGCHECKS_Line(sumsq = Size(G)^2, Concatenation("sum of dim^2 = ", String(sumsq), " = |G|^2 = ", String(Size(G)^2)));
    complete := nonIso and classOK and IsEmpty(bad) and n = expectedNumber and sumsq = Size(G)^2;
    ok := allDG and allSimple and complete;
    Print("\n");
    if ok then
        Print("RESULT: the ", n, " modules are pairwise non-isomorphic simple D(G)-modules, and they are ALL the simple D(G)-modules.\n");
    else
        Print("RESULT: NOT all the checks passed.\n");
    fi;
    return rec(ok := ok, allDGModules := allDG, allSimple := allSimple, pairwiseNonIsomorphic := nonIso, complete := complete,
               numberOfModules := n, expectedNumberOfModules := expectedNumber, sumOfSquares := sumsq, groupOrder := Size(G),
               perModule := results);
end);

# ------------------------------------------------------------------------- labels, names and modules of the paper
# Enumeration of Section 2.4 of the new text. Labels are records rec(kind, s, p):
#   tau: p = [i, j];  rho: p = [i];  chi: p = [i, j, k];  eta: p = [a, l];  s in {0, 1}.
InstallGlobalFunction(QGNAG_SimpleLabels, function()
    local labels, s, p, i, j, k, l, tauOrder, sa;
    tauOrder := [[0, 0], [1, 2], [0, 1], [1, 0], [0, 2], [1, 1]];
    labels := [];
    for s in [0, 1] do
        for p in tauOrder do
            Add(labels, rec(kind := "tau", s := s, p := p));
        od;
    od;
    for s in [0, 1] do
        for i in [0, 1] do
            Add(labels, rec(kind := "rho", s := s, p := [i]));
        od;
    od;
    for s in [0, 1] do
        for i in [0, 1] do
            for j in [0, 1] do
                for k in [0, 1] do
                    Add(labels, rec(kind := "chi", s := s, p := [i, j, k]));
                od;
            od;
        od;
    od;
    for sa in [[1, 2], [0, 1], [0, 2], [1, 1]] do
        for l in [0 .. 5] do
            Add(labels, rec(kind := "eta", s := sa[1], p := [sa[2], l]));
        od;
    od;
    return labels;
end);

InstallGlobalFunction(QGNAG_NewSimpleNames, function()
    return List(QGNAG_SimpleLabels(), function(L)
        if L.kind = "tau" then
            return Concatenation("M(", String(L.s), ",\\tau_{", String(L.p[1]), String(L.p[2]), "})");
        elif L.kind = "rho" then
            return Concatenation("M(", String(L.s), ",\\rho_{", String(L.p[1]), "})");
        elif L.kind = "chi" then
            return Concatenation("M(", String(L.s), ",\\chi_{(", String(L.p[1]), ",", String(L.p[2]), ",", String(L.p[3]), ")})");
        fi;
        return Concatenation("M(", String(L.s), ",\\eta^{", String(L.p[1]), "}_{", String(L.p[2]), "})");
    end);
end);

# The enumeration as LaTeX in the format of the text: align* with four columns  k. & M(...)  and a final period.
InstallGlobalFunction(QGNAG_WriteSimpleNamesTeX, function(filename, names)
    local out, k, n;
    n := Length(names);
    out := OutputTextFile(filename, false);
    SetPrintFormattingStatus(out, false);
    AppendTo(out, "% Enumeration of the simple D(G)-modules, generated by QGNAG_WriteSimpleNamesTeX\n");
    AppendTo(out, "\\begin{align*}\n");
    for k in [1 .. n] do
        AppendTo(out, "\t", String(k), ". \\ & ", names[k]);
        if k = n then
            AppendTo(out, ".\n");
        elif k mod 4 = 0 then
            AppendTo(out, " \\\\\n");
        else
            AppendTo(out, " &\n");
        fi;
    od;
    AppendTo(out, "\\end{align*}\n");
    CloseStream(out);
    return true;
end);

# Position of the module (kind, s, p) in the enumeration; the indices are read modulo 2 (s, rho, chi, tau_i), 3 (tau_j) and 6 (eta_l).
InstallGlobalFunction(QGNAG_LabelPosition, function(labels, kind, s, p)
    local q;
    if kind = "tau" then
        q := [p[1] mod 2, p[2] mod 3];
    elif kind = "rho" then
        q := [p[1] mod 2];
    elif kind = "chi" then
        q := List(p, x -> x mod 2);
    else
        q := [p[1], p[2] mod 6];
    fi;
    return Position(labels, rec(kind := kind, s := s mod 2, p := q));
end);

InstallGlobalFunction(QGNAG_PaperSimples, function(G, gens)
    local t, x, y, z, c, cs, elms, zeta, P2, Pi2, Zsw, labels, names, result, k, L, T, Z, supp, s, i, j, a, l, kk, mats, rho,
          n, deltas, h, Dl, entry, idx, x2;
    if Length(gens) <> 4 then
        Error("QGNAG_PaperSimples: gens must be [t, x, y, z]");
    fi;
    t := gens[1]; x := gens[2]; y := gens[3]; z := gens[4];
    if x <> t^2 or y <> t * z * t^-1 then
        Error("QGNAG_PaperSimples: the generators must be [t, t^2, t z t^-1, z]");
    fi;
    c := t^3;
    x2 := x^2;
    elms := Elements(G);
    zeta := E(3);
    P2  := [[0, 1, 0], [0, 0, 1], [1, 0, 0]];
    Pi2 := [[1, 0, 0, 0], [0, 0, 1, 0], [0, 0, 0, 1], [0, 1, 0, 0]];
    Zsw := [[0, 1, 0, 0], [1, 0, 0, 0], [0, 0, 0, 1], [0, 0, 1, 0]];
    labels := QGNAG_SimpleLabels();
    names := QGNAG_NewSimpleNames();
    result := [];
    for k in [1 .. Length(labels)] do
        L := labels[k];
        s := L.s;
        cs := c^s;
        if L.kind = "tau" then
            i := L.p[1]; j := L.p[2];
            T := [[(-1)^i * zeta^j]];
            Z := [[1]];
            supp := [[cs, [1]]];
        elif L.kind = "rho" then
            i := L.p[1];
            T := (-1)^i * P2;
            Z := DiagonalMat([1, -1, -1]);
            supp := [[cs, [1, 2, 3]]];
        elif L.kind = "chi" then
            i := L.p[1]; j := L.p[2]; kk := L.p[3];
            T := (-1)^kk * P2;
            Z := DiagonalMat([(-1)^i, (-1)^(i + j), (-1)^j]);
            supp := [[z * cs, [1]], [y * z * cs, [2]], [y * cs, [3]]];
        else
            a := L.p[1]; l := L.p[2];
            j := l mod 2;
            kk := First([0 .. 2], q -> (3 * j + 2 * a * q - l) mod 6 = 0);
            T := (-1)^j * zeta^(2 * a * kk) * Pi2;
            Z := Zsw;
            if a = 1 then
                supp := [[x * cs, [1]], [x * y * z * cs, [2]], [x * y * cs, [3]], [x * z * cs, [4]]];
            else
                supp := [[x2 * cs, [1]], [x2 * y * cs, [2]], [x2 * z * cs, [3]], [x2 * y * z * cs, [4]]];
            fi;
        fi;
        n := Length(T);
        mats := [T, T^2, T * Z * T^-1, Z];
        rho := GroupHomomorphismByImages(G, Group(mats), gens, mats);
        if rho = fail then
            Error("QGNAG_PaperSimples: the matrices of ", names[k], " do not define a representation of G");
        fi;
        deltas := [];
        for h in elms do
            Dl := NullMat(n, n);
            for entry in supp do
                if entry[1] = h then
                    for idx in entry[2] do
                        Dl[idx][idx] := 1;
                    od;
                fi;
            od;
            Add(deltas, rec(element := h, matrix := Dl));
        od;
        Add(result, rec(simple := rho, group := G, generatorsofgroup := gens, DeltaStructureMatrices := deltas,
                        label := L, name := names[k]));
    od;
    return result;
end);

# ------------------------------------------------------------------------- comparison with the paper
# Kind of a change of basis X (normalized by its first nonzero entry).
InstallGlobalFunction(QGNAG_ChangeOfBasisKind, function(X)
    local n, Y, first;
    n := Length(X);
    first := First(Concatenation(X), x -> x <> 0);
    Y := X * first^-1;
    if Y = IdentityMat(n) then
        return "identity";
    fi;
    if ForAll(Y, row -> Number(row, x -> x <> 0) = 1) and ForAll(TransposedMat(Y), col -> Number(col, x -> x <> 0) = 1) then
        if Y = DiagonalMat(DiagonalOfMat(Y)) then
            return "diagonal";
        elif ForAll(Concatenation(Y), x -> x in [0, 1]) then
            return "permutation";
        elif ForAll(Concatenation(Y), x -> x in [0, 1, -1]) then
            return "signed permutation";
        fi;
        return "monomial";
    fi;
    return "general";
end);

InstallGlobalFunction(QGNAG_CompareSimplesWithPaper, function(simples, paper)
    local n, k, s, p, elms, gens,
          A, B, zero, sol, iso, Xs,
          kinds, bad, kind, nIso, exact, i,
          dsl, dpl;
    n := Length(simples);
    if n <> Length(paper) then
        Error("QGNAG_CompareSimplesWithPaper: ", n, " modules against ", Length(paper), " modules of the paper");
    fi;
    iso := []; Xs := []; kinds := [];
    for k in [1 .. n] do
        s := simples[k]; p := paper[k];
        elms := Elements(s.group);
        gens := s.generatorsofgroup;
        A := List(gens, g -> s.simple(g));
        B := List(gens, g -> p.simple(g));
        if Length(A[1]) <> Length(B[1]) then
            iso[k] := false; Xs[k] := fail; kinds[k] := "different dimension";
        else
            zero := NullMat(Length(A[1]), Length(A[1]));
            dsl := QGNAG_ModuleDeltas(s);
            dpl := QGNAG_ModuleDeltas(p);
            if fail in dsl or fail in dpl then
                Error("QGNAG_CompareSimplesWithPaper: the delta_h of module ", k, " could not be matched with the elements of G (stored element: ",
                      s.DeltaStructureMatrices[1].element, ")");
            fi;
            for i in [1 .. Length(elms)] do
                if dsl[i] <> zero or dpl[i] <> zero then
                    Add(A, dsl[i]);
                    Add(B, dpl[i]);
                fi;
            od;
            sol := QGNAG_IntertwinerSpace(A, B);
            iso[k] := Length(sol) = 1;
            if iso[k] then
                Xs[k] := sol[1];
                kinds[k] := QGNAG_ChangeOfBasisKind(sol[1]);
            else
                Xs[k] := fail;
                kinds[k] := "not isomorphic";
            fi;
        fi;
    od;
    nIso := Number(iso, x -> x);
    QGNAG_DGCHECKS_Line(nIso = n, Concatenation(String(nIso), "/", String(n),
        " modules are isomorphic, as D(G)-modules, to the module of the same position in the paper"));
    bad := Filtered([1 .. n], k -> not iso[k]);
    if not IsEmpty(bad) then
        Print("        NOT isomorphic to the paper's module: ", bad, "\n");
    fi;
    for kind in ["identity", "diagonal", "permutation", "signed permutation", "monomial", "general"] do
        exact := Filtered([1 .. n], k -> kinds[k] = kind);
        if not IsEmpty(exact) then
            Print("        change of basis '", kind, "': ", Length(exact), " modules ", exact, "\n");
        fi;
    od;
    return rec(ok := nIso = n, iso := iso, X := Xs, kind := kinds,
               identical := Filtered([1 .. n], k -> kinds[k] = "identity"));
end);

# A copy of the list where simple, DeltaStructureMatrices and base are those of the paper (SimplesMn is not modified).
InstallGlobalFunction(QGNAG_SimplesInPaperBasis, function(simples, paper)
    local result, k, r, elems, L, makeElement, makeTensor, canBuildBase, paperDeltas;
    # TensorElement and ElementSDP belong to the package; they are looked up at run time (same calls as UpdateSimpleBase).
    canBuildBase := IsBoundGlobal("TensorElement") and IsBoundGlobal("ElementSDP");
    if canBuildBase then
        makeTensor := ValueGlobal("TensorElement");
        makeElement := ValueGlobal("ElementSDP");
        elems := Elements(GF(4));
    fi;
    result := [];
    for k in [1 .. Length(simples)] do
        r := ShallowCopy(simples[k]);
        r.simple := paper[k].simple;
        # same order of the delta_h as in the module of SimplesMn
        paperDeltas := QGNAG_ModuleDeltas(paper[k]);
        r.DeltaStructureMatrices := List(simples[k].DeltaStructureMatrices,
                                         d -> rec(element := d.element,
                                                  matrix := paperDeltas[QGNAG_ElementIndex(paper[k].group, paper[k].generatorsofgroup, d.element)]));
        L := paper[k].label;
        if canBuildBase then
            # basis of the text: rho {v1,v2,v3}, chi {e,x,x^2} (x) 1, eta {e,z,yz,y} (x) 1
            if L.kind = "rho" then
                r.base := List([[1, 0, 0], [0, 1, 0], [0, 0, 1]], v -> makeTensor(makeElement(elems[1], 0), v));
            elif L.kind = "chi" then
                r.base := List([0, 2, 4], j -> makeTensor(makeElement(elems[1], j), [1]));
            elif L.kind = "eta" then
                r.base := List([1, 2, 4, 3], i -> makeTensor(makeElement(elems[i], 0), [1]));
            fi;
        fi;
        Add(result, r);
    od;
    return result;
end);

# ------------------------------------------------------------------------- fusion rules of the Proposition (new text)
# Vector of multiplicities (length 56) of M_i (x) M_j according to the Proposition. The indices are read modulo 2, 3, 6.
InstallGlobalFunction(QGNAG_PaperFusionVector, function(labels, i, j)
    local L1, L2, order, vec, add, s, a, b, c, u, v, h, hp, l, lp, m, r, ii, jj, kk, l2, tmp;
    order := rec(tau := 0, rho := 1, chi := 2, eta := 3);
    L1 := labels[i];
    L2 := labels[j];
    if order.(L1.kind) > order.(L2.kind) then
        tmp := L1; L1 := L2; L2 := tmp;
    fi;
    vec := ListWithIdenticalEntries(Length(labels), 0);
    add := function(kind, s, p, mult)
        local pos;
        pos := QGNAG_LabelPosition(labels, kind, s, p);
        vec[pos] := vec[pos] + mult;
    end;
    s := L1.s + L2.s;
    if L1.kind = "tau" then
        ii := L1.p[1]; jj := L1.p[2];
        if L2.kind = "tau" then
            add("tau", s, [ii + L2.p[1], jj + L2.p[2]], 1);
        elif L2.kind = "rho" then
            add("rho", s, [ii + L2.p[1]], 1);
        elif L2.kind = "chi" then
            add("chi", s, [L2.p[1], L2.p[2], ii + L2.p[3]], 1);
        else
            add("eta", s, [L2.p[1], L2.p[2] + 3 * ii + 4 * jj], 1);
        fi;
    elif L1.kind = "rho" then
        ii := L1.p[1];
        if L2.kind = "rho" then
            for r in [0 .. 2] do
                add("tau", s, [ii + L2.p[1], r], 1);
            od;
            add("rho", s, [ii + L2.p[1]], 2);
        elif L2.kind = "chi" then
            for u in [0, 1] do
                for v in [0, 1] do
                    if [u, v] <> [L2.p[1], L2.p[2]] then
                        add("chi", s, [u, v, L2.p[3] + ii], 1);
                    fi;
                od;
            od;
        else
            for l2 in [0 .. 5] do
                if (l2 - (L2.p[2] + ii)) mod 2 = 0 then
                    add("eta", s, [L2.p[1], l2], 1);
                fi;
            od;
        fi;
    elif L1.kind = "chi" then
        ii := L1.p[1]; jj := L1.p[2]; kk := L1.p[3];
        if L2.kind = "chi" then
            a := L2.p[1]; b := L2.p[2]; c := L2.p[3];
            if [ii, jj] = [a, b] then
                for r in [0 .. 2] do
                    add("tau", s, [kk + c, r], 1);
                od;
                add("chi", s, [a, b, kk + c], 2);
            else
                add("rho", s, [kk + c], 1);
                for u in [0, 1] do
                    for v in [0, 1] do
                        if not [u, v] in [[ii, jj], [a, b]] then
                            add("chi", s, [u, v, kk + c], 1);
                        fi;
                    od;
                od;
            fi;
        else
            for l2 in [0 .. 5] do
                if (l2 - (L2.p[2] + kk)) mod 2 = 0 then
                    add("eta", s, [L2.p[1], l2], 1);
                fi;
            od;
        fi;
    else
        h := L1.p[1]; l := L1.p[2]; hp := L2.p[1]; lp := L2.p[2];
        m := (l + lp) mod 6;
        if h = hp then
            add("eta", s, [3 - h, m], 2);
            add("eta", s, [3 - h, m + 2], 1);
            add("eta", s, [3 - h, m + 4], 1);
        else
            ii := m mod 2; jj := m mod 3;
            add("tau", s, [ii, jj], 1);
            add("rho", s, [ii], 1);
            for a in [0, 1] do
                for b in [0, 1] do
                    add("chi", s, [a, b, ii], 1);
                od;
            od;
        fi;
    fi;
    return vec;
end);

InstallGlobalFunction(QGNAG_CheckFusionRulesOfPaper, function(data)
    local labels, bad, r, expected, k;
    labels := QGNAG_SimpleLabels();
    bad := [];
    for r in data do
        expected := QGNAG_PaperFusionVector(labels, r.first, r.second);
        if expected <> r.vector then
            Add(bad, r);
        fi;
    od;
    QGNAG_DGCHECKS_Line(IsEmpty(bad), Concatenation(String(Length(data) - Length(bad)), "/", String(Length(data)),
        " products M_i (x) M_j of data_fusion_rules_parallel agree with the Proposition of the paper"));
    for r in bad{[1 .. Minimum(5, Length(bad))]} do
        Print("        e.g. M", r.first, " x M", r.second, ":\n          computed ",
              List(Filtered([1 .. Length(r.vector)], k -> r.vector[k] <> 0), k -> [k, r.vector[k]]),
              "\n          paper    ", List(Filtered([1 .. Length(r.vector)], k -> QGNAG_PaperFusionVector(labels, r.first, r.second)[k] <> 0),
                                          k -> [k, QGNAG_PaperFusionVector(labels, r.first, r.second)[k]]), "\n");
    od;
    return rec(ok := IsEmpty(bad), numberOfProducts := Length(data), mismatches := List(bad, r -> [r.first, r.second]));
end);
