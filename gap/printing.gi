InstallGlobalFunction( QGNAG_PrintNPToString, function( ff )
    local ans, hlp, j, addon, l, sgn, opt, pg;
    ans   := ""; 
    l     := Length(ff[2]);
    addon := false;
    if l = 0 then 
	   ans := "0"; 
    else
    	if not Length( ff[1][1] ) = 0 and ff[1][1][1] < 0 then
		    pg := GBNP.GetOption("PrintModuleGenerators");
		    if pg = fail then
			    pg:= GBNP.GetOptions().pg;
		    fi;
		    GBNP.PrintNPM( ff, pg );
		    return;
	    fi;
    fi;
    for j in [1..l] do
        hlp := ff[2][j];
        if not IsZero(hlp) then 
            if not(IsRat(hlp)) then		
		        sgn := "+ "; 
	        else
                if (SignInt(hlp)=1) then 
		            sgn := "+ "; 
	            else 
                    sgn := "- "; 
	      	        hlp := AbsInt(hlp);
	    	    fi;
	        fi;
            if addon or sgn = "- " then 
		        Append( ans, sgn ); 
	        fi; 
            addon := true; 
            if not IsOne( hlp ) or ff[1][j] = [] then
                Append( ans, String( hlp ) ); 
            fi;
            Append(ans, GBNP.TransWord( ff[1][j] ) );
            Append( ans, " ");
        fi;
    od;
    return ans;
end);;

#############################################################################
# FACTORING MONOMIALS INTO:
#
# prefix * suffix
#
# where:
#
# prefix = part like X0X1X2...
# suffix = part like tD_(w,2), ztD_(1,4), etc.
#
# The idea is to group by prefix.
#############################################################################

InstallGlobalFunction( QGNAG_FactorByPrefix, function(np, nX)

    local mons, coeffs, data, m, c, mon_m, small, small_idx, large, pref, suf, key;

    mons   := np[1];
    coeffs := np[2];
    data   := rec();

    for m in [1..Length(mons)] do

        mon_m := [ [ mons[m] ], [ coeffs[m] ] ];

        #####################################################################
        # Large part = suffix type:
        #
        #   [8,5,29]
        #
        #####################################################################

        large := MonomialForLargeIndex( mon_m, nX );

        #####################################################################
        # Small part = suffix type:
        #
        #   [1,2,3,2,1,3,2,4]
        #
        #####################################################################

        small := MonomialForSmallIndex( mon_m, nX );

        #####################################################################
        # We convert the prefix into a string to use it as a key
        #####################################################################
        
        key := ReplacedString(QGNAG_PrintNPToString(small), " ", "");
        if not IsBound(data.(key)) then
            data.(key) := rec(
                prefix := small[1][1],
                terms  := []
            );
        fi;

        Add(
            data.(key).terms,
            rec(
                suffix := large[1][1],
                coeff  := coeffs[m]
            )
        );
    od;

    return data;

end);

InstallGlobalFunction( QGNAG_PrintFactored, function(factorization)

    local names, k, r, t, s, pol_fact, rels_suffix, coeff_suffix;

    names            := RecNames(factorization);
    pol_fact         := "";

    for k in [1..Length(names)] do
        r            := factorization.(names[k]);
        rels_suffix  := [ ];
        coeff_suffix := [ ];
        for t in r.terms do
            Add(rels_suffix, t.suffix);
            Add(coeff_suffix, t.coeff);
        od;
        s            := QGNAG_PrintNPToString([ rels_suffix, coeff_suffix ]);
        if k = 1 then
            pol_fact := Concatenation(pol_fact, names[k], "(", s, ")");
        else
            pol_fact := Concatenation(pol_fact, " + ", names[k], "(", s, ")");
        fi;
    od;
    Print("\n=================== POLYNOMIAL ======================\n");
    Print(" ", pol_fact, "\n");
end
);