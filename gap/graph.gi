# 1. EL PARSEADOR INTELIGENTE (Detecta bloques $...$ automáticamente)
InstallGlobalFunction(QGNAG_PrepareLaTeX, function(str)
    local result, inMath, currentChunk, c;

    result       := "";
    inMath       := false;
    currentChunk := "";
    
    for c in str do
        if c = '$' then
            if Length(currentChunk) > 0 then
                if inMath then
                    # Si veníamos de estar dentro de $, es matemática pura y se deja intacta
                    result := Concatenation(result, currentChunk);
                else
                    # Si estábamos fuera de $, es texto plano.
                    # Si es una frase (tiene espacios o largo > 1), la protegemos con \text{...}
                    if Position(currentChunk, ' ') <> fail or Length(currentChunk) > 1 then
                        result := Concatenation(result, "\\text{", currentChunk, "}");
                    else
                        result := Concatenation(result, currentChunk);
                    fi;
                fi;
                currentChunk := "";
            fi;
            inMath := not inMath; # Alternamos entre modo matemática y modo texto
        else
            Add(currentChunk, c);
        fi;
    od;
    
    # Procesamos el último fragmento sobrante al final del string
    if Length(currentChunk) > 0 then
        if inMath then
            result := Concatenation(result, currentChunk);
        else
            if Position(currentChunk, ' ') <> fail or Length(currentChunk) > 1 then
                result := Concatenation(result, "\\text{", currentChunk, "}");
            else
                result := Concatenation(result, currentChunk);
            fi;
        fi;
    fi;
    
    return result;
end);

# 2. EL CODIFICADOR URL (Limpio, ya no necesita filtrar los $)
InstallGlobalFunction( QGNAG_UrlEncode, function(str)
    local res, c;
    res := "";
    for c in str do
        if c = ' ' then
            res := Concatenation(res, "%20");
        elif c = '+' then
            res := Concatenation(res, "%2B");
        elif c = '\\' then
            res := Concatenation(res, "%5C");
        elif c = '^' then
            res := Concatenation(res, "%5E");
        elif c = '{' then
            res := Concatenation(res, "%7B");
        elif c = '}' then
            res := Concatenation(res, "%7D");
        elif c = '(' then
            res := Concatenation(res, "%28");
        elif c = ')' then
            res := Concatenation(res, "%29");
        elif c = '=' then
            res := Concatenation(res, "%3D");
        elif c = '/' then
            res := Concatenation(res, "%2F");
        else
            Add(res, c);
        fi;
    od;
    return res;
end);

InstallGlobalFunction(QGNAG_SimplesGraphToTikz, function( filename, data_pols_decomp )
    local numSimples, adjacency, p, q, polynomial_pq, polynomial_qp,
          visited, components, comp, queue, current, neighbor, level,
          hGap, vGap, blockGap, coords, xOffset, maxlevel, byLevel,
          lvl, nodes, i, node, x, y, out;

    numSimples := Length(data_pols_decomp);

    # 1. Grafo simetrico de ligamiento: p ~ q  si  t_{p,q}(1)<>0  o  t_{q,p}(1)<>0
    adjacency := List( [1..numSimples], x -> [] );
    for p in [1..numSimples] do
        for q in [1..numSimples] do
            if p <> q then
                polynomial_pq := data_pols_decomp[p].(String(q));
                polynomial_qp := data_pols_decomp[q].(String(p));
                if Sum(polynomial_pq) <> 0 or Sum(polynomial_qp) <> 0 then
                    Add( adjacency[p], q );
                fi;
            fi;
        od;
    od;

    # 2. Componentes conexas (bloques) + nivel BFS de cada nodo respecto
    #    al minimo de su bloque.
    visited    := BlistList( [1..numSimples], [] );
    components := [];
    level      := rec();
    for p in [1..numSimples] do
        if not visited[p] then
            comp := [];
            level.(String(p)) := 0;
            queue := [p];
            visited[p] := true;
            while Length(queue) > 0 do
                current := Remove(queue, 1);
                Add(comp, current);
                for neighbor in adjacency[current] do
                    if not visited[neighbor] then
                        visited[neighbor] := true;
                        level.(String(neighbor)) := level.(String(current)) + 1;
                        Add(queue, neighbor);
                    fi;
                od;
            od;
            Sort(comp);
            Add(components, comp);
        fi;
    od;
    Sort( components, function(a,b) return a[1] < b[1]; end );

    # 3. Layout: bloques en franjas horizontales, nodos por nivel BFS,
    #    todo con racionales exactos (pgfmath los evalua sin problema).
    hGap     := 8/5;   vGap := 13/10;   blockGap := 11/5;
    coords   := rec();
    xOffset  := 0;

    for comp in components do
        maxlevel := Maximum( List( comp, node -> level.(String(node)) ) );
        byLevel  := rec();
        for node in comp do
            lvl := String( level.(String(node)) );
            if not IsBound( byLevel.(lvl) ) then
                byLevel.(lvl) := [];
            fi;
            Add( byLevel.(lvl), node );
        od;
        for lvl in RecNames(byLevel) do
            nodes := byLevel.(lvl);
            Sort(nodes);
            for i in [1..Length(nodes)] do
                y := ( (Length(nodes)+1)/2 - i ) * vGap;
                x := xOffset + Int(lvl) * hGap;
                coords.(String(nodes[i])) := [ x, y ];
            od;
        od;
        xOffset := xOffset + maxlevel*hGap + blockGap;
    od;

    # 4. Escribir el archivo .tex.
    out := OutputTextFile( filename, false );

    AppendTo( out, "\\subsection{Separation into blocks}\n\n" );
    AppendTo( out, "The linkage graph on the simples, where $p \\sim q$ " );
    AppendTo( out, "whenever $t_{p,q}(1)\\neq 0$ or $t_{q,p}(1)\\neq 0$, " );
    AppendTo( out, "decomposes into connected components as follows.\n\n" );

    AppendTo( out, "\\begin{center}\n" );
    AppendTo( out, "\\begin{tikzpicture}[thick,\n" );
    AppendTo( out, "  simple/.style={circle,draw,minimum size=7mm,inner sep=0pt}]\n" );

    for p in [1..numSimples] do
        x := coords.(String(p))[1];
        y := coords.(String(p))[2];
        AppendTo( out, "  \\node[simple] (n", String(p), ") at (",
                        String(x), ",", String(y), ") {$", String(p), "$};\n" );
    od;

    AppendTo( out, "\n" );

    for p in [1..numSimples] do
        for q in adjacency[p] do
            if p < q then
                AppendTo( out, "  \\draw (n", String(p), ") -- (n", String(q), ");\n" );
            fi;
        od;
    od;

    AppendTo( out, "\\end{tikzpicture}\n" );
    AppendTo( out, "\\end{center}\n\n" );

    CloseStream(out);
end);

############################################################################
# 1. Construir nodos/aristas a partir de la data de simples (t_{p,q}(1)<>0)
############################################################################
InstallGlobalFunction( QGNAG_GraphFromSimples, function( data_pols_decomp )
    local numSimples, 
          edges, 
          p, 
          q, 
          polynomial_pq, 
          polynomial_qp;

    numSimples := Length(data_pols_decomp);
    edges := [];

    for p in [1..numSimples] do
        for q in [p+1..numSimples] do
            polynomial_pq := data_pols_decomp[p].(String(q));
            polynomial_qp := data_pols_decomp[q].(String(p));
            if Sum(polynomial_pq) <> 0 or Sum(polynomial_qp) <> 0 then
                Add( edges, [p,q] );
            fi;
        od;
    od;

    return rec( nodes := [1..numSimples], edges := edges );
end);

############################################################################
# 2. Layout generico: componentes conexas + niveles BFS (coordenadas
#    racionales exactas), igual logica que usamos para el TikZ.
############################################################################
InstallGlobalFunction( QGNAG_GraphComputeLayout, function( nodes, edges )
    local adjacency, 
          node, 
          e, 
          p, 
          q, 
          visited, 
          components, 
          comp, 
          queue,
          current, 
          neighbor, 
          level, 
          hGap, 
          vGap, 
          blockGap, 
          coords,
          xOffset, 
          maxlevel, 
          byLevel, 
          lvl, 
          ns, 
          i, 
          y, 
          x, 
          idx, 
          nodeIndex;

    # indexar nodos 1..n internamente, pero conservando sus ids reales
    nodeIndex := rec();
    for i in [1..Length(nodes)] do
        nodeIndex.(String(nodes[i])) := i;
    od;

    adjacency := rec();
    for node in nodes do
        adjacency.(String(node)) := [];
    od;
    for e in edges do
        p := e[1];
        q := e[2];
        Add( adjacency.(String(p)), q );
        Add( adjacency.(String(q)), p );
    od;

    visited := rec();
    for node in nodes do
        visited.(String(node)) := false;
    od;

    components := [];
    level      := rec();

    for node in nodes do
        if not visited.(String(node)) then
            comp := [];
            level.(String(node)) := 0;
            queue := [node];
            visited.(String(node)) := true;
            while Length(queue) > 0 do
                current := Remove(queue, 1);
                Add(comp, current);
                for neighbor in adjacency.(String(current)) do
                    if not visited.(String(neighbor)) then
                        visited.(String(neighbor)) := true;
                        level.(String(neighbor)) := level.(String(current)) + 1;
                        Add(queue, neighbor);
                    fi;
                od;
            od;
            Sort(comp);
            Add(components, comp);
        fi;
    od;
    Sort( components, function(a,b) return a[1] < b[1]; end );

    hGap     := 8/5;   vGap := 13/10;   blockGap := 11/5;
    coords   := rec();
    xOffset  := 0;

    for comp in components do
        maxlevel := Maximum( List( comp, node -> level.(String(node)) ) );
        byLevel  := rec();
        for node in comp do
            lvl := String( level.(String(node)) );
            if not IsBound( byLevel.(lvl) ) then
                byLevel.(lvl) := [];
            fi;
            Add( byLevel.(lvl), node );
        od;
        for lvl in RecNames(byLevel) do
            ns := byLevel.(lvl);
            Sort(ns);
            for i in [1..Length(ns)] do
                y := ( (Length(ns)+1)/2 - i ) * vGap;
                x := xOffset + Int(lvl) * hGap;
                coords.(String(ns[i])) := [ x, y ];
            od;
        od;
        xOffset := xOffset + maxlevel*hGap + blockGap;
    od;

    return coords;
end);

############################################################################
# 3. Render: SOLO el grafo, misma filosofia que GAPPlot_Render
#    (defaults, armar SVG a mano, capa HTML, JupyterRenderable).
############################################################################
InstallGlobalFunction( QGNAG_GraphRender, function( fig )
    local width, 
          height, 
          margin, 
          nodeRadius, 
          nodes, 
          edges, 
          coords,
          minX, 
          maxX, 
          minY, 
          maxY, 
          PlotX, 
          PlotY, 
          svg, 
          e, 
          p, 
          q,
          x1, 
          y1, 
          x2, 
          y2, 
          node, 
          px, 
          py, 
          cleanTitle, 
          html_output;

    if IsBound(fig.width)  then 
        width  := fig.width;  
    else 
        width  := 500; 
    fi;
    if IsBound(fig.height) then 
        height := fig.height; 
    else 
        height := 350; 
    fi;
    if IsBound(fig.margin)  then 
        margin := fig.margin;  
    else 
        margin := 40;
    fi;
    if IsBound(fig.nodeRadius) then 
        nodeRadius := fig.height; 
    else 
        nodeRadius := 16;
    fi;
    
    if not IsBound(fig.nodes) or not IsBound(fig.edges) then
        Error("fig debe tener 'nodes' y 'edges'.");
    fi;
    nodes := fig.nodes;
    edges := fig.edges;

    if IsBound(fig.coords) then
        coords := fig.coords;
    else
        coords := QGNAG_GraphComputeLayout(nodes, edges);
    fi;

    minX := Minimum( List(nodes, node -> Float(coords.(String(node))[1])) );
    maxX := Maximum( List(nodes, node -> Float(coords.(String(node))[1])) );
    minY := Minimum( List(nodes, node -> Float(coords.(String(node))[2])) );
    maxY := Maximum( List(nodes, node -> Float(coords.(String(node))[2])) );
    if maxX = minX then 
        maxX := minX + 1.0; 
    fi;
    if maxY = minY then 
        maxY := minY + 1.0; 
    fi;

    PlotX := function(x)
        return margin + nodeRadius + Int( (Float(x)-minX)*(width - 2*margin - 2*nodeRadius)/(maxX-minX) );
    end;
    PlotY := function(y)
        return margin + nodeRadius + Int( (maxY-Float(y))*(height - 2*margin - 2*nodeRadius)/(maxY-minY) );
    end;
    # --- SVG ---
    svg := Concatenation(
        "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"", String(width),
        "\" height=\"", String(height), "\">"
    );
    svg := Concatenation(svg,
        "<rect x=\"0\" y=\"0\" width=\"", String(width), "\" height=\"", String(height),
        "\" fill=\"white\" stroke=\"black\"/>"
    );

    # aristas primero, para que queden debajo de los nodos
    for e in edges do
        p := e[1]; 
        q := e[2];
        x1 := PlotX(coords.(String(p))[1]); y1 := PlotY(coords.(String(p))[2]);
        x2 := PlotX(coords.(String(q))[1]); y2 := PlotY(coords.(String(q))[2]);
        svg := Concatenation(svg,
            "<line x1=\"", String(x1), "\" y1=\"", String(y1),
            "\" x2=\"", String(x2), "\" y2=\"", String(y2),
            "\" stroke=\"black\" stroke-width=\"1.5\"/>"
        );
    od;

    # nodos
    for node in nodes do
        px := PlotX(coords.(String(node))[1]);
        py := PlotY(coords.(String(node))[2]);
        svg := Concatenation(svg,
            "<circle cx=\"", String(px), "\" cy=\"", String(py),
            "\" r=\"", String(nodeRadius),
            "\" fill=\"#eef2ff\" stroke=\"black\" stroke-width=\"1.5\"/>",
            "<text x=\"", String(px), "\" y=\"", String(py+5),
            "\" text-anchor=\"middle\" font-size=\"14\" font-family=\"sans-serif\">",
            String(node), "</text>"
        );
    od;

    svg := Concatenation(svg, "</svg>");

    # --- capa HTML (titulo opcional, misma filosofia que GAPPlot_Render) ---
    html_output := Concatenation(
        "<div style=\"position: relative; width: ", String(width),
        "px; height: auto; background: white;\">"
    );

    if IsBound(fig.title) then
        cleanTitle := QGNAG_UrlEncode(QGNAG_PrepareLaTeX(fig.title));
        html_output := Concatenation(html_output,
            "<div style=\"text-align:center; padding: 6px 0;\">",
            "<img src=\"https://latex.codecogs.com/svg.image?\\displaystyle%20",
            cleanTitle, "\" style=\"height: 22px;\" />",
            "</div>"
        );
    fi;

    html_output := Concatenation(html_output, svg, "</div>");

    return JupyterRenderable(
        rec(("text/html") := html_output),
        rec(("text/html") := rec(width := width, height := height))
    );
end);


InstallGlobalFunction(QGNAG_SaveGraphData, function( filename, data_pols_decomp )
    local fig, out;

    fig        := QGNAG_GraphFromSimples( data_pols_decomp );
    fig.coords := QGNAG_GraphComputeLayout( fig.nodes, fig.edges );
    out        := OutputTextFile( filename, false );
    
    AppendTo( out, "QGNAG_SavedGraph := rec(\n" );
    AppendTo( out, "  nodes  := ", String(fig.nodes),  ",\n" );
    AppendTo( out, "  edges  := ", String(fig.edges),  ",\n" );
    AppendTo( out, "  coords := ", String(fig.coords), "\n" );
    AppendTo( out, ");\n" );
    CloseStream(out);
end);