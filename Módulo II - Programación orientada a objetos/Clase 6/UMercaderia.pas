unit UMercaderia;
{$mode objfpc}
interface
uses GenericLinkedList;
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
		listaProducto = specialize LinkedList<Producto>;
		Mercaderia = class
			private
				precios : listaProducto;
			public
				constructor create();
				procedure addProducto(prod : Producto);
				function getProducto(desc : string) : Producto;
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
			precios := listaProducto.create();
		end;
	procedure Mercaderia.addProducto(prod : Producto);
		begin
			// normal, pero podría estar ordenado por precio x kg
			precios.add(prod);
		end;
	function Mercaderia.getProducto(desc : string) : Producto;
		var
			existe : boolean;
			p : Producto;
		begin
			// Asumimos que sólo va a haber un producto con esa descripción
			existe := false;
			precios.reset();
			while ((not precios.eol()) and (not existe)) do begin
				if (precios.current().getDescripcion() = desc) then begin
					p := precios.current();
					existe := true;
				end
				else
					precios.next();
			end;
			// Este arreglo es ineficiente, pero funciona
			if (not existe) then begin
				p := Producto.create(desc, 0, 0);
				precios.add(p);
			end;
			getProducto := p;
		end;
end.
