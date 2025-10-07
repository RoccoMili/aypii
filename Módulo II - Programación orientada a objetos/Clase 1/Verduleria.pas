program Verduleria2y3;
uses GenericLinkedList, UDateTime, URandomGenerator , UBalanza;
type
	producto = record
		nombre : string;
		peso : real;
	end;
	listaProducto = specialize LinkedList<producto>;
	carrito = record
		cant : integer;
		lista : listaProducto;
	end;
	ticketCompra = record
		dia : Date;
		hora : Time;
		cliente : string;
		monto : real;
		productos : listaProducto;
	end;
	
procedure cargarCarrito(var car : carrito; verd : RandomGenerator);
var
	rg : RandomGenerator;
	prodAct : producto;
	i : integer;
begin
	rg := RandomGenerator.create();
	car.cant := rg.getInteger(1, 20);
	car.lista := listaProducto.create();
	for i:=1 to car.cant do begin
		prodAct.nombre := verd.getLabel();
		prodAct.peso := rg.getReal(0.1, 5);
		car.lista.add(prodAct);
	end;
end;

procedure printCarrito(l : listaProducto);
begin
	l.reset();
	while (not l.eol()) do begin
		writeln(l.current().nombre,' : ',(l.current().peso):0:2,'kg');
		l.next();
	end;
end;

{Implemente un módulo que pase todos los productos del carrito
(información recolectada en el módulo CargarCarrito) por la balanza y
calcule el total a pagar. Los precios por kilo de cada producto puede ser
elegido al azar.
Este módulo debe generar un ticket de compra con la siguiente
información:
○ hora y dia (al azar entre el 1/9/2024 y el 30/9/2024)
○ nombre del cliente (un string al azar)
○ monto total a pagar (calculado con la balanza)
○ nombre de los productos comprados y sus respectivos pesos
(información generada en el módulo CargarCarrito).}

procedure pesarCarrito(car : carrito; bal : balanza; var ticket : ticketCompra);
var
	rg : RandomGenerator;
	fechaMin, fechaMax : Date;
	horaMin, horaMax : Time;
begin
	rg := RandomGenerator.create();
	fechaMin := Date.create(1, 9, 2024);
	fechaMax := Date.create(30, 9, 2024);
	horaMin := Time.create(0, 0, 0);
	horaMax := Time.create(23, 59, 59);
	bal.limpiar();
	car.lista.reset();
	while (not car.lista.eol()) do begin
		bal.setPrecioPorKilo(rg.getReal(250, 2000));
		bal.pesar(car.lista.current().peso);
		car.lista.next();
	end;
	
	ticket.dia := rg.getDate(fechaMin, fechaMax);
	ticket.hora := rg.getTime(horaMin, horaMax);
	ticket.cliente := rg.getString(6);
	ticket.monto := bal.getTotalAPagar();
	ticket.productos := car.lista;
end;

{Implemente un módulo que reciba un ticket de compra e imprima por
consola toda su información.}
procedure printTicket(ticket : ticketCompra);
begin
	writeln('====== IMPRIMIENDO TICKET ======');
	writeln('[CLIENTE]: ',ticket.cliente);
	writeln('[FECHA/HORA]: ',ticket.dia.toString(), ' - ',ticket.hora.toString());
	writeln('[MONTO]: ',ticket.monto:0:2);
	writeln('[PRODUCTOS]:');
	printCarrito(ticket.productos);
	writeln('====== IMPRESION TERMINADA ======');
end;

var
	verduras : RandomGenerator;
	chango : carrito;
	balan : balanza;
	ticketAct : ticketCompra;
	index : integer;
BEGIN
	verduras := RandomGenerator.create();
	verduras.addLabel('Papa');
	verduras.addLabel('Morron');
	verduras.addLabel('Cebolla');
	verduras.addLabel('Perejil');
	verduras.addLabel('Puerro');
	verduras.addLabel('Verdeo');
	verduras.addLabel('Chauchas');
	verduras.addLabel('Ajo');
	verduras.addLabel('Tomate');
	verduras.addLabel('Lechuga');
	
{Modifique el programa de la actividad 4 para simular el peso de cinco
compras distintas.}

// En este caso y por simplicidad, no estamos guardando los datos de las compras:
// fácilmente se podría hacer una lista de tickets
	balan := Balanza.create();
	for index:=1 to 5 do begin
		cargarCarrito(chango, verduras);
		pesarCarrito(chango, balan, ticketAct);
		printTicket(ticketAct);
	end;
end.
	
	
	
	


