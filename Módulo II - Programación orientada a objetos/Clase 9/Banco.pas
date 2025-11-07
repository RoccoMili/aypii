program Banco;
{$mode objfpc}

uses GenericLinkedList, URandomGenerator, UServiciosBanco;

type
	ListaServicios = specialize LinkedList<Servicio>;
	
procedure simularMovimientos(lista: ListaServicios);	
var i: integer;
	rg: RandomGenerator;
	m : real;
begin
	rg:= RandomGenerator.create();

	for i:= 1 to 10 do
		begin
		lista.reset();
		while not lista.eol() do
			begin
			if rg.getBoolean() then
				begin
				m:= rg.getReal(200, 1000);
				lista.current().depositar(m);
				writeln('Se hizo un deposito en la cuenta ', lista.current().getNumeroDeCuenta());
				end
			else
				begin
				m:= rg.getReal(100, 500);
				if lista.current().extraer(m) then
					writeln('Se hizo una extraccion en la cuenta ', lista.current().getNumeroDeCuenta())
				else
					writeln('No se pudo extraer de la cuenta ', lista.current().getNumeroDeCuenta());
				end;
			
			lista.current().cobrarMantenimiento();
			lista.next();
			end;
		end;

	writeln('Resumen de las cuentas');
	lista.reset();
	while not lista.eol() do
		begin
		writeln(lista.current().resumen());
		lista.next();
		end;
	end;
	
var 
	l: ListaServicios;
	rg : RandomGenerator;
	i : integer;
	nuevaAhorro : CajaDeAhorro;
	nuevaCorriente : CuentaCorriente;
begin 
	l := ListaServicios.create();
	rg := RandomGenerator.create();
	for i:=1 to 5 do begin
		nuevaAhorro := CajaDeAhorro.create(rg.getBoolean(), rg.getInteger(1000, 9999), rg.getString(8));
	  	l.add(nuevaAhorro);
	end;
	for i:=1 to 5 do begin
		nuevaCorriente := CuentaCorriente.create(rg.getReal(20, 200), rg.getInteger(1000, 9999), rg.getString(8));
	  	l.add(nuevaCorriente);
	end;

	// Recorra la lista agregando un primer depósito con un saldo elegido al azar.
	l.reset();
	while (not l.eol()) do begin
		l.current().depositar(rg.getReal(1500, 4000));
		l.next();
	end;

	simularMovimientos(l);
end.
