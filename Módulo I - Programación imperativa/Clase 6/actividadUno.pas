program implementarBusqueda;
const
	DIMF = 10;
type
	vEnteros = array [1..DIMF] of integer;

{ 1. Implemente el módulo busquedaDicotomica.}
function busquedaBinaria(v : vEnteros; buscar, min, max : integer) : integer;
var
	medio : integer;
begin
	if min > max then
		busquedaBinaria := -1
	else begin
		medio := (max+min) div 2;
		if (v[medio] = buscar) then
			busquedaBinaria := medio
		else if v[medio] > buscar then
			busquedaBinaria := busquedaBinaria(v, buscar, min, medio - 1)
		else
			busquedaBinaria := busquedaBinaria(v, buscar, medio + 1, max);
	end;
end;

{Implemente el módulo OrdenarPorSeleccion visto en 
Algoritmos y Programación I.}
procedure ordenarSeleccion(var v : vEnteros);
var
	i, j, p, elem : integer;
begin
	for i:=1 to DIMF-1 do begin
		p := i;
		for j:=i+1 to DIMF do
			if (v[j] < v[p]) then
				p := j;
		elem := v[p];
		v[p] := v[i];
		v[i] := elem;
	end;
end;

{Haga un programa que cargue un vector de 10 enteros, que lo 
ordene de menor a mayor, que lea un número por teclado y que 
imprima si dicho número se encuentra o no en el vector}
var
	vector : vEnteros;
	i, num, result : integer;
begin
	randomize;
	for i:=1 to DIMF do
		vector[i] := random(20)+1;
	ordenarSeleccion(vector);
	writeln('Ingresa un numero para buscar, del 1 al 20');
	readln(num);
	result := busquedaBinaria(vector, num, 1, DIMF);
	if (result = -1) then
		writeln('El numero buscado NO esta en el vector')
	else begin
		writeln('Se encontro el numero en la posicion ',result);
	end;
end.

