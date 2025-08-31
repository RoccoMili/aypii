program ContandoInmuebles;
uses
	GenericLinkedList;
const
	HAB = 4;
	BANOS = 3;
type
	inmueble = record
		tipo: string;
		cantHab: integer;
		cantBanos : integer;
	end;
	pares = array [0..HAB, 1..BANOS] of integer;
	listaInmuebles = specialize LinkedList<inmueble>;

procedure leerInmueble(var inmu:inmueble);
begin             
	writeln('INGRESA LA CANT DE BANIOS (1-3):');
	readln(inmu.cantBanos);
	if(inmu.cantBanos <> 0) then begin
		writeln('INGRESA EL TIPO DE INMUEBLE (1-4):');
		readln(inmu.tipo);
		writeln('INGRESA LA CANTIDAD DE HABITACIONES (0-4):');
		readln(inmu.cantHab);
	end;
end;

procedure iniciarPares(var m : pares);
var
	fil, col : integer;
begin
	for fil:=0 to HAB do
		for col:=1 to BANOS do begin
			m[fil,col] := 0;
		end;
end;

{Implemente un módulo que genere una nueva lista con inmuebles
 usando el procedimiento cargarInmueble.}
procedure cargarInmueble(var l : listaInmuebles);
var
	inmu : inmueble;
begin
	l := listaInmuebles.create();
	leerInmueble(inmu);
	while (inmu.cantBanos <> 0) do begin
		l.add(inmu);
		leerInmueble(inmu);
	end;
	
end;

{Implemente un módulo que reciba la lista de inmuebles y contabilice
 para cada par posible de cantHab-cantBaños cuantos inmuebles se
 poseen almacenados.}
procedure contarInmuebles(var m : pares; l : listaInmuebles);
begin
	l.reset();
	while (not l.eol()) do begin
		m[l.current().cantHab, l.current().cantBanos] := m[l.current().cantHab, l.current().cantBanos] + 1;
		l.next();
	end;
end;

{Implemente un módulo quereciba la contabilidad y la imprima.}
procedure imprimirContador(m : pares);
var
	fil, col : integer;
begin
	for fil:=0 to HAB do
		for col:=1 to BANOS do
			writeln(m[fil,col], '');
	writeln;
end;

var
	matrizPares : pares;
	lInmu : listaInmuebles;
BEGIN
	iniciarPares(matrizPares);
	cargarInmueble(lInmu);
	contarInmuebles(matrizPares, lInmu);
	imprimirContador(matrizPares);
END.