program actividadTres;
const
	DIMF = 16;
type
	vEnteros = array [1..DIMF] of integer;


{Modifique los módulos busquedaDicotomica y 
buscarConOrden para que devuelvan la cantidad de 
comparaciones realizadas hasta encontrar (o no) el elemento 
buscado.}
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

{Implemente el módulo buscarConOrden visto en Algoritmos y 
Programación I.}
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

{Modifique el programa para buscar cada uno de los 10 valores 
generados al azar con ambos módulos de búsqueda. Informe 
para cada valor buscado la cantidad de comparaciones 
realizadas por cada uno de los dos módulos de búsqueda.}
var
	vectorBase, vectorValores : vEnteros;
	i, iteraciones, index, encontradoBinario : integer;
	encontradoLineal : boolean;
begin
	randomize;
	for i:=1 to DIMF do begin
		// Generar los arrays de valores, uno estatico y otro con los valores a uscar
		vectorBase[i] := random(50)+1;
		vectorValores[i] := random(50)+1;
	end;
	
	// Ordena el vector y muestra los elementos (opcional, usado para ver los valores esperados)
	ordenarSeleccion(vectorBase);
	i := 1;
	for i:=1 to DIMF do
		write(vectorBase[i], ' | ');
	
	// Reinicia el vector y empieza la busqueda
	i := 1;
	writeln('');
	for i:=1 to DIMF do begin 
		writeln('================== NUEVA ITERACION, BUSCA ',vectorValores[i],' [',i,']==================');
		// Hacer la busqueda del valor de vectorValores en vectorBase
		iteraciones := 0;
		index := 1;
		encontradoBinario := -1;
		encontradoLineal := false;
		busquedaBinaria(vectorBase, vectorValores[i], 1, DIMF, iteraciones, encontradoBinario);
		busquedaLineal(vectorBase, vectorValores[i], index, encontradoLineal);
		
		// Informa si se encontro y en su respectiva posicion
		if (encontradoBinario <> -1) then
			writeln('[ITER. ',iteraciones,' - BIN.]: Encontrado en la pos. ',encontradoBinario)
		else
			writeln('[ITER. ',iteraciones,' - BIN.]: NO encontrado');

		if (encontradoLineal) then
			writeln('[ITER. ',index,' - LIN.]: Encontrado en la pos. ', index)
		else
			writeln('[ITER. ',index,' - LIN.]: NO encontrado');
		
	end;
end.
