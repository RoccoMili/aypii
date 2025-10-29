unit UMercaderia;
{$mode objfpc}
interface
uses GenericLinkedList;
	type
		Producto = class
			private
				descripcion : string;
				precioKilo : real;
			public
				constructor create(nuevaDesc : string; nuevoPrecio : real);
				function getPrecioKilo() : real;
				function getDescripcion() : string;
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

	constructor Producto.create(nuevaDesc : string; nuevoPrecio : real);
		begin
			descripcion := nuevaDesc;
			precioKilo := nuevoPrecio;
		end;
	function Producto.getPrecioKilo() : real;
		begin
			getPrecioKilo := precioKilo;
		end;
	function Producto.getDescripcion() : string;
		begin
			getDescripcion := descripcion;
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
		begin
			// Asumimos que sólo va a haber un producto con esa descripción
			precios.reset();
			while not (precios.eol()) do begin
				if (precios.current().getDescripcion() = desc) then
					getProducto := precios.current();
				precios.next();
			end;
		end;
end.
