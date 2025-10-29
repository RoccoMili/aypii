unit UCliente;
{$mode objfpc}
interface
uses UCajaDeAhorro, UCarniceria;
	type
		Cliente = class
			private
				nombre : string;
				billetera : CajaDeAhorro;
			public
				constructor create(nuevoNombre : string; nuevaCaja : CajaDeAhorro);
				procedure comprarEnCarniceria(carn : Carniceria);
		end;
implementation
uses URandomGenerator;
	constructor Cliente.create(nuevoNombre : string; nuevaCaja : CajaDeAhorro);
		begin
			nombre := nuevoNombre;
			billetera := nuevaCaja;
		end;
	procedure Cliente.comprarEnCarniceria(carn : Carniceria);
		var
			rg : RandomGenerator;
			i, cantLlevar : integer;
			total : real;
			exito : boolean;
		begin
			carn.comenzarCompra();
			rg := RandomGenerator.create();
			cantLlevar := rg.getInteger(1, 5);
			rg.addLabel('Mondongo'); rg.addLabel('Lomo'); rg.addLabel('Asado'); rg.addLabel('Cola de cuadril'); rg.addLabel('Chorizo'); rg.addLabel('Morcilla'); rg.addLabel('Chinchulin'); rg.addLabel('Nalga'); rg.addLabel('Tripa gorda'); rg.addLabel('Provoleta');
			
			for i:=1 to cantLlevar do
				carn.llevo(rg.getLabel(), rg.getReal(1, 3));
			total := carn.finalizarCompra();
			
			billetera.extraer(total, exito);
			if (exito) then
				writeln('Le transferiste $',total:0:2,' a Carniceria')
			else
				writeln('Transferencia rechazada. Fondos insuficientes');
		end;
end.
