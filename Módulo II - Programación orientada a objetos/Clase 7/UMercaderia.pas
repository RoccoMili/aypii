unit UMercaderia;
{$mode objfpc}
interface
uses GenericLinkedList, UDiccionario;
	type
		Producto = class
			private
				descripcion : string;
				precioKilo : real;
				stock : real;
			public
				constructor create(nuevaDesc : string; nuevoPrecio : real; nuevoStock : real);
				function getPrecioKilo() : real;
				function getDescripcion() : string;
				procedure setStock(cant : real); // en real, para expresar en Kgs
				function getStock() : real; 

		end;
		Mercaderia = class
			private
				precios : Diccionario;
				stock : Diccionario; // para adaptarlo bien, no pedido en el ejercicio
			public
				constructor create();
				procedure addProducto(prod : Producto);
				function getProducto(desc : string) : Producto;
				procedure updateStock(desc : string; newStock : real); // necesario para adaptarlo
		end;
implementation
	constructor Producto.create(nuevaDesc : string; nuevoPrecio : real; nuevoStock : real);
		begin
			descripcion := nuevaDesc;
			precioKilo := nuevoPrecio;
			stock := nuevoStock;
		end;
	function Producto.getPrecioKilo() : real;
		begin
			getPrecioKilo := precioKilo;
		end;
	function Producto.getDescripcion() : string;
		begin
			getDescripcion := descripcion;
		end;
	procedure Producto.setStock(cant : real);
		begin
			stock := cant;
		end;
	function Producto.getStock() : real;
		begin
		  	getStock := stock;
		end;
	
	constructor Mercaderia.create();
		begin
			precios := Diccionario.create();
			stock := Diccionario.create();
		end;
	procedure Mercaderia.addProducto(prod : Producto);
		begin
			precios.addKeyValue(prod.getDescripcion(), prod.getPrecioKilo());
			stock.addKeyValue(prod.getDescripcion(), prod.getStock());
		end;
	function Mercaderia.getProducto(desc : string) : Producto;
		var
			prod : Producto;
		begin
			if (precios.exists(desc)) then
				prod := Producto.create(desc, precios.getValue(desc), stock.getValue(desc))
			else
				prod := Producto.create(desc, 0, 0);
			getProducto := prod;
		end;
	procedure Mercaderia.updateStock(desc : string; newStock : real);
		begin
			if (stock.exists(desc)) then
				stock.addKeyValue(desc, newStock);
		end;
end.
