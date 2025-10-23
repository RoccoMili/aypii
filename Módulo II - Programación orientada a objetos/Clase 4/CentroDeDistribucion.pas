program CentroDeDistribucion;
uses GenericLinkedList, URandomGenerator, UCamion, UCartero, UEncomienda;

const
	CANTIDAD_CAMIONES = 10;

type 		
	REncomienda = record
		remitente, destinatario: string;
		peso: real;
	end;
	
	ListaREncomiendas = specialize LinkedList<REncomienda>;
	
	vCamiones = array [1..CANTIDAD_CAMIONES] of Camion;
	
// Use esta función para obtener la lista con la información de encomiendas a repartir
procedure ObtenerInfoEncomiendas(var lista: ListaREncomiendas);
var i, nValores: integer;
	enc: REncomienda;
	rg: RAndomGenerator;

begin
lista:= ListaREncomiendas.create();
rg:= RandomGenerator.create;

nValores:= random(3000) + 1000;	//Nos aseguramos un mínimo de 1000 encomiendas
	
// Generamos N encomiendas y los almacenamos en la lista
for i:= 1 to nValores do
	begin
	enc.remitente:= rg.getString(10);
	enc.destinatario:= rg.getString(10);
	enc.peso:= rg.getReal(10, 100);
	
	lista.add(enc);
	end;
end;
//--------------------------------------------------------

{Implemente un módulo CrearCamiones que instancie los 10 camiones
del centro de distribución con capacidades seleccionadas al azar (entre
5000 y 25000).}
procedure crearCamiones(var v : vCamiones);
var
	rg : RandomGenerator;
	i : integer;
begin
	rg := RandomGenerator.create();
	for i:=1 to CANTIDAD_CAMIONES do
		v[i] := Camion.create(rg.getReal(5000, 25000));
end;

{Utilice el módulo ObtenerInfoEncomiendas dado por la cátedra para
repartir las encomiendas en todos los camiones. Implemente un
módulo que reparta las encomiendas entre los 10 camiones. Se
comienza almacenando las encomiendas en el primer camión hasta
agotar toda su capacidad, luego se almacenan en el siguiente camión
hasta agotar su capacidad y así se continúa con el resto de los
camiones. NOTA 1: Los camiones podrían agotar toda su capacidad y
quedar encomiendas sin repartir. NOTA 2: si no hay suficientes
encomiendas, algunos camiones podrían quedar vacíos.}
procedure repartirEncomiendas(v : vCamiones; l : ListaREncomiendas);
var
	encomAct : Encomienda;
	index : integer;
	agregado : boolean;
begin
	l.reset();
	index := 1;
	while ((not l.eol()) AND (index <= 10)) do begin
		encomAct := Encomienda.create(l.current().remitente, l.current().destinatario, l.current().peso);

		agregado := v[index].agregarEncomienda(encomAct);
		if (not agregado) then
			index := index + 1;

		// Potencial error: que no pueda ser insertado en un camión, tampoco se pueda en el próximo,
		// y por lo tanto se descarta la encomienda. No es posible actualmente, pero con un cambio
		// en el código podría llegar a suceder. (el próximo camión siempre estaría vacío y las encomiendas
		// no son lo suficientemente grandes
		
		// Este if trata de añadirlo si todavía quedan camiones
		if (index <= 10) then
			agregado := v[index].agregarEncomienda(encomAct);
			
		l.next();
	end;
end;

{Implemente un módulo AsignarEncomiendas que reciba un cartero,
los camiones y un peso máximo a transportar y que le asigne al cartero	
todas las encomiendas que pueda transportar hasta superar el peso
máximo. Las encomiendas a asignar deberían ser las más livianas que
estén entre todos los camiones.}
procedure asignarEncomiendas(v : vCamiones; cart : Cartero; max : real);
var
	index : integer;
	pesoAct : real;
	encomAct : Encomienda;
begin
	index := 1;
	pesoAct := 0;
	while ((index < CANTIDAD_CAMIONES) AND (pesoAct < max)) do begin
		if ((v[index].cantEncomiendas() >= 1) AND (pesoAct + v[index].getPrimerPeso() < max)) then begin
			encomAct := v[index].extraerEncomienda();
			pesoAct := pesoAct + encomAct.getPeso();
			cart.addEncomienda(encomAct);
		end
		else if (index < CANTIDAD_CAMIONES) then
			index := index + 1;
	end;
end;

{Implemente un módulo recursivo llamado SimularReparto que reciba
un cartero por parámetro y que simule el reparto de todas sus
encomiendas. El reparto de una encomienda se simula imprimiendo
toda la información de la encomienda.}
procedure simularReparto(cart : Cartero);
var
	encomAct : Encomienda;
begin
	if (cart.countEncomiendas() >= 1) then begin
		encomAct := cart.removeEncomienda();
		writeln('==== ENCOMIENDA NUEVA ====');
		writeln('[-] REMITENTE: ',encomAct.getRemitente());
		writeln('[-] DESTINATARIO: ',encomAct.getDestinatario());
		writeln('[-] PESO: ',encomAct.getPeso():0:2);
		writeln('==== FIN DE ENCOMIENDA ====');
		simularReparto(cart);	
	end; 
end;


var 
	lista: ListaREncomiendas;
	camiones : vCamiones;
	carteroTest : Cartero;
	pesoMaxCartero : real;
begin
	randomize;

	writeln('Obteniendo lista');
	ObtenerInfoEncomiendas(lista);

	crearCamiones(camiones);
	repartirEncomiendas(camiones, lista);
	
	carteroTest := Cartero.create();
	writeln('Ingresa el peso maximo que puede llevar el cartero de prueba');
	readln(pesoMaxCartero);
	asignarEncomiendas(camiones, carteroTest, pesoMaxCartero);
	simularReparto(carteroTest);
end.
