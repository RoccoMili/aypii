program ejercicioUno;
uses
	GenericLinkedList;
const
	CANT = 5;
type
	gasto = record
		tipo : string;
		fecha : string;
		monto : integer;
	end;
	totalGasto = record
		tipo : string;
		monto : integer;
	end;
	listaGastos = specialize LinkedList<gasto>;
	listaComun = specialize LinkedList<totalGasto>;
	vListas = array [1..CANT] of listaGastos;

{El módulo cargarListaGastos que lea los gastos aleatoriamente (de manera similar a
como se generaban los inmuebles) y los almacene ordenados por tipo de gasto. La
lectura finaliza cuando se lee monto 0}
procedure cargarListaGastos(var l : listaGastos);
var
	vTipos : array [1..5] of string = ('Impuestos', 'Supermercado', 'Steam', 'Servicios', 'Puchos');
	vFecha : array [1..10] of string = ('29/08', '27/10', '04/08', '20/11', '12/10', '9/7', '14/6', '23/04', '15/06', '02/09');
	gastoAct : gasto;
begin
	gastoAct.monto := random(100);
	while (gastoAct.monto <> 0) do begin
		gastoAct.tipo := vTipos[random(5)+1];
		gastoAct.fecha := vFecha[random(10)+1];
		l.reset();
		while ((not l.eol()) AND (l.current().tipo <= gastoAct.tipo)) do
			l.next();
		l.insertCurrent(gastoAct);
		writeln('ANIADIDO: ',gastoAct.tipo, ' [',gastoAct.monto,']');
		gastoAct.monto := random(100);
	end;
end;

procedure cargarGastos(var v : vListas);
var
	i : integer;
begin
	for i:=1 to CANT do begin
		v[i] := listaGastos.create();
		cargarListaGastos(v[i]);
	end;
end;

{Los módulos cargarGastos(), mergeAcumulador() y minimo (). (sólo deberán
transcribirlos de esta presentación)}
procedure buscarMinimo(var min : gasto; v : vListas);
var
	i, posMin : integer;
begin
	min.tipo := 'zzz';
	posMin := -1;
	for i:=1 to CANT do begin
		if (not v[i].eol()) then begin
			if (v[i].current().tipo <= min.tipo) then begin
				min := v[i].current();
				posMin := i;
			end;
		end;
	end;
	if (posMin <> -1) then
		v[posMin].next();
end;

procedure mergeAcumulador(var lAcc : listaComun; v : vListas);
var
	min : gasto;
	gastoAct : totalGasto;
	i : integer;
begin
	lAcc := listaComun.create();
	for i:=1 to CANT do
		v[i].reset();
	buscarMinimo(min, v);
	while (min.tipo <> 'zzz') do begin
		gastoAct.tipo := min.tipo;
		gastoAct.monto := 0;
		while (gastoAct.tipo = min.tipo) do begin
			gastoAct.monto := gastoAct.monto + min.monto;
			buscarMinimo(min, v);
		end;
		lAcc.add(gastoAct);
		writeln('ANIADIDO:',gastoAct.tipo, ' ',gastoAct.monto);
	end;
end;

{Un módulo que reciba la “lista única” y retorne el tipo de gasto con mayor gasto.}
function imprimirMayor(l : listaComun) : string;
var
	maxTipo : string;
	maxCant : integer;
begin
	l.reset();
	maxCant := -1;
	while (not l.eol()) do begin
		if (l.current().monto > maxCant) then begin
			maxCant := l.current().monto;
			maxTipo := l.current().tipo;
		end;
		l.next();
	end;
	imprimirMayor := maxTipo;
end;

var
	listas : vListas;
	comun : listaComun;
begin
	randomize;
	cargarGastos(listas);
	mergeAcumulador(comun, listas);
	writeln('El tipo con mas gastos es ',imprimirMayor(comun));
end.
