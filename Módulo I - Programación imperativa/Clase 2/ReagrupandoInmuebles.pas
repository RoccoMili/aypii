program ReagrupandoInmuebles;
uses
    GenericLinkedList;
const
    HAB = 4;
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
    vectorInmuebles = array [0..HAB] of listaInmuebles;
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
 vendido para cada mes-año. Los inmuebles tienen de cero a cuatro
 habitaciones}
procedure generarInmueble(var m : matrizInmuebles);
var
    fil, col : integer;
    inmuAct : inmueble;
begin
    for fil:=1 to MESES do
        for col:=AINI to AFIN do begin
            cargarInmueble(inmuAct);
            m[fil,col] := inmuAct;
        end;
end;

procedure iniciarListas(var v : vectorInmuebles);
var
    i : integer;
begin
    for i:=0 to 4 do
        v[i] := listaInmuebles.create();
end;

{Implemente un módulo que reciba la estructura generada en a) y
 almacene a todos los inmuebles en otra estructura agrupada por
 cantidad de habitaciones}
procedure reagruparInmueble(m : matrizInmuebles; var v : vectorInmuebles);
var
    fil, col : integer;
begin
    iniciarListas(v);
    for fil:=1 to MESES do
        for col:=AINI to AFIN do
            v[m[fil,col].cantHab].add(m[fil,col]);
end;

{Implemente un módulo que imprima toda la información de los
 inmuebles agrupados por cantidad de habitaciones}
procedure imprimirInmuebles(v : vectorInmuebles);
var
    i : integer;
    inmuAct : inmueble;
begin
    for i:=0 to HAB do begin
        v[i].reset();
        while not (v[i].eol()) do begin
            inmuAct := v[i].current();
            writeln('[',i,' HABITACIONES]: TIPO: ', inmuAct.tipo);
            writeln('[',i,' HABITACIONES]: BANIOS: ', inmuAct.cantBanos);
            writeln('[',i,' HABITACIONES]: PRECIO.: ', (inmuAct.precio):8:2);
            writeln('[',i,' HABITACIONES]: LOCALIDAD.: ', inmuAct.localidad);
            v[i].next();
        end;
    end;
end;

var
    matriz : matrizInmuebles;
    vector : vectorInmuebles;
BEGIN
    generarInmueble(matriz);
    reagruparInmueble(matriz, vector);
    imprimirInmuebles(vector);
END.