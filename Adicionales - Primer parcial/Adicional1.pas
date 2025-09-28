program Adicional1;
uses sysutils, GenericABB, GenericLinkedList;

const
	CANTIDAD_VENDEDORAS = 7;
	CANTIDAD_VENTAS = 50;

type 	
	Venta = record
		numero_vendedora: integer;
		numero_venta: integer;
		codigo_producto: integer;
		precio_unitario: real;
		cantidad_unidades_vendidas: integer;
		fecha_de_venta: string;
	end;
	ListaVentas = specialize LinkedList<Venta>;

	MatrizVentas = array [1..CANTIDAD_VENDEDORAS, 1..CANTIDAD_VENTAS] of Venta;

	CantVentas = record
		fecha : string;
		cantidad : integer;
	end;
	ABBCantVentas = specialize ABB<CantVentas>;

	ProdResumen = record
		codigo : integer;
		totalVendidos : integer;
		montoTotal : real;
	end;
	
	ListaResumen = specialize LinkedList<ProdResumen>;
	VectorPosiciones = array [1..CANTIDAD_VENDEDORAS] of integer;


// Use esta función para obtener la lista de ventas
procedure ObtenerVentas(var lista: ListaVentas);
var i, nValores: integer;
    fecha: TDateTime;
	ven: Venta;
	cVentas: array [1..CANTIDAD_VENDEDORAS] of integer;
	fechas: array [1..CANTIDAD_VENDEDORAS] of TDateTime;

begin
lista:= ListaVentas.create();
	
nValores:= CANTIDAD_VENDEDORAS * CANTIDAD_VENTAS;
for i := 1 to CANTIDAD_VENDEDORAS do
	begin
	cVentas[i]:= 0;
	fechas[i]:= Date - random(120) - 60;
	end;

// Generamos N ventas y las almacenamos en la lista
i:= 1;
while i <= nValores do
	begin
	ven.numero_vendedora:= random(CANTIDAD_VENDEDORAS) + 1;
	if cVentas[ven.numero_vendedora] < CANTIDAD_VENTAS then
		begin
		cVentas[ven.numero_vendedora]:= cVentas[ven.numero_vendedora] + 1;
		ven.numero_venta:= cVentas[ven.numero_vendedora];
		ven.codigo_producto:= random(1000) + 200;
		ven.precio_unitario:= random(100) + 10;
		ven.cantidad_unidades_vendidas:= random(15) + 1;
		fecha:= fechas[ven.numero_vendedora];
		fechas[ven.numero_vendedora]:= fechas[ven.numero_vendedora] + random(3) + 1;
		ven.fecha_de_venta:= FormatDateTime('YYYY/MM/DD',fecha);
		
		i:= i + 1;
		lista.add(ven);
		end;
	end;
end;
//--------------------------------------------------------

{Haga un módulo que recorra la lista de ventas que se dispone y arme una matriz con 
todas las ventas de cada una de las vendedoras. En cada fila se deben almacenar todas 
las ventas de cada vendedora.}
procedure cargarMatriz(var m : MatrizVentas; l : ListaVentas);
begin
	l.reset();
	while (not l.eol()) do begin
		m[l.current().numero_vendedora, l.current().numero_venta] := l.current();
	  	l.next();
	end;
end;

{Haga un módulo que reciba la matriz y retorne un árbol de cantidades de ventas 
ordenada por fecha de venta. Para cada fecha solo se desea almacenar la cantidad de 
ventas. }
procedure agregarVenta(a : ABBCantVentas; v : Venta);
var
	cantAct : CantVentas;
begin
	if (a.isEmpty()) then begin
		cantAct.fecha := v.fecha_de_venta;
		cantAct.cantidad := v.cantidad_unidades_vendidas;
	  	a.insertCurrent(cantAct);
	end
	else if (a.current().fecha = v.fecha_de_venta) then begin
	  	cantAct.fecha := v.fecha_de_venta;
		cantAct.cantidad := cantAct.cantidad + v.cantidad_unidades_vendidas;
		a.setCurrent(cantAct);
	end
	else if (v.fecha_de_venta < a.current().fecha) then
		agregarVenta(a.getLeftChild(), v)
	else
		agregarVenta(a.getRightChild(), v);
end;

procedure cargarArbol(a : ABBCantVentas; m : MatrizVentas);
var
	fil, col : integer;
begin
	for fil:=1 to CANTIDAD_VENDEDORAS do
		for col:=1 to CANTIDAD_VENTAS do begin
			agregarVenta(a, m[fil,col]);
		end;
end;

{Haga un módulo que reciba la matriz y la retorne ordenada. Para cada vendedora 
ordene todas sus ventas por código de producto. }

function ordenarMatriz(m : MatrizVentas) : MatrizVentas;
var
	fil, col, i, p : integer;
	swap : Venta;
begin
	for fil:=1 to CANTIDAD_VENDEDORAS do
		for col:=1 to (CANTIDAD_VENTAS)-1 do begin
			p := col;
			for i:=col+1 to CANTIDAD_VENTAS do
				if (m[fil,i].codigo_producto < m[fil,p].codigo_producto) then
					p := i;
			swap := m[fil,p];
			m[fil,p] := m[fil,col];
			m[fil,col] := swap;
		end;
	ordenarMatriz := m;
end;

{Haga un módulo que reciba las ventas ordenadas y genere un resumen por cada 
producto distinto vendido. Por cada producto se desea saber: cantidad total de 
unidades vendidas y monto total acumulado.}

procedure buscarCodigo(m : MatrizVentas; vPos : VectorPosiciones; var min : integer);
var
	fil : integer;
begin
	min := 9999;
	for fil:=1 to CANTIDAD_VENDEDORAS do begin
	  	if (vPos[fil] <= CANTIDAD_VENTAS) then begin
		  	if (m[fil,vPos[fil]].codigo_producto <= min) then begin
			  	min := m[fil,vPos[fil]].codigo_producto;
			end;
		end;
	end;
end;

procedure acumularVentas(m : MatrizVentas; var l : listaResumen);
var
	resAct : ProdResumen;
	fil, codMin: integer;
	vPos : VectorPosiciones;
begin
	l := listaResumen.create();
	for fil:=1 to CANTIDAD_VENDEDORAS do
		vPos[fil] := 1;
	buscarCodigo(m, vPos, codMin);
	while (codMin <> 9999) do begin
		resAct.codigo := codMin;
		resAct.totalVendidos := 0;
		resAct.montoTotal := 0;
		while (codMin = resAct.codigo) do begin
			for fil:=1 to CANTIDAD_VENDEDORAS do begin
				if ((vPos[fil] <= CANTIDAD_VENTAS) AND (m[fil,vPos[fil]].codigo_producto = resAct.codigo)) then begin
					resAct.totalVendidos := resAct.totalVendidos + m[fil,vPos[fil]].cantidad_unidades_vendidas;
					resAct.montoTotal := resAct.montoTotal + (m[fil,vPos[fil]].precio_unitario * m[fil,vPos[fil]].cantidad_unidades_vendidas);
					vPos[fil] := vPos[fil] + 1;
				end;
			end;
			buscarCodigo(m, vPos, codMin);
		end;
		l.add(resAct);
	end;
end;

procedure mostrarMatriz(m : MatrizVentas);
var 
	fil, col: integer;
begin
	writeln('=== MATRIZ ORDENADA ===');
	for fil := 1 to CANTIDAD_VENDEDORAS do begin
		write('Vendedora ', fil, ': [');
		for col := 1 to CANTIDAD_VENTAS do begin
			write(m[fil,col].codigo_producto);
			if col < CANTIDAD_VENTAS then write(', ');
		end;
		writeln(']');
	end;
	writeln;
end;

procedure mostrarResumen(l : ListaResumen);
var 
	res: ProdResumen;
begin
	writeln('=== RESUMEN POR PRODUCTO ===');
	l.reset();
	while not l.eol() do begin
		res := l.current();
		writeln('Producto ', res.codigo, ': ', res.totalVendidos, ' unidades vendidas, $', res.montoTotal:0:2, ' total');
		l.next();
	end;
	writeln;
end;

{Haga un módulo recursivo que reciba los resúmenes de ventas y devuelva el producto 
con mayor monto acumulado.}
procedure buscarMayor(l : ListaResumen; var ProdMax : ProdResumen);
begin
	if (not l.eol()) then begin
	  	if (l.current().montoTotal > ProdMax.montoTotal) then
			ProdMax := l.current();
		l.next();
		buscarMayor(l, ProdMax); 
	end;
end;

{Haga un módulo que reciba el árbol y devuelva la fecha con mayor cantidad de ventas 
(suponga que solo hay una fecha que cumple esa condición).}
procedure buscarMayorFecha(a : ABBCantVentas; var max : integer; var fec : string);
begin
	if (not a.isEmpty()) then begin
		buscarMayorFecha(a.getLeftChild(), max, fec);
		if (a.current().cantidad > max) then begin
			max := a.current().cantidad;
			fec := a.current().fecha;
		end;
		buscarMayorFecha(a.getRightChild(), max, fec);
	end;
end;

{Haga un módulo que reciba el árbol y devuelva la fecha en que comenzaron las ventas. }
function inicioActividades(a : ABBCantVentas) : string;
begin
	if (a.hasLeftChild()) then
		inicioActividades := inicioActividades(a.getLeftChild())
	else
		inicioActividades := a.current().fecha;
end;

var 
	l: ListaVentas;
	matriz, matOrd : MatrizVentas;
	arbol : ABBCantVentas;
	listaResumida : ListaResumen;
	productoMaximo : ProdResumen;
	cantMax : integer;
	fechaMax : string;
begin
	randomize;

	writeln('Obteniendo lista');
	ObtenerVentas(l);

	cargarMatriz(matriz, l);

	arbol := ABBCantVentas.create();
	cargarArbol(arbol, matriz);

	matOrd := ordenarMatriz(matriz);
	
	writeln('TEST ACUMULACION. MATRIZ ORDENADA:');
	mostrarMatriz(matOrd);
	
	acumularVentas(matOrd, listaResumida);
	mostrarResumen(listaResumida);

	listaResumida.reset();
	productoMaximo := listaResumida.current();
	buscarMayor(listaResumida, productoMaximo);
	writeln('PRODUCTO MAYOR MONTO: ', productoMaximo.codigo, ' CON $', productoMaximo.montoTotal:0:2);

	cantMax := 0;
	fechaMax := '';
	buscarMayorFecha(arbol, cantMax, fechaMax);
	writeln('FECHA CON MAYOR CANTIDAD: ',fechaMax, ' [',cantMax,']');

	writeln('FECHA DE INICIO DE ACTIVIDADES: ',inicioActividades(arbol));
end.
