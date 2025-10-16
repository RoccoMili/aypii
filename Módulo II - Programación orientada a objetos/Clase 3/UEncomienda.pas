unit UEncomienda;
{$mode objfpc}
interface
	type
		{Cree un objeto Encomienda para representar las encomiendas que se 
		envían y reciben por correo.}
		Encomienda = class
			private
				peso : real;
				remitente : string;
				destinatario : string;
			public
				constructor create(eRemit, eDestinat : string; ePeso : real);
				function getRemitente() : string;
				function getDestinatario() : string;
				function getPeso() : real;
				function toString() : ansistring; override;
		end;
implementation
uses sysutils;
	constructor Encomienda.create(eRemit, eDestinat : string; ePeso : real);
	begin
		peso := ePeso;
		remitente := eRemit;
		destinatario := eDestinat;
	end;
	function Encomienda.getRemitente() : string;
	begin
		getRemitente := remitente;
	end;
	function Encomienda.getDestinatario() : string;
	begin
		getDestinatario := destinatario;
	end;
	function Encomienda.getPeso() : real;
	begin
		getPeso := peso;
	end;
	function Encomienda.toString() : ansistring;
	begin
		toString := destinatario + remitente + format('%10.3f', [peso]);
	end;
end.
