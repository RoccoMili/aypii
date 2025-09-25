program ListaDePrecios;
uses GenericABB, GenericLinkedList;

const
	CANTIDAD_PRODUCTOS = 30;

type 	
    // Tipos de datos a usar en la activdad 3, 4, 5 y 6
	Producto = record
		descripcion: string;
		codigo: integer;
		precio: real;
	end;
	ListaProducto = specialize LinkedList<Producto>;
	//------------------------------------------------------------------
	
	// Registro a usar en la activdad 4 y 6
	ProductoAComprar = record
		codigo: integer;
		cantidad: integer;
	end;
	ListaCompra = specialize LinkedList<ProductoAComprar>;
	//------------------------------------------------------------------
	
	// Uso interno del módulo que genera las listas
	VectorCodigos = array [1..CANTIDAD_PRODUCTOS] of integer;
	//------------------------------------------------------------------

	ABBProductos = specialize ABB<Producto>;

// Use este módulo para obtener la lista de precios que se "dispone" para las actividades 3, 4, 5 y 6
procedure ObtenerListaDePrecios(var lista: ListaProducto; var codigos: VectorCodigos; var nValores: integer);
var i, j, swap: integer;
	swap_s: string;
	prod: Producto;
	codigos_db: array [1..CANTIDAD_PRODUCTOS] of integer = (1234, 1872, 1970, 2345, 3109, 3892, 4520, 4781, 5601, 5905,
	                                                 6254, 6822, 7974, 8145, 9109, 9892, 10520, 10781, 12601, 12905,
	                                                 21834, 21879, 21990, 22745, 23109, 23892, 24520, 24781, 25601, 25905);
	descripciones_db: array [1..CANTIDAD_PRODUCTOS] of string = ('Musculosa',   'Pelota de basquet',    'Paleta',    'Mancuerna',   'Guante',     'Remera',    'Remo',  'Red',        'Casco',   'Botines',
														'Aro de basquet' ,   'Bicicleta', 'Palo de hockey', 'Pelota de futbol',  'Mesa de ping pong',  'Kayak', 'Rodillera',  'Protector bucal', 'Raqueta', 'Colchoneta',
														'Cronometro', 'Botella',    'Banda elastica',   'Caña de pescar', 'Cono plastico', 'Canillera',    'Rollers', 'Bate',     'Antiparra',  'Gorra');

begin
lista:= ListaProducto.create();

nValores:= random(CANTIDAD_PRODUCTOS - 6) + 5;	//Nos aseguramos un mínimo de 5 productos

// Copiamos los códigos al vector pasado por parámetro. Este vector luego será meclado al azar.
// Los códigos que se agreguen a la lista que se dispone serán tomados secuencialmente de este vector.
// De esta manera garantizamos que no haya códigos repetidos en la lista que se dispone.
for i:= 1 to CANTIDAD_PRODUCTOS do
	codigos[i]:= codigos_db[i];
// Mezclamos los códigos y las descripciones al azar.
// Los valores serán tomados de manera secuencial comenzando por el primer elemento.
for i:= 1 to CANTIDAD_PRODUCTOS do
	begin
	j:= random(CANTIDAD_PRODUCTOS) + 1;
	swap:= codigos[i];
	codigos[i]:= codigos[j];
	codigos[j]:= swap;
	
	j:= random(CANTIDAD_PRODUCTOS) + 1;
	swap_s:= descripciones_db[i];
	descripciones_db[i]:= descripciones_db[j];
	descripciones_db[j]:= swap_s;
	end;
	
// Generamos N productos y lo almacenamos en la lista
for i:= 1 to nValores do
	begin
	prod.codigo:= codigos[i];
	prod.descripcion:= descripciones_db[i];
	prod.precio:= (random(10000) + 2000) / 100;
	
	lista.add(prod);
	end;
end;
//----------------------------------------------------------------------

// Utilice este módulo para obtener la lista de compras que se "dispone" para la actividad 4 y 6
procedure ObtenerListaDeCompra(var lista: ListaCompra; codigos: VectorCodigos; nValores: integer);
var prod: ProductoAComprar;
	i: integer;
begin
lista:= ListaCompra.create();

nValores:= random(nValores - 4) + 3;	//Nos aseguramos un mínimo de 3 productos

for i:= 1 to nValores do
	begin
	// Se usa el vector codigos generado por el procedimiento ObtenerListaDePrecios.
	// Esto se hace para asegurarse de generar una lista de compras con productos existentes.
	prod.codigo:= codigos[i];
	prod.cantidad:= random(15) + 1;
	
	lista.add(prod);
	end;
end;
//--------------------------------------------------------

{ Utilice el módulo ObtenerListaDePrecios ya implementado por la cátedra 
para obtener una lista de productos. A partir de dicha lista arme un ABB 
con todos los productos que vende el local, ordenado por código único del 
producto.}
procedure insertarProducto(a : ABBProductos; prod : Producto);
begin
	if (a.isEmpty()) then
		a.insertCurrent(prod)
	else if (a.current().codigo > prod.codigo) then
		insertarProducto(a.getLeftChild(), prod)
	else
		insertarProducto(a.getRightChild(), prod);
end;

procedure cargarArbol(a : ABBProductos; l : ListaProducto);
begin
	l.reset();
	while (not l.eol()) do begin
		insertarProducto(a, l.current());
		l.next();
	end;
end;

{Implemente un módulo que reciba un ABB de productos y un código 
único e informe el precio del producto si es que el producto existe dentro 
del árbol. }
function buscarPrecio(a : ABBProductos; cod : integer) : real;
begin
	if (a.isEmpty()) then
		buscarPrecio := -1
	else if (a.current().codigo = cod) then
		buscarPrecio := a.current().precio
	else if (a.current().codigo > cod) then
		buscarPrecio := buscarPrecio(a.getLeftChild(), cod)
	else
		buscarPrecio := buscarPrecio(a.getRightChild(), cod);
end;

{Implemente un módulo que reciba un ABB de productos e imprima la 
descripción del producto más barato y del más caro.}
procedure iterarComparar(a : ABBProductos; var min, max : Producto);
begin
	if (not a.isEmpty()) then begin
		iterarComparar(a.getLeftChild(), min, max);
		if (a.current().precio < min.precio) then
			min := a.current();
		if (a.current().precio > max.precio) then
			max := a.current();
		iterarComparar(a.getRightChild(), min, max);
	end;
end;

procedure printExtremos(a : ABBProductos);
var
	min, max : Producto;
begin
	min.precio := 32767; min.codigo := -1; min.descripcion := '';
	max.precio := -32766; max.codigo := -1; max.descripcion := '';
	iterarComparar(a, min, max);
	writeln('[MINIMO]: ',min.descripcion);
	writeln('[MAXIMO]: ',max.descripcion);
end;

var // Variable a utilizar en la actividad 3, 4, 5 y 6
    lp: ListaProducto;
    //------------------------------------------------------------------

	// Variables a utilizar en la actividad 4 y 6
	lc: ListaCompra;
	indices_codigos: VectorCodigos;
	cantidadProductosGenerados: integer;
	//------------------------------------------------------------------
	arbol : ABBProductos;
	codBuscar : integer;
begin
	randomize;

// Lista a utilizar en la actividad 3, 4, 5 y 6
	writeln('Obteniendo lista de precios');
	ObtenerListaDePrecios(lp, indices_codigos, cantidadProductosGenerados);
//------------------------------------------------------------------
	arbol := ABBProductos.create();
	cargarArbol(arbol, lp);

	writeln('Ingresa un codigo para buscar:');
	readln(codBuscar);
	if (buscarPrecio(arbol, codBuscar) <> -1) then
		writeln('El precio del item con el codigo ',codBuscar,' es de ',buscarPrecio(arbol, codBuscar):0:2)
	else 
		writeln('No existe un item con ese codigo');

	printExtremos(arbol);
// Lista a utilizar en la actividad 4 y 6
	writeln('Obteniendo lista de compras');
	ObtenerListaDeCompra(lc, indices_codigos, cantidadProductosGenerados);
//------------------------------------------------------------------
end.
