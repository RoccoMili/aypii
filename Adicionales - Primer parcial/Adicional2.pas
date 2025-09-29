program Adicional2;
uses GenericABB, GenericLinkedList;
const
	CANTIDAD_SUCURSALES = 9;

type 	
	RegistroAnual = record
		codigo_sucursal: integer;
		anio: integer;
		codigo_cliente: integer;
		monto_total: real;
	end;
	ListaRegistrosAnuales = specialize LinkedList<RegistroAnual>;

	ABBRegistros = specialize ABB<RegistroAnual>;
	MatrizMontos = array [101..109, 2020..2024] of real;
	Maximo = record
		cod : integer;
		anio : integer;
		total : real;
	end;
	VectorMaximos = array [101..109] of Maximo;
// Use esta función para obtener la lista de registros anuales
procedure ObtenerRegistrosAnuales(var lista: ListaRegistrosAnuales);
var i, finalizados: integer;
	regan: RegistroAnual;
	anios: array [101..(CANTIDAD_SUCURSALES+100)] of integer;

begin
lista:= ListaRegistrosAnuales.create();

for i := 101 to CANTIDAD_SUCURSALES+100 do
	begin
	anios[i]:= 2020 + random(5);
	end;

// Generamos N registros anuales
finalizados:= 0;
while finalizados < CANTIDAD_SUCURSALES do
	begin
	regan.codigo_sucursal:= random(CANTIDAD_SUCURSALES) + 101;

	if anios[regan.codigo_sucursal] < 2025 then
		begin
		regan.anio:= anios[regan.codigo_sucursal];
		anios[regan.codigo_sucursal]:= anios[regan.codigo_sucursal] + 1;
		if anios[regan.codigo_sucursal] = 2025 then
			finalizados:= finalizados + 1;
		
		regan.codigo_cliente:= random(50) + 2500;
		regan.monto_total:= random(10000) + 1000;
				
		lista.add(regan);
		end;
	end;
end;
//--------------------------------------------------------

{Haga un módulo que procese la lista de registros anuales que se dispone y que cargue 
en un árbol los registros ordenados por código de cliente. }
procedure agregarRegistro(a : ABBRegistros; reg : RegistroAnual);
begin
	if (a.isEmpty()) then
	  	a.insertCurrent(reg)
	else if (reg.codigo_cliente < a.current().codigo_cliente) then
		agregarRegistro(a.getLeftChild(), reg)
	else
		agregarRegistro(a.getRightChild(), reg);
end;

procedure cargarArbol(a : ABBRegistros; l : ListaRegistrosAnuales);
begin
	l.reset();
	while (not l.eol()) do begin
		agregarRegistro(a, l.current());
	  	l.next();
	end;
end;

{ Haga un módulo que reciba el árbol y que contabilice en una matriz el monto total 
gastado por todos los clientes para cada sucursal (101..109) y para el período 
2020..2024.}
procedure acumularMatriz(a : ABBRegistros; var m : MatrizMontos);
begin
	if (not a.isEmpty()) then begin
		acumularMatriz(a.getLeftChild(), m);
		m[a.current().codigo_sucursal, a.current().anio] := m[a.current().codigo_sucursal, a.current().anio] + a.current().monto_total;
		acumularMatriz(a.getRightChild(), m);
	end;
end;

procedure cargarMatriz(a : ABBRegistros; var m : MatrizMontos);
var
	fil, col : integer;
begin
	for fil:=101 to 109 do
		for col:=2020 to 2024 do
			m[fil,col] := 0;
	acumularMatriz(a, m);
end;

{Haga un módulo recursivo que reciba la matriz y un código de sucursal y que devuelva 
el año con mayor facturación, junto con el monto facturado. }
procedure mayorFacturacion(m : MatrizMontos; cod, i : integer; var anioMax : integer; var montoMax : real);
begin
	if (i <= 2024) then begin
		if (m[cod,i] > montoMax) then begin
		  	anioMax := i;
			montoMax := m[cod,i];
		end;
		mayorFacturacion(m, cod, i+1, anioMax, montoMax);
	end;
end;

{Haga un módulo que reciba la matriz y retorne en un vector los años y monto 
facturado con mayor facturación de cada una de las sucursales. Nota: este módulo 
debe invocar el módulo implementado en el punto 3.}
procedure maximosSucursales(m : MatrizMontos; var v : VectorMaximos);
var
	suc, index, anioAct : integer;
	montoAct : real;
begin
	for suc:=101 to 109 do begin
	 	index := 2020;
		anioAct := -1;
		montoAct := -1;
		mayorFacturacion(m, suc, index, anioAct, montoAct);
		v[suc].cod := suc;
		v[suc].anio := anioAct;
		v[suc].total := montoAct;
	end;
	for suc:=101 to 109 do begin
	  	writeln('[SUC. ',suc,']: $',(v[suc].total):0:2,' EN ',v[suc].anio);
	end;
end;

{Haga un módulo que reciba el vector y lo imprima ordenado de menor a mayor por 
monto facturado. Nota: preste atención qué pasa con los códigos de sucursal al 
ordenar el vector.}
procedure ordenarMontos(var v : VectorMaximos);
var
	i, j, p : integer;
	swap : Maximo;
begin
	for i:=101 to 109-1 do begin
		p := i;
		for j:=i+1 to 109 do
			if (v[j].total < v[p].total) then
				p := j;
		swap := v[p];
		v[p] := v[i];
		v[i] := swap;
	end;
	for i:=101 to 109 do begin
		writeln('[SUC. ',v[i].cod,'] RECAUDO UN TOTAL DE $',(v[i].total):0:2,' EN ',v[i].anio);
	end;
end;

function sumarCliente(a : ABBRegistros; codigo : integer) : integer;
begin
	if (a.isEmpty()) then
		sumarCliente := 0
	else if (a.current().codigo_cliente = codigo) then
		sumarCliente := sumarCliente(a.getRightChild(), codigo) + 1
	else if (codigo < a.current().codigo_cliente) then
		sumarCliente := sumarCliente(a.getLeftChild(), codigo)
	else
		sumarCliente := sumarCliente(a.getRightChild(), codigo);
end;

{Haga un módulo que reciba el árbol y dos códigos de clientes e imprima toda la 
información de los registros anuales para todos los clientes cuyo código de cliente se 
encuentre entre los dos códigos recibidos. }
procedure imprimirEntre(a : ABBRegistros; codInf, codSup : integer);
begin
	if (not a.isEmpty()) then begin
	  	if ((a.current().codigo_cliente >= codInf) AND (a.current().codigo_cliente <= codSup)) then begin
		  	imprimirEntre(a.getLeftChild(), codInf, codSup);
			writeln('[SUC. ',a.current().codigo_sucursal,' - ',a.current().anio,'] CLIENTE #',a.current().codigo_cliente, ' CON UN TOTAL DE $',(a.current().monto_total):0:2);
			imprimirEntre(a.getRightChild(), codInf, codSup);
		end
		else if (a.current().codigo_cliente > codSup) then
			imprimirEntre(a.getLeftChild(), codInf, codSup)
		else
			imprimirEntre(a.getRightChild(), codInf, codSup);
	end;
end;

var 
	l : ListaRegistrosAnuales;
	arbol : ABBRegistros;
	matriz : MatrizMontos;
	vector : VectorMaximos;
	codigoBuscar1, codigoBuscar2 : integer;
begin
	randomize;

	writeln('Obteniendo lista');
	ObtenerRegistrosAnuales(l);

	arbol := ABBRegistros.create();

	cargarArbol(arbol, l);
	cargarMatriz(arbol, matriz);
	maximosSucursales(matriz, vector);
	ordenarMontos(vector);

	writeln('Inserta un codigo de cliente para buscar cuanto aparece:');
	readln(codigoBuscar1);
	writeln('El cliente con el codigo ',codigoBuscar1,' aparece un total de ',sumarCliente(arbol, codigoBuscar1),' veces');

	writeln('Inserta un codigo de cliente como limite INFERIOR para imprimir:');
	readln(codigoBuscar1);
	writeln('Inserta un codigo de cliente como limite SUPERIOR para imprimir:');
	readln(codigoBuscar2);
	imprimirEntre(arbol, codigoBuscar1, codigoBuscar2);
end.
