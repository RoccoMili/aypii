program Biblioteca;
uses SysUtils, GenericLinkedList, UDateTime_EJ, URandomGenerator, OBJPrestamo;

type 		
	RPrestamo = record
		codigoSocio: integer;
		fecha: Date;
		isbn: string;
	end;
	ListaRPrestamos = specialize LinkedList<RPrestamo>;
	
	listaPrestamos = specialize LinkedList<Prestamo>;
	prestamosMensuales = array [1..12] of listaPrestamos;
	
// Use esta función para obtener la lista con la información de los prestamos
procedure ObtenerInfoPrestamos(var lista: ListaRPrestamos);
var i, nPrestamos, nLibros: integer;
	pres: RPrestamo;
	rg: RAndomGenerator;
	d1, d2: Date;
begin
lista:= ListaRPrestamos.create();
rg:= RandomGenerator.create;

nPrestamos:= random(300) + 100;	//Nos aseguramos un mínimo de 100 préstamos
nLibros:= random(100) + 30;	//Nos aseguramos un mínimo de 30 libros

for i:= 1 to nLibros do
	rg.addLabel('978' + IntToStr(rg.getInteger(10,99)) + IntToStr(rg.getInteger(1000,9999)) + IntToStr(rg.getInteger(100,999)) + IntToStr(rg.getInteger(1,9)));
	
d1:= Date.create(1,1,2024);
d2:= Date.create(31,12,2024);
// Generamos N encomiendas y los almacenamos en la lista
for i:= 1 to nPrestamos do
	begin
	pres.codigoSocio:= rg.getInteger(100, 150);
	pres.fecha:= rg.getDate(d1, d2);;
	pres.isbn:= rg.getLabel();
	
	lista.add(pres);
	end;
end;
//--------------------------------------------------------

procedure inicializarMensuales(var v : prestamosMensuales);
var
	i : integer;
begin
	for i:=1 to 12 do
		v[i] := listaPrestamos.create();
end;

{ Implemente un módulo que reciba la lista de préstamos y los retorne en 
una estructura que almacene los préstamos agrupados por mes. Para 
cada mes los préstamos deben quedar ordenados por ISBN. 
NOTA: 
Implemente la clase Prestamo. 
NOTA2: Esta clase debería implementar 
un método de comparación para determinar que un libro es menor o 
mayor a otro.}

procedure ordenarMensual(v : prestamosMensuales; l : listaRPRestamos);
var
	prestAct : Prestamo;
	mesAct : integer;
begin
	l.reset();
	while (not l.eol()) do begin
		prestAct := Prestamo.create(l.current().codigoSocio, l.current().fecha, l.current().isbn);
		
		mesAct := l.current().fecha.getMonth();
		v[mesAct].reset();
		while (not v[mesAct].eol()) do
			v[mesAct].next();
		v[mesAct].insertCurrent(prestAct);
	
		l.next();
	end;
end;
	

	
var 
	lista: ListaRPrestamos;
	mensuales : prestamosMensuales;
begin
	randomize;

	writeln('Obteniendo lista');
	ObtenerInfoPrestamos(lista);

	inicializarMensuales(mensuales);
	ordenarMensual(mensuales, lista);
	
end.
