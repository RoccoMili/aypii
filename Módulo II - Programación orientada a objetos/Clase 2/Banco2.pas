program Banco1;
uses
	UCajaDeAhorro, GenericLinkedList, URandomGenerator, UDateTime;
const
	CANT = 15;	
	SUC = 7;
	TOT = 105;
type
	matrizSucursales = array [1..SUC, 1..CANT] of CajaDeAhorro;
	vMaximos = array [1..SUC] of real;

{Implemente un módulo que cree las cajas de ahorro de todas las
sucursales.}
procedure crearCajas(var m : matrizSucursales);
var
	fil, col : integer;
	cont : integer;
begin
	// en este caso, usamos cont para llevar el registro de las 105 cajas (7x15), aunque un poco impráctico
	cont := 1;
	for fil:=1 to SUC do
		for col:=1 to CANT do begin
			m[fil,col] := CajaDeAhorro.create(cont);
			cont := cont + 1; 
		end;
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

procedure simularOperaciones(m : matrizSucursales);
var
	rg : RandomGenerator;
	i : integer;
begin
	rg := RandomGenerator.create();
	for i:=1 to 45 do
		simularMovimiento(m[(rg.getInteger(1, SUC)),(rg.getInteger(1 , CANT))]);
end;

{Implemente un módulo que imprima el saldo de las cajas de ahorro.}
procedure printSaldos(m : matrizSucursales);
var
	fil, col : integer;
begin
	for fil:=1 to SUC do
		for col:=1 to CANT do
			writeln('[SUC. ',fil,' - CAJA ',col,']: ', '$',m[fil,col].consultarSaldo():0:2);
end;

{Implemente un módulo que devuelva el número de sucursal que más
dinero tiene. El dinero de una sucursal es la suma de los saldos de
todas sus cajas de ahorro.}
procedure buscarMaximos(m : matrizSucursales; var vMax : vMaximos);
var
	i : integer;
	fil, col : integer;
begin
	for i:=1 to SUC do
		v[i] := -1;
	for fil:=1 to SUC do 
		for col:=1 to CANT do begin
			if (v[fil] < m[fil,col].consultarSaldo()) then begin
				v[fil] := m[fil,col].consultarSaldo();
			end;
		end;
end;

var
	cajas : matrizSucursales;
	maximos 
BEGIN
	crearCajas(cajas);
	simularOperaciones(cajas);
	printSaldos(cajas);
END.
