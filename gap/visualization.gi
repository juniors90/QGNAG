InstallGlobalFunction( QGNAG_PlotColumnsRecordSVG, function(decomp_char)
        local xs, ys,width, height,xmin, xmax, ymin, ymax,sx, sy,svg,i, x1, y1, x2, y2,
        marginLeft, marginRight, marginTop, marginBottom, PlotY, PlotX, data;
        data:=QGNAG_GradedRecordToColumns(decomp_char);
        xs := data.degree;
        ys := data.value;
        width  := 600;
        height := 400;
        xmin := Minimum(xs);
        xmax := Maximum(xs);
        ymin := Minimum(ys);
        ymax := Maximum(ys);
        PlotX := function(x)
            return marginLeft + Int((x-xmin)*(width-marginLeft-marginRight)/(xmax-xmin));
        end;
        PlotY := function(y)
            return height - marginBottom - Int((y-ymin)*(height-marginTop-marginBottom)/(ymax-ymin));
        end;
        if xmax = xmin then
            xmax := xmin + 1;
        fi;
        if ymax = ymin then
            ymax := ymin + 1;
        fi;
        svg := Concatenation(
            "<svg xmlns=\"http://www.w3.org/2000/svg\" ",
            "width=\"", String(width), "\" ",
            "height=\"", String(height), "\">"
        );

        svg := Concatenation(
            svg,
            "<rect x=\"0\" y=\"0\" width=\"",
            String(width),
            "\" height=\"",
            String(height),
            "\" fill=\"white\" stroke=\"black\"/>"
        );
        marginLeft   := 70;
        marginRight  := 30;
        marginTop    := 50;
        marginBottom := 70;

        svg := Concatenation(
            svg,
            # eje X
            "<line x1=\"", String(marginLeft),
            "\" y1=\"", String(height-marginBottom),
            "\" x2=\"", String(width-marginRight),
            "\" y2=\"", String(height-marginBottom),
            "\" stroke=\"black\" stroke-width=\"2\"/>",
            # eje Y
            "<line x1=\"", String(marginLeft),
            "\" y1=\"", String(marginTop),
            "\" x2=\"", String(marginLeft),
            "\" y2=\"", String(height-marginBottom),
            "\" stroke=\"black\" stroke-width=\"2\"/>"
        );
        svg := Concatenation(
            svg,
            "<text x=\"",
            String(width/2),
            "\" y=\"25\" text-anchor=\"middle\" ",
            "font-size=\"20\" font-weight=\"bold\">",
            "Character decomposition",
            "</text>"
        );

        for i in [1..Length(xs)] do
            x1 := marginLeft + Int((xs[i]-xmin)*(width-marginLeft-marginRight)/(xmax-xmin));
            svg := Concatenation(
                svg,
                "<line x1=\"", String(x1),
                "\" y1=\"", String(height-marginBottom),
                "\" x2=\"", String(x1),
                "\" y2=\"", String(height-marginBottom+5),
                "\" stroke=\"black\"/>",
                "<text x=\"", String(x1),
                "\" y=\"", String(height-marginBottom+20),
                "\" text-anchor=\"middle\">",
                String(xs[i]),
                "</text>"
            );
        od;

        for i in [ymin..ymax] do
            y1 := height - marginBottom - Int((i-ymin)*(height-marginTop-marginBottom)/(ymax-ymin));
            svg := Concatenation(
                svg,
                "<line x1=\"", String(marginLeft-5),
                "\" y1=\"", String(y1),
                "\" x2=\"", String(marginLeft),
                "\" y2=\"", String(y1),
                "\" stroke=\"black\"/>",
                "<text x=\"", String(marginLeft-10),
                "\" y=\"", String(y1+5),
                "\" text-anchor=\"end\">",
                String(i),
                "</text>"
            );
        od;

        svg := Concatenation(
            svg,
            "<line x1=\"...", 
            " stroke=\"#dddddd\" stroke-dasharray=\"4,4\"/>"
        );
        
        for i in [1..Length(xs)-1] do
            x1 := PlotX(xs[i]);
            y1 := PlotY(ys[i]);
            x2 :=PlotX(xs[i+1]);
            y2 := PlotY(ys[i+1]);
            svg := Concatenation(
                svg,
                "<line x1=\"", String(x1),
                "\" y1=\"", String(y1),
                "\" x2=\"", String(x2),
                "\" y2=\"", String(y2),
                "\" stroke=\"blue\" stroke-width=\"2\"/>"
            );

        od;
        
        for i in [1..Length(xs)] do
            x1 := PlotX(xs[i]);
            y1 := PlotY(ys[i]);
            svg := Concatenation(
                svg,
                "<circle cx=\"", String(x1),
                "\" cy=\"", String(y1),
                "\" r=\"4\" fill=\"red\"/>"
            );
        od;
        for i in [1..Length(xs)] do
            x1  := PlotX(xs[i]);
            y1  := PlotY(ys[i]);
            svg := Concatenation(
                svg,
                "<text x=\"", String(x1-10),
                "\" y=\"", String(y1-10),
                "\" text-anchor=\"middle\" ",
                "font-size=\"12\">",
                String(ys[i]),
                "</text>"
            );
        #ymin := ymin + 0.05*(ymax-ymin);
        #ymax := ymax - 0.05*(ymax-ymin);
        od;
        svg := Concatenation(
            svg,
            "<text x=\"",
            String(width/2),
            "\" y=\"",
            String(height-20),
            "\" text-anchor=\"middle\">Degree</text>",

            "<text x=\"20\" y=\"",
            String(height/2),
            "\" transform=\"rotate(-90 20 ",
            String(height/2),
            ")\" text-anchor=\"middle\">Hom Dimension</text>"
        );
        
        svg := Concatenation(svg, "</svg>");
        
        return JupyterRenderable(
            rec(
                ("image/svg+xml") := svg
            ),
            rec(
                ("image/svg+xml") := rec(
                    width := width,
                    height := height
                )
            )
        );

end);