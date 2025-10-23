program PCorreo;
uses
	UCartero, UEncomienda, UDateTime,URandomGenerator;
const
	CANT = 5;
type
	vCarteros = array [1..CANT] of Cartero;

{Implemente un módulo Inicializar que cree los 5 carteros sin 
encomiendas.}
procedure inicializar(var v : vCarteros);
var
	i : integer;
begin
	for i:=1 to CANT do
		v[i] := Cartero.create();
end;

function randomEncomienda() : Encomienda;
var
	rg : RandomGenerator;
	encom : Encomienda;
begin
	rg := RandomGenerator.create();
	encom := Encomienda.create(rg.getString(6), rg.getString(6), rg.getReal(1, 5000));
	randomEncomienda := encom;
end;

{Implemente un módulo SimularRecepcion que reciba a todos los 
carteros por parámetro y que simule la recepción de encomiendas 
agregando N encomiendas generadas al azar. (N también es elegido al azar) 
La elección de a qué cartero asignarle cada una de las encomiendas 
también se elige al azar. (Los carteros podrían quedar con distinto número 
de encomiendas).}
procedure simularRecepcion(v : vCarteros);
var
	rg : RandomGenerator;
	i, cantEncom : integer;
begin
	rg := RandomGenerator.create();
	cantEncom := rg.getInteger(1, 50);
	for i:=1 to cantEncom do
		v[rg.getInteger(1, CANT)].addEncomienda(randomEncomienda());
end;

{Implemente un módulo SimularReparto que reciba a todos los carteros 
por parámetro y que simule el reparto de encomiendas. El reparto de una 
encomienda se simula imprimiendo toda la información de la encomienda. 
Todos los carteros deben hacer el reparto de todas sus encomiendas.}
procedure simularReparto(v : vCarteros);
var
	i : integer;
	encomAct : Encomienda;
begin
	for i:=1 to CANT do begin
		writeln('============ CARTERO NUMERO ',i,'============');
		while (v[i].countEncomiendas() <> 0) do begin
			encomAct := v[i].removeEncomienda;
			writeln('==== ENCOMIENDA NUEVA ====');
			writeln('[-] REMITENTE: ',encomAct.getRemitente());
			writeln('[-] DESTINATARIO: ',encomAct.getDestinatario());
			writeln('[-] PESO: ',encomAct.getPeso():0:2);
			// writeln(encomAct.toString());   Esto es opcional, utilizando el método introducido antes. Pero no me gusta
			writeln('==== FIN DE ENCOMIENDA ====');
		end;
	end;
end;

var 
	carteros : vCarteros;
begin
	inicializar(carteros);
	simularRecepcion(carteros);
	simularReparto(carteros);
end.
