program Banco1;
uses
	UCajaDeAhorro, GenericLinkedList, URandomGenerator, UDateTime;
const
	CANT = 15;	
type
	arrayCajas = array [1..CANT] of CajaDeAhorro;

{Implemente un módulo que cree las cajas de ahorro.}
procedure crearCajas(var v : arrayCajas);
var
	i : integer;
begin
	for i:=1 to CANT do
		v[i] := CajaDeAhorro.create(i);
end;

{Implemente un módulo SimularMovimiento que reciba una caja de
ahorro por parámetro y que deposite o extraiga una suma generada al
azar. La acción de depositar o extraer debe ser determinada al azar.
Este módulo además debe informar el éxito o no de la operación.}

procedure simularMovimiento(caja : CajaDeAhorro);
var
	rg : RandomGenerator;
	exito : boolean;
begin
	rg := RandomGenerator.create();
	// if True => depositamos
	if (rg.getBoolean()) then
		caja.depositar(rg.getReal(1, 5000))
	else
		caja.extraer(rg.getReal(1, 5000), exito);
		
	if (exito) then
		writeln('La operacion tuvo exito')
	else
		writeln('La operacion NO tuvo exito');
end;

{Implemente un módulo que simule 30 operaciones sobre las cajas de
ahorro. Por cada operación debe elegir al azar una caja de ahorro e
invocar al módulo SimularMovimiento.}

procedure simularOperaciones(v : arrayCajas);
var
	rg : RandomGenerator;
	i : integer;
begin
	rg := RandomGenerator.create();
	for i:=1 to 30 do
		simularMovimiento(v[rg.getInteger(1, CANT)]);
end;

procedure printSaldos(v : arrayCajas);
var
	i : integer;
begin
	for i:=1 to CANT do
		writeln('[CAJA ',i,']: ', '$',v[i].consultarSaldo():0:2);
end;

var
	cajas : arrayCajas;
BEGIN
	crearCajas(cajas);
	simularOperaciones(cajas);
	printSaldos(cajas);
END.
