unit UCarniceria;
{$mode objfpc}
interface
uses UMercaderia, UBalanza, UCajaDeAhorro;
	type
		Carniceria = class
			private
				nombre : string;
				carnMercaderia : Mercaderia;
				carnBalanza : Balanza;
				carnCaja : CajaDeAhorro;
			public
				constructor create(nuevoNombre : string; nuevaCaja : CajaDeAhorro);
				procedure comenzarCompra();
				procedure llevo(desc : string; peso : real; var exito : boolean; var resto : real);
				function finalizarCompra() : real;
				procedure recibirPago(monto : real);
		end;
implementation
uses URandomGenerator;
	constructor Carniceria.create(nuevoNombre : string; nuevaCaja : CajaDeAhorro);
		var
			rg : RandomGenerator;
			prodRandom : Producto;
			i : integer;
		begin
			nombre := nuevoNombre;
			carnMercaderia := Mercaderia.create();
			
			rg := RandomGenerator.create();
			rg.addLabel('Mondongo'); rg.addLabel('Lomo'); rg.addLabel('Asado'); rg.addLabel('Cola de cuadril'); rg.addLabel('Chorizo'); rg.addLabel('Morcilla'); rg.addLabel('Chinchulin'); rg.addLabel('Nalga'); rg.addLabel('Tripa gorda'); rg.addLabel('Provoleta');
			for i:=1 to 10 do begin
				prodRandom := Producto.create(rg.getLabel(), rg.getReal(7500, 15000), rg.getReal(1, 25));
				carnMercaderia.addProducto(prodRandom);
			end;
			
			carnBalanza := Balanza.create();
			carnCaja := nuevaCaja;
		end;
	procedure Carniceria.comenzarCompra();
		begin
			carnBalanza.limpiar();
		end;
	procedure Carniceria.llevo(desc : string; peso : real; var exito : boolean; var resto : real);
		var
			rg : RandomGenerator;
			llevarResto : boolean;
		begin
			rg := RandomGenerator.create(); // esto crea una instancia cada vez
			carnBalanza.setPrecioPorKilo(carnMercaderia.getProducto(desc).getPrecioKilo());
			if (carnMercaderia.getProducto(desc).getStock() >= peso) then begin
				carnBalanza.pesar(peso);
				carnMercaderia.getProducto(desc).setStock(carnMercaderia.getProducto(desc).getStock() - peso);
				exito := true;
			end
			else if (carnMercaderia.getProducto(desc).getStock() > 0) then begin
				llevarResto := rg.getBoolean();
				if (llevarResto) then begin
					carnBalanza.pesar(carnMercaderia.getProducto(desc).getStock());
					carnMercaderia.getProducto(desc).setStock(0);
					exito := true;
				end
				else
					exito := false;
			end
			else
				exito := false;
			resto := carnMercaderia.getProducto(desc).getStock();
		end;
	function Carniceria.finalizarCompra() : real;
		begin
			finalizarCompra := carnBalanza.getTotalAPagar();
		end;
	procedure Carniceria.recibirPago(monto : real);
		begin
		  	carnCaja.depositar(monto);
		end; 
end.
