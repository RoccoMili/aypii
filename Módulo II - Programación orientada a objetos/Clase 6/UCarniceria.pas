unit UCarniceria;
{$mode objfpc}
interface
uses UMercaderia, UBalanza;
	type
		Carniceria = class
			private
				nombre : string;
				carnMercaderia : Mercaderia;
				carnBalanza : Balanza;
			public
				constructor create(nuevoNombre : string);
				procedure comenzarCompra();
				procedure llevo(desc : string; peso : real);
				function finalizarCompra() : real;
		end;
implementation
uses URandomGenerator;
	constructor Carniceria.create(nuevoNombre : string);
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
				prodRandom := Producto.create(rg.getLabel(), rg.getReal(7500, 15000));
				carnMercaderia.addProducto(prodRandom);
			end;
			
			carnBalanza := Balanza.create();
		end;
	procedure Carniceria.comenzarCompra();
		begin
			carnBalanza.limpiar();
		end;
	procedure Carniceria.llevo(desc : string; peso : real);
		begin
			carnBalanza.setPrecioPorKilo(carnMercaderia.getProducto(desc).getPrecioKilo());
			carnBalanza.pesar(peso);
		end;
	function Carniceria.finalizarCompra() : real;
		begin
			finalizarCompra := carnBalanza.getTotalAPagar();
		end;
end.
