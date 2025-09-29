program Adicional4;
uses GenericABB, GenericLinkedList;

const
	CANTIDAD_PATENTES = 20;
	CANTIDAD_MARCAS = 10;

type
	Fecha = record
		dia, mes, anio: integer;
	end;
	Alquiler = record
		codigo_sucursal: integer;
		fecha_alquiler: Fecha;
		patente: string;
		marca: string;
		modelo: integer;
		dias_alquiler: integer;
		precio_por_dia: real;
	end;
	ListaAlquileres = specialize LinkedList<Alquiler>;

	VectorSucursales = array [1..10] of ListaAlquileres;

	Resumen = record
		marca : string;
		cantidad : integer;
		total : real;
	end;
	ListaResumen = specialize LinkedList<Resumen>;

	DatoPatente = record
		patente : string;
		lista : ListaAlquileres;
	end;
	ABBPatentes = specialize ABB<DatoPatente>;

// Use esta función para obtener la lista de alquileres
procedure ObtenerAlquileres(var lista: ListaAlquileres);
var i, j, nValores: integer;
	alq: Alquiler;
	patentes: array [1..CANTIDAD_PATENTES] of string = ('A5', 'B8', 'C3', 'D1', 'E7', 'F9', 'G4', 'H6', 'I2', 'J8',
	                                              'K7', 'L2', 'M1', 'N8', 'O5', 'P0', 'Q3', 'R4', 'S1', 'T7');
	marcas_db: array [1..CANTIDAD_MARCAS] of string = ('Fiat', 'Audi', 'Ford', 'Renault', 'Volkswagen',
	                                              'Peugeot', 'Citroen', 'Nissan', 'Chevrolet', 'Toyota');
	modelos: array [1..CANTIDAD_PATENTES] of integer;
	marcas: array [1..CANTIDAD_PATENTES] of string;

begin
lista:= ListaAlquileres.create();

for i:= 1 to CANTIDAD_PATENTES do
	begin
	marcas[i]:= marcas_db[random(CANTIDAD_MARCAS) + 1];
	modelos[i]:= random(4) + 2020;
	end;
	
nValores:= random(1000) + 200;

// Generamos N alquileres y los almacenamos en la lista
for i:= 1 to nValores do
	begin
	alq.codigo_sucursal:= random(10) + 1;
	alq.fecha_alquiler.anio:= random(5) + 2020;
	alq.fecha_alquiler.mes:= random(12) + 1;
	alq.fecha_alquiler.dia:= random(28) + 1;
	j:= random(CANTIDAD_PATENTES) + 1;
	alq.patente:= patentes[j];
	alq.marca:= marcas[j];
	alq.modelo:= modelos[j];;
	alq.dias_alquiler:= random(15) + 4;
	alq.precio_por_dia:= random(15) + 70;
		
	lista.add(alq);
	end;
end;
//--------------------------------------------------------

{Haga un módulo que procese la lista de alquileres que se dispone y que los almacene 
agrupados por sucursal y ordenados por marca en una estructura de datos adecuada y 
que la retorne. }
procedure cargarVector(var v : VectorSucursales; l : ListaAlquileres);
var
	i : integer;
begin
	for i:=1 to 10 do
		v[i] := ListaAlquileres.create();
	l.reset();
	while (not l.eol()) do begin
	  	v[l.current().codigo_sucursal].reset();
		while ((not v[l.current().codigo_sucursal].eol()) AND (v[l.current().codigo_sucursal].current().marca <= l.current().marca)) do
			v[l.current().codigo_sucursal].next();
		v[l.current().codigo_sucursal].insertCurrent(l.current());
	  	l.next();
	end;
end;

{Haga un módulo que reciba la estructura de datos devuelta por el módulo anterior y 
retorne un resumen de alquileres para cada marca, registrando cantidad de alquileres y 
precio total. Ordenada de manera descendente por cantidad de alquileres. }
procedure buscarMinimo(var v : VectorSucursales; var marcaAct : Alquiler);
var
	i, posMin : integer;
begin
	marcaAct.marca := 'ZZZZZZZZZZ';
	for i:=1 to 10 do
		if (not v[i].eol()) then
			if (v[i].current().marca <= marcaAct.marca) then begin
			  	marcaAct.marca := v[i].current().marca;
				marcaAct.dias_alquiler := v[i].current().dias_alquiler;
				marcaAct.precio_por_dia := v[i].current().precio_por_dia;
				posMin := i;
			end;
	if (marcaAct.marca <> 'ZZZZZZZZZZ') then
		v[posMin].next();
end;

procedure resumenMarca(v : VectorSucursales; var l : ListaResumen);
var
	actual : Resumen;
	marcaAct : Alquiler;
	i : integer;
begin
	l := ListaResumen.create();
	for i:=1 to 10 do
		v[i].reset();
	buscarMinimo(v, marcaAct);
	while (marcaAct.marca <> 'ZZZZZZZZZZ') do begin
	  	actual.marca := marcaAct.marca;
		actual.cantidad := 0;
		actual.total := 0;
		while (marcaAct.marca = actual.marca) do begin
		  	actual.cantidad := actual.cantidad + 1;
			actual.total := actual.total + (marcaAct.dias_alquiler * marcaAct.precio_por_dia);
			buscarMinimo(v, marcaAct);
		end;
		l.reset();
		while ((not l.eol()) AND (l.current().cantidad >= actual.cantidad)) do
			l.next();
		l.insertCurrent(actual);
	end;
end; 

{Haga un módulo que reciba la estructura de datos devuelta por el módulo 
implementado en el punto 2 e imprima la marca con mayor cantidad de alquileres a 
nivel nacional. }
procedure mayorMarca(l : ListaResumen);
begin
	l.reset();
	if (not l.eol()) then
		writeln('[',l.current().cantidad,']: ',l.current().marca);
end;

{ PARA DEBUGGING, NO LO PIDE NINGUNA CONSIGNA
procedure print(l : ListaResumen);
begin
	l.reset();
	while (not l.eol()) do begin
		writeln('[',l.current().cantidad,']: ',l.current().marca);
	  	l.next();
	end;
end; }

{Haga un módulo que procese la lista de alquileres que se dispone, almacene en una 
estructura de datos eficiente para la búsqueda de alquileres por patente y que la 
retorne. Para cada patente se desea almacenar todos sus alquileres. }
procedure agregarPatente(a : ABBPatentes; alq : Alquiler);
var
	pat : DatoPatente;
begin
	if (a.isEmpty()) then begin
		pat.patente := alq.patente;
		pat.lista := ListaAlquileres.create();
		pat.lista.add(alq);
		a.insertCurrent(pat);
	end
	else if (a.current().patente = alq.patente) then
		a.current().lista.add(alq)
	else if (a.current().patente > alq.patente) then
		agregarPatente(a.getLeftChild(), alq)
	else
		agregarPatente(a.getRightChild(), alq);
end;

procedure crearArbol(a : ABBPatentes; l : ListaAlquileres);
begin
	l.reset();
	while (not l.eol()) do begin
	  	agregarPatente(a, l.current());
		l.next();
	end;
end;

{Haga un módulo que reciba la estructura de datos retornada en el punto 4, una 
patente y una fecha y devuelva si ese auto se alquiló en la fecha recibida.}
function buscarPatente(a : ABBPatentes; patente : string; fec : Fecha) : boolean;
var
	found : boolean;
begin
	if (a.isEmpty()) then
		buscarPatente := false
	else if (a.current().patente = patente) then begin
	  	a.current().lista.reset();
		found := false;
		while ((not a.current().lista.eol()) AND (not found)) do begin
			if ((a.current().lista.current().fecha_alquiler.dia = fec.dia) AND (a.current().lista.current().fecha_alquiler.mes = fec.mes) AND (a.current().lista.current().fecha_alquiler.anio = fec.anio)) then
				found := true;
			a.current().lista.next();
		end;
		buscarPatente := found;
	end
	else if (a.current().patente > patente) then
		buscarPatente := buscarPatente(a.getLeftChild(), patente, fec)
	else
		buscarPatente := buscarPatente(a.getRightChild(), patente, fec);
end;

{Haga un módulo que reciba la estructura de datos retornada en el punto 4 y una fecha 
y devuelva la cantidad de alquileres que se realizaron en esa fecha. }
procedure cantAlquileres(a : ABBPatentes; fec : Fecha; var cont : integer);
begin
	if (not a.isEmpty()) then begin
		cantAlquileres(a.getLeftChild(), fec, cont);
		a.current().lista.reset();
		while (not a.current().lista.eol()) do begin
			if ((a.current().lista.current().fecha_alquiler.dia = fec.dia) AND (a.current().lista.current().fecha_alquiler.mes = fec.mes) AND (a.current().lista.current().fecha_alquiler.anio = fec.anio)) then
				cont := cont + 1;
		  	a.current().lista.next();
		end;
		cantAlquileres(a.getRightChild(), fec, cont);
	end;
end;

var 
	l: ListaAlquileres;
	vector : VectorSucursales;
	lResumen : ListaResumen;
	arbol : ABBPatentes;
	patBuscar : string;
	fecBuscar : Fecha;
	contarFecha : integer;
begin
	randomize;

	writeln('Obteniendo lista');
	ObtenerAlquileres(l);

	l.reset();
	while not l.eol do begin
  		if l.current.patente = 'S1' then begin
  			writeln(l.current.codigo_sucursal);
			writeln(l.current.fecha_alquiler.anio);
			writeln(l.current.fecha_alquiler.mes);
			writeln(l.current.fecha_alquiler.dia);
			writeln(l.current.patente);
			writeln(l.current.marca);
			writeln(l.current.modelo);
			writeln(l.current.dias_alquiler);
			writeln(l.current.precio_por_dia);
  			writeln('-----------------');
		end;
  		l.next;
   end;

	cargarVector(vector, l);
	resumenMarca(vector, lResumen);
	// print(lResumen);
	mayorMarca(lResumen);

	arbol := ABBPatentes.create();
	crearArbol(arbol, l);

	writeln('Ingresa una patente para buscar:');
	readln(patBuscar);
	writeln('Ingresa un dia para buscar una fecha:');
	readln(fecBuscar.dia);
	writeln('Ingresa un mes para buscar una fecha:');
	readln(fecBuscar.mes);
	writeln('Ingresa un anio para buscar una fecha:');
	readln(fecBuscar.anio);
	if (buscarPatente(arbol, patBuscar, fecBuscar)) then
		writeln('La patente ',patBuscar,' en la fecha indicada existe')
	else
		writeln('La patente NO existe');
	writeln('Ingresa un dia para buscar una fecha:');
	readln(fecBuscar.dia);
	writeln('Ingresa un mes para buscar una fecha:');
	readln(fecBuscar.mes);
	writeln('Ingresa un anio para buscar una fecha:');
	readln(fecBuscar.anio);
	contarFecha := 0;
	cantAlquileres(arbol, fecBuscar, contarFecha);
	writeln('En esa fecha se alquilaron ',contarFecha,' autos');

end.
