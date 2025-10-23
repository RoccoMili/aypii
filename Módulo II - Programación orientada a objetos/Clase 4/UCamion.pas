unit UCamion;
{$mode objfpc}
interface
uses GenericLinkedList, UEncomienda;
	type
		listaEncomiendas = specialize LinkedList<Encomienda>;
		Camion = class
			private
				encomiendas : listaEncomiendas; 
				cantidadEncomiendas : integer;
				capacidad : real;
				pesoActual : real;
			public
				constructor create(maxCapacidad : real);
				function agregarEncomienda(encom : Encomienda) : boolean;
				function extraerEncomienda() : Encomienda;
				function getPrimerPeso() : real;
				function cantEncomiendas() : integer;
		end;
implementation
	constructor Camion.create(maxCapacidad : real);
	begin
		encomiendas := listaEncomiendas.create();
		cantidadEncomiendas := 0;
		capacidad := maxCapacidad;
		pesoActual := 0;
	end;
	function Camion.agregarEncomienda(encom : Encomienda) : boolean;
	var
		exito : boolean;
	begin
		// si (entra otro paquete) then -> lo añadimos | else -> no pasa nada 
		if (capacidad > (pesoActual + encom.getPeso())) then begin
			encomiendas.reset();
			while ((not encomiendas.eol()) AND (encomiendas.current().getPeso < encom.getPeso())) do
				encomiendas.next();
			encomiendas.insertCurrent(encom);
			cantidadEncomiendas := cantidadEncomiendas + 1;
			pesoActual := pesoActual + encom.getPeso();
			exito := true;
		end
		else
			exito := false;
			
		agregarEncomienda := exito;
	end;
	function Camion.extraerEncomienda() : Encomienda;
	var
		encomAct : Encomienda;
	begin
		encomiendas.reset();
		// asumimos que NO se va a llamar a la función si está vacía
		encomAct := encomiendas.current();
		encomiendas.removeCurrent();
		cantidadEncomiendas := cantidadEncomiendas - 1;
		pesoActual := pesoActual - encomAct.getPeso();
		extraerEncomienda := encomAct;
	end;
	function Camion.getPrimerPeso() : real;
	begin
		encomiendas.reset();
		getPrimerPeso := encomiendas.current().getPeso();
	end;
	function Camion.cantEncomiendas() : integer;
	begin
		cantEncomiendas := cantidadEncomiendas;
	end;
end.
