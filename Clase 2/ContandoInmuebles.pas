program ContandoInmuebles;
uses
	GenericLinkedList;
const
	HAB = [0..4];
	BAÑOS = [1..3];
type
	inmueble = record
		tipo: string;
		cantHab: integer;
		cantBanos : integer;
	end;
	pares = array [HAB, BAÑOS]
	listaInmuebles = specialize LinkedList<inmueble>;

procedure leerInmueble(var inmu:inmueble);
var 
   inmuAct : inmueble;
begin             
	writeln('INGRESA LA CANT DE BAÑOS (1-3):');
	readln(inmuAct.cantBanos);
	if(inmuAct.cantBanos <> 0) then begin
		writeln('INGRESA EL TIPO DE INMUEBLE (1-4):');
		readln(inmuAct.tipo);
		writeln('INGRESA LA CANTIDAD DE HABITACIONES (0-4):');
		readln(inmuAct.cantHab);
		writeln('INGRESA LA CANT DE BAÑOS (1-3)');
		readln(inmuAct.cantBanos);
	end;
end;

{-----------------------------------
DISCLAIMER: NO TERMINADO! TENGAN COMPASIÓN POR FAVOR SOY HUMANO
-----------------------------------}

procedure iniciarPares(var m : pares);
var
	fil, col : integer;
begin
	
end;

procedure contarInmuebles(var m : pares; l : listaInmuebles);
var
	l.reset();
	while (not l.eol()) do begin
		m[]
		l.next();
	end;
begin

end;

procedure cargarInmueble(var l : listaInmuebles)
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
