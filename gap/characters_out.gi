#############################################################################
##
#W  characters.gi                                QGNAG
##
##  Characters of the simple modules L(lambda) in the format of the paper.
##
#############################################################################

# Term of one degree.  pairs = [ [mult, idx], ... ] at degree d (d <= 0).
#   one multiplicity, 1 :  \underline{a}\,q^{d}            or   (\underline{a}+\underline{b})q^{d}
#   one multiplicity, m :  m\cdot\underline{a}\,q^{d}      or   m\cdot(\underline{a}+\underline{b})q^{d}
#   several             :  (\underline{a}+\underline{b}+m\cdot(\underline{c}+\underline{d}))q^{d}
# (the multiplicity-1 terms first; then the groups by increasing multiplicity).
InstallGlobalFunction(QGNAG_CharacterDegreeTermToTeX, function(pairs, d, style)
    local u, mults, parts, m, idxs, body, thin, qpart;

    u := i -> Concatenation("\\underline{", String(i), "}");

    mults := Set(List(pairs, p -> p[1]));
    parts := [];
    for m in mults do
        idxs := List(Filtered(pairs, p -> p[1] = m), p -> p[2]);
        Sort(idxs);
        if m = 1 then
            Add(parts, JoinStringsWithSeparator(List(idxs, u), "+"));
        elif Length(idxs) = 1 then
            Add(parts, Concatenation(String(m), "\\cdot", u(idxs[1])));
        else
            Add(parts, Concatenation(String(m), "\\cdot(",
                                     JoinStringsWithSeparator(List(idxs, u), "+"), ")"));
        fi;
    od;

    thin := false;
    if Length(mults) = 1 then
        if mults[1] = 1 and Length(pairs) > 1 then
            body := Concatenation("(", parts[1], ")");
        else
            body := parts[1];
            thin := (Length(pairs) = 1);          # a single underline: add a thin space before q
        fi;
    else
        body := Concatenation("(", JoinStringsWithSeparator(parts, "+"), ")");
    fi;

    if style = "bracket" then
        return [ Concatenation(body, "[", String(d), "]"), Length(pairs) ];
    fi;
    if d = 0 then
        qpart := "q^0";
    else
        qpart := Concatenation("q^{", String(d), "}");
    fi;
    if thin then
        qpart := Concatenation("\\,", qpart);
    fi;
    return [ Concatenation(body, qpart), Length(pairs) ];
end);

# One character:  \car(name) &= term + term + ...   with a LaTeX line break when a line would have
# more than maxItems underlines.
InstallGlobalFunction(QGNAG_CharacterToTeX, function(rec_info, LName, maxItems, style)
    local degrees, d, t, text, count, first;

    degrees := List(RecNames(rec_info), Int);
    Sort(degrees);
    text  := Concatenation("\\car", LName, "\n\t&=");
    count := 0;
    first := true;
    for d in degrees do
        t := QGNAG_CharacterDegreeTermToTeX(rec_info.(String(d)), d, style);
        if not first then
            if count + t[2] > maxItems then
                text  := Concatenation(text, "\\\\\n\t&\\quad+");
                count := 0;
            else
                text := Concatenation(text, "+");
            fi;
        fi;
        text  := Concatenation(text, t[1]);
        count := count + t[2];
        first := false;
    od;
    return text;
end);

InstallGlobalFunction(QGNAG_CharactersTeXText, function(permuted_decomps, sNamesL, n_top, filtered, maxItems, style)
    local families, fam, kept, i, nrec, text, k, skip;

    families := [ [ "\\tau",  "\\Lambda_\\tau'"  ],
                  [ "\\rho",  "\\Lambda_\\rho'"  ],
                  [ "\\chi",  "\\Lambda_\\chi'"  ],
                  [ "\\eta",  "\\Lambda_\\eta'"  ] ];
    text := "";
    for fam in families do
        kept := [];
        for i in [1 .. Length(permuted_decomps)] do
            nrec := Length(RecNames(permuted_decomps[i]));
            skip := filtered and (nrec = n_top or nrec = 1);
            if not skip and PositionSublist(sNamesL[i], fam[1]) <> fail then
                Add(kept, i);
            fi;
        od;
        if Length(kept) > 0 then
            text := Concatenation(text, "\\subsubsection{Case $\\lambda\\in ", fam[2], "$}\n\n\\begin{align*}\n");
            for k in [1 .. Length(kept)] do
                i    := kept[k];
                text := Concatenation(text, "\t",
                                      QGNAG_CharacterToTeX(permuted_decomps[i], sNamesL[i], maxItems, style));
                if k < Length(kept) then
                    text := Concatenation(text, ".\\\\\n");
                else
                    text := Concatenation(text, ".\n");
                fi;
            od;
            text := Concatenation(text, "\\end{align*}\n\n");
        fi;
    od;
    return text;
end);

InstallGlobalFunction(QGNAG_WriteCharactersTeX, function(data_record_data_decomp, SimpleNames, filename, filtered)
    local tau, data_neg, data_neg_permuted, sNamesL, n_top, text, out;

    tau               := QGNAG_PermutationVarChars(data_record_data_decomp);
    data_neg          := List(data_record_data_decomp, QGNAG_PrepareDecomposition);
    data_neg_permuted := Permuted(data_neg, tau);
    sNamesL           := List(SimpleNames, QGNAG_ExtractTuple);
    n_top             := Length(RecNames(data_record_data_decomp[1][1]));

    text := Concatenation(
        "% Characters of the simple modules L(lambda), generated by QGNAG_WriteCharactersTeX\n",
        "% Requires: amsmath;  \\car = \\operatorname{char}\n\n",
        QGNAG_CharactersTeXText(data_neg_permuted, sNamesL, n_top, filtered, 7, "q"));

    out := OutputTextFile(filename, false);
    SetPrintFormattingStatus(out, false);
    AppendTo(out, text);
    CloseStream(out);
    return true;
end);
