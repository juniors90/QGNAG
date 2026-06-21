InstallGlobalFunction( QGNAGShowConfig, function()
    local el;
    Print("\n");
    Print("========================================\n");
    Print("         QGNAG CONFIGURATION\n");
    Print("========================================\n\n");

    Print("Base Structures\n");
    Print("---------------\n");
    Print("Cyclic group order (C_m)     : ", QGNAG.Config.m, "\n");
    Print("Finite field size (q = p^n)  : ", QGNAG.Config.q, "\n\n");

    Print("Derived Objects\n");
    Print("---------------\n");
    Print("Cyclic ring            : Z/", QGNAG.Config.m, "Z\n");
    Print("Finite field           : GF(", QGNAG.Config.q, ")\n\n");

    Print("Index Sets\n");
    Print("----------\n");
    Print("xIndex     : ", QGNAG.Config.xIndex, "\n");
    Print("groupIndex : ", QGNAG.Config.groupIndex, "\n");
    Print("deltaIndex : ", QGNAG.Config.deltaIndex, "\n");
    Print("yIndex     : ", QGNAG.Config.yIndex, "\n\n");

    Print("Dimensions\n");
    Print("----------\n");
    Print("Number of x generators       : ", QGNAG.Config.nX, "\n");
    Print("Number of group generators   : ", QGNAG.Config.nGensOfG, "\n");
    Print("Number of delta generators   : ", QGNAG.Config.nDelta, "\n");
    Print("Number of y generators       : ", QGNAG.Config.nY, "\n\n");

    Print("Elements Of Group\n");
    Print("---------------\n");
    Print("Elements: ", "\n");
    for el in QGNAG.Config.elmsG do
        Print( el, "\n");
    od;
    Print("\n");
    Print("Nichols Algebra\n");
    Print("---------------\n");
    Print("Number of j generators: ", List(QGNAG.Config.gensA, x -> ElementFq(x)), "\n");

    Print("\n========================================\n\n");

end );

MyDateISO8601 := function()
    local s, date;
    s    := IO_Popen( "date", [ "+%y-%m-%d" ], "r");
    date := IO_ReadLine( s );
    IO_Close(s);
    return Concatenation( "20", date{[ 1 .. Length(date)-1 ]} );
end;

MyCurrentTimestamp := function() 
    local s, date;
    s    := IO_Popen("date", [ ], "r");
    date := IO_ReadLine(s);
    IO_Close(s);
    return date{[ 1 .. Length(date)-1 ]};
end;

MyCustomDate := function( format )
    local s, result;
    s      := IO_Popen( "date", [ format ], "r");
    result := IO_ReadLine( s );
    IO_Close(s);
    return result{[ 1 .. Length(result)-1 ]};
end;
# MyCustomDate("+%H:%M");
# MyCustomDate("+%A");
# MyCustomDate("+%Y");

