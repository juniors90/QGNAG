InstallGlobalFunction(StringMonomial, function( ff )
    local ans, hlp, j, addon, l, sgn, opt, pg;
    
    ans := ""; 
    l := Length( ff[2] );
    addon := false;

    if l = 0 then 
	   ans := "0"; 
    else
    	if not Length( ff[1][1] ) = 0 and ff[1][1][1] < 0 then

		    pg := GBNP.GetOption("PrintModuleGenerators");
		
            if pg = fail then
                pg := GBNP.GetOptions().pg;
            fi;

            GBNP.PrintNPM(ff, pg);
            
            return;
        fi;
    fi;

    for j in [1..l] do
        hlp := ff[2][j];
        if not IsZero( hlp ) then 
            if not( IsRat( hlp ) ) then		
		sgn := "+ "; 
	    else
            if ( SignInt( hlp ) = 1 ) then 
		        sgn := "+ "; 
	        else 
                sgn := "- "; 
	      	    hlp := AbsInt( hlp ) ;
	    	fi;
	    fi;
            if addon or sgn = "- " then 
		        Append( ans, sgn ); 
            fi; 
            
            addon := true; 
            
            if not IsOne( hlp ) or ff[1][j] = [] then
                Append( ans, String( hlp ) ); 
            fi;
            Append( ans, GBNP.TransWord( ff[1][j] ) );
            Append( ans, " " );
        fi;
    od;
    return ans;
end);