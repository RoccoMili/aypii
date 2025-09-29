program Adicional3;
uses SysUtils, GenericABB, GenericLinkedList;

const
	CANTIDAD_FILAS = 80;
	CANTIDAD_BUTACAS = 100;
	CANTIDAD_OBRAS = 20;

type 	
	EntradaVendida = record
		fecha: string;
		nombre_obra: string;
		fila, butaca: integer;
		dni_espectador: integer;
	end;
	ListaEntradasVendidas = specialize LinkedList<EntradaVendida>;

	DatoButaca = record
		cantidad : integer;
		lista : ListaEntradasVendidas;
	end;
	MatrizButacas = array [1..CANTIDAD_FILAS, 1..CANTIDAD_BUTACAS] of DatoButaca;
 
	DatoObra = record
		nombre_obra : string;
		entradas : ListaEntradasVendidas;
	end;
	ABBObras = specialize ABB<DatoObra>;

// Use esta función para obtener la lista de entradas vendidas
procedure ObtenerEntradasVendidas(var lista: ListaEntradasVendidas);
var i, nValores, dia: integer;
	sdia: string;
	enVen: EntradaVendida;
	obras: array [1..CANTIDAD_OBRAS] of string = ('Romeo y Julieta', 'Hamlet', 'Don Juan Tenorio', 'El fantasma de la opera', 'La Celestina',
	                                              'Casa de muñecas', 'Un tranvia llamado deseo', 'La gaviota', 'Bodas de sangre', 'Las troyanas',
	                                              'Guillermo Tell', 'Antigona', 'Los miserables', 'La divina comedia', 'La casa de Bernarda Alba',
	                                              'Fuente Ovejuna', 'Las aves', 'El burlador de Sevilla', 'Tres sombreros de copa', 'La venganza de Don Mendo');

begin
lista:= ListaEntradasVendidas.create();

nValores:= random(1000) + 200;

// Generamos N ventas de entradas y las almacenamos en la lista
for i:= 1 to nValores do
	begin
	dia:= random(30)+1;
	sdia:= IntToStr(dia);
	if dia < 10 then
		sdia:= '0' + sdia;
	enVen.fecha:= '2023-09-' + sdia;
		
	enVen.nombre_obra:= obras[random(CANTIDAD_OBRAS) + 1];
		
	enVen.fila:= random(CANTIDAD_FILAS) + 1;
	enVen.butaca:= random(CANTIDAD_BUTACAS) + 1;
	enVen.dni_espectador:= random(20000) + 300;

	lista.add(enVen);
	end;
end;
//--------------------------------------------------------

{Haga un módulo que procese la lista de ventas que se dispone y las almacene en una 
estructura de datos conveniente para resolver el objetivo y retorne dicha estructura de 
datos.}

// Este módulo va a servir para el punto 3
procedure iniciarMatriz(var m : MatrizButacas);
var
	fil, col : integer;
begin
	for fil:=1 to CANTIDAD_FILAS do
		for col:=1 to CANTIDAD_BUTACAS do begin
			m[fil,col].cantidad := 0; 
			m[fil,col].lista := ListaEntradasVendidas.create();
		end;
end;

procedure llenarMatriz(var m : MatrizButacas; l : ListaEntradasVendidas);
begin
	iniciarMatriz(m);
	l.reset();
	while (not l.eol()) do begin
		m[l.current().fila, l.current().butaca].cantidad := m[l.current().fila, l.current().butaca].cantidad + 1;
		m[l.current().fila, l.current().butaca].lista.add(l.current()); // Acá duplica los campos de fila y butaca, 
		l.next();                                                       //  por simplicidad lo vamos a dejar así.
	end;
end;

{Haga un módulo recursivo que reciba la estructura de datos retornada en el punto 1 y 
devuelva la ubicación más vendida.}
procedure masVendida(m : MatrizButacas; fil, col : integer; var butacaMax : DatoButaca);
begin
	if ((col < CANTIDAD_BUTACAS) AND (fil < CANTIDAD_FILAS)) then begin
	  	if (m[fil,col].cantidad > butacaMax.cantidad) then
			butacaMax := m[fil,col];
		masVendida(m, fil, col+1, butacaMax);
	end
	else if ((col = CANTIDAD_BUTACAS) AND (fil < CANTIDAD_FILAS)) then begin
	  	if (m[fil,col].cantidad > butacaMax.cantidad) then
			butacaMax := m[fil,col];
		col := 1;
		masVendida(m, fil+1, col, butacaMax);
	end
	else if ((col < CANTIDAD_BUTACAS) AND (fil = CANTIDAD_FILAS)) then begin
	  	if (m[fil,col].cantidad > butacaMax.cantidad) then
			butacaMax := m[fil,col];
		masVendida(m, fil, col+1, butacaMax);
	end
	else if ((col = CANTIDAD_BUTACAS) AND (fil = CANTIDAD_FILAS)) then begin
	  	if (m[fil,col].cantidad > butacaMax.cantidad) then
			butacaMax := m[fil,col];
		// En vez de guardar los datos de fila y columna más vendida, simplemente busca cuál esos datos en
		// la primer venta. Justamente, si tiene ventas, es porque es la más vendida.
		butacaMax.lista.reset();
		writeln('La butaca mas vendida fue la de la fila ',butacaMax.lista.current().fila, ', butaca #',butacaMax.lista.current().butaca, ' con un total de ',butacaMax.cantidad);
	end;
end;

{Haga un módulo que reciba la estructura de datos retornada en el punto 1 y devuelva 
la cantidad de ubicaciones que no tienen entradas vendidas. }
function sinVentas(m : MatrizButacas) : integer;
var
	fil, col : integer;
begin
	sinVentas := 0;
	for fil:=1 to CANTIDAD_FILAS do
		for col:=1 to CANTIDAD_BUTACAS do begin
			if (m[fil,col].cantidad = 0) then
				sinVentas := sinVentas + 1;
		end;
end;

{Haga un módulo que procese la lista de ventas que se dispone, las almacene en una 
estructura de datos y que la retorne. Dicha estructura debe permitir la búsqueda 
eficiente por nombre de obra. Para cada obra se desea almacenar todas las entradas 
vendidas (fecha, ubicación y DNI del comprador). }

{ Para el inciso 3, elegí hacer un record que guarde el nombre y duplique la entrada
  en una lista. Podría, teóricamente, haber hecho un árbol de listas, y que sólo vaya
  añadiendo las ventas en tanto (l.current().nombre_obra = a.current().nombre_obra),
  pero para evitar posibles errores decidí hacer esto, aunque más ineficiente }
procedure agregarVenta(a : ABBObras; v : EntradaVendida);
var
	obraAct : DatoObra;
begin
	if (a.isEmpty()) then begin
		obraAct.nombre_obra := v.nombre_obra;
		obraAct.entradas := ListaEntradasVendidas.create();
		obraAct.entradas.add(v);    // Como antes, acá duplicamos el dato nombre_entrada
	  	a.insertCurrent(obraAct);   // pero de lo contrario habría que armar un record acotado
	end
	else if (a.current().nombre_obra = v.nombre_obra) then
		a.current().entradas.add(v)
	else if (a.current().nombre_obra > v.nombre_obra) then
		agregarVenta(a.getLeftChild(), v)
	else
		agregarVenta(a.getRightChild(), v);
end;

procedure cargarArbol(a : ABBObras; l : ListaEntradasVendidas);
begin
	l.reset();
	while (not l.eol()) do begin
	  	agregarVenta(a, l.current());
		l.next();
	end;
end;

{Haga un módulo que reciba la estructura de datos retornada en el punto 4 y un DNI y 
que devuelva la cantidad de veces que asistió el espectador con dicho DNI. Nota: un 
espectador pudo haber asistido más de una vez a la misma obra. }
procedure buscarAsistencias(a : ABBObras; dni : integer; var cont : integer);
begin
	if (not a.isEmpty()) then begin
	  	buscarAsistencias(a.getLeftChild(), dni, cont);

		a.current().entradas.reset();
		while (not a.current().entradas.eol()) do begin
			if (a.current().entradas.current().dni_espectador = dni) then
				cont := cont + 1;
		  	a.current().entradas.next();
		end;

		buscarAsistencias(a.getRightChild(), dni, cont);
	end;
end;

{Haga un módulo que reciba la estructura de datos retornada en el punto 4 y dos DNI, e 
imprima las fechas de las obras de todos los espectadores cuyo DNI se encuentra entre 
los dos DNIs recibidos. }

{ Es la consigna menos clara del universo, pero esto imprime las fechas (y obras)
  a las que fueron las personas entre esos DNIs }
procedure printEntreDNIs(a : ABBObras; dniInf, dniSup : integer);
begin
	if (not a.isEmpty()) then begin
	  	printEntreDNIs(a.getLeftChild(), dniInf, dniSup);

		a.current().entradas.reset();
		while (not a.current().entradas.eol()) do begin
		  	if ((a.current().entradas.current().dni_espectador >= dniInf) AND (a.current().entradas.current().dni_espectador <= dniSup)) then
				writeln('[',a.current().entradas.current().fecha,'] ',a.current().nombre_obra, ' (',a.current().entradas.current().dni_espectador,')');
			a.current().entradas.next();
		end;

		printEntreDNIs(a.getRightChild(), dniInf, dniSup);
	end;
end;

{Haga un módulo que reciba el nombre de una obra y que devuelva la cantidad de 
espectadores (cero si nadie fue a verla). }
function espectadoresObra(a : ABBObras; obra : string) : integer;
var
	cont : integer;
begin
	if (a.isEmpty()) then
		espectadoresObra := 0
	else if (a.current().nombre_obra = obra) then begin
		cont := 0;
		a.current().entradas.reset();
		while (not a.current().entradas.eol()) do begin
			cont := cont + 1;
			a.current().entradas.next();
		end;
		espectadoresObra := cont;
	end
	else if (a.current().nombre_obra > obra) then
		espectadoresObra := espectadoresObra(a.getLeftChild(), obra)
	else
		espectadoresObra := espectadoresObra(a.getRightChild(), obra);
end;

var 
	l: ListaEntradasVendidas;
	matriz : MatrizButacas;
	filInicial, colInicial : integer;
	butacaMaxima : DatoButaca;
	arbol : ABBObras;
	dniBuscar1, contador : integer;
	dniBuscar2 : integer;
	obraBuscar : string;
begin
	randomize;

	writeln('Obteniendo lista');
	ObtenerEntradasVendidas(l);

	writeln('Llenando matriz');
	llenarMatriz(matriz, l);

	filInicial := 1; colInicial := 1;
	butacaMaxima.cantidad := 0;
    { DISCLAIMER: SE SUPONE QUE ACÁ VA EL LLAMADO A MASVENDIDA,
	  SIN EMBARGO EL HECHO DE QUE SEA RECURSIVA HACE UN
	  STACKOVERFLOW AL MANEJAR 8000 CASOS, POR LO TANTO
	  NO FUNCIONA DE ESTA FORMA, PERO FUNCIONA EN LA TEORÍA }
	// masVendida(matriz, filInicial, colInicial, butacaMaxima);

	writeln('Hay un total de ',sinVentas(matriz), ' butacas sin ventas');

	arbol := ABBObras.create();
	cargarArbol(arbol, l);

	writeln('Ingresa un DNI a buscar:');
	readln(dniBuscar1);
	contador := 0;
	buscarAsistencias(arbol, dniBuscar1, contador);
	writeln('El DNI ',dniBuscar1,' asistio a un total de ',contador,' peliculas');

	writeln('Ingresa un DNI como limite INFERIOR para buscar las fechas de las obras a las que fue(ron)');
	readln(dniBuscar1);
	writeln('Ingresa un DNI como limite SUPERIOR para buscar las fechas de las obras a las que fue(ron)');
	readln(dniBuscar2);
	printEntreDNIs(arbol, dniBuscar1, dniBuscar2);

	writeln('Ingresa el nombre de una obra para buscar la cantidad de espectadores:');
	readln(obraBuscar);
	writeln('La obra ',obraBuscar,' tuvo un total de ',espectadoresObra(arbol, obraBuscar),' espectadores');
end.
