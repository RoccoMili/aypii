program implementarBusqueda;
const
	DIMF = 10;
type
	vEnteros = array [1..DIMF] of integer;

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

{Modifique la actividad anterior para generar 10 números al azar 
y buscarlos dentro del vector. Contabilice cuántas veces se 
encontró el número generado y cuántas veces no se encontró.}

var
	vector : vEnteros;
	i, num, result : integer;
	esta : integer;
begin
	randomize;
	for i:=1 to DIMF do
		vector[i] := random(20)+1;

	ordenarSeleccion(vector);

	esta := 0;
	for i:=1 to 10 do begin
		writeln('ITERACION N°',i);
		num := random (20)+1 ;
		result := busquedaBinaria(vector, num, 1, DIMF);
		if (result = -1) then
			writeln('El numero buscado NO esta en el vector');
		else begin
			writeln('Numero encontrado en la pos. ',result);
			esta := esta + 1;
		end;
	end;
	writeln('');
	writeln('=============== RESULTADOS ===============');
	writeln('[ENCONTRADOS]: ',esta);
	writeln('[NO ENCONTRADOS]: ',(10-esta));
end.

