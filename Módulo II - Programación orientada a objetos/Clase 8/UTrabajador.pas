unit UTrabajador;
{$mode objfpc}
interface
uses UPersona, UCajaDeAhorro, UDateTime, SysUtils;
	type
		Trabajador = class(Persona)
			private
				cajaAhorro : CajaDeAhorro;
				sueldo : real;
				mesesAntiguedad : integer;
			protected
				function calcularSalario() : real; virtual;
			public
				constructor create(newNombre, newDNI : string; fechaNacimiento : Date; caja : CajaDeAhorro; salario : real);
				function getSueldo() : real;
				procedure actualizarSueldo(por : real);
				procedure pagarImpuesto(monto : real);
				procedure cobrarSalario();
				function toString() : ansistring; override;
		end;
implementation
	constructor Trabajador.create(newNombre, newDNI : string; fechaNacimiento : Date; caja : CajaDeAhorro; salario : real);
	begin
		inherited create(newNombre, newDNI, fechaNacimiento);
		cajaAhorro := caja;
		sueldo := salario;
		mesesAntiguedad := 0;
	end;
	function Trabajador.calcularSalario() : real;
	begin
		calcularSalario := (sueldo * ((1+mesesAntiguedad)/100))
	end;
	function Trabajador.getSueldo() : real;
	begin
		getSueldo := sueldo;
	end;
	procedure Trabajador.actualizarSueldo(por : real);
	begin
		sueldo := (sueldo * ((1+(por/100))));
	end;
	procedure Trabajador.pagarImpuesto(monto : real);
	var
		exito : boolean;
	begin
		cajaAhorro.extraer(monto, exito);
		if (not exito) then
			writeln('Estoy en problemas!!!!');
	end;
	procedure Trabajador.cobrarSalario();
	begin
		cajaAhorro.depositar(self.calcularSalario());
		mesesAntiguedad := mesesAntiguedad + 1;
	end;
	function Trabajador.toString() : ansistring;
	begin
		toString := (inherited toString() + ' | [SALDO]: '+ FormatFloat('0.00', cajaAhorro.consultarSaldo()));
	end;
end.
