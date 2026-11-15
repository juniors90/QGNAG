#############################################################################
##
#F  QGNAG_WriteHilbertSeriesTeX( <data_record_data_decomp>, <SimpleNames>,
##                                <degreeofreps>, <filename> )
##
##  For each simple module (as described by <data_record_data_decomp>),
##  writes to <filename> a LaTeX block containing:
##    - the character decomposition  "Char L_i = ..."
##    - the Hilbert series           "H_{L_i}(t) = ..."
##    - the total dimension          "dim L_i = ..."
##
##  Arguments:
##    data_record_data_decomp : list of decomposition records, one per
##                               simple module, as expected by
##                               QGNAG_PermutationVarChars and
##                               QGNAG_PrepareDecomposition.
##    SimpleNames              : list of simple-module name descriptors,
##                               one per entry of data_record_data_decomp,
##                               as expected by QGNAG_ExtractTuple.
##    degreeofreps             : list giving, for each representation
##                               index, the degree of that representation
##                               (used to compute dimensions).
##    filename                 : string, path of the .tex file to
##                               (over)write.
##
##  Returns true on success. The file is closed before returning.
##

InstallGlobalFunction(QGNAG_WriteHilbertSeriesTeX, function(data_record_data_decomp, SimpleNames, Simples, filename)
    local tau,
          data_rec_info_to_zero_negative,
          data_rec_info_to_zero_negative_permuted,
          sNamesL,
          out,
          theta,
          i,
          rec_info,
          LName,
          degrees,
          d,
          pair,
          mult,
          idx,
          term,
          first_char,
          first,
          dim_total,
          degreeofreps,
          total;

    # Permutation that reorders the decomposition data into the desired
    # output order.
    degreeofreps := List(Simples, s -> DegreeOfRepresentation(s.simple));
    tau := QGNAG_PermutationVarChars(data_record_data_decomp);

    # Normalize each decomposition record (zero/negative degree handling).
    data_rec_info_to_zero_negative := List(data_record_data_decomp, QGNAG_PrepareDecomposition);

    # Apply the permutation to the normalized records.
    data_rec_info_to_zero_negative_permuted := Permuted(data_rec_info_to_zero_negative, tau);

    # Display names for each simple module, in the original order.
    sNamesL := List(SimpleNames, QGNAG_ExtractTuple);
    out := OutputTextFile(filename, false);
    theta := Length(data_rec_info_to_zero_negative_permuted);
    for i in [1 .. theta] do
        rec_info := data_rec_info_to_zero_negative_permuted[i];
        LName    := sNamesL[i];
        degrees := List(RecNames(rec_info), Int);
        Sort(degrees);
        # --- Character decomposition -----------------------------------
        AppendTo(out, "\\subsubsection{$L", LName, "$}\n");
        AppendTo(out, "\\[\n");
        AppendTo(out, "\\operatorname{Char}", LName, " = ");
        first_char := true;
        for d in degrees do
            for pair in rec_info.(String(d)) do
                mult := pair[1];
                idx  := pair[2];
                if mult = 1 then
                    term := StringFormatted("\\underline{{{}}}[{}]", idx, d);
                else
                    term := StringFormatted("{}\\,\\underline{{{}}}[{}]", mult, idx, d);
                fi;

                if first_char then
                    AppendTo(out, term);
                    first_char := false;
                else
                    AppendTo(out, " + ", term);
                fi;
            od;
        od;
        AppendTo(out, "\n\\]\n\n");
        # --- Hilbert series and total dimension -------------------------
        AppendTo(out, "\\[\n");
        AppendTo(out, "\\operatorname{H}_{", LName, "}(t) = ");
        first     := true;
        dim_total := 0;
        for d in degrees do
            total := 0;
            for pair in rec_info.(String(d)) do
                mult  := pair[1];
                idx   := pair[2];
                total := total + mult * degreeofreps[idx];
            od;
            dim_total := dim_total + total;
            if d = 0 then
                term := StringFormatted("{}", total);
            elif total = 1 then
                term := StringFormatted("t^{{{}}}", d);
            else
                term := StringFormatted("{}t^{{{}}}", total, d);
            fi;
            if first then
                AppendTo(out, term);
                first := false;
            else
                AppendTo(out, " + ", term);
            fi;
        od;
        AppendTo(out, "\n\\]\n");
        AppendTo(out, "\\[\n\\dim L", LName, " = ", String(dim_total), "\n\\]\n\n");
    od;
    CloseStream(out);
    return true;
end);




InstallGlobalFunction(QGNAG_WeightsPermutation, function( data_rec_info, lambda_chek )
    local i, j, k,
          rec_info,
          degrees,
          top_degree,
          bottom_degree,
          top_modules,
          bottom_modules,
          bottom_module,
          perm_list,
          top_of_socle,
          sigma,
          tau;

    perm_list    := [1..Length(data_rec_info)];
    top_of_socle := [1..Length(data_rec_info)];

    for i in [1..Length(data_rec_info)] do
        rec_info := data_rec_info[i];   # schar(lambda_i)

        # (1) Given lambda_i find lambda_j = lambda_i^vee.
        j := i^lambda_chek;

        # (2) Compute lambda_k = topS(lambda_i).
        degrees       := List(RecNames(rec_info), Int);
        top_degree    := Maximum(degrees);
        bottom_degree := Minimum(degrees);

        top_modules := rec_info.(String(top_degree));
        if Length(top_modules) <> 1 or top_modules[1][1] <> 1 then
            Error("Top degree of data_rec_info[", i, "] does not contain a unique module");
        fi;
        k := top_modules[1][2];
        top_of_socle[i] := k;

        # Consistency check: botS(lambda_i) must be lambda_i^vee.
        bottom_modules := rec_info.(String(bottom_degree));
        if Length(bottom_modules) <> 1 or bottom_modules[1][1] <> 1 then
            Error("Bottom degree of data_rec_info[", i, "] does not contain a unique module");
        fi;
        bottom_module := bottom_modules[1][2];
        if bottom_module <> j then
            Error("botS(lambda_", i, ") = lambda_", bottom_module,
                  " but lambda_chek(lambda_", i, ") = lambda_", j);
        fi;

        # (3) p maps k |-> j.
        perm_list[k] := j;
    od;

    sigma := PermList(perm_list);
    if sigma = fail then
        Error("The assignment k |-> j is not a permutation");
    fi;

    # tau: lambda |-> p(lambda^vee) = sigma(lambda_chek(lambda))
    tau := lambda_chek * sigma;

    return rec( sigma := sigma,
                tau := tau,
                top_of_socle := top_of_socle );
end);

InstallGlobalFunction(QGNAG_PrintWeightsPermutation, function( data_rec_info, lambda_chek, result )
    local i;
    for i in [1..Length(data_rec_info)] do
        Print("weight lambda_", i, ":",
              "  lambda_chek = lambda_", i^lambda_chek,
              "  |  topS = lambda_", result.top_of_socle[i],
              "  |  p(topS) = lambda_", result.top_of_socle[i]^result.sigma,
              "  |  tau = p(lambda_chek) = lambda_", i^result.tau, "\n");
    od;
end);


InstallGlobalFunction(QGNAG_WeightsPermutationToLaTeX, function( data_rec_info, lambda_chek, result, filename )
    local output,
          write_line,
          i,
          sigma,
          tau,
          top_of_socle,
          cycles_to_math;

    sigma        := result.sigma;
    tau          := result.tau;
    top_of_socle := result.top_of_socle;

    # Cycle notation allowing line breaks between consecutive cycles.
    cycles_to_math := function( perm )
        return Concatenation("$",
                             ReplacedString(String(perm), ")(", ")\\allowbreak ("),
                             "$");
    end;

    output := OutputTextFile(filename, false);
    if output = fail then
        Error("Cannot open ", filename, " for writing");
    fi;
    SetPrintFormattingStatus(output, false);

    write_line := function( line )
        AppendTo(output, line, "\n");
    end;

    # ------------------------------------------------------------------
    # Part 1: text of the subsection
    # ------------------------------------------------------------------
    write_line("% Weights permutation, generated by QGNAG_WeightsPermutationToLaTeX");
    write_line("% Requires: amsmath, algorithm, algpseudocode, longtable");
    write_line("\\subsection{Weights permutation}");
    write_line("\\label{subsec:weights_permutation}");
    write_line("We recall that the permutation $\\mathtt{p}\\colon\\Lambda\\to\\Lambda$ assigns to each weight $\\lambda$ the bottom weight $\\operatorname{bot}\\L(\\lambda)$ of the irreducible module $\\L(\\lambda)$; here $\\lambda=\\operatorname{top}\\L(\\lambda)$. In terms of the socle $\\Ss(\\lambda)$, this is the inverse of the map $\\lambda^\\vee=\\operatorname{bot}\\Ss(\\lambda)\\mapsto\\operatorname{top}\\Ss(\\lambda)$; here $\\lambda^\\vee=\\lambda\\ot\\beta$. Hence we can construct $\\mathtt{p}$ using the characters $\\operatorname{schar}(\\lambda)$ computed in \\S\\ref{subsec:characters} via the following steps");
    write_line("\\begin{enumerate}");
    write_line("  \\renewcommand{\\labelenumi}{(\\arabic{enumi})}");
    write_line("  \\item Given a weight $\\lambda_i\\in\\Lambda$ find $\\lambda_j=\\lambda_i^\\vee$.");
    write_line("  \\item Compute $\\lambda_k=\\operatorname{top}\\Ss(\\lambda_i)$.");
    write_line("  \\item $\\mathtt{p}$ maps $k\\mapsto j$.");
    write_line("\\end{enumerate}");
    write_line("It also important to keep track of $\\tau\\colon\\Lambda\\to\\Lambda$, namely $\\lambda\\mapsto\\mathtt{p}(\\lambda^\\vee)$.");
    write_line("");

    # ------------------------------------------------------------------
    # Part 2: pseudocode of QGNAG_WeightsPermutation
    # ------------------------------------------------------------------
    write_line("\\begin{algorithm}[H]");
    write_line("\\caption{Weights permutation $\\mathtt{p}$ and $\\tau$ from the socle characters}");
    write_line("\\label{alg:weights_permutation}");
    write_line("\\begin{algorithmic}[1]");
    write_line("\\Require the characters $\\operatorname{schar}(\\lambda_1),\\dots,\\operatorname{schar}(\\lambda_m)$ of the socles $\\Ss(\\lambda_i)$, stored as records (\\texttt{data\\_rec\\_info}): for each degree $d$, the record of $\\operatorname{schar}(\\lambda_i)$ lists the pairs $(a,n)$ such that $\\mathsf{M}_n$ appears with multiplicity $a$ in degree $d$;");
    write_line("         the permutation $i\\mapsto j$ with $\\lambda_j=\\lambda_i^\\vee$ (\\texttt{lambda\\_chek})");
    write_line("\\Ensure the permutation $\\mathtt{p}$ (\\texttt{sigma}), the permutation $\\tau\\colon\\lambda\\mapsto\\mathtt{p}(\\lambda^\\vee)$ (\\texttt{tau}),");
    write_line("        and the indices $k_i$ with $\\lambda_{k_i}=\\operatorname{top}\\Ss(\\lambda_i)$ (\\texttt{top\\_of\\_socle})");
    write_line("");
    write_line("\\State $\\mathtt{perm\\_list}\\gets(1,2,\\dots,m)$");
    write_line("\\For{$i=1,\\dots,m$}");
    write_line("  \\State \\textbf{(1)} $j\\gets\\lambda^\\vee(i)$ \\Comment{$\\lambda_j=\\lambda_i^\\vee$}");
    write_line("  \\State Let $d_\\top$ and $d_\\bot$ be the largest and the smallest degree of $\\operatorname{schar}(\\lambda_i)$");
    write_line("  \\State \\textbf{(2)} Let $T$ be the list of pairs of $\\operatorname{schar}(\\lambda_i)$ in degree $d_\\top$");
    write_line("  \\If{$T$ is not a single pair $(1,k)$}");
    write_line("    \\State \\textbf{error}: the top degree of $\\operatorname{schar}(\\lambda_i)$ does not contain a unique module");
    write_line("  \\EndIf");
    write_line("  \\State $k_i\\gets k$ \\Comment{$\\lambda_k=\\operatorname{top}\\Ss(\\lambda_i)$}");
    write_line("  \\State Let $B$ be the list of pairs of $\\operatorname{schar}(\\lambda_i)$ in degree $d_\\bot$");
    write_line("  \\If{$B$ is not a single pair $(1,b)$}");
    write_line("    \\State \\textbf{error}: the bottom degree of $\\operatorname{schar}(\\lambda_i)$ does not contain a unique module");
    write_line("  \\EndIf");
    write_line("  \\If{$b\\neq j$} \\Comment{consistency check: $\\operatorname{bot}\\Ss(\\lambda_i)=\\lambda_i^\\vee$}");
    write_line("    \\State \\textbf{error}: $\\operatorname{bot}\\Ss(\\lambda_i)\\neq\\lambda_i^\\vee$");
    write_line("  \\EndIf");
    write_line("  \\State \\textbf{(3)} $\\mathtt{perm\\_list}[k]\\gets j$ \\Comment{$\\mathtt{p}$ maps $k\\mapsto j$}");
    write_line("\\EndFor");
    write_line("\\State $\\mathtt{p}\\gets$ the permutation $k\\mapsto\\mathtt{perm\\_list}[k]$; \\textbf{error} if $\\mathtt{perm\\_list}$ is not a permutation");
    write_line("\\State $\\tau\\gets$ the permutation $i\\mapsto\\mathtt{p}(\\lambda^\\vee(i))$");
    write_line("\\State \\Return $\\mathtt{p}$, $\\tau$ and $(k_1,\\dots,k_m)$");
    write_line("\\end{algorithmic}");
    write_line("\\end{algorithm}");
    write_line("");

    # ------------------------------------------------------------------
    # Part 3: computed permutations
    # ------------------------------------------------------------------
    write_line("The permutations obtained, written as products of disjoint cycles of indices (the index $i$ stands for the weight $\\lambda_i$), are the following.");
    write_line("");
    write_line(Concatenation("\\noindent $\\lambda\\mapsto\\lambda^\\vee$: ", cycles_to_math(lambda_chek), "\\par"));
    write_line(Concatenation("\\noindent $\\mathtt{p}$: ", cycles_to_math(sigma), "\\par"));
    write_line(Concatenation("\\noindent $\\tau$: ", cycles_to_math(tau), "\\par"));
    write_line("");
    write_line("\\begin{longtable}{rrrrr}");
    write_line("\\caption{Weights permutation: $j$ is the index of $\\lambda_i^\\vee$, $k$ is the index of $\\operatorname{top}\\Ss(\\lambda_i)$, and $\\tau(i)=\\mathtt{p}(j)$.}\\label{tab:weights_permutation}\\\\");
    write_line("\\hline");
    write_line("$i$ & $j$ & $k$ & $\\mathtt{p}(i)$ & $\\tau(i)$\\\\");
    write_line("\\hline");
    write_line("\\endfirsthead");
    write_line("\\hline");
    write_line("$i$ & $j$ & $k$ & $\\mathtt{p}(i)$ & $\\tau(i)$\\\\");
    write_line("\\hline");
    write_line("\\endhead");
    write_line("\\hline");
    write_line("\\endlastfoot");
    for i in [1..Length(data_rec_info)] do
        write_line(Concatenation(String(i), " & ",
                                 String(i^lambda_chek), " & ",
                                 String(top_of_socle[i]), " & ",
                                 String(i^sigma), " & ",
                                 String(i^tau), " \\\\"));
    od;
    write_line("\\end{longtable}");

    CloseStream(output);
    Print("LaTeX file with the weights permutation written to ", filename, "\n");
end);