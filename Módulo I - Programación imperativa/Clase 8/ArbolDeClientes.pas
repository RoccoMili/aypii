program Ejercicio2;
uses GenericABB, GenericLinkedList;

const
	CANTIDAD_CLIENTES = 30;

type 	
	Cliente = record
		nombre, apellido: string;
		DNI: integer;
		categoria: integer;
	end;
	ListaCliente = specialize LinkedList<Cliente>;
	ABBClientes = specialize ABB<Cliente>;
	
function ObtenerClientes: ListaCliente;
var lista: ListaCliente;
	nValores, i, j, swap: integer;
	cli: Cliente;
	indices: array [1..CANTIDAD_CLIENTES] of integer;
	dnis: array [1..CANTIDAD_CLIENTES] of integer = (1234, 1872, 1970, 2345, 3109, 3892, 4520, 4781, 5601, 5905,
	                                                 6254, 6822, 7974, 8145, 9109, 9892, 10520, 10781, 12601, 12905,
	                                                 21834, 21879, 21990, 22745, 23109, 23892, 24520, 24781, 25601, 25905);
	nombres: array [1..CANTIDAD_CLIENTES] of string = ('Maria',   'Jose',    'Wei',    'Yan',   'Ali',     'John',    'David',  'Li',        'Ana',   'Michael',
														'Juan' ,   'Roberto', 'Daniel', 'Luis',  'Carlos',  'Antonio', 'Elena',  'Francisco', 'Peter', 'Fatima',
														'Richard', 'Paul',    'Olga',   'Pedro', 'William', 'Rosa',    'Thomas', 'Jorge',     'Yong',  'Elizabeth');
	apellidos: array [1..CANTIDAD_CLIENTES] of string = ('Gonzalez', 'Gomez',  'Diaz',    'Rodriguez', 'Fernandez', 'Martinez', 'Lopez', 'Gutierrez', 'Hernandez', 'Benitez',
	                                                      'Perez',    'Romero', 'Flores',  'Garcia',    'Sosa',	     'Sanchez',	 'Perez', 'Cortez',    'Quiroga',   'Ruiz',
	                                                      'Ramirez',  'Cruz',   'Estevez', 'Vasquez',   'Zapata',    'Rojas',    'Soto',  'Silva',     'Sepulveda', 'Morales');

begin
lista:= ListaCliente.create();

nValores:= random(CANTIDAD_CLIENTES - 6) + 5;

for i:= 1 to CANTIDAD_CLIENTES do
	indices[i]:= i; 
for i:= 1 to CANTIDAD_CLIENTES do
	begin
	j:= random(CANTIDAD_CLIENTES) + 1;
	swap:= indices[i];
	indices[i]:= indices[j];
	indices[j]:= swap;
	end;
	
for i:= 1 to nValores do
	begin
	cli.DNI:= dnis[indices[i]];
	cli.nombre:= nombres[random(CANTIDAD_CLIENTES) + 1];
	cli.apellido:= apellidos[random(CANTIDAD_CLIENTES) + 1];
	cli.categoria:= random(5) + 1;
	
	lista.add(cli);
	end;
	
ObtenerClientes:= lista;
end;
//--------------------------------------------------------


{Utilice el módulo ObtenerClientes ya implementado por la cátedra para 
obtener una lista de clientes. Implemente un módulo cargarArbol que reciba 
un ABB y lo llene con los clientes de la lista que se dispone. Los clientes 
deberán quedar ordenados por DNI.}
procedure insertarCliente(a : ABBClientes; cli : Cliente);
begin
	if (a.isEmpty()) then
		a.insertCurrent(cli)
	else if (a.current().DNI > cli.DNI) then
		insertarCliente(a.getLeftChild(), cli)
	else
		insertarCliente(a.getRightChild(), cli); 
end;

procedure cargarArbol(a : ABBClientes; l : ListaCliente);
begin
	l.reset();
	while (not l.eol()) do begin
		insertarCliente(a, l.current());
		l.next();
	end;
end;

{Implemente un módulo que reciba un ABB de clientes y un DNI e imprima su 
categoría si es que el cliente existe dentro del árbol.}
function buscarCategoria(a : ABBClientes; dni : integer) : integer;
begin
	if (a.isEmpty()) then
		buscarCategoria := -1
	else if (a.current().dni = dni) then
		buscarCategoria := a.current().categoria
	else if (a.current().dni > dni) then
		buscarCategoria := buscarCategoria(a.getLeftChild(), dni)
	else
		buscarCategoria := buscarCategoria(a.getRightChild(), dni);
end;

{ Implemente un módulo que reciba un ABB de clientes y dos DNI, e imprima 
nombre y apellido de todos los clientes que están dentro del rango formado 
por los dos DNIs recibidos por parámetro.}
procedure printRango(a : ABBClientes; dniInf, dniSup : integer);
begin
	if (not a.isEmpty()) then begin
		if ((a.current().dni >= dniInf) AND (a.current().dni <= dniSup)) then begin
			printRango(a.getLeftChild(), dniInf, dniSup);
			writeln(a.current().nombre,' ',a.current().apellido);
			printRango(a.getRightChild(), dniInf, dniSup);
		end
		else if (a.current().dni > dniSup) then
			printRango(a.getLeftChild(), dniInf, dniSup)
		else
			printRango(a.getRightChild(), dniInf, dniSup);
	end;
end;

{ Implemente un módulo que reciba un ABB de clientes y una categoría, e 
imprima todos los datos de los clientes que tienen dicha categoría.}
procedure printCategoria(a : ABBClientes; cat : integer);
begin
	if (not a.isEmpty()) then begin
	  	printCategoria(a.getLeftChild(), cat);
		if (a.current().categoria = cat) then begin
			writeln(a.current().nombre, ' ', a.current().apellido, '(',a.current().dni,')');
		end;
		printCategoria(a.getRightChild(), cat);
	end;
end;

{Escriba un programa que instancie un ABB de clientes e invoque a los cuatro 
módulos implementados}
var 
	l : ListaCliente;
	arbol : ABBClientes;
	dniBuscar, dniBuscar2, catBuscar : integer;
begin
	randomize;

	writeln('Obteniendo lista');
	l := ObtenerClientes();

	arbol := ABBClientes.create();
	cargarArbol(arbol, l);

	writeln('Inserta un DNI para buscar la categoria del cliente:');
	readln(dniBuscar);
	if (buscarCategoria(arbol, dniBuscar)) then
		writeln('El DNI ',dniBuscar,' esta en el arbol');
	else
		writeln('El DNI ',dniBuscar,' NO esta en el arbol');

	writeln('Ingresa un DNI bajo para buscar dentro del rango');
	readln(dniBuscar);
	writeln('Ingresa un DNI alto para buscar dentro del rango');
	readln(dniBuscar2);
	printRango(arbol, dniBuscar, dniBuscar2);
	
	writeln('Ingresa una categoria para imprimir:');
	readln(catBuscar);
	printCategoria(arbol, catBuscar);
end.
