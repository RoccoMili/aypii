unit UCartero;
{$mode objfpc}
interface
uses GenericLinkedList, UEncomienda;
	type
		listaEncomiendas = specialize LinkedList<Encomienda>;
		Cartero = class
			private
				encomiendas : listaEncomiendas;
				cantidadEncomiendas : integer;
			public
				constructor create();
				procedure addEncomienda(encom : Encomienda);
				function removeEncomienda() : Encomienda;
				function countEncomiendas() : integer;
		end;
implementation
	constructor Cartero.create();
	begin
		encomiendas := listaEncomiendas.create();
		cantidadEncomiendas := 0;
	end;
	procedure Cartero.addEncomienda(encom : Encomienda);
	begin
		encomiendas.reset();
		while ((not encomiendas.eol()) AND (encomiendas.current().getPeso() < encom.getPeso())) do begin
			writeln('BUSCANDO OTRA POSICION PARA LA ENCOMIENDA');
			encomiendas.next();
		end;
		encomiendas.insertCurrent(encom);
		cantidadEncomiendas := cantidadEncomiendas + 1;
	end;
	function Cartero.removeEncomienda() : Encomienda;
	var
		toRemove : Encomienda;
	begin
		// presuponemos que no se va a llamar a removeEncomienda si no hay encomiendas
		encomiendas.reset();
		toRemove := encomiendas.current();
		encomiendas.removeCurrent();
		cantidadEncomiendas := cantidadEncomiendas - 1;
		removeEncomienda := toRemove;
	end;
	function Cartero.countEncomiendas() : integer;
	begin
		countEncomiendas := cantidadEncomiendas;
	end;
end.
