program Fechas;
uses
	GenericLinkedList, UDateTime_EJ, URandomGenerator;
const
	TEST = 15;
type
	vectorFechas = array [1..TEST] of Date;
	
{Implemente un módulo que cargue un vector de 15 fechas de
nacimiento elegidas al azar.}
procedure crearFechas(var v : vectorFechas);
var
	rg : RandomGenerator;
	i : integer;
begin
	rg := RandomGenerator.create();
	for i:=1 to TEST do begin
		// asume que todos los meses tienen 31 días. se presta a errores, pero es fácilmente arreglable
		v[i] := Date.create(rg.getInteger(1, 31), rg.getInteger(1, 12), rg.getInteger(1962, 2025));
	end;
end;

{Implemente un módulo que reciba un vector de fechas y las imprima
por consola.}
procedure printFechas(v : vectorFechas);
var
	i : integer;
begin
	for i:=1 to TEST do
		writeln(v[i].toString())
end;

{Implemente un módulo que reciba un vector de fechas y una fecha a
buscar y devuelva si existe en el vector.}
function existeFecha(v : vectorFechas; buscar : Date) : boolean;
var
	i : integer;
	existe : boolean;
begin
	i := 1;
	existe := false;
	while ((i<=TEST) AND (not existe)) do begin
		if (v[i].equals(buscar)) then
			existe := true;
		i := i + 1;
	end;
	existeFecha := existe;
	// en teoría, defaultea a Falso si no existe
end;

function masJoven(v : vectorFechas) : Date;
var
	i : integer;
	jovenActual : Date;
begin
	jovenActual := v[1];
	for i:=2 to TEST do begin
		if (v[i].greaterThan(jovenActual)) then
			jovenActual := v[i];
	end;
	masJoven := jovenActual;
end;

{Implemente un módulo que reciba un vector de fechas y lo devuelva
ordenado de menor a mayor.}
procedure ordenarFechas(var v : vectorFechas);
var
	i, p, j : integer;
	swap : Date;
begin
	for i:=1 to TEST-1 do begin
		p := i;
		for j:=i+1 to TEST do
			if (v[j].lessThan(v[p])) then
				p := j;
		swap := v[p];
		v[p] := v[i];
		v[i] := swap;
	end;
end;

var
	fechasNac : vectorFechas;
	fechaBuscar : Date;
	fechaBuscarD, fechaBuscarM, fechaBuscarY : integer;
begin
	crearFechas(fechasNac);
	printFechas(fechasNac);
	
	writeln('=== INGRESA UNA FECHA PARA BUSCAR ===');
	writeln('[INGRESA EL DIA]:');
	readln(fechaBuscarD);
	writeln('[INGRESA EL MES]:');
	readln(fechaBuscarM);
	writeln('[INGRESA EL ANIO]:');
	readln(fechaBuscarY);
	fechaBuscar := Date.create(fechaBuscarD, fechaBuscarM, fechaBuscarY);
	
	if (existeFecha(fechasNac, fechaBuscar)) then
		writeln('Existe la fecha ',fechaBuscar.toString())
	else
		writeln('No existe la fecha ',fechaBuscar.toString());
	writeln('=====================================');
		
	writeln('[MAS JOVEN]: ',masJoven(fechasNac).toString());
	
	writeln('=== FECHAS ORDENADAS ASCENDENTE ===');
	ordenarFechas(fechasNac);
	printFechas(fechasNac);
	writeln('=== TERMINADA LA IMPRESION ORDENADA ===');
	
end.
