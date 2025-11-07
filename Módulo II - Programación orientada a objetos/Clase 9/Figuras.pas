program Figuras;
uses UFiguras, GenericLinkedList;
type
    listaFiguras = specialize LinkedList<UFiguras.Figura>;

var
    lista : listaFiguras;
    square : Cuadrado; circle : Circulo; triangle : Triangulo;
BEGIN
    lista := listaFiguras.create();
    square := Cuadrado.create(5);
    circle := Circulo.create(3);
    triangle := Triangulo.create(2, 3, 4);
    lista.add(square); lista.add(circle); lista.add(triangle);

    lista.reset();
    while (not lista.eol()) do begin
        writeln(lista.current.toString(), ' - AREA: ',lista.current().getArea():8:2); // este toString estaba hecho con el TObject de FPC
        writeln(lista.current.toString(), ' - PERIMETRO: ',lista.current().getPerimetro():8:2);
        lista.next();
    end;

    writeln('OTRA ITERACION');
    lista.reset();
    while (not lista.eol()) do begin
        writeln(lista.current().toString());
        lista.next();
    end;
END.