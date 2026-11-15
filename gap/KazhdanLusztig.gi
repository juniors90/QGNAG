

InstallGlobalFunction(QGNAG_PrepareDecomposition, function(record_data_decomp)
    local rec_info, 
          rec_info_to_zero, 
          rec_info_to_zero_negative, 
          tau;

    rec_info                  := QGNAG_Decomposition(record_data_decomp);
    rec_info_to_zero          := QGNAG_ShiftKeysToZero(rec_info);
    rec_info_to_zero_negative := QGNAG_InvertKeySigns(rec_info_to_zero);

    return rec_info_to_zero_negative;
end);

InstallGlobalFunction(QGNAG_EquivalenceClosure, function( data )
    local n,
          parent,
          Find,
          Union,
          i,
          j,
          keys,
          classes,
          NonZeroKeysInt,
          root;

    n      := Length(data);
    parent := [1 .. n];

    NonZeroKeysInt := function(r)
        return List(Filtered(RecNames(r), k -> r.(k) <> 0), i ->  Int(i));
    end;

    Find := function(x)
        while parent[x] <> x do
            parent[x] := parent[parent[x]];
            x := parent[x];
        od;
        return x;
    end;

    Union := function(x, y)
        local rx, ry;
        rx := Find(x);
        ry := Find(y);
        if rx <> ry then
            parent[ry] := rx;
        fi;
    end;
    # Relaciones generadoras
    for i in [1 .. n] do
        keys := NonZeroKeysInt(data[i]);
        for j in keys do
            Union(i, j);
        od;
    od;
    # Construir las clases de equivalencia
    classes := [];
    for i in [1 .. n] do
        root := Find(i);
        if not IsBound(classes[root]) then
            classes[root] := [];
        fi;
        Add(classes[root], i);
    od;
    return Filtered(classes, c -> IsBound(c));
end);


InstallGlobalFunction(QGNAG_QuantumPolsToBlocks, function( data_quantum_pols_eval )
    local n,
          remaining,
          blocks,
          block,
          new_block,
          NonZeroKeysInt,
          i;

    n         := Length( data_quantum_pols_eval );;
    remaining := [1 .. n];;
    blocks    := [];;

    NonZeroKeysInt := function(r)
        return List(Filtered(RecNames(r), k -> r.(k) <> 0), i ->  Int(i));
    end;

    while Length(remaining) > 0 do
        i     := remaining[1];; # Elegimos un índice que todavía no pertenece a un bloque
        block := [i];;          # Bloque inicial
        while true do           # Saturamos el bloque
            new_block := Union(block, Union( List( block, j -> NonZeroKeysInt( data_quantum_pols_eval[j] ) ) ));;
            if new_block = block then # Ya no aparecieron elementos nuevos
                break;
            fi;
            block := new_block;;
        od;
        Add( blocks, block );;                        # Guardamos el bloque saturado
        remaining := Difference( remaining, block );; # Esos índices ya fueron utilizados
    od;

    return blocks;

end);


InstallGlobalFunction( QGNAG_BlocksToRecord, function( blocks )
    local r, i;
    r := rec();
    for i in [1 .. Length(blocks)] do
        r.(String(i)) := blocks[i];
    od;
    return r;
end);

