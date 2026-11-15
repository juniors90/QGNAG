#############################################################################
##
#W  simplessummary.gi                       QGNAG                     
##
##  Implementation of QGNAG_SimplesSummaryToLaTeX: LaTeX description of the simple
##  D(G)-modules stored in SimplesMn (generic: it only reads that list).
##
#############################################################################

InstallGlobalFunction(QGNAG_SimplesSummary_ObjToString, function(obj)
    local str, out;
    str := "";
    out := OutputTextString(str, true);
    PrintTo(out, obj);
    CloseStream(out);
    return str;
end);

# Escape the characters that are special in LaTeX (non-ASCII characters become "?").
InstallGlobalFunction(QGNAG_SimplesSummary_EscapeLaTeX, function(str)
    local out, c;
    out := "";
    for c in str do
        if IntChar(c) > 127 then
            Append(out, "?");
        elif c = '\\' then
            Append(out, "\\textbackslash{}");
        elif c = '_' then
            Append(out, "\\_");
        elif c = '^' then
            Append(out, "\\^{}");
        elif c = '&' then
            Append(out, "\\&");
        elif c = '%' then
            Append(out, "\\%");
        elif c = '#' then
            Append(out, "\\#");
        elif c = '$' then
            Append(out, "\\$");
        elif c = '{' then
            Append(out, "\\{");
        elif c = '}' then
            Append(out, "\\}");
        elif c = '~' then
            Append(out, "\\~{}");
        else
            Add(out, c);
        fi;
    od;
    return out;
end);

# 0, +-E(3)^k are written with zeta = E(3); any other cyclotomic E(n)^k as zeta_n^k.
InstallGlobalFunction(QGNAG_SimplesSummary_CycloToLaTeX, function(x)
    local sgn, j, str, out, pos, close, e, len;
    if x = 0 then
        return "0";
    fi;
    for sgn in [1, -1] do
        for j in [0 .. 2] do
            if x = sgn * E(3)^j then
                if j = 0 then
                    str := "1";
                elif j = 1 then
                    str := "\\zeta";
                else
                    str := "\\zeta^2";
                fi;
                if sgn = -1 then
                    str := Concatenation("-", str);
                fi;
                return str;
            fi;
        od;
    od;
    str := String(x);
    len := Length(str);
    out := "";
    pos := 1;
    while pos <= len do
        if str[pos] = 'E' and pos < len and str[pos + 1] = '(' then
            close := Position(str, ')', pos);
            if close = fail then
                Add(out, str[pos]);
                pos := pos + 1;
            else
                Append(out, Concatenation("\\zeta_{", str{[pos + 2 .. close - 1]}, "}"));
                pos := close + 1;
                if pos <= len and str[pos] = '^' then
                    e := "";
                    pos := pos + 1;
                    while pos <= len and str[pos] in "0123456789" do
                        Add(e, str[pos]);
                        pos := pos + 1;
                    od;
                    Append(out, Concatenation("^{", e, "}"));
                fi;
            fi;
        elif str[pos] = '*' then
            pos := pos + 1;
        else
            Add(out, str[pos]);
            pos := pos + 1;
        fi;
    od;
    return out;
end);

InstallGlobalFunction(QGNAG_SimplesSummary_MatrixToLaTeX, function(M)
    local rows;
    if Length(M) = 1 then
        return QGNAG_SimplesSummary_CycloToLaTeX(M[1][1]);
    fi;
    rows := List(M, row -> JoinStringsWithSeparator(
                List(row, QGNAG_SimplesSummary_CycloToLaTeX), " & "));
    return Concatenation("\\left(\\begin{smallmatrix} ",
                         JoinStringsWithSeparator(rows, " \\\\ "),
                         " \\end{smallmatrix}\\right)");
end);

# Elements printed as "( a , s )" are split into a and s; a is "w" or "w2" when it is
# the generator of F_4 printed as zeta_3 or zeta_3^2. Anything else is kept as raw text.
InstallGlobalFunction(QGNAG_SimplesSummary_ElementToPair, function(g)
    local raw, str, pos, a, s;
    raw := NormalizedWhitespace(QGNAG_SimplesSummary_ObjToString(g));
    str := raw;
    if Length(str) >= 2 and str[1] = '(' and str[Length(str)] = ')' then
        str := str{[2 .. Length(str) - 1]};
    fi;
    pos := Position(str, ',');
    if pos = fail then
        return rec(a := str, s := "?", raw := raw);
    fi;
    a := NormalizedWhitespace(str{[1 .. pos - 1]});
    s := NormalizedWhitespace(str{[pos + 1 .. Length(str)]});
    if PositionSublist(a, "_3^2") <> fail or PositionSublist(a, "E(3)^2") <> fail
       or PositionSublist(a, "Z(2^2)^2") <> fail then
        a := "w2";
    elif PositionSublist(a, "_3") <> fail or PositionSublist(a, "E(3)") <> fail
       or PositionSublist(a, "Z(2^2)") <> fail then
        a := "w";
    fi;
    return rec(a := a, s := s, raw := raw);
end);

InstallGlobalFunction(QGNAG_SimplesSummary_ElementToLaTeX, function(g)
    local pair, a;
    pair := QGNAG_SimplesSummary_ElementToPair(g);
    if pair.s = "?" then
        return Concatenation("\\texttt{", QGNAG_SimplesSummary_EscapeLaTeX(pair.raw), "}");
    fi;
    a := pair.a;
    if a = "w" then
        a := "\\omega";
    elif a = "w2" then
        a := "\\omega^2";
    else
        a := QGNAG_SimplesSummary_EscapeLaTeX(a);
    fi;
    return Concatenation("(", a, ",", QGNAG_SimplesSummary_EscapeLaTeX(pair.s), ")");
end);

# Basis elements are printed as "(( a , s )) <tensor> [ v1, v2, ... ]".
InstallGlobalFunction(QGNAG_SimplesSummary_BaseElementToLaTeX, function(b)
    local str, p1, p2, p3, p4, vec;
    str := NormalizedWhitespace(QGNAG_SimplesSummary_ObjToString(b));
    p1 := PositionSublist(str, "((");
    p2 := PositionSublist(str, "))");
    p3 := Position(str, '[');
    p4 := Position(str, ']');
    if p1 = fail or p2 = fail or p3 = fail or p4 = fail then
        return Concatenation("\\texttt{", QGNAG_SimplesSummary_EscapeLaTeX(str), "}");
    fi;
    vec := ReplacedString(str{[p3 + 1 .. p4 - 1]}, " ", "");
    if Position(vec, ',') <> fail then
        vec := Concatenation("(", vec, ")");
    fi;
    return Concatenation(QGNAG_SimplesSummary_ElementToLaTeX(str{[p1 + 1 .. p2]}),
                         "\\otimes ", vec);
end);

# delta_h is diagonal: write it as Id_n or diag(...); otherwise as a full matrix.
InstallGlobalFunction(QGNAG_SimplesSummary_DeltaToLaTeX, function(M)
    local n, diag;
    n := Length(M);
    diag := List([1 .. n], r -> M[r][r]);
    if M <> DiagonalMat(diag) or ForAny(diag, x -> not x in [0, 1]) then
        return QGNAG_SimplesSummary_MatrixToLaTeX(M);
    elif n = 1 then
        return String(diag[1]);
    elif ForAll(diag, x -> x = 1) then
        return Concatenation("\\mathrm{Id}_{", String(n), "}");
    fi;
    return Concatenation("\\operatorname{diag}(",
                         JoinStringsWithSeparator(List(diag, String), ","), ")");
end);

InstallGlobalFunction(QGNAG_SimplesSummaryToLaTeX, function(filename, simples, names, genNames, relationsOK)
    local n, m, k, i, dim, dims, gens, gnames, stream, sumsq, items, d, b, line,
          groupOrder, groupName, modname, attached, parts, c;
    if names = fail then
        names := [];
    fi;
    n := Length(simples);
    if n = 0 then
        Error("QGNAG_SimplesSummaryToLaTeX: the list of simple modules is empty");
    fi;
    m := Length(simples[1].generatorsofgroup);
    if genNames = fail or Length(genNames) <> m then
        if genNames <> fail then
            Print("#W QGNAG_SimplesSummaryToLaTeX: genNames must have ", m,
                  " entries; using f_1, ..., f_", m, "\n");
        fi;
        gnames := List([1 .. m], i -> Concatenation("f_{", String(i), "}"));
    else
        gnames := genNames;
    fi;
    groupOrder := Size(simples[1].group);
    if IsBound(simples[1].G) then
        groupName := QGNAG_SimplesSummary_EscapeLaTeX(QGNAG_SimplesSummary_ObjToString(simples[1].G));
    else
        groupName := "G";
    fi;
    dims := List(simples, s -> Length(s.simple(s.generatorsofgroup[1])));

    stream := OutputTextFile(filename, false);
    SetPrintFormattingStatus(stream, false);

    AppendTo(stream,
        "% Simple D(G)-modules, generated by QGNAG_SimplesSummaryToLaTeX from SimplesMn\n",
        "% Requires: amsmath, amssymb\n",
        "\\subsection{Simple $\\cD(G)$-modules}\n",
        "\\label{subsec:simples_summary}\n",
        "We list the $", String(n), "$ simple $\\cD(G)$-modules $M_1,\\dots,M_{", String(n),
        "}$ stored in \\texttt{SimplesMn}, where $G$ is the group \\texttt{", groupName,
        "} of order $", String(groupOrder), "$. For each module we give its dimension, ",
        "the element $g$ it is attached to (with the centralizer of $g$), its basis, ",
        "the matrices of the generators $", JoinStringsWithSeparator(gnames, ","),
        "$ of $G$ (in the order of \\texttt{generatorsofgroup}; matrices act on column vectors) ",
        "and the nonzero matrices $\\delta_h$ of $\\Bbbk^G$, which are diagonal. ",
        "Entries are written in terms of $\\zeta_k=e^{2\\pi i/k}$, with $\\zeta=\\zeta_3$.\n\n");

    for k in [1 .. n] do
        dim  := dims[k];
        gens := List(simples[k].generatorsofgroup, g -> simples[k].simple(g));
        if k <= Length(names) then
            modname := names[k];
        else
            modname := Concatenation("M_{", String(k), "}");
        fi;
        attached := "";
        if IsBound(simples[k].weightSDP) and IsBound(simples[k].weightSDP.g) then
            attached := Concatenation("; attached to $g=", QGNAG_SimplesSummary_ElementToLaTeX(simples[k].weightSDP.g), "$");
            if IsBound(simples[k].Gamma_g) then
                attached := Concatenation(attached, " (centralizer \\texttt{",
                    QGNAG_SimplesSummary_EscapeLaTeX(QGNAG_SimplesSummary_ObjToString(simples[k].Gamma_g)), "})");
            fi;
        fi;
        AppendTo(stream,
            "\\begin{samepage}\\noindent\\textbf{\\underline{", String(k), "}}\\quad $",
            modname, "$, $\\dim=", String(dim), "$", attached, ".\\\\\n");
        items := [];
        for b in [1 .. Length(simples[k].base)] do
            Add(items, Concatenation("$b_{", String(b), "}=",
                                     QGNAG_SimplesSummary_BaseElementToLaTeX(simples[k].base[b]), "$"));
        od;
        AppendTo(stream, "Basis: ", JoinStringsWithSeparator(items, ", "), ".\\\\\n");
        items := [];
        for i in [1 .. m] do
            Add(items, Concatenation("$[", gnames[i], "]=", QGNAG_SimplesSummary_MatrixToLaTeX(gens[i]), "$"));
        od;
        AppendTo(stream, JoinStringsWithSeparator(items, ",\\quad "), ".\\\\\n");
        items := [];
        for d in simples[k].DeltaStructureMatrices do
            if not IsZero(d.matrix) then
                Add(items, Concatenation("$\\delta_{", QGNAG_SimplesSummary_ElementToLaTeX(d.element), "}=",
                                         QGNAG_SimplesSummary_DeltaToLaTeX(d.matrix), "$"));
            fi;
        od;
        AppendTo(stream, "Nonzero $\\delta_h$: ", JoinStringsWithSeparator(items, ", "),
                 ".\\end{samepage}\n\\medskip\n\n");
    od;

    sumsq := Sum(List(dims, x -> x^2));
    parts := List(Collected(dims), function(c)
                 if c[2] = 1 then
                     return Concatenation("$", String(c[1]), "$ (1 module)");
                 fi;
                 return Concatenation("$", String(c[1]), "$ (", String(c[2]), " modules)");
             end);
    AppendTo(stream, "\\noindent Check: there are $", String(n), "$ simple modules, of dimensions ",
        JoinStringsWithSeparator(parts, ", "), ", and $\\sum_k(\\dim M_k)^2=", String(sumsq));
    if sumsq = groupOrder^2 then
        AppendTo(stream, "=|G|^2$");
    else
        AppendTo(stream, "\\neq|G|^2=", String(groupOrder^2), "$");
        Print("#W QGNAG_SimplesSummaryToLaTeX: sum of squares of dimensions differs from |G|^2\n");
    fi;
    if relationsOK = true then
        AppendTo(stream, "; all of them satisfy the defining relations of $\\Bbbk G$, $\\Bbbk^G$ and $\\cD(G)$");
    fi;
    AppendTo(stream, ".\n");

    CloseStream(stream);
    Print("Written ", filename, " (", n, " modules)\n");
    return true;
end);
