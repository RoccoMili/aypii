program Banco1;
uses
	UCajaDeAhorro, GenericLinkedList, URandomGenerator, UDateTime;
const
	SUC = 7;
	TOT = 80;
type
	listaCajas = specialize LinkedList<CajaDeAhorro>;
    arraySucursales = array [1..SUC] of listaCajas;
    poolCajas = array [1..TOT] of CajaDeAhorro;

{Se desea modificar el programa de la actividad anterior para que cada
sucursal maneje un número indefinido de cajas de ahorro.
Implemente un módulo que cree 80 cajas de ahorro de todas las
sucursales. }
procedure crearCajas(var v : arraySucursales; var pool : poolCajas);
var
	rg : RandomGenerator;
    i : integer;
    caja : CajaDeAhorro;
begin
    rg := RandomGenerator.create();
	for i:=1 to SUC do
        v[i] := listaCajas.create();
    for i:=1 to TOT do begin
        caja := CajaDeAhorro.create(i);
        pool[i] := caja;
        v[rg.getInteger(1, 7)].add(caja);
    end;
    
end;

procedure simularMovimiento(caja : CajaDeAhorro);
var
	rg : RandomGenerator;
	exito : boolean;
begin
	rg := RandomGenerator.create();
	if (rg.getBoolean()) then
		caja.depositar(rg.getReal(1, 5000))
	else
		caja.extraer(rg.getReal(1, 5000), exito);
		
	if (exito) then
		writeln('La operacion tuvo exito')
	else
		writeln('La operacion NO tuvo exito');
end;

{Implemente un módulo que simule 50 diferentes operaciones sobre las
cajas de ahorro (incluyendo cajas de ahorro entre distintas sucursales)}
procedure simularOperaciones(pool : poolCajas);
var
	rg : RandomGenerator;
	i : integer;
begin
	rg := RandomGenerator.create();
	for i:=1 to 50 do begin
        simularMovimiento(pool[rg.getInteger(1, TOT)]);
    end;
end;

var
	cajas : arraySucursales;
    pool : poolCajas;
BEGIN
	crearCajas(cajas, pool);
	simularOperaciones(pool);
END.
