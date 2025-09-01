program ejercicioUno;
uses
    GenericLinkedList;
type
    libro = record
        autor : string;
        titulo : string;
        anio : integer;
    end;
    listaLibros = specialize LinkedList<libro>;

procedure cargarEstante(var l : listaLibros);
var
    lib : libro;
    vAutores : array [1..4] of string = ('Joshy', 'Mikeke', 'Joaco', 'Valen');
    vTitulos : array [1..10] of string = ('The Art of Doing Science and Engineering', 'Mathematics for Machine Learning', 'A Hitchhikers Guide to the Galaxy', '1984', 'Rebelion en la granja', 'Himno', 'La rebelion de Atlas', 'El manantial', 'La etica de la libertad', 'El hombre, la Economia y el Estado');
begin
    lib.anio := random(2025-1900)+1900+1;
    while (lib.anio <> 2025) do begin
        lib.titulo := vTitulos[random(10)+1];
        lib.autor := vAutores[random(4)+1];
        l.add(lib);
        lib.anio := random(2025-1900)+1900+1;
    end;
end;

procedure buscarMinimo(var min : libro; est1, est2 : listaLibros);
begin
    min.titulo := 'VACIO';
    if ((not (est1.eol()) AND (not est2.eol()))) then begin
        if (est1.current().titulo <= est2.current().titulo) then begin
            min := est1.current();
            est1.next();
        end
        else begin
            min := est2.current();
            est2.next();
        end;
    end
    else if (not est1.eol()) then begin
        min := est1.current();
        est1.next();
    end
    else if (not est2.eol()) then begin
        min := est2.current();
        est2.next();
    end;
end;

procedure ordenarEstante(var ord : listaLibros; est1, est2 : listaLibros);
var
    min : libro;
begin
    ord := listaLibros.create();
    est1.reset(); est2.reset();
    buscarMinimo(min, est1, est2);
    while (min.titulo <> 'VACIO') do begin
        ord.add(min);
        buscarMinimo(min, est1, est2);
    end;
end;

procedure imprimirEstante(l : listaLibros);
begin
    l.reset();
    while (not l.eol()) do begin
        writeln('"',l.current().titulo,'" por ',l.current().autor,' [',l.current().anio,']');
        l.next();
    end;
end;

var
    estante1, estante2 : listaLibros;
    ordenado : listaLibros;
BEGIN
    estante1 := listaLibros.create();
    estante2 := listaLibros.create();
    cargarEstante(estante1);
    cargarEstante(estante2);
    ordenarEstante(ordenado, estante1, estante2);
    imprimirEstante(ordenado);
END.