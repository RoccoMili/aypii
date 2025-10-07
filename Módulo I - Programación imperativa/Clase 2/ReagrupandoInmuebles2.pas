program ReagrupandoInmuebles2;
uses
    GenericLinkedList;
const
    MESES = 12;
    AINI = 2010;
    AFIN = 2023;
type
    inmueble = record
        tipo : string;
        cantHab : integer;
        cantBanos : integer;
        precio : real;
        localidad : string;
    end;
    listaInmuebles = specialize LinkedList<inmueble>;
    listaListas = specialize LinkedList<listaInmuebles>;
    matrizInmuebles = array [1..MESES, AINI..AFIN] of inmueble;

{Importado de Inmueble.pas}
procedure cargarInmueble(var inmu:inmueble);
var 
    vTipos : array[1..4] of string = ('Casa', 'Departamento', 'Duplex', 'Local Comercial');
    vLocal : array[1..10] of string = ('La Plata', 'Berisso', 'Ensenada', 'Quilmes','Avellaneda','Bernal','Berazategui','Olavarria','Tandil','Dolores');
begin
    inmu.tipo := vTipos[random(4)+1];
    inmu.cantHab := random(5);
    inmu.cantBanos := random(3)+1;
    inmu.precio := random(50000)/2+10000;
    inmu.localidad := vLocal[random(10)+1];      
end;

{Implemente un módulo que genere inmuebles con el procedimiento
 cargarInmueble. Se debe generar un inmueble para cada mes de los
 años 2010 a 2023. Los inmuebles generados representan el mejor
 vendido para cada mes-año}
procedure generarInmueble(var m : matrizInmuebles);
var
    inmuAct : inmueble;
    fil, col : integer;
begin
    for fil:=1 to MESES do
        for col:=AINI to AFIN do begin
            cargarInmueble(inmuAct);
            m[fil,col] := inmuAct;
        end;
end;

{Implemente un módulo que reciba la estructura generada en a) y
 almacene todos los inmuebles en otra estructura agrupada por
 localidad de manera ordenada.}
procedure agruparInmuebles(var ll : listaListas; m : matrizInmuebles);
var
    fil, col : integer;
    listaNueva : listaInmuebles;
begin
    ll := listaListas.create(); 
    for fil:=1 to MESES do
        for col:=AINI to AFIN do begin
            ll.reset();
            while ((not ll.eol()) AND (m[fil,col].localidad > ll.current().current().localidad)) do
                ll.next();
            if ((ll.eol()) OR (m[fil,col].localidad <> ll.current().current().localidad)) then begin
                listaNueva := listaInmuebles.create();
                ll.insertCurrent(listaNueva);
            end;
            ll.current().add(m[fil,col]);
        end;
end;

{Implemente un módulo que imprima toda la información de los
 inmuebles agrupados por localidad}
procedure imprimirLista(ll : listaListas);
begin
    ll.reset();
    while (not ll.eol()) do begin 
        ll.current().reset();
        while ((not ll.current().eol())) do begin
            writeln('[',ll.current().current().localidad,'] TIPO: ', ll.current().current().tipo);
            writeln('[',ll.current().current().localidad,'] BANIOS: ', ll.current().current().cantBanos);
            writeln('[',ll.current().current().localidad,'] HABIT.: ', ll.current().current().cantHab);
            writeln('[',ll.current().current().localidad,'] PRECIO: $', (ll.current().current().precio):6:2);
            ll.current().next();
        end;
        ll.next();
    end;
end;

var
    localidades : listaListas;
    datos : matrizInmuebles;
BEGIN
    generarInmueble(datos);
    agruparInmuebles(localidades, datos);
    imprimirLista(localidades);
END.