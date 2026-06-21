# ########################################################################### #
# Álgebra de Drinfeld D(S3): relaciones δ_h g = g δ_{g^{-1} h g}              #
# Convención de GAP: δ_h * g = g * δ_{g * h * g^-1}                           #
# ########################################################################### #
# --------------------------------------------------------------------------- #
# Índices y mapeos coherentes con el sistema GBNP                             #
# --------------------------------------------------------------------------- #
# Representación en términos de generadores                                   #
# (debe coincidir con los groupIndex previos)                                 #
# ########################################################################### #
# Generación automática de las relaciones δ_h g = g δ_{g^{-1} h g}            #
# ########################################################################### #
InstallGlobalFunction(CommutationRelationsGroupAndDeltas, function(allPairsInG, groupIndex, deltaIndex)
    local g, h, pos_h, pos_g, delta_h, conj, pos_conj, delta_conj, g_word, m1, m2, relsDG;
    
    relsDG := [];;
    for g in allPairsInG do
        for h in allPairsInG do
            pos_g      := Position(allPairsInG, g);
            pos_h      := Position(allPairsInG, h);
            if pos_g = fail or pos_h = fail then
                Error("Element not found in allPairsInG.");
            fi;
            delta_h    := deltaIndex[pos_h];
            conj       := g^-1 * h * g;
            pos_conj   := Position(allPairsInG, conj);
            if pos_conj = fail then
                Error("No conjugate found.");
            fi;
            delta_conj := deltaIndex[pos_conj];
            g_word     := groupIndex[pos_g];
            m1         := Concatenation([delta_h], g_word);    # δ_h * g
            m2         := Concatenation(g_word, [delta_conj]); # g * δ_{g^-1*h*g }
            Add(relsDG, [ [m1, m2], [1, -1] ]);
        od;
    od;
    return relsDG;
end);