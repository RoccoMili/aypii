program programaVectores;
type
	vEnteros = array [1..50] of integer;

{Implemente un módulo CargarVector que cree un vector de enteros 
con 50 valores aleatorios. Los valores, generados aleatoriamente (entre 
un mínimo y máximo recibidos por parámetro), deben ser 
almacenados en el vector en el mismo orden que se generaron.}
procedure CargarVector(var v : vEnteros; min, max : integer);
var
	actual, i: integer;
begin
	for i:=1 to 50 do begin
		actual := random(max-min) + min + 1;
		v[i] := actual;
	end;
end;

{Implemente un módulo ImprimirVector que reciba un vector de 
enteros e imprima todos los valores del vector en el mismo orden que 
están almacenados.}
procedure ImprimirVector(v:vEnteros);
var i:integer;
begin
  for i:=1 to 50 do 
    writeln(v[i]);
end;

{Implemente un módulo BuscarElemento que reciba un vector de 
enteros y un valor entero y retorne true si el valor se encuentra en el 
vector y false en caso contrario}
function BuscarElemento (v:vEnteros; n:integer): boolean;
var i:integer;
  encontrado:boolean;
begin
  i := 1;
  encontrado := false;
  while (i <= 50) and not encontrado do begin
    if (v[i] = n) then
      encontrado := true;
    i:=i+1;
  end;
  BuscarElemento := encontrado;
end;

{Escriba el cuerpo principal que invoque a los módulos ya 
implementados para crear el vector generado, mostrar todos sus 
elementos y determinar si un valor leído por teclado se encuentra o no 
en el vector}
var
	rMin, rMax,  valor: integer;
	vector : vEnteros;
begin
	randomize;
	writeln('Dame el rango mínimo');
	readln(rMin);
	writeln('Dame el rango máximo');
	readln(rMax);
	cargarVector(vector, rMin, rMax);
	ImprimirVector(vector);
	writeln('Decime un valor');
	readln(valor);
	BuscarElemento(vector, valor); 
end.
