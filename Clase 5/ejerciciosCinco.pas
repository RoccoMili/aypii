program ejerciciosClase5;
uses
	GenericLinkedList;
const
	DIMF = 100;
	CANT = 5;
type
	vReales = array [1..DIMF] of real;
	listaReales = specialize LinkedList<real>;
	vListas = array [1..CANT] of listaReales;
	
{ ACTIVIDAD 1: 1. Implemente el módulo sumatoria_rec.}
function sum(N : integer) : integer;
begin
	if N <> 1 then
		sum := sum(N-1) + N
	else
		sum := 1;
end;

{ ACTIVIDAD 2: 1. Implemente el módulo sumaTotal_rec.}
function sumaTotal(v : vReales; i : integer) : real;
begin
	if (i < DIMF) then
		sumaTotal := sumaTotal(v, i+1) + v[i]
	else
		sumaTotal := v[i];	
end;

{ACTIVIDAD 3: 1. Implemente un módulo recursivo que reciba un vector de 
reales e imprima todos sus valores en el mismo orden en que 
están cargados}
procedure printAscendente(v : vReales; i : integer);
begin
	if (i <= DIMF) then begin
		writeln(v[i]:0:2);
		printAscendente(v, i+1);
	end;
end;

{ACTIVIDAD 3: 2. Implemente un módulo recursivo que reciba un vector de 
reales e imprima todos los valores en orden inverso en el que 
están cargados.}
procedure printDescendente(v : vReales; i : integer);
begin
	if (i >= 1) then begin
		writeln(v[i]:0:2);
		printDescendente(v, i-1);
	end;
end;

{ Implemente una versión recursiva del módulo buscarMinimo 
de la operación merge.}
procedure minimoRecursivo(v : vListas; i : integer; var min : real; var iMin : integer);
begin
	if (i <= CANT) then begin
		if ((not v[i].eol()) AND (v[i].current() <= min)) then begin
			min := v[i].current();
			iMin := i;
		end;
		minimoRecursivo(v, i+1, min, iMin);
	end
	else begin
		if ((iMin <> -1) AND (not v[iMin].eol())) then
			v[iMin].next();
	end;
end;

var
	int, index : integer;
	vector : vReales;
BEGIN
	writeln('Dame un N entero mayor a 0 para hacer la suma de los N primeros enteros');
	readln(int);
	writeln('La suma es de ',sum(int));
	
	randomize;
	for index:=1 to DIMF do
		vector[index] := random()*100;
	index := 1;
	writeln('La suma total del vector es de ',(sumaTotal(vector, index)):0:2);
	
	{Para verificar el orden}
	index := 1;
		for index:=1 to 5 do
			vector[index] := index;
	
	index := 1;
	printAscendente(vector, index);
	writeln('---------------- NUEVA IMPRESIÓN -------------------');
	index := DIMF;
	printDescendente(vector, index);
END.

