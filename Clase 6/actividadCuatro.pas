program actividadTres;
uses
	math;
const
	DIMF = 500;
type
	vEnteros = array [1..DIMF] of integer;
	vBuscar = array [1..100] of integer;

procedure busquedaBinaria(v : vEnteros; buscar, min, max : integer; var iter, result : integer);
var
	medio: integer;
begin
	if (min > max) then
		result := -1
	else begin
		medio := (max+min) div 2;
		if (v[medio] = buscar) then
			result := medio
		else if (v[medio] > buscar) then begin
			iter := iter + 1;
			busquedaBinaria(v, buscar, min, medio - 1, iter, result);
		end
		else begin
			iter := iter + 1;
			busquedaBinaria(v, buscar, medio + 1, max, iter, result);
		end;
	end
end;

procedure busquedaLineal(v : vEnteros; buscar : integer; var i : integer; var found : boolean);
begin
	found := false;
	while ((i <= DIMF) and (not found)) do
		if (v[i] = buscar) then begin
			found := true;
		end
		else 
			i := i + 1;
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


var
	vectorBase : vEnteros;
	vectorValores : vBuscar;
	i, iteraciones, index, cantLineal, encontradoBinario, iterLineal, iterBinario : integer;
	encontradoLineal : boolean;
begin
	randomize;
	for i:=1 to DIMF do
		vectorBase[i] := random(500)+1;

	for i:=1 to 100 do
		vectorValores[i] := random(500)+1;
	
	ordenarSeleccion(vectorBase);

	i := 1;
	writeln('');
	iterLineal := 0;
	iterBinario := 0;
	cantLineal := 0;
	for i:=1 to 100 do begin 
		iteraciones := 0;
		index := 1;
		encontradoBinario := -1;
		encontradoLineal := false;
		busquedaBinaria(vectorBase, vectorValores[i], 1, DIMF, iteraciones, encontradoBinario);
		busquedaLineal(vectorBase, vectorValores[i], index, encontradoLineal);
		
		if (encontradoBinario <> -1) then
			iterBinario := iterBinario + iteraciones;
		if (encontradoLineal) then begin
			iterLineal := iterLineal + index;
			cantLineal := cantLineal + 1;
		end;
	end;
	writeln('PROMEDIO IMPRESIONES LINEAL: ',(iterLineal/cantLineal):0:0);
	writeln('PROMEDIO IMPRESIONES BINARIO: ',log2(iterBinario):0:6);
end.
